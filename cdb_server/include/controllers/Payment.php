<?php
defined('BASEPATH') OR exit('No direct script access allowed');
require_once("extend/notify.php");

class Payment extends CI_Controller {

    public function __construct()
    {
        parent::__construct();
        global $_A,$_GPC;
        if ($_A['segments'][2] == 'over') {
            json_error('余额支付系统升级中...');
        }
        if (!in_array($_A['segments'][2], array('alipay_notify', 'wxpay_notify', 'apply_return'))) {
            the_user();
            if (empty($_A['user'])) {
                json_error('会员身份丢失！', 1001);
            }
            //
            $array = explode('_', $_GPC['payid']);
            $paytype = substr($array[0], 0, 3);
            if (substr($array[0], 3) != $_A['user']['id']) {
                json_error('身份丢失，请重新提交支付申请！');
            }
            $payid = $array[0].$array[1];
            if (strlen($payid) < 13) {
                json_error('参数错误，请重新提交支付申请！');
            }
            /**
             * 押金支付
             */
            if ($paytype == 102) {
                //设备数据
                $cdb = cdb_info($_GPC['sn']);
                if (intval($cdb['id']) == 0) {
                    json_error($cdb);
                }
                if ($cdb['userid'] == $_A['user']['id']) {
                    json_error('抱歉，此设备已经被您使用！');
                }
                if ($cdb['userid'] == 0) {
                    json_error('抱歉，此设备尚未投入使用！');
                }
                if ($_A['user']['isdealer']) {
                    json_error('抱歉，商家身份不能借用设备！');
                }
                //支付金额
                $money = DEPOSIT;
                //支付数据
                $inArray = array(
                    'type'=>'deposit',
                    'title'=>'押金',
                    'userid'=>$_A['user']['id'],
                    'payid'=>$payid,
                    'money'=>$money,        //实付金额
                    'omoney'=>$money,       //原价金额
                    'status'=>'待付款',
                    'sn'=>$cdb['sn'],
                    'setting'=>array('cdb'=>$cdb),
                    'indate'=>SYS_TIME
                );
            }
            /**
             * 归还设备
             */
            elseif ($paytype == 103) {
                //设备数据
                $order = db_getone(table('order'), array('id'=>$_GPC['orderid'], 'sn'=>$_GPC['sn'], 'userid'=>$_A['user']['id'], '`ret`>'=>0));
                if (empty($order)) {
                    json_error('此订单无需付款（或已经付款）！');
                }
                $cdb = cdb_info($order['sn']);
                $cdb['orderinfo'] = $order;
                //使用优惠券
                $mySale = array('id'=>0, 'saleMoney'=>0);
                if ($_GPC['usaleid'] > 0) {
                    foreach (my_order_sale($order) AS $item) {
                        if ($item['idB'] == $_GPC['usaleid']) {
                            $mySale = $item;
                        }
                    }
                    if (empty($mySale)) {
                        json_error('您选择的'.sale_name().'无效，请选择正确的'.sale_name().'！');
                    }
                }
                //支付金额
                $money = max(0, $order['retmoney'] - $mySale['saleMoney']);
                //核对传递金额是否正确
                if ($money != $_GPC['money']) {
                    json_error('参数错误，请刷新页面后重新支付！');
                }
                //支付数据
                $inArray = array(
                    'type'=>'giveback',
                    'title'=>'归还设备',
                    'userid'=>$_A['user']['id'],
                    'payid'=>$payid,
                    'usaleid'=>$mySale['idB'],           //优惠券ID（用户的）
                    'money'=>$money,                     //实付金额
                    'omoney'=>$order['retmoney'],        //原价金额
                    'status'=>'待付款',
                    'sn'=>$cdb['sn'],
                    'setting'=>array('cdb'=>$cdb),
                    'indate'=>SYS_TIME
                );
            }
            /**
             * 商家入驻支付费用
             */
            elseif ($paytype == 104) {
                //判断是否已经支付过
                $row = db_getone(table('order_join'), array('userid'=>$_A['user']['id'], 'status'=>'审核中'));
                if ($row) {
                    json_error('您已提交过申请，我们正在拼命审核中....');
                }
                //支付金额
                $money = store_float($_GPC['money'], true);
                //核对传递金额是否正确
                if ($money != floatval($_GPC['money'])) {
                    json_error('参数错误，请刷新页面后重新支付！');
                }
                //支付数据
                $inArray = array(
                    'type'=>'joindealer',
                    'title'=>'商家入驻',
                    'userid'=>$_A['user']['id'],
                    'payid'=>$payid,
                    'money'=>$money,        //实付金额
                    'omoney'=>$money,       //原价金额
                    'status'=>'待付款',
                    'sn'=>'',
                    'setting'=>array(),
                    'indate'=>SYS_TIME
                );
            }
            /**
             * 参数错误
             */
            else{
                json_error('参数错误！'); exit();
            }
            /**
             * 统一生成支付数据
             */
            $payrow = db_getone(table('pay'), array('payid'=>$payid, 'userid'=>$_A['user']['id']));
            if (empty($payrow)) {
                db_delete(table('pay'), array('status'=>'待付款', 'userid'=>$_A['user']['id'], '`indate`<'=>SYS_TIME-259200));
                $inArray['setting']['submitGPC'] = $_GPC;
                $inArray['setting'] = array2string($inArray['setting']);
                db_insert(table('pay'), $inArray);
                $payrow = db_getone(table('pay'), array('payid'=>$payid, 'userid'=>$_A['user']['id']));
                if (empty($payrow)) {
                    json_error('系统繁忙，请稍后再试！');
                }
                $payrow['setting'] = string2array($payrow['setting']);
            }else{
                if ($payrow['money'] != $money) {
                    json_error('参数丢失，请重新提交支付申请！');
                }
                if ($payrow['status'] != '待付款') {
                    json_error('已成功支付，请勿重复提交！');
                }
            }
            $_A['payrow'] = $payrow;
        }
    }

