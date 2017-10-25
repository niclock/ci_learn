<?php
defined('BASEPATH') OR exit('No direct script access allowed');
error_reporting(0);

class Users extends CI_Controller {

    public function __construct()
    {
        parent::__construct();
        the_user();
    }

    /**
     * 登录
     */
    public function login()
    {
        global $_A,$_GPC;
        $arr = array();
        $arr['success'] = 0;
        $arr['message'] = '';
        $arr['userinfo'] = array();
        //
        if ($_GPC['code']) {
            //验证码登录
            $this->load->model('sms');
            $smsarr = $this->sms->verify($_GPC['userphone'], $_GPC['code'], 0, 'verification');
            if (empty($smsarr['success'])) {
                json_error('验证码错误！');
            }
            $row = db_getone(table('users'), array('userphone'=>$_GPC['userphone']));
            if (empty($row)) {
                //新用户
                $fromid = intval($_GPC['fromid']);      //邀请的会员ID
                $invitenum = 0;                         //累计邀请次数
                if ($fromid > 0) {
                    $fromrow = db_getone(table('users'), array('id'=>$fromid));
                    if (empty($fromrow)) {
                        $fromid = 0;
                    }else{
                        $invitenum = db_count(table('users'), array('from_id'=>$fromid));
                    }
                }
                $invitenum++;
                //
                db_trans_start();
                db_insert(table('users'), array(
                    'from_id'=>$fromid,
                    'browser_sn'=>$_GPC['__browser_sn']?$_GPC['__browser_sn']:'',
                    'username'=>substr($_GPC['userphone'], 0, 3).'****'.substr($_GPC['userphone'], -4),
                    'userphone'=>$_GPC['userphone'],
                    'userpass'=>'',
                    'regbrowser'=>$_A['browser'],
                    'regtype'=>'phone',
                    'regip'=>ONLINE_IP,
                    'regdate'=>SYS_TIME
                ));
                $row = db_getone(table('users'), array('userphone'=>$_GPC['userphone']));
                if (empty($row)) {
                    $arr['message'] = '登录失败，请稍后再试！';
                    json_echo($arr);
                }
                $this->load->model('userevent');
                $this->userevent->reg($row['id']);
                if ($fromid > 0) {
                    if ($invitenum == 1) {
                        $this->userevent->first_invite($fromid);
                    }elseif ($invitenum > 1) {
                        $this->userevent->every_invite($fromid);
                    }
                }
                db_trans_complete();
            }else{
                //老用户
                $uparr = array('loginnum[+]'=>1, 'loginapp[+]'=>1, 'lastip'=>ONLINE_IP, 'lastdate'=>SYS_TIME);
                if ($_GPC['__browser_sn']) {
                    $uparr['browser_sn'] = $_GPC['__browser_sn'];
                }
                db_trans_start();
                db_update(table('users'), $uparr, array('id'=>$row['id']));
                $this->load->model('userevent');
                $this->userevent->login($row['id']);
                db_trans_complete();
            }
        }else{
            //密码登录
            $row = db_getone(table('users'), array('userphone'=>$_GPC['userphone']));
            if (empty($row)) {
                $arr['message'] = '账号或密码错误！';
                json_echo($arr);
            }
            if ($row['userpass'] != md52($_GPC['userpass'])) {
                $arr['message'] = '账号或密码错误！';
                json_echo($arr);
            }
            //
            $uparr = array('loginnum[+]'=>1, 'loginapp[+]'=>1, 'lastip'=>ONLINE_IP, 'lastdate'=>SYS_TIME);
            if ($_GPC['__browser_sn']) {
                $uparr['browser_sn'] = $_GPC['__browser_sn'];
            }
            db_trans_start();
            db_update(table('users'), $uparr, array('id'=>$row['id']));
            $this->load->model('userevent');
            $this->userevent->login($row['id']);
            db_trans_complete();
        }
        $row['setting'] = string2array($row['setting']);
        //
        if ($_GPC['__browser_sn']) {
            db_update(table('users'), array('browser_sn'=>''), array('browser_sn'=>$_GPC['__browser_sn'], '`id`!='=>$row['id']));
        }
        //
        $this->session->set_userdata('userid', $row['id']);
        setcookie('__:proxy:userid', $row['id'], SYS_TIME + 2592000, BASE_DIR);
        setcookie('__:proxy:username', $row['username'], SYS_TIME + 2592000, BASE_DIR);
        setcookie('__:proxy:userphone', $row['userphone'], SYS_TIME + 2592000, BASE_DIR);
        //
        if ($_GPC['wx_openid'] == 'in') {
            $wx_openid = wx_pay_openid();
            if ($wx_openid) {
                db_update(table('users'), array('wx_openid'=>''), array('wx_openid'=>$wx_openid));
                db_update(table('users'), array('wx_openid'=>$wx_openid), array('id'=>$row['id']));
            }
        }
        //
        $arr['success'] = 1;
        $arr['message'] = '登录成功';
        $arr['userinfo'] = $this->userinfo($row);
        json_echo($arr);
    }

