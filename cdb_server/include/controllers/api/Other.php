<?php
defined('BASEPATH') OR exit('No direct script access allowed');

class Other extends CI_Controller {

    public function __construct()
    {
        parent::__construct();
    }

    /**
     * 生成二维码 (设备)
     */
    public function cdb_qrcode()
    {
        global $_GPC;
        include_once dirname(dirname(dirname(__FILE__))) . "/libraries/other/phpqrcode.php";
        QRcode::png(url('cdb/' . $_GPC['sn']), false, 'M', 10, 1);
        exit();
    }

    /**
     * 生成二维码 (会员)
     */
    public function users_qrcode()
    {
        global $_GPC;
        include_once dirname(dirname(dirname(__FILE__))) . "/libraries/other/phpqrcode.php";
        QRcode::png(url('users/' . $_GPC['sn']), false, 'M', 10, 1);
        exit();
    }


    /**
     * 根据经纬度查询地址详情 (设备)
     */
    public function position_address()
    {
        global $_GPC;
        $this->load->library('geocoding');
        if (!($_GPC['lon'] && $_GPC['lat'])) {
            json_error('参数错误');
        }
        $data = $this->geocoding->getAddressComponent($_GPC['lon'], $_GPC['lat']);
        if (!$data['result']['formatted_address']) {
            json_error('获取失败');
        }
        $data['result']['address'] = $data['result']['formatted_address'];
        json_sure($data['result']);
    }


    /**
     * 通过sn和userid获取设备是否支付成功（userid为用户的）
     */
    public function sn_pay_status()
    {
        global $_GPC;
        if ($_GPC['sn'] && $_GPC['userid']) {
            $count = db_count(table('cdb'), array('sn'=>$_GPC['sn'], 'userid'=>$_GPC['userid'], 'status'=>'使用中'));
            if ($count > 0) {
                json_sure('ok');
            }
        }
        json_error('err');
    }

    /**
     * 通过sn和orderid获取设备是否归还成功（orderid为借用订单ID）
     */
    public function sn_give_status()
    {
        global $_GPC;
        if ($_GPC['sn'] && $_GPC['orderid']) {
            $count = db_count(table('order'), array('sn'=>$_GPC['sn'], 'id'=>$_GPC['orderid'], '`retpaydate`>'=>'0'));
            if ($count > 0) {
                json_sure('ok');
            }
        }
        json_error('err');
    }

    /**
     * 通过会员ID和支付订单ID获取会员是否已经支付商家入驻费用
     */
    public function user_joindealer()
    {
        global $_GPC;
        if ($_GPC['userid'] > 0) {
            $row = db_getone(table('order_join'), array('userid'=>$_GPC['userid'], 'payid'=>$_GPC['payid'], 'status'=>'审核中'));
            if ($row) {
                json_sure('ok');
            }
        }
        json_error('err');
    }

    /**
     * 代理商合作提交申请
     */
    public function user_joinagents()
    {
        global $_A,$_GPC;
        the_user();
        if (empty($_A['user']['id'])) {
            json_error('身份丢失', 1001);
        }
        if (empty($_GPC['fullname'])) {
            json_error('请输入姓名');
        }
        if (empty($_GPC['userphone'])) {
            json_error('请输入联系电话');
        }
        if (empty($_GPC['weixin'])) {
            json_error('请输入微信');
        }
        if (empty($_GPC['area'])) {
            json_error('请输入城市/区域');
        }
        if (empty($_GPC['advantage'])) {
            json_error('请输入资源优质');
        }
        db_insert(table('joinagents'), array(
            'userid'=>$_A['user']['id'],
            'username'=>$_A['user']['username'],
            'fullname'=>$_GPC['fullname'],
            'userphone'=>$_GPC['userphone'],
            'weixin'=>$_GPC['weixin'],
            'area'=>$_GPC['area'],
            'advantage'=>$_GPC['advantage'],
            'indate'=>SYS_TIME
        ));
        json_sure('您的申请已提交，我们会尽快审核您的材料，审核通过我们将会有市场客服人员联系您。如有需求，请联系客服电话'.settingfind('system', 'tel_num').'。');
    }

    /**
     * 根据会员ID获取设备数量
     */
    public function userid_cdbnum()
    {
        global $_GPC;
        $arr = array(
            'userid' => $_GPC['userid'],
            'count' => 0
        );
        if ($_GPC['userid'] > 0) {
            $arr['count'] = intval(db_getone(table('users'), array('id'=>$_GPC['userid']), '', 'cdbnum'));
            $arr['count']+= db_total("SELECT cdbnum AS num FROM ".table('users'), array('mastersync'=>1, 'masterid'=>$_GPC['userid']));
        }
        json_sure($arr);
    }
}
