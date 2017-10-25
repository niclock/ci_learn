<?php
defined('BASEPATH') OR exit('No direct script access allowed');

/**
 * 设备二维码页面
 * Class Cdb
 */
class Cdb extends CI_Controller {

	public function __construct()
	{
		parent::__construct();
	}

    public function _remap()
    {
        global $_A,$_GPC;
        if ($_A['segments'][2] && $_A['segments'][2] != 'index') {
            gourl(url('cdb').'?s='.$_A['segments'][2]);
        }
        the_user();
        //
        $cdb = cdb_info($_GPC['s']);
        $wx_openid = wx_pay_openid();
        if ($wx_openid) {
            $userid = db_getone(table('users'), array('wx_openid'=>$wx_openid), '', 'id');
            if ($userid > 0) {
                $this->session->set_userdata('userid', $userid);
                the_user();
            }
        }
        tpl('index', get_defined_vars());
    }
}
