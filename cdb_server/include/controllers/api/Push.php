<?php
defined('BASEPATH') OR exit('No direct script access allowed');
error_reporting(0);

class Push extends CI_Controller {

	public function __construct()
	{
		parent::__construct();
        the_user();
	}

    /**
     * 更新推送身份标识cid
     */
    public function cid()
    {
        global $_A,$_GPC;
        if ($_GPC['cid']) {
            db_update(table('users'), array('push_cid'=>'', 'push_update'=>SYS_TIME), array('push_cid'=>$_GPC['cid']));
            if ($_A['user']['id'] > 0) {
                db_update(table('users'), array('push_cid'=>$_GPC['cid'], 'push_update'=>SYS_TIME), array('id'=>$_A['user']['id']));
            }
        }
        json_sure('更新成功！');
    }

    /**
     * 清除推送身份标识cid
     */
    public function cidclear()
    {
        global $_GPC;
        if ($_GPC['cid']) {
            db_update(table('users'), array('push_cid'=>'', 'push_update'=>SYS_TIME), array('push_cid'=>$_GPC['cid']));
        }
        json_sure('更新成功！');
    }

    /**
     * 获取通知列表
     */
    public function message_appcall()
    {
        global $_A;
        if ($_A['user']['id'] > 0) {
            $lists = db_getall(table('message'), array('userid'=>$_A['user']['id'], 'tobe'=>1, 'appcall'=>0 ,'viewdate'=>0), "indate DESC");
            if ($lists) {
                db_update(table('message'), array('appcall'=>1), array('appcall'=>0 ,'userid'=>$_A['user']['id']));
            }
            json_sure($lists);
        }
        json_error('没有数据！');
    }

    /**
     * 阅读信息
     */
    public function message_read()
    {
        global $_A,$_GPC;
        if ($_A['user']['id'] > 0) {
            db_update(table('message'), array('viewdate'=>SYS_TIME), array('id'=>$_GPC['id'] ,'userid'=>$_A['user']['id']));
        }
        json_sure('read:ok');
    }
}