    /**
     * 0元免付款
     */
    public function free()
    {
        global $_A;
        $arr = array();
        $arr['success'] = 0;
        $arr['message'] = '';
        //
        if (in_array($_A['payrow']['type'], array('giveback'))) {
            $totalfee = $_A['payrow']['money'];
        }else{
            json_error('参数错误！'); exit();
        }
        if ($_A['payrow']['money'] != 0) {
            json_error('错误的支付金额！');
        }
        //
        $notify = payment_notify($_A['payrow']['payid'], '0元免付');
        if (is_error($notify)) {
            json_error($notify['message']);
        }
        //
        json_sure(fetch(get_defined_vars()));
    }

    /**
     * 支付宝付款
     */
    public function alipay()
    {
        global $_A;
        $arr = array();
        $arr['success'] = 0;
        $arr['message'] = '';
        //
        $system = setting('system');
        $setting = setting('pay');
        $payconfig = $setting['alipay'];
        if (!$payconfig['openapp']) {
            json_error('此支付方式暂未开放！');
        }
        if (in_array($_A['payrow']['type'], array('deposit', 'giveback', 'joindealer'))) {
            $order_data =   $_A['payrow']['title'];
            $payid =        $_A['payrow']['payid'];
            $totalfee =     $_A['payrow']['money'];
        }else{
            json_error('参数错误！'); exit();
        }
        if ($totalfee <= 0) {
            json_error('错误的支付金额！');
        }
        //
        $array = array(
            'body' => ($system['name'] ? $system['name'] : BASE_NAME),
            'subject' => $order_data,
            'out_trade_no' => $payid,
            'timeout_express' => '30m',
            'total_amount' => $totalfee,
            'product_code' => 'QUICK_MSECURITY_PAY',
        );
        $this->load->library('alipay');
        //
        $arr['success'] = 1;
        $arr['message'] = $this->alipay->orderInfo($array);
        json_sure(fetch(get_defined_vars()));
    }

    /**
     * 支付宝付款 -- 通知
     */
    public function alipay_notify()
    {
        global $_GPC;
        $this->load->library('alipay');
        $notify = $this->alipay->notifyCheck();
        if (!$notify) {
            json_error('支付结束！');
        }
        if (!in_array($_GPC['trade_status'], array('TRADE_SUCCESS', 'TRADE_FINISHED'))) {
            json_error('支付失败！');
        }
        //
        $notify = payment_notify($_GPC['out_trade_no'], '支付宝');
        if (is_error($notify)) {
            json_error($notify['message']);
        }else{
            json_sure($notify['message']);
        }
        echo "success"; exit();
    }