    /**
     * 切换账号
     */
    public function uswitch()
    {
        global $_A,$_GPC;
        //
        if (empty($_A['user']['id'])) {
            json_error('身份丢失', 1001);
        }
        //
        $row = array();
        foreach (user_switch($_A['user']['id']) AS $item) {
            if ($item['id'] == $_GPC['userid']) {
                $row = $item;
                break;
            }
        }
        $arr = array();
        $arr['success'] = 0;
        $arr['message'] = '切换失败，请退出重新登录！';
        $arr['userinfo'] = array();
        if ($row) {
            $uparr = array('loginnum[+]'=>1, 'loginapp[+]'=>1, 'lastip'=>ONLINE_IP, 'lastdate'=>SYS_TIME);
            if ($_GPC['__browser_sn']) {
                $uparr['browser_sn'] = $_GPC['__browser_sn'];
                db_update(table('users'), array('browser_sn'=>''), array('browser_sn'=>$_GPC['__browser_sn'], '`id`!='=>$row['id']));
            }
            db_update(table('users'), $uparr, array('id'=>$row['id']));
            //
            $this->session->set_userdata('userid', $row['id']);
            setcookie('__:proxy:userid', $row['id'], SYS_TIME + 2592000, BASE_DIR);
            setcookie('__:proxy:username', $row['username'], SYS_TIME + 2592000, BASE_DIR);
            setcookie('__:proxy:userphone', $row['userphone'], SYS_TIME + 2592000, BASE_DIR);
            //
            $arr['success'] = 1;
            $arr['message'] = '切换成功';
            $arr['userinfo'] = $this->userinfo($row);
        }
        json_echo($arr);
    }

    /**
     * 登出
     */
    public function out()
    {
        global $_A,$_GPC;
        if ($_GPC['clear'] == 'wx_openid' && $_A['user']['wx_openid']) {
            db_update(table('users'), array('wx_openid'=>''), array('wx_openid'=>$_A['user']['wx_openid']));
        }
        $this->session->set_userdata('userid', '');
        setcookie('__:proxy:userid', '', SYS_TIME - 1, BASE_DIR);
        setcookie('__:proxy:username', '', SYS_TIME - 1, BASE_DIR);
        setcookie('__:proxy:userphone', '', SYS_TIME - 1, BASE_DIR);
        json_sure('退出成功');
    }

    /**
     * 检测用户
     */
    public function check()
    {
        global $_A;
        if ($_A['user']['id'] > 0) {
            json_sure('sure');
        }else{
            json_error('error');
        }
    }

    /**
     * 获取用户相关信息
     */
    public function otherinfo()
    {
        global $_A;
        if (empty($_A['user']['id'])) {
            json_error('身份丢失', 1001);
        }
        $arr = array();
        //余额
        $arr['money'] = $_A['user']['money'];
        //收益
        $arr['income'] = $_A['user']['income'];
        //设备数量
        $arr['cdbnum'] = $_A['user']['cdbnum'];
        //押金
        $wheresql = "`userid`=".$_A['user']['id']." AND `type`='deposit' AND `status` IN ('已付款','使用中','退款中')";
        $arr['deposit'] = store_float(db_total("SELECT money AS num FROM ".table('pay'), $wheresql));
        //
        json_sure(array_merge($arr, $this->tisnum(true)));
    }

    /**
     * 获取提示总数
     * @param bool $isRet
     * @return array
     */
    public function tisnum($isRet = false)
    {
        global $_A;
        $arr = users_badge($_A['user']['id']);
        if (empty($_A['user']['id'])) {
            if (!$isRet) { json_error('身份丢失', 1001); }
            return $arr;
        }
        if (!$isRet) { json_sure($arr); }
        return $arr;
    }

    /**
     * 认领设备
     */
    public function claim()
    {
        global $_A,$_GPC;
        if (empty($_A['user']['id'])) {
            json_error('身份丢失', 1001);
        }
        if (empty($_A['user']['isdealer'])) {
            //不是商家
            json_error('您没有认领设备的权限！');
        }
        if (empty($_A['user']['isentry'])) {
            //没有录入权限
            json_error('认领设备的权限不足！');
        }
        $setting = setting('system');
        if ($setting['claim_pass'] && $setting['claim_pass'] != md52($_GPC['claimpass'])) {
            json_error('请输入正确的认领密码！');
        }
        $cdb = cdb_info($_GPC['sn']);
        if ($cdb['status'] == '启用' && $cdb['userid'] == 0) {
            db_trans_start();
            $upcdb = array();
            $upcdb['userid'] = $_A['user']['id'];
            $upcdb['update'] = SYS_TIME;
            db_update(table('cdb'), $upcdb, array('id' => $cdb['id']));
            users_cdbnum($_A['user']['id']);
            //生成设备记录
            db_insert(table('cdb_notes'), array(
                'type'=>'in',
                'sn'=>$cdb['sn'],
                'userid'=>$_A['user']['id'],
                'userid_be'=>0,
                'indate'=>SYS_TIME
            ));
            db_trans_complete();
            //
            $this->load->library('getui');
            $this->getui->message(array(
                'userid' => $_A['user']['id'],
                'type' => "claim",
                'tobe' => 1,
                'title' => '认领成功',
                'subtitle' => '设备编号：' . $cdb['sn'],
                'content' => '设备编号：' . $cdb['sn'],
                'indate' => SYS_TIME
            ));
            json_sure('认领成功！');
        }else{
            json_error('此设备不符合认领条件！');
        }
    }

