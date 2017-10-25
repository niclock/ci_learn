<?php
defined('BASEPATH') OR exit('No direct script access allowed');


if ( ! function_exists('payment_notify'))
{
    /**
     * @param string $payid     支付订单ID
     * @param string $type      支付类型（支付宝|微信）
     * @param string $subtype   支付类型附加信息（可能拿来区分不同收款账户）
     * @return array
     */
    function payment_notify($payid, $type, $subtype = '')
    {
        global $_GPC;
        //
        if (empty($payid)) {
            return error(1, '参数丢失！');
        }
        $row = db_getone(table('pay'), array('payid' => $payid));
        if (empty($row)) {
            return error(0, '记录不存在或已支付功能！');
        }
        if ($row['status'] == "已付款") {
            return error(0, '支付成功！');
        }
        if ($row['status'] != "待付款") {
            return error(1, '支付'.$row['status'].'！');
        }
        $row['setting'] = string2array($row['setting']);
        $row['setting']['payGPC'] = $_GPC;
        //更新支付数据
        db_update(table('pay'), array('status' => '已付款', 'payfrom' => $type, 'subpayfrom' => $subtype, 'paydate' => SYS_TIME, 'setting' => array2string($row['setting'])), array('id' => $row['id']));
        //开始处理订单
        $CI = & get_instance();
        switch (substr($payid, 0, 3)) {

            /**
             * 押金支付
             */
            case '102':
                $cdb = $row['setting']['cdb'];
                $userid = $row['userid'];       //消费者
                $userinfo = db_getone(table('users'), array('id'=>$userid));    //消费者
                db_trans_start();
                //更新设备数据
                $upcdb = array();
                $upcdb['userid'] = $userid;
                $upcdb['status'] = '使用中';
                $upcdb['update'] = SYS_TIME;
                db_update(table('cdb'), $upcdb, array('id' => $cdb['id']));
                users_cdbnum($userid);
                users_cdbnum($cdb['userid']);
                //生成设备记录
                db_insert(table('cdb_notes'), array(
                    'type'=>'out',
                    'sn'=>$cdb['sn'],
                    'userid'=>$cdb['userid'],
                    'userid_be'=>$userid,
                    'indate'=>SYS_TIME
                ));
                //生成订单记录
                $orderid = db_insert(table('order'), array(
                    'type' =>       'cdb',
                    'paytype' =>    $type,
                    'paysubtype' => $subtype,
                    'payid' =>      $row['payid'],
                    'userid' =>     $userid,
                    'userid_old' => $cdb['userid'],
                    'sn' =>         $cdb['sn'],
                    'indate' =>     SYS_TIME
                ), true);
                //标记使用中
                db_update(table('pay'), array('status' => '使用中', 'waitorder' => 0), array('id' => $row['id']));
                //更新押金次数
                db_update(table('users'), array('deposit_num[+]'=>1), array('id'=>$userinfo['id']));
                //事件关联
                $CI->load->model('userevent');
                if ($userinfo['deposit_num'] == 0) {
                    $CI->userevent->first_pay($userinfo['id']);
                }else{
                    $CI->userevent->every_pay($userinfo['id']);
                }
                //商家收益
                $setup = store_float(INCOME_BORROW, true);
                $auser = db_getone(table('users'), array('id'=>$cdb['userid']));
                $buser = ($auser['masterid']>0)?masterUser($auser):array();    //获取顶级主商家
                if ($setup > 0) {
                    $inarr = array(
                        'type'=>'income',
                        'payid'=>$row['payid'],
                        'subtype'=>'借出设备',
                        'userid'=>$auser['id'],
                        'fromid'=>0,
                        'fromname'=>'系统',
                        'orderid'=>$orderid,
                        'title'=>'借出设备: '. $cdb['sn'],
                        'setup'=>$setup,
                        'after'=>$auser['income'] + $setup,
                        'setting'=>array2string(array('cdb'=>$cdb, 'pay'=>$row)),
                        'indate'=>SYS_TIME
                    );
                    if ($buser) {
                        $inarr['userid'] = $buser['id'];
                        $inarr['after'] = $buser['income'] + $setup;
                        $inarr['masterid'] = $auser['id'];
                        $inarr['mastername'] = $auser['username'];
                    }
                    db_insert(table('users_log'), $inarr);
                    db_update(table('users'), array('income[+]'=>$setup, 'income_plus[+]'=>$setup), array('id'=>$inarr['userid']));
                }
                //通知商家
                $inarr = array(
                    'userid'=>$cdb['userid'],
                    'type'=>"borrow",
                    'tobe'=>1,
                    'title'=>'借出设备: '.$cdb['sn'],
                    'subtitle'=>'借用会员: '.$userinfo['username'].'; 本次收益: '.$setup.'元',
                    'content'=>'设备编码: '.$cdb['sn'].'; 借用会员: '.$userinfo['username'].'; 本次收益: '.$setup.'元',
                    'indate'=>SYS_TIME
                );
                if ($setup == 0) {
                    $inarr['subtitle'] = '借用会员: '.$userinfo['username'];
                    $inarr['content'] = '设备编码: '.$cdb['sn'].'; 借用会员: '.$userinfo['username'];
                }
                if ($buser) {
                    $inarr['userid'] = $buser['id'];
                }
                $CI->load->library('getui');
                $CI->getui->message($inarr);
                db_trans_complete();
                break;

            /**
             * 归还设备
             */
            case '103':
                $cdb = $row['setting']['cdb'];
                $userid = $row['userid'];       //消费者
                $userinfo = db_getone(table('users'), array('id'=>$userid));    //消费者
                db_trans_start();
                //更新订单信息
                db_update(table('order'), array('ret' => 0, 'retpaydate'=>SYS_TIME, 'retpayid'=>$row['payid'], 'retpaytype'=>$type), array('id'=>$cdb['orderinfo']['id']));
                //标记已付款（归还）
                db_update(table('pay'), array('status' => '已付款'), array('userid' => $row['userid'], 'status' => '使用中', 'sn'=>$cdb['sn']));
                //更新完成次数
                db_update(table('users'), array('complete_num[+]'=>1), array('id'=>$userinfo['id']));
                //事件关联
                $CI->load->model('userevent');
                if ($userinfo['complete_num'] == 0) {
                    $CI->userevent->first_complete($userinfo['id']);
                }else{
                    $CI->userevent->every_complete($userinfo['id']);
                }
                //如果使用优惠券（标记优惠券已使用）
                used_users_sale($row['usaleid'], $cdb['orderinfo']['id']);
                //商家收益
                $setup = store_float($row['money'] * INCOME_GIVEBACK, true);
                $auser = db_getone(table('users'), array('id'=>$cdb['orderinfo']['retuserid']));
                $buser = ($auser['masterid']>0)?masterUser($auser):array();    //获取主商家
                if ($setup > 0) {
                    $inarr = array(
                        'type'=>'income',
                        'payid'=>$row['payid'],
                        'subtype'=>'归还设备',
                        'userid'=>$auser['id'],
                        'fromid'=>0,
                        'fromname'=>'系统',
                        'orderid'=>$cdb['orderinfo']['id'],
                        'title'=>'归还设备: '. $cdb['sn'],
                        'setup'=>$setup,
                        'after'=>$auser['income'] + $setup,
                        'setting'=>array2string(array('cdb'=>$cdb, 'pay'=>$row)),
                        'indate'=>SYS_TIME
                    );
                    if ($buser) {
                        $inarr['userid'] = $buser['id'];
                        $inarr['after'] = $buser['income'] + $setup;
                        $inarr['masterid'] = $auser['id'];
                        $inarr['mastername'] = $auser['username'];
                    }
                    db_insert(table('users_log'), $inarr);
                    db_update(table('users'), array('income[+]'=>$setup, 'income_plus[+]'=>$setup), array('id'=>$inarr['userid']));
                }
                //通知商家
                $inarr = array(
                    'userid'=>$cdb['orderinfo']['retuserid'],
                    'type'=>"giveback",
                    'tobe'=>1,
                    'title'=>'归还已完成: '.$cdb['sn'],
                    'subtitle'=>'归还会员: '.$userinfo['username'].'; 本次收益: '.$setup.'元',
                    'content'=>'设备编码: '.$cdb['sn'].'; 归还会员: '.$userinfo['username'].'; 本次收益: '.$setup.'元',
                    'indate'=>SYS_TIME
                );
                if ($setup == 0) {
                    $inarr['subtitle'] = '归还会员: '.$userinfo['username'];
                    $inarr['content'] = '设备编码: '.$cdb['sn'].'; 归还会员: '.$userinfo['username'];
                }
                if ($buser) {
                    $inarr['userid'] = $buser['id'];
                }
                $CI->load->library('getui');
                $CI->getui->message($inarr);
                db_trans_complete();
                break;

            /**
             * 商家入驻支付费用
             */
            case '104':
                $userid = $row['userid'];       //消费者
                //
                db_trans_start();
                //生成订单记录
                db_insert(table('order_join'), array(
                    'storename' =>  $row['setting']['submitGPC']['storename'],
                    'address' =>    $row['setting']['submitGPC']['address'],
                    'username' =>   $row['setting']['submitGPC']['username'],
                    'userphone' =>  $row['setting']['submitGPC']['userphone'],

                    'paytype' =>    $type,
                    'paysubtype' => $subtype,
                    'payid' =>      $row['payid'],
                    'userid' =>     $userid,
                    'status' =>     '审核中',
                    'indate' =>     SYS_TIME
                ));
                db_trans_complete();
                break;

            /**
             * 参数错误
             */
            default:
                return error('参数错误！');
        }
        return error(0, '支付成功！');
    }
}