    /**
     * 微信支付
     */
    public function wxpay()
    {
        global $_A;
        $arr = array();
        $arr['success'] = 0;
        $arr['message'] = '';
        $arr['setting'] = array();
        $arr['config'] = array();
        //
        $system = setting('system');
        $setting = setting('pay');
        $payconfig = $setting['weixin'];
        if (!$payconfig['openapp']) {
            json_error('此支付方式暂未开放！');
        }
        if (in_array($_A['payrow']['type'], array('deposit', 'giveback', 'joindealer'))) {
            $order_data =   $_A['payrow']['title'];
            $payid =        $_A['payrow']['payid'];
            $totalfee =     $_A['payrow']['money'];
            $orderid =      $_A['payrow']['id'];
        }else{
            json_error('参数错误！'); exit();
        }
        if ($totalfee <= 0) {
            json_error('错误的支付金额！');
        }
        //
        $arr['setting'] = $payconfig;
        $arr['setting']['notifyurl'] = url('payment/wxpay_notify');
        $arr['setting']['subject'] = $order_data;
        $arr['setting']['body'] = ($system['name']?$system['name']:BASE_NAME);
        $arr['setting']['total_fee'] = $totalfee*100;
        //
        $arr['success'] = 1;
        json_sure(fetch(get_defined_vars()));
    }

    /**
     * 微信公众号支付参数
     */
    public function wxpay_jsapi()
    {
        global $_A;
        $arr = array();
        $arr['success'] = 0;
        $arr['message'] = '';
        //
        $setting = setting('pay');
        $payconfig = $setting['weixin'];
        if (!$payconfig['open']) {
            json_error('支付功能暂未开放！');
        }
        if (in_array($_A['payrow']['type'], array('deposit'))) {
            $order_data =   $_A['payrow']['title'];
            $payid =        $_A['payrow']['payid'];
            $totalfee =     $_A['payrow']['money'];
            $orderid =      $_A['payrow']['id'];
        }else{
            json_error('参数错误！'); exit();
        }
        if ($totalfee <= 0) {
            json_error('错误的支付金额！');
        }
        define('WXPC_APPID',        $payconfig['appid']);
        define('WXPC_MCHID',        $payconfig['mchid']);
        define('WXPC_KEY',          $payconfig['apikey']);
        define('WXPC_APPSECRET',    $payconfig['secret']);
        //
        require_once(dirname(__FILE__) . '/' . '../libraries/weixin/WxPay.Api.php');
        $this->load->library('wx');
        //
        $input = new WxPayUnifiedOrder();
        $input->SetBody($order_data);
        $input->SetAttach($orderid);
        $input->SetOut_trade_no($payid);
        $input->SetTotal_fee($totalfee*100);
        $input->SetTime_start(date("YmdHis"));
        $input->SetTime_expire(date("YmdHis", time() + 600));
        $input->SetGoods_tag($order_data);
        $input->SetNotify_url(url('payment/wxpay_notify/js'));
        $input->SetTrade_type("JSAPI");
        $input->SetOpenid($_A['payrow']['setting']['submitGPC']['openid']);
        $order = WxPayApi::unifiedOrder($input);
        $jsApiParameters = $this->wx->GetJsApiParameters($order);
        if (is_error($jsApiParameters)) {
            json_error($jsApiParameters['message']);
        }else{
            json_sure(json_decode($jsApiParameters, true));
        }
    }

    /**
     * 微信支付 -- 通知
     */
    public function wxpay_notify()
    {
        global $_A;
        $setting = setting('pay');
        $payconfig = $setting['weixin'];
        if ($_A['segments'][3] == "js") {
            define('WXPC_PAYTYPE',      "微信公众号");
            define('WXPC_APPID',        $payconfig['appid']);
            define('WXPC_MCHID',        $payconfig['mchid']);
            define('WXPC_KEY',          $payconfig['apikey']);
            define('WXPC_APPSECRET',    $payconfig['secret']);
        }else{
            define('WXPC_PAYTYPE',      "微信客户端");
            define('WXPC_APPID',        $payconfig['app_appid']);
            define('WXPC_MCHID',        $payconfig['app_mchid']);
            define('WXPC_KEY',          $payconfig['app_apikey']);
            define('WXPC_APPSECRET',    $payconfig['app_secret']);
        }
        //
        require_once("extend/wxpay.php");
        $notify = new PayNotifyCallBack();
        $notify->Handle(false);
    }

    /**
     * 申请押金退款
     */
    public function apply_return()
    {
        global $_A,$_GPC;
        //
        the_user();
        if (empty($_A['user'])) {
            json_error('会员身份丢失！', 1001);
        }
        $return = apply_return($_GPC['payid'], $_A['user']['id']);
        if (is_error($return)) {
            json_error($return['message']);
        }else{
            json_sure($return['message']);
        }
    }
}