    /**
     * 取回(归还)设备
     */
    public function giveback()
    {
        global $_A,$_GPC;
        if (empty($_A['user']['id'])) {
            json_error('身份丢失', 1001);
        }
        if ($_GPC['act'] == 'apply') {
            //收回设备
            $cdb = cdb_info($_GPC['sn']);
            if ($cdb['status'] != '使用中') {
                json_error('设备不在使用状态无法取回！');
            }
            if (!$_A['user']['isdealer']) {
                json_error('您不是商家，无法使用收回设备功能！');
            }
            $orderinfo = db_getone(table('order'), array('sn'=>$cdb['sn'], 'userid'=>$cdb['userid']), '`indate` DESC,`id` DESC');
            if ($orderinfo['retpaydate'] > 0) {
                json_error('订单状态异常，请联系客服！');
            }
            //
            db_trans_start();
            $upcdb = array();
            $upcdb['userid'] = $_A['user']['id'];
            $upcdb['status'] = '启用';
            $upcdb['update'] = SYS_TIME;
            db_update(table('cdb'), $upcdb, array('id' => $cdb['id']));
            db_update(table('order'),
                array('ret'=>1, 'retdate' => SYS_TIME, 'retuserid' => $_A['user']['id'], 'retmoney' => cdb_totalMoney($orderinfo['indate'], 0, 0, $cdb['type'])),
                array('id'=>$orderinfo['id']));
            users_cdbnum($_A['user']['id']);
            users_cdbnum($cdb['userid']);
            //标记等待付款
            db_update(table('pay'), array('waitorder' => $orderinfo['id']), array('userid' => $cdb['userid'], 'status' => '使用中', 'sn'=>$cdb['sn']));
            //生成设备记录
            db_insert(table('cdb_notes'), array(
                'type'=>'in',
                'sn'=>$cdb['sn'],
                'userid'=>$_A['user']['id'],
                'userid_be'=>$cdb['userid'],
                'indate'=>SYS_TIME
            ));
            db_trans_complete();
            //
            $this->load->library('getui');
            $this->getui->information($cdb['userid'], 'giveback', '归还提醒', '点击这里查看详情');
            json_sure('收回设备成功！');
        }elseif ($_GPC['act'] == 'mark') {
            //用户设置归还状态
            $order = db_getone(table('order'), array('userid'=>$_A['user']['id'], 'id'=>$_GPC['orderid']), '`ret` DESC');
            if (empty($order)) {
                json_error('订单不存在！');
            }
            if ($order['ret'] == 0) {
                json_error(($order['retpaydate']>0?'此订单已付款':'此订单状态异常').'（请刷新查看最新状态）');
            }
            db_update(table('order'), array('ret'=>2), array('userid'=>$_A['user']['id'], 'ret'=>1));
            db_update(table('order'), array('ret'=>1), array('userid'=>$_A['user']['id'], 'id'=>$_GPC['orderid']));
            json_sure('设置成功！');
        }elseif ($_GPC['act'] == 'clear') {
            //用户消除归还状态
            db_update(table('order'), array('ret'=>2), array('userid'=>$_A['user']['id'], 'ret'=>1));
            json_sure('消除成功！');
        }else{
            //用户拉取归还状态（检查有没有正在归还的设备）
            $row = db_getone(table('order'), array('userid'=>$_A['user']['id'], 'ret'=>1), '`retdate` ASC', 'id,sn,retdate');
            if (empty($row)) { json_error(''); }
            json_sure($row);
        }
    }