if ( ! function_exists('apply_return')) {

    /**
     * 退款订单
     * @param $payid
     * @param $userid
     * @return array
     */
    function apply_return($payid, $userid)
    {
        //
        if (empty($payid)) {
            return error(1, '参数丢失！');
        }
        $wherearr = array('payid' => $payid, 'type' => 'deposit');
        if ($userid !== false) { $wherearr['userid'] = $userid; }
        $row = db_getone(table('pay'), $wherearr);
        if (empty($row)) {
            return error(1, '记录不存在！');
        }
        if ($row['status'] == '已退款') {
            return error(0, "已完成退款！");
        }
        if (!in_array($row['status'], array('已付款', '退款中'))) {
            return error(1, '非允许退款状态！');
        }
        //
        $row['setting'] = string2array($row['setting']);
        $backid = date('Ymds', SYS_TIME) . rand(10, 99) . $row['id'] . $row['userid'];
        $setting = setting('pay');
        //
        $CI = & get_instance();
        switch ($row['payfrom']) {

            case '微信':
                $payconfig = $setting['weixin'];
                if ($row['subpayfrom'] == '微信公众号') {
                    if (!$payconfig['open']) {
                        return error(1, '系统正在维护...');
                    }
                    define('WXPC_APPID', $payconfig['appid']);
                    define('WXPC_MCHID', $payconfig['mchid']);
                    define('WXPC_KEY', $payconfig['apikey']);
                    define('WXPC_APPSECRET', $payconfig['secret']);
                    define('WXPC_SSLCERT', payCert('wx_cert'));
                    define('WXPC_SSLKEY', payCert('wx_cert_key'));
                }elseif ($row['subpayfrom'] == '微信小程序') {
                    if (!$payconfig['openxiaoapp']) {
                        return error(1, '系统正在维护...');
                    }
                    define('WXPC_APPID', $payconfig['xiaoapp_appid']);
                    define('WXPC_MCHID', $payconfig['xiaoapp_mchid']);
                    define('WXPC_KEY', $payconfig['xiaoapp_apikey']);
                    define('WXPC_APPSECRET', $payconfig['xiaoapp_secret']);
                    define('WXPC_SSLCERT', payCert('wxxiaoapp_cert'));
                    define('WXPC_SSLKEY', payCert('wxxiaoapp_cert_key'));
                } else {
                    if (!$payconfig['openapp']) {
                        return error(1, '系统正在维护...');
                    }
                    if ($row['paydate'] < strtotime('2017-07-14 11:50:00')) {
                        $setting = setting('old_pay');
                        $payconfig = $setting['weixin'];
                        define('WXPC_SSLCERT', payCert('wxapp_cert', true));
                        define('WXPC_SSLKEY', payCert('wxapp_cert_key', true));
                    }else{
                        define('WXPC_SSLCERT', payCert('wxapp_cert'));
                        define('WXPC_SSLKEY', payCert('wxapp_cert_key'));
                    }
                    define('WXPC_APPID', $payconfig['app_appid']);
                    define('WXPC_MCHID', $payconfig['app_mchid']);
                    define('WXPC_KEY', $payconfig['app_apikey']);
                    define('WXPC_APPSECRET', $payconfig['app_secret']);
                }
                //开始退款
                require_once(dirname(dirname(__FILE__)) . '/' . '../libraries/weixin/WxPay.Api.php');
                $input = new WxPayRefund();
                $input->SetOut_trade_no($row['payid']);
                $input->SetTotal_fee(intval($row['money'] * 100));
                $input->SetRefund_fee(intval($row['money'] * 100));
                $input->SetOut_refund_no($backid);
                $input->SetOp_user_id(WxPayConfig::MCHID);
                $retResult = WxPayApi::refund($input);
                if ($retResult['return_code'] == 'FAIL') {
                    return error(1, $retResult['return_msg']);
                }
                if ($retResult['result_code'] == 'FAIL') {
                    //未结算资金不足，使用余额付款
                    if ($retResult['err_code'] == 'NOTENOUGH' && $retResult['err_code_des'] == '交易未结算资金不足，请使用可用余额退款') {
                        $input->SetRefund_account('REFUND_SOURCE_RECHARGE_FUNDS');
                        $retResult = WxPayApi::refund($input);
                    }
                    //余额不足，付款失败
                    if ($retResult['result_code'] == 'FAIL') {
                        return apply_return_way($row, $retResult['err_code_des'] ? $retResult['err_code_des'] : '退款失败，错误代码：' . $retResult['err_code']);
                    }
                }
                if ($retResult['result_code'] != 'SUCCESS') {
                    return apply_return_way($row, "退款失败，错误代码：-1");
                }
                $row['setting']['retResult'] = $retResult;
                db_update(table('pay'), array('status' => '已退款', 'retdate' => SYS_TIME, 'setting' => array2string($row['setting'])), array('id' => $row['id']));
                //通知
                $CI->load->library('getui');
                $CI->getui->message(array(
                    'userid' => $row['userid'],
                    'type' => "retdeposit",
                    'tobe' => 1,
                    'title' => '押金退款成功',
                    'subtitle' => '退款金额: ' . $row['money'] . '元',
                    'content' => '退款金额: ' . $row['money'] . '元; 退回账户: ' . $row['payfrom'],
                    'indate' => SYS_TIME
                ));
                return error(0, "已完成退款");
                break;

            case '支付宝':
                $CI->load->library('alipay');
                $payconfig = $setting['alipay'];
                if (!$payconfig['openapp']) {
                    return error(1, '系统正在维护...');
                }
                if ($row['paydate'] < strtotime('2017-07-12 13:00:00')) {
                    $setting = setting('old_pay');
                    $CI->alipay->config($setting['alipay']);
                }
                $array = array(
                    'out_trade_no' => $row['payid'],
                    'trade_no' => '',
                    'refund_amount' => $row['money'],
                    'refund_reason' => '正常押金退款',
                    'out_request_no' => '',
                    'operator_id' => '',
                    'store_id' => '',
                    'terminal_id' => ''
                );
                //开始退款
                $retResult = $CI->alipay->refund($array);
                if (intval($retResult['code']) != 10000) {
                    return apply_return_way($row, $retResult['sub_msg'] ? $retResult['sub_msg'] : '退款失败，错误代码：' . $retResult['code']);
                }
                $row['setting']['retResult'] = $retResult;
                db_update(table('pay'), array('status' => '已退款', 'retdate' => SYS_TIME, 'setting' => array2string($row['setting'])), array('id' => $row['id']));
                //通知
                $CI->load->library('getui');
                $CI->getui->message(array(
                    'userid' => $row['userid'],
                    'type' => "retdeposit",
                    'tobe' => 1,
                    'title' => '押金退款成功',
                    'subtitle' => '退款金额: ' . $row['money'] . '元',
                    'content' => '退款金额: ' . $row['money'] . '元; 退回账户: ' . $row['payfrom'],
                    'indate' => SYS_TIME
                ));
                return error(0, "已完成退款！");
                break;
        }
        return error(1, '订单支付方式不可退款！');
    }
}

if ( ! function_exists('apply_return_way')) {

    /**
     * 标记为退款中
     * @param $row
     * @param $retmsg
     * @return array
     */
    function apply_return_way($row, $retmsg)
    {
        if ($row['retdate'] == 0) {
            //通知财务人员
            $CI = & get_instance();
            $CI->load->library('getui');
            $adminlist = get_notify_users('deposit_notify');
            if ($adminlist) {
                foreach ($adminlist AS $aitem) {
                    $CI->getui->message(array(
                        'userid' => $aitem['id'],
                        'type' => "retnotification",
                        'tobe' => 1,
                        'title' => '退款申请通知',
                        'subtitle' => '商户编号: ' . $row['payid'],
                        'content' => '商户编号: ' . $row['payid'],
                        'indate' => SYS_TIME
                    ));
                }
            }
        }
        db_update(table('pay'), array('status' => '退款中', 'retmsg' => $retmsg, 'retdate' => SYS_TIME), array('id' => $row['id']));
        return error(0, "退款申请已受理，将于3个工作日内完成！");
    }
}