    /**
     * 已付押金，直接租用
     */
    public function borrow()
    {
        global $_A,$_GPC;
        //
        $row = depositPay();
        if (empty($row)) {
            json_error('借用数量超出最大值，请返回重新借用');
        }
        //
        $cdb = cdb_info($_GPC['sn']);
        if (intval($cdb['id']) == 0) {
            json_error($cdb?$cdb:'参数错误！');
        }
        if ($cdb['userid'] == $_A['user']['id']) {
            json_error('抱歉，此设备已经被您使用！');
        }
        if ($cdb['userid'] == 0) {
            json_error('抱歉，此设备尚未投入使用！');
        }
        if ($cdb['status'] != '启用') {
            json_error('抱歉，此设备当前状态不可借用！');
        }
        if ($_A['user']['isdealer']) {
            json_error('抱歉，商家身份不能借用设备！');
        }
        if (!in_array($cdb['type'], array('充电宝'))) {
            json_error('抱歉，错误的请求！');
        }
        $userid = $_A['user']['id'];       //消费者
        db_trans_start();
        //更新设备数据
        $upcdb = array();
        $upcdb['userid'] = $userid;
        $upcdb['status'] = '使用中';
        $upcdb['update'] = SYS_TIME;
        db_update(table('cdb'), $upcdb, array('id'=>$cdb['id']));
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
            'paytype' =>    '免付',
            'payid' =>      $row['payid'],
            'userid' =>     $userid,
            'userid_old' => $cdb['userid'],
            'sn' =>         $cdb['sn'],
            'indate' =>     SYS_TIME
        ), true);
        //标记使用中
        db_update(table('pay'), array('status' => '使用中', 'waitorder' => 0, 'sn' => $cdb['sn']), array('id' => $row['id']));
        //商家收益
        $setup = store_float(INCOME_BORROW, true);
        $auser = db_getone(table('users'), array('id'=>$cdb['userid']));
        $buser = ($auser['masterid']>0)?masterUser($auser):array();    //获取主商家
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
            'subtitle'=>'借用会员: '.$_A['user']['username'].'; 本次收益: '.$setup.'元',
            'content'=>'设备编码: '.$cdb['sn'].'; 借用会员: '.$_A['user']['username'].'; 本次收益: '.$setup.'元',
            'indate'=>SYS_TIME
        );
        if ($setup == 0) {
            $inarr['subtitle'] = '借用会员: '.$_A['user']['username'];
            $inarr['content'] = '设备编码: '.$cdb['sn'].'; 借用会员: '.$_A['user']['username'];
        }
        if ($buser) {
            $inarr['userid'] = $buser['id'];
        }
        $this->load->library('getui');
        $this->getui->message($inarr);
        //
        db_trans_complete();
        json_sure('租用成功！');
    }

    /**
     * 免押金设备，直接租用（雨伞）
     */
    public function borrow_free()
    {
        global $_A,$_GPC;
        //
        $cdb = cdb_info($_GPC['sn']);
        if (intval($cdb['id']) == 0) {
            json_error($cdb?$cdb:'参数错误！');
        }
        if ($cdb['userid'] == $_A['user']['id']) {
            json_error('抱歉，此设备已经被您使用！');
        }
        if ($cdb['userid'] == 0) {
            json_error('抱歉，此设备尚未投入使用！');
        }
        if ($cdb['status'] != '启用') {
            json_error('抱歉，此设备当前状态不可借用！');
        }
        if ($_A['user']['isdealer']) {
            json_error('抱歉，商家身份不能借用设备！');
        }
        if (!in_array($cdb['type'], array('雨伞'))) {
            json_error('抱歉，错误的请求！');
        }
        $userid = $_A['user']['id'];       //消费者
        db_trans_start();
        //更新设备数据
        $upcdb = array();
        $upcdb['userid'] = $userid;
        $upcdb['status'] = '使用中';
        $upcdb['update'] = SYS_TIME;
        db_update(table('cdb'), $upcdb, array('id'=>$cdb['id']));
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
            'type' =>       'ys',
            'paytype' =>    '免付',
            'payid' =>      0,
            'userid' =>     $userid,
            'userid_old' => $cdb['userid'],
            'sn' =>         $cdb['sn'],
            'indate' =>     SYS_TIME
        ), true);
        //商家收益
        $setup = store_float(INCOME_BORROW, true);
        $auser = db_getone(table('users'), array('id'=>$cdb['userid']));
        $buser = ($auser['masterid']>0)?masterUser($auser):array();    //获取主商家
        if ($setup > 0) {
            $inarr = array(
                'type'=>'income',
                'payid'=>0,
                'subtype'=>'借出设备',
                'userid'=>$auser['id'],
                'fromid'=>0,
                'fromname'=>'系统',
                'orderid'=>$orderid,
                'title'=>'借出设备: '. $cdb['sn'],
                'setup'=>$setup,
                'after'=>$auser['income'] + $setup,
                'setting'=>array2string(array('cdb'=>$cdb)),
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
            'subtitle'=>'借用会员: '.$_A['user']['username'].'; 本次收益: '.$setup.'元',
            'content'=>'设备编码: '.$cdb['sn'].'; 借用会员: '.$_A['user']['username'].'; 本次收益: '.$setup.'元',
            'indate'=>SYS_TIME
        );
        if ($setup == 0) {
            $inarr['subtitle'] = '借用会员: '.$_A['user']['username'];
            $inarr['content'] = '设备编码: '.$cdb['sn'].'; 借用会员: '.$_A['user']['username'];
        }
        if ($buser) {
            $inarr['userid'] = $buser['id'];
        }
        $this->load->library('getui');
        $this->getui->message($inarr);
        //
        db_trans_complete();
        json_sure('租用成功！');
    }

    /**
     * 获取短信验证码
     */
    public function sms()
    {
        global $_GPC;
        if (!isMobile($_GPC['userphone'])) {
            json_error('请输入正确的手机号码！');
        }

        $this->load->model('sms');
        $arr = $this->sms->send($_GPC['userphone'], 0, 'verification',$_GPC['type']);
        json_echo($arr);
    }

    /**
     * 验证短信验证码
     */
    public function sms_verify()
    {
        global $_GPC;
        if (!isMobile($_GPC['userphone'])) {
            json_error('请输入正确的手机号码！');
        }
        if (empty($_GPC['code'])) {
            json_error('请输入验证码！');
        }


        $this->load->model('sms');
        $smsarr = $this->sms->verify($_GPC['userphone'], $_GPC['code'], 0, 'verification');
        if (empty($smsarr['success'])) {
            json_error('验证码错误！');
        }
        json_sure('验证码正确！');
    }

    /**
     * 商家 搜索
     */
    public function search_dealer()
    {
        global $_GPC;
        //
        $wheresql = "A.isdealer=1 AND A.disabled=0";
        /**
         * 搜索类型
         */
        if ($_GPC['act'] == 'location') {
            /**
             * 地图搜索
             */
            if (!($_GPC['lat'] > 0 && $_GPC['lng'] > $_GPC['lat'])) {
                json_error('参数错误');
            }
            $pageRow = 50;
            //根据中心获取2公里范围内
            $wheresql.= " AND B.lng<".($_GPC['lng'] + 0.03);
            $wheresql.= " AND B.lng>".($_GPC['lng'] - 0.03);
            $wheresql.= " AND B.lat<".($_GPC['lat'] + 0.03);
            $wheresql.= " AND B.lat>".($_GPC['lat'] - 0.03);
        }else{
            /**
             * 列表搜索
             */
            $pageRow = 20;
            if ($_GPC['keyaddr']) {
                $wheresql.= " AND (A.username LIKE '%".$_GPC['keyaddr']."%' OR B.address LIKE '%".$_GPC['keyaddr']."%')";
            }
        }
        /**
         * 只显示正常店
         */
        if ($_GPC['onlyin']) {
            $wheresql.= " AND A.istest=0";
        }
        /**
         * 只显示主账号 或 不与主账号同步资料的子账号
         */
        $wheresql.= " AND (A.masterid=0 OR A.mastersync=0)";
        /**
         * 按距离排序
         */
        if ($_GPC['lat'] > 0 && $_GPC['lng'] > $_GPC['lat']) {
            $ordersql = db_acos($_GPC['lat'], $_GPC['lng'], 'B.lat', 'B.lng').',B.update DESC';
        }else{
            $ordersql = 'B.update DESC';
        }
        /**
         * 获取的数据字段
         */
        $fields = 'A.id,A.username,A.userimg,A.cdbnum,A.albums,A.istest,A.findnum,B.map,B.lng,B.lat,B.address';
        /**
         * 开始获取数据
         */
        $lists = db_getlist('SELECT '.$fields.' FROM '.table('users').' A INNER JOIN '.table('users_lbs').' B ON A.id=B.userid',
            $wheresql, $ordersql, $pageRow, $_GPC['page']);
        $this->load->library('gps');
        foreach ($lists['list'] AS $key=>$item) {
            if ($item['findnum'] > 0) {
                //有子账号的
                $lists['list'][$key]['cdbnum']+= intval(db_total("SELECT cdbnum AS num FROM ".table('users'), array('mastersync'=>1, 'masterid'=>$item['id'])));
                $lists['list'][$key]['cdbnum'] = $lists['list'][$key]['cdbnum'] . "";
            }
            $map = string2array($item['map']);
            if ($map['lng'] > 0 && $map['lat'] > 0) {
                $distance = $this->gps->getDistance($_GPC['lat'], $_GPC['lng'], $map['lat'], $map['lng']);
                $lists['list'][$key]['distance'] = $this->gps->distanceFormat($distance);
            }
            $albums = string2array($item['albums']);
            foreach ($albums AS $k=>$v) { $albums[$k] = fillurl($v); }
            $lists['list'][$key]['map'] = $map;
            $lists['list'][$key]['albums'] = $albums;
            $lists['list'][$key]['userimg'] = $item['userimg'] ? fillurl($item['userimg']) : IMG_PATH.'avatar.png';
        }
        if ($_GPC['act'] != 'location') {
            //搜索列表只显示一页
            $lists['totalpage'] = 1;
        }
        json_sure($lists);
    }

    /**
     * 押金记录
     */
    public function deposit_lists()
    {
        global $_A, $_GPC;
        if (empty($_A['user']['id'])) {
            json_error('身份丢失', 1001);
        }
        //
        $wheresql = "`type`='deposit'";
        $wheresql.= " AND `userid`=".$_A['user']['id'];
        //
        if (in_array($_GPC['type'], array('已付款', '退款中', '已退款', '使用中'))) {
            if ($_GPC['type'] == '已付款') {
                $wheresql.= " AND (`status`='".$_GPC['type']."' OR (`status`='使用中' AND `waitorder`>0))";
            }else{
                $wheresql.= " AND `status`='".$_GPC['type']."'";
            }
        }else{
            $wheresql.= " AND `status` IN ('已付款', '退款中', '已退款', '使用中')";
        }
        //
        $lists = db_getall(table('pay'), $wheresql, "`id` DESC");
        $intemp = '';
        foreach ($lists AS $item) {
            if ($item['status'] == '使用中' && $item['waitorder'] > 0) {
                $statusbtn = '<div onclick="'.$_GPC['js'].'apply(this, \'' . $item['payid'] . '\');" class="button button-fill" data-waitorder="'.$item['waitorder'].'">押金退款</div>';
            }elseif ($item['status'] == '已付款') {
                $statusbtn = '<div onclick="'.$_GPC['js'].'apply(this, \'' . $item['payid'] . '\');" class="button button-fill" data-waitorder="0">押金退款</div>';
            }else{
                $statusbtn = '<div onclick="'.$_GPC['js'].'apply(this, \'' . $item['payid'] . '\');" class="button button-fill button-disabled">'.$item['status'].'</div>';
            }
            $intemp.= '<li class="item-content">
                    <div class="item-inner">
                        <div class="item-title-row">
                            <div class="item-title">金额: '.$item['money'].'元</div>
                            <div class="item-after">'.date_year($item['indate']).'</div>
                        </div>
                        <div class="item-subtitle"><em>订单ID:</em> '.$item['payid'].'</div>
                        <div class="item-subtitle"><em>支付方式:</em> '.$item['payfrom'].'</div>
                        <div class="item-subtitle"><em>使用设备:</em> '.$item['sn'].'</div>
                        '.($item['status']=='已退款'?'<div class="item-subtitle"><em>退款时间:</em> '.date_year($item['retdate']).'</div>':'').'
                        <div class="item-text">'.$statusbtn.'</div>
                    </div>
                </li>';
        }
        if (empty($intemp)) {
            json_sure('<ul data-type="'.$_GPC['type'].'" class="no"><li>没有记录</li></ul>');
        }else{
            json_sure('<ul data-type="'.$_GPC['type'].'">' . $intemp . '</ul>', ($lists['totalpage']>$lists['nowpage']?1:0));
        }
    }

    /**
     * 订单记录
     */
    public function order_lists()
    {
        global $_A, $_GPC;
        if (empty($_A['user']['id'])) {
            json_error('身份丢失', 1001);
        }
        if ($_GPC['act'] == 'await') {
            $waitnum = db_count(table('order'), array('userid'=>$_A['user']['id'], '`retdate`>'=>0, '`ret`>'=>0));
            if ($waitnum > 0) {
                json_sure($waitnum);
            }else{
                json_error(0);
            }
        }
        $wheresql = "A.userid=".$_A['user']['id'];
        switch ($_GPC['type']) {
            case '使用中':
                $wheresql.= " AND A.retdate=0";
                break;
            case '待付款': //归还中
                $wheresql.= " AND A.retdate>0 AND A.ret>0";
                break;
            case '已归还':
                $wheresql.= " AND A.retdate>0 AND A.ret=0";
                break;
        }
        $fields = "A.*,B.userimg,B.username,B.userphone,C.status,C.title,C.type AS cdb_type";
        $lists = db_getlist('SELECT '.$fields.' FROM ('.table('order').' A INNER JOIN '.table('users').' B ON A.userid=B.id) INNER JOIN '.table('cdb').' C ON A.sn=C.sn', $wheresql, 'A.ret DESC,A.indate DESC,A.id DESC', 20, $_GPC['page']);
        $intemp = '';
        foreach ($lists['list'] AS $item) {
            $intemp .= '<li class="item-content">
                        <div class="item-inner">
                            <div class="item-title-row">
                                <div class="item-title">' . $item['title'] . '</div>
                                <div class="item-after">借用时间: ' . date_year($item['indate']) . '</div>
                            </div>
                            <div class="item-subtitle">设备编码: ' . $item['sn'] . '</div>';
            if ($item['retdate'] > 0) {
                $intemp.= '<div class="item-subtitle">租用时长: '.cdb_time_diff($item['indate'], $item['retdate']).'</div>
                           <div class="item-subtitle">借用金额: '.$item['retmoney'].'元</div>
                           <div class="item-subtitle">归还时间: '.date_year($item['retdate']).'</div>';
                if ($item['ret'] > 0) {
                    $intemp.= '<div class="item-text"><div onclick="'.$_GPC['js'].'givebank(\''.$item['id'].'\');" class="button button-fill" style="font-weight:700">已归还，待付款（'.$item['retmoney'].'元）</div></div>';
                }else{
                    $intemp.= '<div class="item-text"><div class="button button-fill button-disabled">已归还成功</div></div>';
                }
            } else {
                $totalMoney = cdb_totalMoney($item['indate'], 0, 0, $item['cdb_type']);
                if ($item['cdb_type'] == '雨伞') {
                    $intemp.= '<div class="item-subtitle">租用时长: '.cdb_time_diff($item['indate'], SYS_TIME).'</div>
                           <div class="item-subtitle">借用金额: <span style="color:#ff5722;"><b>'.$totalMoney.'元</b>（三免期）</span></div>
                           <div class="item-text"><div onclick="'.$_GPC['js'].'givebackYs();" class="button button-fill">归还雨伞（'.$totalMoney.'元）</div></div>';
                }else{
                    $intemp.= '<div class="item-subtitle">租用时长: '.cdb_time_diff($item['indate'], SYS_TIME).'</div>
                           <div class="item-subtitle">借用金额: '.$totalMoney.'元</div>
                           <div class="item-text"><div onclick="$A.alert(\'请将充电宝送至【服务网点（G家）】，<br/>G家店员扫码，即完成归还。<br/><br/>客服：'.settingfind('system', 'tel_num').'\', \'归还方式\');" class="button button-fill">归还设备（'.$totalMoney.'元）</div></div>';
                }
            }
            $intemp.= '</div></li>';
        }
        if (empty($intemp)) {
            json_sure('<ul data-type="'.$_GPC['type'].'" class="no"><li>没有记录</li></ul>');
        }else{
            json_sure('<ul data-type="'.$_GPC['type'].'">' . $intemp . '</ul>', ($lists['totalpage']>$lists['nowpage']?1:0));
        }
    }

    /**
     * 我的收益
     */
    public function income_lists()
    {
        global $_A, $_GPC;
        if (empty($_A['user']['id'])) {
            json_error('身份丢失', 1001);
        }
        $wheresql = "A.userid=".$_A['user']['id'];
        $wheresql.= " AND A.type='income'";
        $fields = "A.*,B.userimg,B.username,B.userphone";
        $lists = db_getlist('SELECT '.$fields.' FROM '.table('users_log').' A INNER JOIN '.table('users').' B ON A.userid=B.id', $wheresql, 'A.indate DESC,A.id DESC', 20, $_GPC['page']);
        $intemp = '';
        foreach ($lists['list'] AS $item) {
            $intemp.= '<li class="item-content">
                        <div class="item-inner">
                            <div class="item-title-row">
                                <div class="item-title">收入：'.($item['setup']<0?'-':($item['setup']>0?'+':'')).' ' . $item['setup'] . '</div>
                                <div class="item-after">' . date_year($item['indate']) . '</div>
                            </div>
                            <div class="item-subtitle">' . $item['title'] . '</div>';
            if ($item['masterid'] > 0) {
                $intemp.= '<div class="item-subtitle">操作会员: '.$item['mastername'].'</div>';
            }
            $intemp.= '</div></li>';
        }
        $array = array(
            'user_income'=>store_float($_A['user']['income']),
            'user_income_out'=>store_float($_A['user']['income_out'])
        );
        if (empty($intemp)) {
            $array['content'] = '<ul data-type="'.$_GPC['type'].'" class="no"><li>没有记录</li></ul>';
            json_sure($array);
        }else{
            $array['content'] = '<ul data-type="'.$_GPC['type'].'">' . $intemp . '</ul>';
            json_sure($array, ($lists['totalpage']>$lists['nowpage']?1:0));
        }
    }

    /**
     * 我的设备
     */
    public function cdbnotes_lists()
    {
        global $_A, $_GPC;
        if (empty($_A['user']['id'])) {
            json_error('身份丢失', 1001);
        }
        //
        $wheresql = "`userid`=".$_A['user']['id'];
        if ($_GPC['type'] == '设备记录') {
            $lists = db_getlist(table('cdb_notes'), $wheresql, '`indate` DESC,`id` DESC', 20, $_GPC['page']);
            $intemp = '';
            foreach ($lists['list'] AS $item) {
                $intemp .= '<li class="item-content">
                        <div class="item-inner">
                            <div class="item-title-row">
                                <div class="item-title">' . ($item['type']=='in'?'收录':'借出') . '设备：' . $item['sn'] . '</div>
                                <div class="item-after">' . date_year($item['indate']) . '</div>
                            </div>';
                $intemp.= '</div></li>';
            }
        }else{
            $wheresql.= " AND `status`='启用'";
            $lists = db_getlist(table('cdb'), $wheresql, '`update` DESC,`id` DESC', 20, $_GPC['page']);
            $intemp = '';
            foreach ($lists['list'] AS $item) {
                $intemp .= '<li class="item-content">
                        <div class="item-inner">
                            <div class="item-title-row">
                                <div class="item-title">设备编号：' . $item['sn'] . '</div>
                                <div class="item-after">' . date_year($item['update']) . '</div>
                            </div>';
                $intemp.= '</div></li>';
            }
        }
        if (empty($intemp)) {
            json_sure('<ul data-type="'.$_GPC['type'].'" class="no"><li>没有记录</li></ul>');
        }else{
            json_sure('<ul data-type="'.$_GPC['type'].'">' . $intemp . '</ul>', ($lists['totalpage']>$lists['nowpage']?1:0));
        }
    }

    /**
     * 获取信息列表
     */
    public function message_lists()
    {
        global $_A, $_GPC;
        if (empty($_A['user']['id'])) {
            json_error('身份丢失', 1001);
        }
        $wheresql = "`userid`=".$_A['user']['id'];
        switch ($_GPC['type']) {
            case '已阅读':
                $wheresql.= " AND `viewdate`>0";
                break;
            case '未阅读':
                $wheresql.= " AND `viewdate`=0";
                break;
        }
        $lists = db_getlist(table('message'), $wheresql, '`id` DESC', 20, $_GPC['page']);
        $intemp = '';
        foreach ($lists['list'] AS $item) {
            $intemp .= '<li class="item-content'.($item['viewdate']?'':' noview').'" data-id="'.$item['id'].'" onclick="'.$_GPC['js'].'view(this);">
                        <div class="item-inner">
                            <div class="item-title-row">
                                <div class="item-title">'.($item['viewdate']?'':'<em></em>').'' . $item['title'] . '</div>
                                <div class="item-after">' . date_year($item['indate']) . '</div>
                            </div>
                            <div class="item-subtitle">' . $item['subtitle'] . '</div>
                            <div class="item-text">' . $item['content'] . '</div>
                        </div>
                        </li>';
        }
        if (empty($intemp)) {
            json_sure('<ul data-type="'.$_GPC['type'].'" class="no"><li>没有记录</li></ul>');
        }else{
            json_sure('<ul data-type="'.$_GPC['type'].'">' . $intemp . '</ul>', ($lists['totalpage']>$lists['nowpage']?1:0));
        }
    }

    /**
     * 优惠券列表
     */
    public function sale_lists()
    {
        global $_A, $_GPC;
        if (empty($_A['user']['id'])) {
            json_error('身份丢失', 1001);
        }
        $lists = user_sales($_A['user']['id'], 500, $_GPC['page']);
        $newarr = $lists['list'];
        switch ($_GPC['type']) {
            case '可使用':
                $items = $newarr['B'];
                break;
            case '已使用':
                $items = $newarr['C'];
                break;
            case '已过期':
                $items = $newarr['D'];
                break;
            default:
                $items = $newarr['A'];
                break;
        }
        $intemp = '';
        foreach ($items AS $item) {
            if ($item['sale_type'] == "T") {
                $btntext = '可抵'.forum_hour2day($item['sale']);
            }elseif ($item['sale_type'] == "P") {
                $btntext = intval((100 - $item['sale']) / 10).'折优惠';
            }elseif ($item['sale_type'] == "F") {
                $btntext = '可抵'.$item['sale'].'元现金';
            }elseif ($item['sale_type'] == "C") {
                $btntext = $item['sale_mode'];
            }else{
                continue;
            }
            $intemp .= '<li class="item-content'.($item['viewdate']?'':' noview').'" data-id="'.$item['id'].'">
                        <div class="item-inner">
                            <div class="item-title-row">
                                <div class="item-title">' . $item['title'] . '</div>
                                <div class="item-after">' . date_year($item['indateB']) . '</div>
                            </div>
                            <div class="item-subtitle">优惠方式：' . $btntext . '</div>
                            <div class="item-subtitle">使用条件：' . ($item['limit_exp']?$item['limit_exp']:($item['min'] > 0?'满'.$item['min'].'元可用':'全平台通用')) . '</div>
                            '.($item['sale_type'] == "C"?'<div class="item-subtitle">兑换编码：'. four_format($item['exchangesn']) . '</div>':'').'
                            <div class="item-subtitle">有效期限：' . date_year($item['enddate']) . ($item['status_cn']=='可使用'&&$item['enddate']-SYS_TIME<259200?'<span class="badge bg-orange">即将过期</span>':'') . '</div>
                            <div class="item-text"><div data-saletype="'.$item['sale_type'].'" data-exchangesn="'.$item['exchangesn'].'" data-title="'.$item['use_exp'].'" onclick="'.$_GPC['js'].'apply(this);" class="button button-fill '.($item['status_cn']!='可使用'?'button-disabled':'').'">'.$item['status_cn'].'</div></div>
                        </div>
                        </li>';
        }
        if (empty($intemp)) {
            json_sure('<ul data-type="'.$_GPC['type'].'" class="no"><li>没有记录</li></ul>');
        }else{
            json_sure('<ul data-type="'.$_GPC['type'].'">' . $intemp . '</ul>', ($lists['totalpage']>$lists['nowpage']?1:0));
        }
    }

    /**
     * 兑换核销优惠券
     */
    public function used_sale()
    {
        global $_A, $_GPC;
        if (empty($_A['user']['id'])) {
            json_error('身份丢失', 1001);
        }
        $sale = user_sale_info($_GPC['idB']);
        if (empty($sale)) {
            json_error('兑换失败：兑换编码不正确或不在可使用状态！');
        }
        if (!in_array($_A['user']['id'], $sale['cancel_ids'])) {
            json_error('兑换失败：身份权限不足！');
        }
        if (used_users_sale($sale['idB'], $_A['user']['id'])) {
            $this->load->library('getui');
            $this->getui->message(array(
                'userid'=>$sale['userid'],
                'type'=>"usedsale",
                'tobe'=>1,
                'title'=>'兑换成功: '.$sale['title'],
                'subtitle'=>'兑换编码: '.$sale['exchangesn'],
                'content'=>'兑换编码: '.$sale['exchangesn'],
                'indate'=>SYS_TIME
            ));
            json_sure('兑换成功！');
        }else{
            json_sure('兑换失败：兑换编码不存在！');
        }
    }

    /**
     * 更新资料
     */
    public function updatepersonal()
    {
        global $_A, $_GPC;
        if (empty($_A['user']['id'])) {
            json_error('身份丢失', 1001);
        }
        if ($_GPC['action'] == 'userimg') {
            //修改头像
            $upload_path = "uploadfiles/userimg/".zerofill(substr($_A['user']['id'], 0, 3), 3).'/'.$_A['user']['id'].'/';
            make_dir(BASE_PATH.$upload_path);
            $this->load->model('vupload');
            if ($_FILES['file']) {
                $uparr = array();
                $uparr['upload_path'] = BASE_PATH.$upload_path;
                $uparr['allowed_types'] = 'gif|jpg|jpeg|png';
                $uparr['file_name'] = SYS_TIME.rand(10,99);
                $uparr['max_size'] = 3 * 1024;
                $_img = $this->vupload->upfile($uparr, 'file');
                if ($_img['success']) {
                    $this->vupload->img2thumb($_img['upload_data']['full_path'], $_img['upload_data']['full_path'], 320, 0);
                    db_update(table('users'), array('userimg'=>$_img['upload_data']['full_path_site']), array('id'=>$_A['user']['id']));
                    json_sure(fillurl($_img['upload_data']['full_path_site']));
                }else{
                    json_error('修改失败：'.$_img['message']);
                }
            }
        }elseif ($_GPC['action'] == 'username') {
            //修改昵称
            $username = trim($_GPC['username']);
            if (strlen($username) < 2) {
                json_error('昵称不得少于两个字符！');
            }
            db_update(table('users'), array('username'=>$username), array('id'=>$_A['user']['id']));
            json_sure($username);
        }elseif ($_GPC['action'] == 'userphone') {
            //修改手机号码
            if (isMobile_sub($_A['user']['userphone'])) {
                json_error('特殊号码请联系G电客服修改！');
            }
            $this->load->model('sms');
            $smsarr = $this->sms->verify($_A['user']['userphone'], $_GPC['oldcode'], 0, 'verification');
            if (empty($smsarr['success'])) {
                json_error('旧手机号验证码错误！');
            }
            $newuserphone = trim($_GPC['newuserphone']);
            if (!isMobile($newuserphone)) {
                json_error('新手机号码格式错误！');
            }
            if ($newuserphone == $_A['user']['userphone']) {
                json_error('新手机号与旧手机号一致！');
            }
            $smsarr = $this->sms->verify($newuserphone, $_GPC['newcode'], 0, 'verification');
            if (empty($smsarr['success'])) {
                json_error('新手机号验证码错误！');
            }
            $row = db_getone(table('users'), array('userphone'=>$newuserphone));
            if ($row) {
                json_error('新手机号已被使用！');
            }
            db_update(table('users'), array('userphone'=>$newuserphone), array('id'=>$_A['user']['id']));
            json_sure($newuserphone);
        }
        json_error('参数错误！');
    }

    /**
     * 兑换优惠券
     */
    public function checksale()
    {
        global $_A,$_GPC;
        $sn = $_GPC['sn'];
        $sale = db_getone(table('sale'), array('code'=>$sn, 'status'=>'启用'));
        if (empty($sale)) {
            json_error('兑换码错误!');
        }elseif ($sale['num'] < 1) {
            json_error(sale_name().'已被兑换完了!');
        }elseif ($sale['end_type'] == 'fixed' && $sale['enddate'] < SYS_TIME) {
            json_error(sale_name().'已过期!');
        }else{
            $lwhere = array('saleid' => $sale['id'], 'userid' => $_A['user']['id']);
            if ($sale['numcan_type'] == 'day') {
                $lwhere['`indate`>='] = mktime(0, 0, 0, date('m'), date('d'), date('Y'));
            } elseif ($sale['numcan_type'] == 'week') {
                $lwhere['`indate`>='] = mktime(0, 0, 0, date('m'), date('d') - date('w') + 1, date('Y'));
            } elseif ($sale['numcan_type'] == 'month') {
                $lwhere['`indate`>='] = mktime(0, 0, 0, date('m'), 1, date('Y'));
            } elseif ($sale['numcan_type'] == 'year') {
                $lwhere['`indate`>='] = mktime(0, 0, 0, 1, 1, date('Y'));
            }
            $mysale = db_count(table('users_sale'), $lwhere);
            if ($mysale >= $sale['numcan']) {
                json_error('您已经兑换过此'.sale_name().'!');
            }else{
                //开始兑换
                db_trans_start();
                db_insert(table('users_sale'), array('userid' => $_A['user']['id'], 'saleid' => $sale['id'], 'from' => 'input_sn', 'indate' => SYS_TIME));
                db_update(table('sale'), array('num[-]' => 1), array('id' => $sale['id']));
                //通知
                $this->load->library('getui');
                $this->getui->message(array(
                    'userid' => $_A['user']['id'],
                    'type' => "sale_input",
                    'tobe' => 1,
                    'title' => '获得' . sale_name() . '通知',
                    'subtitle' => '恭喜您获得1张' . sale_name(),
                    'content' => '恭喜您获得1张' . sale_name(),
                    'indate' => SYS_TIME
                ));
                db_trans_complete();
                //兑换完成
                json_sure('兑换成功!');
            }
        }
        json_error('兑换错误!');
    }

    /** ****************************************************************************************** */
    /** ****************************************************************************************** */
    /** ****************************************************************************************** */

    /**
     * 处理会员详细信息
     * @param $info
     * @return mixed
     */
    private function userinfo($info)
    {
        $info['userimg'] = $info['userimg'] ? fillurl($info['userimg']) : IMG_PATH.'avatar.png';
        return $info;
    }
}
