<?php
defined('BASEPATH') OR exit('No direct script access allowed');

class Admin extends CI_Controller {

    public function __construct()
    {
        parent::__construct();
        //跳转到新后台功能
        gourl('https://a.gengdian.net');
        //
        global $_A,$IS_ADMIN_DB;
        the_user();
        if (!$_A['user']['isadmin']) {
            gourl(url('index/login').'?ctx='.urlencode(get_url()));
        }
        //
        $_A['role'] = db_getone(table('admin_role'), array('userid'=>$_A['user']['id']));
        $_A['_role'] = string2array($_A['role']['role']);
        //
        $this->load->helper('tpl');
        //
        $IS_ADMIN_DB = true;
    }

    /**
     * 临时
     */
    public function upgcj02map() {
        $list = db_getall(table('users_lbs'), null, 'id');
        foreach ($list AS $item) {
            $map = string2array($item['map']);
            if ($map['gcj02']['lng'] || $map['gcj02']['lat']) {
                $uarr = array(
                    'lng_gcj02'=>$map['gcj02']['lng'],
                    'lat_gcj02'=>$map['gcj02']['lat']
                );
                unset($map['gcj02']);
                $uarr['map'] = array2string($map);
                db_update(table('users_lbs'), $uarr, array('id'=>$item['id']));
            }
        }
        message("OK");
    }

    /**
     * 后台首页
     */
    public function index()
    {
        $isgd = extension_loaded("gd")?'是':'否';
        $web_server = $_SERVER['SERVER_SOFTWARE'];
        tpl(get_defined_vars());
    }

    /**
     * 系统设置
     */
    public function system()
    {
        global $_GPC;
        if ($_GPC['submit']) {
            if ($_POST['claim_pass'] == '0') {
                $_POST['claim_pass'] = '';
            }elseif (empty($_POST['claim_pass'])) {
                $_POST['claim_pass'] = $_POST['_claim_pass'];
            }else{
                $_POST['claim_pass'] = md52($_POST['claim_pass']);
            }
            setting('system', $_POST);
            gourl(url(0));
        }
        $setting = setting('system');
        tpl(get_defined_vars());
    }

    /**
     * 支付设置
     */
    public function pay()
    {
        global $_GPC;
        if ($_GPC['submit']) {
            $setting = setting('pay');
            $certArray = array(
                'wx_cert',
                'wx_cert_key',
                'wx_cert_rootca',
                'wxapp_cert',
                'wxapp_cert_key',
                'wxapp_cert_rootca',
                'wxxiaoapp_cert',
                'wxxiaoapp_cert_key',
                'wxxiaoapp_cert_rootca'
            );
            foreach ($setting AS $key=>$val) {
                if (in_array($key, $certArray)) {
                    $_POST[$key] = $val;
                }
            }
            if ($_FILES) {
                $this->load->model('vupload');
                $uparr = array();
                $uparr['upload_path'] = dirname(dirname(__FILE__))."/libraries/weixin/cert/";
                $uparr['allowed_types'] = 'pem';
                $uparr['overwrite'] = true;
                $uparr['max_size'] = 1024;
                foreach ($_FILES AS $key=>$val) {
                    if ($val['name'] && in_array($key, $certArray)) {
                        $uparr['file_name'] = $key;
                        $ret = $this->vupload->upfile($uparr, $key);
                        if ($ret['success']) {
                            $_POST[$key] = $ret['upload_data']['full_path_site'];
                        }else{
                            message(null, '上传文件错误：'.$ret['message']);
                        }
                    }
                }
            }
            $setting = setting('pay', $_POST);
            //
            $pay_cert = setting('pay_cert');
            foreach ($certArray AS $val) {
                $path = BASE_PATH.$setting[$val];
                if ($setting[$val] && file_exists($path)) {
                    $pay_cert[$val] = file_get_contents($path);
                }
            }
            setting('pay_cert', $pay_cert);
            //
            gourl(url(0));
        }
        $setting = setting('pay');
        tpl(get_defined_vars());
    }

    /**
     * 分享设置
     */
    public function share()
    {
        global $_GPC;
        if ($_GPC['submit']) {
            setting('share', $_POST);
            gourl(url(0));
        }
        $setting = setting('share');
        tpl(get_defined_vars());
    }

    /**
     * 短信模板
     */
    public function smstmpl()
    {
        global $_GPC;
        if ($_GPC['did']) {
            db_delete(table('smstmplmsg'), array('id' => intval($_GPC['did'])));
            gourl(get_link('did'));
        }
        $smstmplmsg = db_getall(table('smstmplmsg'), '', 'id ASC');
        tpl(get_defined_vars());
    }

    /**
     * 添加、修改 短信模板
     */
    public function smstmpl_add()
    {
        global $_GPC;
        $id = intval($_GPC['id']);
        $subtitle = '添加';
        $setting = array();
        if ($id > 0) {
            $smstmpl = db_getone(table('smstmplmsg'), array('id' => $id));
            if (empty($smstmpl)) {
                $id = 0;
            }else{
                $subtitle = '修改';
            }
        }
        //
        if ($_GPC['submit']) {
            $arr = $_arr = array();
            $arr['success'] = 0;
            //
            $_arr['tid'] = $_GPC["tid"];
            $_arr['title'] = $_GPC["title"];
            $_arr['template'] = $_GPC["template"];
            //
            if (empty($_arr['tid'])) {
                $arr['message'] = '模板ID不能留空';
                json_echo($arr);
            }
            if (empty($_arr['title'])) {
                $arr['message'] = '模板名称不能留空';
                json_echo($arr);
            }
            if (empty($_arr['template'])) {
                $arr['message'] = '模板内容不能留空';
                json_echo($arr);
            }
            //
            if ($id > 0){
                //修改
                $arr['id'] = $id;
                if (db_update(table('smstmplmsg'), $_arr, array("id"=>$id))){
                    $arr['success'] = 1;
                    $arr['message'] = '修改成功';
                }
            }else{
                //新增
                $id = db_insert(table('smstmplmsg'), $_arr, true);
                $arr['id'] = $id;
                if ($id > 0){
                    $arr['success'] = 1;
                    $arr['message'] = '添加成功';
                }
            }
            json_echo($arr);
        }
        //
        tpl(get_defined_vars());
    }

    /**
     * 设备管理
     */
    public function cdb()
    {
        global $_GPC;
        if ($_GPC['action'] == 'del_all') {
            foreach ($_GPC['checkbox'] AS $iid) {
                if ($iid > 0) {
                    db_trans_start();
                    $sn = db_getone(table('cdb'), array('id'=>$iid), '', 'sn');
                    if ($sn) {
                        if ($sn['status'] == '启用中') {
                            message(null, '使用中的设备禁止删除！');
                        }
                        db_delete(table('cdb'), array('id'=>$iid));
                        db_delete(table('cdb_notes'), array('sn'=>$sn));
                    }
                    db_trans_complete();
                }
            }
            gourl(url(0));
        }elseif ($_GPC['action'] == 'del') {
            $iid = intval($_GPC['id']);
            if ($iid > 0) {
                $sn = db_getone(table('cdb'), array('id'=>$iid), '', 'sn');
                if ($sn) {
                    if ($sn['status'] == '启用中') {
                        message(null, '使用中的设备禁止删除！');
                    }
                    db_delete(table('cdb'), array('id'=>$iid));
                    db_delete(table('cdb_notes'), array('sn'=>$sn));
                }
            }
            gourl(url(0));
        }
        //
        $page = $_GPC['page'];
        $_where = " 1=1 ";
        $wheresql = $_where;
        if ($_GPC['id'] > 0) {
            $wheresql.= " AND id=".intval($_GPC['id']);
        }
        if ($_GPC['userid'] > 0 || $_GPC['userid'] == '0') {
            $wheresql.= " AND userid=".intval($_GPC['userid']);
        }
        if (in_array($_GPC['status'], array('使用中', '启用', '禁用'))) {
            $wheresql.= " AND status='".$_GPC['status']."'";
        }
        if ($_GPC['sn']) {
            $wheresql.= " AND sn LIKE '%".$_GPC['sn']."%'";
        }
        if ($_GPC['stime']) {
            $wheresql.= " AND indate>=".strtotime($_GPC['stime']);
        }
        if ($_GPC['etime']) {
            $wheresql.= " AND indate<=".strtotime($_GPC['etime']);
        }
        if ($_GPC['sutime']) {
            $wheresql.= " AND update>=".strtotime($_GPC['sutime']);
        }
        if ($_GPC['eutime']) {
            $wheresql.= " AND update<=".strtotime($_GPC['eutime']);
        }
        if ($_GPC['type']) {
            $wheresql.= " AND `type` = '".$_GPC['type']."'";
        }
        if ($_GPC['submit'] == '导出Excel') {
            message(null, '开发中...');
        }
        $lists = db_getlist(table('cdb'), $wheresql, 'inorder DESC,id DESC', 25, intval($page), '*', 1);
        $lists['next'] = ($lists['totalpage']>$lists['nowpage'])?1:0; //上一页
        $lists['prev'] = ($lists['nowpage']>1 && $lists['totalpage']>1)?1:0; //下一页
        //
        tpl(get_defined_vars());
    }


    /**
     * 添加、修改 设备
     */
    public function cdb_add()
    {
        global $_GPC;
        if ($_GPC['act'] == 'getuser') {
            //搜索会员
            $wheresql = '';
            if ($_GPC['key']) {
                $_GPC['key'] = get_subto($_GPC['key'], '/');
                $wheresql = "`username` LIKE '%".$_GPC['key']."%' OR `userphone` LIKE '%".$_GPC['key']."%'";
            }
            $lists = db_getall(table('users'), $wheresql, '`id` LIMIT 0, 50');
            foreach ($lists AS $item) {
                echo '<li data-id="'.$item['id'].'" data-title="'.$item['username'].'">';
                if ($item['userimg']) {
                    echo '<img src="'.fillurl($item['userimg']).'">';
                }
                echo '<span>';
                echo $item['username'];
                if ($item['userphone']) {
                    echo ' (手机: '.$item['userphone'].')';
                }
                echo '</span>';
                echo '</li>';
            }
            exit("");
        }
        $id = intval($_GPC['id']);
        $subtitle = '添加';
        $data = array();
        if ($id > 0) {
            $data = db_getone(table('cdb'), array('id'=>$id));
            if (empty($data)) {
                $id = 0;
            }else{
                $subtitle = '修改';
                $data['userinfo'] = db_getone(table('users'), array('id'=>$data['userid']));
            }
        }
        if ($_GPC['submit']) {
            $arr = array();
            $arr['success'] = 0;
            $arr['message'] = '';
            if ($id == 0 && strlen($_GPC['sn']) < 10) {
                $arr['message'] = $subtitle.'失败：识别码不能小于10位数！';
                json_echo($arr);
            }
            if ($id > 0 && $data['status'] == '使用中') {
                $arr['message'] = $subtitle.'失败：设备正在使用中！';
                json_echo($arr);
            }
            $wherearr = array('sn' => $_GPC['sn']);
            if ($id > 0) {
                $wherearr['`id`!='] = $id;
            }
            $row = db_getone(table('cdb'), $wherearr);
            if ($row && empty($_GPC['skiprep'])) {
                $arr['message'] = $subtitle.'失败：识别码已存在！';
                json_echo($arr);
            }
            if (!in_array($_GPC['type'], array('充电宝', '雨伞'))) {
                $arr['message'] = $subtitle.'失败：请选择正确的类型！';
                json_echo($arr);
            }
            $postarr = array(
                'sn'=>$_GPC['sn'],
                'title'=>$_GPC['title'],
                'type'=>$_GPC['type'],
                'userid'=>intval($_GPC['userid']),
                'inorder'=>intval($_GPC['inorder']),
                'status'=>$_GPC['status']=='启用'?$_GPC['status']:'禁用',
                'update'=>SYS_TIME
            );
            $userinfo = array();
            if ($postarr['userid'] > 0) {
                $userinfo = db_getone(table('users'), array('id'=>$postarr['userid']));
                if (empty($userinfo)) {
                    $arr['message'] = $subtitle.'失败，所属会员选择错误！';
                    json_echo($arr);
                }
            }
            db_trans_start();
            $jj = 0;
            if ($id > 0) {
                unset($postarr['sn']);
                db_update(table('cdb'), $postarr, array('id'=>$id));
                $jj++;
                users_cdbnum($postarr['userid']);
                users_cdbnum($data['userid']);
                //生成设备记录
                if ($postarr['userid'] != $data['userid']) {
                    if ($userinfo['isdealer']) {
                        db_insert(table('cdb_notes'), array(
                            'type'=>'in',
                            'sn'=>$data['sn'],
                            'userid'=>$userinfo['id'],
                            'userid_be'=>$data['userid'],
                            'indate'=>SYS_TIME
                        ));
                    }
                    if ($data['userinfo']['isdealer']) {
                        db_insert(table('cdb_notes'), array(
                            'type'=>'out',
                            'sn'=>$data['sn'],
                            'userid'=>$data['userid'],
                            'userid_be'=>intval($userinfo['id']),
                            'indate'=>SYS_TIME
                        ));
                    }
                }
            }else{
                $postarr['indate'] = SYS_TIME;
                if ($_GPC['addnum'] > 0) {
                    for ($i = 0; $i < $_GPC['addnum']; $i++) {
                        if (is_numeric($_GPC['sn'])) {
                            $wherearr['sn'] = zerofill($_GPC['sn'] + $i, strlen($_GPC['sn']));
                        } else {
                            $wherearr['sn'] = $_GPC['sn'] . '-' . zerofill($i + 1, strlen($_GPC['addnum']));
                        }
                        $row = db_getone(table('cdb'), $wherearr);
                        if ($row && empty($_GPC['skiprep'])) {
                            $arr['message'] = '批量添加失败，'. $wherearr['sn'].' 已存在！';
                            json_echo($arr);
                        }
                        if (empty($row)) {
                            $postarr['sn'] = $wherearr['sn'];
                            db_insert(table('cdb'), $postarr);
                            $jj++;
                            //生成设备记录
                            if ($userinfo['isdealer']) {
                                db_insert(table('cdb_notes'), array(
                                    'type'=>'in',
                                    'sn'=>$postarr['sn'],
                                    'userid'=>$userinfo['id'],
                                    'userid_be'=>0,
                                    'indate'=>SYS_TIME
                                ));
                            }
                        }
                    }
                }else{
                    db_insert(table('cdb'), $postarr);
                    $jj++;
                    //生成设备记录
                    if ($userinfo['isdealer']) {
                        db_insert(table('cdb_notes'), array(
                            'type'=>'in',
                            'sn'=>$postarr['sn'],
                            'userid'=>$userinfo['id'],
                            'userid_be'=>0,
                            'indate'=>SYS_TIME
                        ));
                    }
                }
                users_cdbnum($postarr['userid']);
            }
            db_trans_complete();
            $arr['success'] = 1;
            $arr['message'] = $subtitle.'成功（'.$jj.'个）！';
            json_echo($arr);
        }
        tpl(get_defined_vars());
    }


    /**
     * 会员
     */
    public function users()
    {
        global $_GPC;
        if ($_GPC['act'] == 'getuser') {
            //搜索会员
            $wheresql = '';
            if ($_GPC['key']) {
                $_GPC['key'] = get_subto($_GPC['key'], '/');
                $wheresql = "`username` LIKE '%".$_GPC['key']."%' OR `userphone` LIKE '%".$_GPC['key']."%'";
            }
            $lists = db_getall(table('users'), $wheresql, '`id` LIMIT 0, 50');
            foreach ($lists AS $item) {
                echo '<li data-id="'.$item['id'].'" data-title="'.$item['username'].'">';
                if ($item['userimg']) {
                    echo '<img src="'.fillurl($item['userimg']).'">';
                }
                echo '<span>';
                echo $item['username'];
                if ($item['userphone']) {
                    echo ' (手机: '.$item['userphone'].')';
                }
                echo '</span>';
                echo '</li>';
            }
            exit("");
        }elseif ($_GPC['act'] == 'add') {
            //添加会员
            $arr = array();
            $arr['success'] = 0;
            $arr['message'] = '';
            //
            if (!isMobile($_GPC['userphone'])) {
                $arr['message'] = "请填写正确的手机号码";
                json_echo($arr);
            }
            if (empty($_GPC['username'])) {
                $_GPC['username'] = substr($_GPC['userphone'], 0, 3).'****'.substr($_GPC['userphone'], -4);
            }
            $row = db_getone(table('users'), array('userphone'=>$_GPC['userphone']));
            if ($row) {
                $arr['message'] = "手机号码已存在";
                json_echo($arr);
            }
            $from_id = intval($_GPC['from_id']);
            if ($from_id) {
                $row = db_getone(table('users'), array('id'=>$from_id));
                if (empty($row)) {
                    $arr['message'] = "请填写正确的推广员";
                    json_echo($arr);
                }
            }
            $inarr = array(
                'from_id'=>$from_id,
                'isdealer'=>$_GPC['isdealer']?1:0,
                'username'=>$_GPC['username'],
                'userphone'=>$_GPC['userphone'],
                'userpass'=>$_GPC['password']?md52($_GPC['password']):'',
                'browser_sn'=>'',
                'regtype'=>'add',
                'regip'=>ONLINE_IP,
                'regdate'=>SYS_TIME
            );
            db_trans_start();
            db_insert(table('users'), $inarr);
            $row = db_getone(table('users'), array('userphone'=>$_GPC['userphone']));
            if (empty($row)) {
                $arr['message'] = '注册失败，请稍后再试！';
                json_echo($arr);
            }
            db_trans_complete();
            $arr['success'] = 1;
            $arr['message'] = '注册成功！';
            json_echo($arr);
        }elseif ($_GPC['action'] == 'admin_is') {
            //设为管理员
            foreach ($_GPC['checkbox'] AS $k=>$iid) { if ($iid <= 0) { unset($_GPC['checkbox'][$k]); } }
            db_update(table('users'), array('isadmin'=>1), array('`id` IN ('.implode(',',$_GPC['checkbox']).')'=>null));
            gourl(get_link('action'));
        }elseif ($_GPC['action'] == 'admin_no') {
            //取消管理员
            foreach ($_GPC['checkbox'] AS $k=>$iid) { if ($iid <= 0) { unset($_GPC['checkbox'][$k]); } }
            db_update(table('users'), array('isadmin'=>0), array('`id` IN ('.implode(',',$_GPC['checkbox']).')'=>null));
            gourl(get_link('action'));
        }elseif ($_GPC['action'] == 'dealer_is') {
            //设为商家
            foreach ($_GPC['checkbox'] AS $k=>$iid) { if ($iid <= 0) { unset($_GPC['checkbox'][$k]); } }
            db_update(table('users'), array('isdealer'=>1), array('`id` IN ('.implode(',',$_GPC['checkbox']).')'=>null));
            gourl(get_link('action'));
        }elseif ($_GPC['action'] == 'dealer_no') {
            //取消商家
            foreach ($_GPC['checkbox'] AS $k=>$iid) { if ($iid <= 0) { unset($_GPC['checkbox'][$k]); } }
            db_update(table('users'), array('isdealer'=>0), array('`id` IN ('.implode(',',$_GPC['checkbox']).')'=>null));
            gourl(get_link('action'));
        }elseif ($_GPC['action'] == 'rank') {
            //会员等级设置
            setting('users_rank', $_POST['rank']);
            gourl(get_link('action'));
        }
        $users_rank = setting('users_rank');
        //
        $page = $_GPC['page'];
        $_where = "1=1";
        if ($_GPC['type'] == '管理员') {
            $_where.= " AND `isadmin`=1 ";
        }elseif ($_GPC['type'] == '商家') {
            $_where.= " AND `isdealer`=1 ";
        }elseif ($_GPC['type'] == '非商家') {
            $_where.= " AND `isdealer`=0 ";
        }elseif ($_GPC['type'] == '商家子账号') {
            $_where.= " AND `isdealer`=1 AND `masterid`>0 ";
        }elseif ($_GPC['type'] == '商家主账号') {
            $_where.= " AND `isdealer`=1 AND `masterid`=0 ";
        }elseif ($_GPC['type'] == '商家同步号') {
            $_where.= " AND `isdealer`=1 AND `mastersync`>0 ";
        }elseif ($_GPC['type'] == '商家非同步号') {
            $_where.= " AND `isdealer`=1 AND `mastersync`=0 ";
        }elseif ($_GPC['type'] == '商家测试店') {
            $_where.= " AND `isdealer`=1 AND `istest`=1 ";
        }elseif ($_GPC['type'] == '商家非测试店') {
            $_where.= " AND `isdealer`=1 AND `istest`=0 ";
        }
        if ($_GPC['userid'] > 0) {
            $_where.= " AND `id`=".intval($_GPC['userid']);
        }
        if ($_GPC['userphone']) {
            $_where.= " AND `userphone` LIKE '%".$_GPC['userphone']."%'";
        }
        if ($_GPC['stime']) {
            $_where.= " AND `regdate`>=".strtotime($_GPC['stime']);
        }
        if ($_GPC['etime']) {
            $_where.= " AND `regdate`<=".strtotime($_GPC['etime']);
        }
        if ($_GPC['point_lv'] > 0 && isset($users_rank[$_GPC['point_lv']])) {
            $_min = intval($users_rank[$_GPC['point_lv']]['min']);
            $_max = $_min;
            $_where.= " AND `point_plus`<=".$_min;
            foreach ($users_rank AS $item) {
                if ($item['min'] > 0  && $item['min'] < $_max) {
                    $_max = $item['min'];
                }
            }
            if ($_max != $_min) {
                $_where.= " AND `point_plus`>".$_max;
            }
        }
        if ($_GPC['username']) {
            $_where.= " AND `username` LIKE '%".$_GPC['username']."%'";
        }
        if ($_GPC['from_id'] > 0) {
            $_where.= " AND `from_id`=".intval($_GPC['from_id']);
        }
        if ($_GPC['masterid'] > 0) {
            $_where.= " AND `masterid`=".intval($_GPC['masterid']);
        }
        $byorder = 'id DESC';
        if (in_array($_GPC['by_order'], array('id', 'money', 'money_not', 'point', 'point_plus', 'regdate', 'loginnum'))) {
            $byorder = $_GPC['by_order'].' '.($_GPC['by_desc']=='desc'?'desc':'asc');
            if ($_GPC['by_order'] != 'id') {
                $byorder.= ',id DESC';
            }
        }
        if ($_GPC['submit'] == '导出Excel' || $_GPC['submit'] == '导出商家Excel') {
            message(null, '开发中...');
        }
        $users = db_getlist(table('users'), $_where, $byorder, 15, intval($page), '*', 1);
        $users['next'] = ($users['totalpage']>$users['nowpage'])?1:0; //上一页
        $users['prev'] = ($users['nowpage']>1 && $users['totalpage']>1)?1:0; //下一页
        //
        tpl(get_defined_vars());
    }


    /**
     * 修改 会员
     */
    public function users_add()
    {
        global $_GPC;
        $this->role();
        $users_id = intval($_GPC['id']);
        $subtitle = '修改';
        $users = db_getone(table('users'), array('id'=>$users_id));
        if (empty($users)) {
            message(null, '会员不存在！');
        }
        $users_lbs = users_lbs($users_id);
        if ($_GPC['act'] == 'getuser') {
            $wheresql = '`id`!='.$users_id;
            if ($_GPC['key']) {
                $_GPC['key'] = get_subto($_GPC['key'], '/');
                $wheresql = " AND `username` LIKE '%".$_GPC['key']."%' OR `userphone` LIKE '%".$_GPC['key']."%'";
            }
            $lists = db_getall(table('users'), $wheresql, '`id` LIMIT 0, 50');
            foreach ($lists AS $item) {
                echo '<li data-id="'.$item['id'].'" data-title="'.$item['username'].'">';
                if ($item['userimg']) {
                    echo '<img src="'.fillurl($item['userimg']).'">';
                }
                echo '<span>';
                echo $item['username'];
                if ($item['userphone']) {
                    echo ' (手机: '.$item['userphone'].')';
                }
                echo '</span>';
                echo '</li>';
            }
            exit("");
        }
        //
        $role = db_getone(table('admin_role'), array('userid'=>$users_id));
        $_role = string2array($role['role']);
        if (empty($role)) {
            db_insert(table('admin_role'), array('userid'=>$users_id));
            $role = db_getone(table('admin_role'), array('userid'=>$users_id));
            $_role = string2array($role['role']);
        }
        //
        if ($_GPC['submit']) {
            $arr = $_arr = array();
            $arr['success'] = 0;
            if (!$this->rolerun(1)) {
                $arr['message'] = "权限不足";
                echo json_encode($arr); exit();
            }
            //
            $_arr['username'] = $_GPC["username"];
            $_arr['userphone'] = $_GPC["userphone"];
            $_arr['useremail'] = $_GPC["useremail"];
            $_arr['isdealer'] = $_GPC["isdealer"]?1:0;
            $_arr['istest'] = $_GPC["istest"]?1:0;
            $_arr['isentry'] = $_GPC["isentry"]?1:0;
            $_arr['disabled'] = $_GPC["disabled"]?1:0;
            $_arr['masterid'] = intval($_GPC["masterid"]);
            $_arr['mastersync'] = intval($_GPC["mastersync"]);
            $_arr['albums'] = array2string($_GPC["albums"]);
            if ($_GPC['userpass']) {
                $_arr['userpass'] = md52($_GPC["userpass"]);
            }
            //
            if (empty($_arr['username'])) {
                $arr['message'] = '昵称不能为空！';
                json_echo($arr);
            }
            if (empty($_arr['userphone'])) {
                $arr['message'] = '手机不能为空！';
                json_echo($arr);
            }
            if (!isMobile($_arr['userphone'])) {
                $arr['message'] = '手机号码格式不正确！';
                json_echo($arr);
            }
            $num = db_count(table('users'), array('userphone'=>$_arr['userphone'], 'id!='=>$users_id));
            if ($num > 0) {
                $arr['message'] = '手机号码已存在！';
                json_echo($arr);
            }
            if (!empty($_arr['useremail'])) {
                if (!isMail($_arr['useremail'])) {
                    $arr['message'] = '邮箱地址格式不正确！';
                    json_echo($arr);
                }
                $num = db_count(table('users'), array('useremail'=>$_arr['useremail'], 'id!='=>$users_id));
                if ($num > 0) {
                    $arr['message'] = '邮箱地址已存在！';
                    json_echo($arr);
                }
            }
            //
            $this->load->library('gps');
            $gcj02 = $this->gps->BaiduToGcj02($_GPC['map']['lat'], $_GPC['map']['lng']);
            //
            $userslbs = array(
                'province'=>intval($_GPC['province']),
                'city'=>intval($_GPC['city']),
                'area'=>intval($_GPC['area']),
                'province_cn'=>$_GPC['province_cn'],
                'city_cn'=>$_GPC['city_cn'],
                'area_cn'=>$_GPC['area_cn'],

                'address'=>$_GPC['map']['title'],
                'map'=>array2string($_GPC['map']),
                'lat'=>$_GPC['map']['lat'],
                'lng'=>$_GPC['map']['lng'],
                'lat_gcj02'=>$gcj02['lat'],
                'lng_gcj02'=>$gcj02['lng'],
                'update'=>SYS_TIME
            );
            if ($_arr['mastersync'] && $_arr['masterid']) {
                //信息跟主账号同步
                $syncuser = db_getone(table('users'), array('id'=>$_arr['masterid']));
                if ($syncuser) {
                    $userslbs = users_lbs($syncuser['id']);
                    unset($userslbs['id']);
                    unset($userslbs['userid']);
                    $_arr['albums'] = $syncuser['albums'];
                }
            }
            //开始修改
            $arr['id'] = $users_id;
            db_trans_start();
            users_lbs($users_id, $userslbs);
            if (db_update(table('users'), $_arr, array("id"=>$users_id))){
                if (empty($_arr['masterid'])) {
                    //是主账号时更新同步的子账号
                    $syncusers = db_getall(table('users'), array('masterid'=>$users_id, 'mastersync'=>1));
                    foreach ($syncusers AS $item) {
                        users_lbs($item['id'], $userslbs);
                    }
                }
                //更新子账号数量
                users_findnum($_arr['masterid']);
                if ($_arr['masterid'] != $users['masterid']) {
                    users_findnum($users['masterid']);
                }
                //
                $rarr = array();
                $rarr['role'] = array2string($_GPC['role']);
                $rarr['deposit_notify'] = intval($_GPC['deposit_notify']);
                db_update(table('admin_role'), $rarr, array('userid'=>$users_id));
                //
                $arr['success'] = 1;
                $arr['message'] = '修改成功';
            }else{
                $arr['message'] = '网络繁忙，请稍后再试！';
            }
            db_trans_complete();
            json_echo($arr);
        }
        //
        if ($users['masterid'] > 0) {
            $masterid_name = db_getone(table('users'), array('id'=>$users['masterid']), '', 'username');
        }
        //
        $_GET['ctx'] = urlencode($_GET['ctx']);
        $Lmoney = db_getlist(table('users_log'), "`type`='money' AND `userid`=".$users_id, "indate DESC,id DESC", 20, $_GPC['mpage'], '*', 1);
        $Lpoint = db_getlist(table('users_log'), "`type`='point' AND `userid`=".$users_id, "indate DESC,id DESC", 20, $_GPC['ppage'], '*', 1);
        //
        tpl(get_defined_vars());
    }

    /**
     * 会员积分
     */
    public function users_point($type = 'point')
    {
        global $_GPC;
        if ($_GPC['act'] == 'getuser') {
            $wheresql = '';
            if ($_GPC['key']) {
                $_GPC['key'] = get_subto($_GPC['key'], '/');
                $wheresql = "`username` LIKE '%".$_GPC['key']."%' OR `userphone` LIKE '%".$_GPC['key']."%'";
            }
            $lists = db_getall(table('users'), $wheresql, '`id` LIMIT 0, 50');
            foreach ($lists AS $item) {
                echo '<li data-id="'.$item['id'].'" data-title="'.$item['username'].'">';
                if ($item['userimg']) {
                    echo '<img src="'.fillurl($item['userimg']).'">';
                }
                echo '<span>';
                echo $item['username'];
                if ($item['userphone']) {
                    echo ' (手机: '.$item['userphone'].')';
                }
                echo '</span>';
                echo '</li>';
            }
            exit("");
        }elseif ($_GPC['act'] == 'change') {
            $arr = array();
            $arr['success'] = 0;
            $arr['message'] = '';
            //
            $user = db_getone(table('users'), array('id'=>$_GPC['userid']));
            if (empty($user)) {
                $arr['message'] = "会员选择不正确";
                json_echo($arr);
            }
            $number = doubleval($_GPC['number']);
            if ($number <= 0 || $number != $_GPC['number']) {
                $arr['message'] = "请填写正确的增减数量";
                json_echo($arr);
            }
            if (empty($_GPC['type'])) {
                $number = $number * -1;
            }
            $content = trim($_GPC['content']);
            if (empty($content)) {
                $arr['message'] = "请输入操作说明";
                json_echo($arr);
            }
            $uarr = array($type.'[+]'=>$number);
            if ($_GPC['addplus']) {
                if ($type == 'point') {
                    $uarr['point_plus[+]'] = $number;
                }elseif ($type == 'money') {
                    $uarr['money_not[+]'] = $number;
                }
            }
            db_trans_start();
            db_update(table('users'), $uarr, array('id'=>$user['id']));
            db_insert(table('users_log'), array(
                'type'=>$type,
                'subtype'=>'系统',
                'fromid'=>0,
                'fromname'=>'系统',
                'userid'=>$user['id'],
                'title'=>$content,
                'setup'=>$number,
                'after'=>$user[$type] + $number,
                'setting'=>array2string(array()),
                'indate'=>SYS_TIME
            ));
            db_trans_complete();
            $arr['success'] = 1;
            $arr['message'] = '提交成功！';
            json_echo($arr);
        }
        $page = $_GPC['page'];
        $_where = "A.type='".$type."'";
        $wheresql = $_where;
        if ($_GPC['userid'] > 0) {
            $wheresql.= " AND A.userid=".intval($_GPC['userid']);
        }
        if ($_GPC['userphone']) {
            $wheresql.= " AND B.userphone LIKE '%".$_GPC['userphone']."%'";
        }
        if ($_GPC['stime']) {
            $wheresql.= " AND A.indate>=".strtotime($_GPC['stime']);
        }
        if ($_GPC['etime']) {
            $wheresql.= " AND A.indate<=".strtotime($_GPC['etime']);
        }
        if ($_GPC['pstime']) {
            $wheresql.= " AND A.todate>=".strtotime($_GPC['pstime']);
        }
        if ($_GPC['petime']) {
            $wheresql.= " AND A.todate<=".strtotime($_GPC['petime']);
        }
        if ($_GPC['username']) {
            $wheresql.= " AND B.username LIKE '%".$_GPC['username']."%'";
        }
        if ($_GPC['from_id']) {
            $wheresql.= " AND B.from_id=".intval($_GPC['from_id']);
        }
        if ($_GPC['keyword']) {
            $wheresql.= " AND (A.title LIKE '%".$_GPC['keyword']."%' OR A.subtitle LIKE '%".$_GPC['keyword']."%')";
        }
        if ($_GPC['payid'] > 0) {
            $wheresql.= " AND A.payid = '".$_GPC['payid']."' ";
        }
        if ($_GPC['orderid'] > 0) {
            $wheresql.= " AND A.orderid = ".intval($_GPC['orderid']);
        }
        if ($_GPC['subtype']) {
            if ($_GPC['subtype'] == 'to0') {
                $wheresql.= " AND A.toacc=0 ";
            }elseif ($_GPC['subtype'] == 'to1') {
                $wheresql.= " AND A.toacc=1 ";
            }else{
                $wheresql.= " AND A.subtype = '".$_GPC['subtype']."' ";
            }
        }
        $byorder = 'A.indate DESC,A.id DESC';
        if (in_array($_GPC['by_order'], array('id', 'indate', 'setup', 'indate', 'todate'))) {
            $byorder = 'A.'.$_GPC['by_order'].' '.($_GPC['by_desc']=='desc'?'desc':'asc');
            if ($_GPC['by_order'] != 'id') {
                $byorder.= ',A.id DESC';
            }
        }
        if ($_GPC['submit'] == '导出Excel') {
            $lists = db_getall('SELECT A.*,B.username,B.userimg,B.userphone,B.from_id FROM '.table('users_log').' A INNER JOIN '.table('users').' B ON A.userid=B.id', $wheresql, $byorder);
            $xlsData = array();
            foreach ($lists AS $item) {
                $item['setting'] = string2array($item['setting']);
                $laiyuan = ($item['fromname']?' '.$item['fromname']:'').($item['subtype']=='推广'?'('.chinanum($item['setting']['floor']).'级)':'');
                $xlsData[] = array(
                    $item['id'],
                    $item['id'].$item['indate'],
                    $item['username'],
                    $item['userid'],
                    $item['userphone'],
                    str_replace(array('money','point'), array('余额','积分'), $item['type']).($item['subtype']?'('.$item['subtype'].')':''),
                    $item['title'],
                    $item['orderid'],
                    $item['payid']?$item['payid']:'-',
                    $item['subtitle']?$item['subtitle']:'-',
                    $laiyuan?$laiyuan:'-',
                    ($item['type']=='point'?floatval($item['setup']):$item['setup'].'元'),
                    $item['toacc']?'审核中':($item['type']=='point'?floatval($item['after']):$item['after'].'元'),
                    nullshow($item['from_id'], '-'),
                    date("Y-m-d H:i:s", $item['indate'])
                );
            }
            $this->load->library('pexcel');
            $xlsCell  = array('数据ID', '流水号', '会员昵称', '会员ID', '手机号码', '类型', '业务名称', '订单ID', '商户单号', '备注状态', '关系来源', '变化', '剩余', '推广员ID', '时间');
            $othData = array();
            $othData[] = '导出时间：'.date("Y-m-d H:i:s", SYS_TIME);
            $this->pexcel->export(str_replace(array('money','point'), array('收益账户','余额账户','积分账户'), $type)."列表", $xlsCell, $xlsData, $othData);
            exit();
        }
        $lists = db_getlist('SELECT A.*,B.username,B.userimg,B.userphone,B.from_id FROM '.table('users_log').' A INNER JOIN '.table('users').' B ON A.userid=B.id', $wheresql, $byorder, 25, intval($page), '*', 1);
        if ($type != 'point') {
            return get_defined_vars();
        }
        tpl(get_defined_vars());
    }

    /**
     * 会员余额
     */
    public function users_money()
    {
        tpl($this->users_point('money'));
    }

    /**
     * 商家入驻
     */
    public function join_dealer()
    {
        global $_GPC;
        //
        if ($_GPC['act'] == 'update') {
            $row = db_getone(table('order_join'), array('id'=>intval($_GPC['id'])));
            if ($row) {
                if ($_GPC['status'] == '1' && $row['status'] == '审核中') {
                    db_update(table('order_join'), array('status'=>'已审核', 'update'=>SYS_TIME), array('id'=>$row['id']));
                }
                if ($_GPC['status'] == '0' && $row['status'] == '已审核') {
                    db_update(table('order_join'), array('status'=>'审核中', 'update'=>SYS_TIME), array('id'=>$row['id']));
                }
            }
            gourl(urldecode($_GPC['ctx']));
        }
        $_where = "1=1";
        $wheresql = $_where;
        if ($_GPC['id'] > 0) {
            $wheresql.= " AND A.id=". intval($_GPC['id']);
        }
        if ($_GPC['payid'] > 0) {
            $wheresql.= " AND A.payid='". $_GPC['id'] ."'";
        }
        if ($_GPC['stime']) {
            $wheresql.= " AND A.indate>=".strtotime($_GPC['stime']);
        }
        if ($_GPC['etime']) {
            $wheresql.= " AND A.indate<=".strtotime($_GPC['etime']);
        }
        if ($_GPC['userid'] > 0) {
            $wheresql.= " AND A.userid=". intval($_GPC['userid']);
        }
        if ($_GPC['storename']) {
            $wheresql.= " AND A.storename LIKE '%".$_GPC['storename']."%'";
        }
        if ($_GPC['address']) {
            $wheresql.= " AND A.address LIKE '%".$_GPC['address']."%'";
        }
        if ($_GPC['username']) {
            $wheresql.= " AND A.username LIKE '%".$_GPC['username']."%'";
        }
        if ($_GPC['userphone']) {
            $wheresql.= " AND A.userphone LIKE '%".$_GPC['userphone']."%'";
        }
        if ($_GPC['status']) {
            $wheresql.= " AND A.status='". $_GPC['status'] ."'";
        }
        $byorder = "A.indate DESC,A.id DESC";
        $lists = db_getlist('SELECT A.*,B.money FROM '.table('order_join').' A INNER JOIN '.table('pay').' B ON A.payid=B.payid', $wheresql, $byorder, 25, intval($_GPC['page']), '*', 1);
        tpl(get_defined_vars());
    }

    /**
     * 代理商申请
     */
    public function join_agents()
    {
        global $_GPC;
        if ($_GPC['act'] == 'del') {
            $row = db_getone(table('joinagents'), array('id' => intval($_GPC['id'])));
            if ($row) {
                db_delete(table('joinagents'), array('id'=>$row['id']));
            }
            gourl(urldecode($_GPC['ctx']));
        }
        if ($_GPC['act'] == 'view') {
            db_update(table('joinagents'), array('update'=>($_GPC['view']?SYS_TIME:0)), array('id'=>intval($_GPC['id'])));
            gourl(urldecode($_GPC['ctx']));
        }
        $_where = "1=1";
        $wheresql = $_where;
        if ($_GPC['id'] > 0) {
            $wheresql.= " AND `id`=". intval($_GPC['id']);
        }
        if ($_GPC['fullname']) {
            $wheresql.= " AND `fullname` LIKE '%".$_GPC['fullname']."%'";
        }
        if ($_GPC['userid'] > 0) {
            $wheresql.= " AND `userid`=". intval($_GPC['userid']);
        }
        if ($_GPC['username']) {
            $wheresql.= " AND `username` LIKE '%".$_GPC['username']."%'";
        }
        if ($_GPC['stime']) {
            $wheresql.= " AND `indate`>=".strtotime($_GPC['stime']);
        }
        if ($_GPC['etime']) {
            $wheresql.= " AND `indate`<=".strtotime($_GPC['etime']);
        }
        if ($_GPC['userphone']) {
            $wheresql.= " AND `userphone` LIKE '%".$_GPC['userphone']."%'";
        }
        if ($_GPC['weixin']) {
            $wheresql.= " AND `weixin` LIKE '%".$_GPC['weixin']."%'";
        }
        if ($_GPC['area']) {
            $wheresql.= " AND `area` LIKE '%".$_GPC['area']."%'";
        }
        if ($_GPC['advantage']) {
            $wheresql.= " AND `advantage` LIKE '%".$_GPC['advantage']."%'";
        }
        if ($_GPC['status'] == '已阅读') {
            $wheresql.= " AND `update`>0";
        }
        if ($_GPC['status'] == '未阅读') {
            $wheresql.= " AND `update`=0";
        }
        $byorder = "indate DESC,id DESC";
        $lists = db_getlist(table('joinagents'), $wheresql, $byorder, 25, intval($_GPC['page']), '*', 1);
        tpl(get_defined_vars());
    }

    /**
     * 订单管理
     */
    public function order()
    {
        tpl(get_defined_vars());
    }

    /**
     * 押金管理
     */
    public function deposit()
    {
        global $_GPC;
        $this->role();
        if ($_GPC['act'] == 'ret') {
            $this->role('refund');
            require_once("extend/notify.php");
            $return = apply_return($_GPC['payid'], false);
            message(null, $return['message'], urldecode($_GPC['ctx']));
        }
        $_where = "A.type='deposit'";
        $_where.= " AND A.status != '待付款'";
        $wheresql = $_where;
        if ($_GPC['id'] > 0) {
            $wheresql.= " AND A.id=". intval($_GPC['id']);
        }
        if ($_GPC['payid'] > 0) {
            $wheresql.= " AND A.payid='". $_GPC['payid'] ."'";
        }
        if ($_GPC['stime']) {
            $wheresql.= " AND A.paydate>=".strtotime($_GPC['stime']);
        }
        if ($_GPC['etime']) {
            $wheresql.= " AND A.paydate<=".strtotime($_GPC['etime']);
        }
        if ($_GPC['userid'] > 0) {
            $wheresql.= " AND A.userid=". intval($_GPC['userid']);
        }
        if ($_GPC['username']) {
            $wheresql.= " AND B.username LIKE '%".$_GPC['username']."%'";
        }
        if ($_GPC['money'] > 0) {
            $wheresql.= " AND A.money=". floatval($_GPC['money']);
        }
        if ($_GPC['status']) {
            $wheresql.= " AND A.status='". $_GPC['status'] ."'";
        }
        if ($_GPC['rstime']) {
            $wheresql.= " AND A.retdate>=".strtotime($_GPC['rstime']);
        }
        if ($_GPC['retime']) {
            $wheresql.= " AND A.retdate<=".strtotime($_GPC['retime']);
        }
        $byorder = "A.id DESC";
        $lists = db_getlist('SELECT A.*,B.username,B.userimg,B.userphone FROM '.table('pay').' A INNER JOIN '.table('users').' B ON A.userid=B.id', $wheresql, $byorder, 25, intval($_GPC['page']), '*', 1);
        tpl(get_defined_vars());
    }

    /**
     * 卡券
     */
    public function sale()
    {
        global $_GPC;
        if ($_GPC['action'] == 'del_all') {
            foreach ($_GPC['checkbox'] AS $iid) {
                if ($iid > 0) {
                    db_delete(table('sale'), array('id'=>$iid));
                }
            }
            gourl(url(0));
        }elseif ($_GPC['action'] == 'ordinary') {
            foreach ($_GPC['checkbox'] AS $iid) {
                if ($iid > 0) {
                    db_update(table('sale'), array('status'=>'启用'), array('id'=>$iid));
                }
            }
            gourl(url(0));
        }elseif ($_GPC['action'] == 'disabled') {
            foreach ($_GPC['checkbox'] AS $iid) {
                if ($iid > 0) {
                    db_update(table('sale'), array('status'=>'禁用'), array('id'=>$iid));
                }
            }
            gourl(url(0));
        }
        //
        $page = $_GPC['page'];
        $_where = " 1=1 ";
        if ($_GPC['keyword']) {
            $_where.= " AND `title` LIKE '%".$_GPC['keyword']."%' ";
        }
        $sale = db_getlist(table('sale'), $_where, 'id DESC', 20, intval($page), '*', 1);
        $sale['next'] = ($sale['totalpage']>$sale['nowpage'])?1:0; //上一页
        $sale['prev'] = ($sale['nowpage']>1 && $sale['totalpage']>1)?1:0; //下一页
        //
        $autoget = array(
            'reg'=>'新注册',
            'login'=>'每次登录',
            'first_pay'=>'首次支付押金',
            'every_pay'=>'每次支付押金',
            'first_complete'=>'首次完成交易',
            'every_complete'=>'每次完成交易',
            'first_invite'=>'首次成功邀请',
            'every_invite'=>'每次成功邀请',
        );
        //
        tpl(get_defined_vars());
    }

    /**
     * 添加、修改 卡券
     */
    public function sale_add()
    {
        global $_GPC;
        $sale_id = intval($_GPC['id']);
        $subtitle = '添加';
        if ($sale_id > 0) {
            $sale = db_getone(table('sale'), array('id' => $sale_id));
            if (empty($sale)) {
                $sale_id = 0;
            }else{
                $subtitle = '修改';
                $sale['setting'] = string2array($sale['setting']);
            }
        }
        //
        if ($_GPC['submit']) {
            $arr = array();
            $arr['success'] = 0;
            //
            $_arr = array();
            $_arr['title'] = $_GPC["title"];
            $_arr['code'] = $_GPC["code"]?$_GPC["code"]:generate_password(10,2);
            $_arr['sale'] = doubleval($_GPC['sale']);
            $_arr['sale_type'] = in_array($_GPC["sale_type"], array('T','P','F','C'))?$_GPC["sale_type"]:'P';   //优惠方式
            $_arr['sale_mode'] = $_GPC["sale_mode"];        //优惠方式说明
            $_arr['limit_exp'] = $_GPC["limit_exp"];        //使用条件说明
            $_arr['use_exp'] = $_GPC["use_exp"];            //可使用说明
            $_arr['cancel_ids'] = ",".str_replace("，", ",", $_GPC['cancel_ids']).",";
            $_arr['end_type'] = in_array($_GPC["end_type"], array('fixed','day','each'))?$_GPC["end_type"]:'fixed';
            $_arr['end_day'] = intval($_GPC["end_day"]);
            $_arr['end_each'] = in_array($_GPC["end_each"], array('day','week','month','year'))?$_GPC["end_each"]:'week';
            $_arr['startdate'] = strtotime($_GPC["startdate"]);
            $_arr['enddate'] = strtotime($_GPC["enddate"]);
            $_arr['autoget'] = ",".implode(",", $_GPC['autoget']).",";
            $_arr['autoget_num'] = intval($_GPC["autoget_num"]);
            $_arr['reg_assign'] = ",".str_replace("，", ",", $_GPC['reg_assign']).",";
            $_arr['reg_unassign'] = ",".str_replace("，", ",", $_GPC['reg_unassign']).",";
            $_arr['status'] = $_GPC["status"];
            $_arr['numcan_type'] = in_array($_GPC["numcan_type"], array('closed','day','week','month','year'))?$_GPC["numcan_type"]:'closed';
            $_arr['numcan'] = intval($_GPC["numcan"]);
            $_arr['numall'] = intval($_GPC["numall"]);
            $_arr['num'] = intval($_GPC["num"]);
            $_arr['min'] = intval($_GPC["min"]);
            $_arr['send'] = intval($_GPC["send"]);
            $_arr['update'] = SYS_TIME;
            $_arr['setting'] = array2string($_arr['setting']);
            //
            if ($_arr['sale_type'] == 'T') {
                $_arr['sale'] = intval($_arr['sale']);
            }
            if (empty($_arr['title'])) {
                $arr['message'] = '名称不能为空';
                echo json_encode($arr); exit();
            }
            if ($sale_id > 0){
                //修改
                $subart = db_count(table('sale'), array('id!='=>$sale_id, 'code'=>$_GPC['code']));
                if ($subart > 0) {
                    $arr['message'] = '代码已存在！';
                    echo json_encode($arr); exit();
                }
                //
                $arr['id'] = $sale_id;
                if (db_update(table('sale'), $_arr, array("id"=>$sale_id))){
                    $arr['success'] = 1;
                    $arr['message'] = '修改成功';
                }
            }else{
                //新增
                $subart = db_count(table('sale'), array('code'=>$_GPC['code']));
                if ($subart > 0) {
                    $arr['message'] = '代码已存在！';
                    echo json_encode($arr); exit();
                }
                //
                $_arr['indate'] = SYS_TIME;
                $sale_id = db_insert(table('sale'), $_arr, true);
                $arr['id'] = $sale_id;
                if ($sale_id > 0){
                    $arr['success'] = 1;
                    $arr['message'] = '添加成功';
                }
            }
            echo json_encode($arr); exit();
        }
        $startdate = $sale_id&&isset($sale)?$sale['startdate']:SYS_TIME;
        $enddate = $sale_id&&isset($sale)?$sale['enddate']:SYS_TIME + 2592000;
        $numcan = $sale_id&&isset($sale)?$sale['numcan']:1;
        $numall = $sale_id&&isset($sale)?$sale['numall']:100;
        $num = $sale_id&&isset($sale)?$sale['num']:100;
        tpl(get_defined_vars());
    }

    /**
     * 发放记录 卡券
     */
    public function sale_notes()
    {
        global $_GPC;
        //
        $sale = db_getone(table('sale'), array('id' => $_GPC['id']));
        if (empty($sale)) {
            message(null, sale_name().'不存在！');
        }
        $_where = 'A.saleid='.$sale['id'];
        $wheresql = $_where;
        if ($_GPC['userid'] > 0) {
            $wheresql.= " AND A.userid=".intval($_GPC['userid']);
        }
        if ($_GPC['userphone']) {
            $wheresql.= " AND B.userphone LIKE '%".$_GPC['userphone']."%'";
        }
        if ($_GPC['stime']) {
            $wheresql.= " AND A.indate>=".strtotime($_GPC['stime']);
        }
        if ($_GPC['etime']) {
            $wheresql.= " AND A.indate<=".strtotime($_GPC['etime']);
        }
        if ($_GPC['username']) {
            $wheresql.= " AND B.username LIKE '%".$_GPC['username']."%'";
        }
        if ($_GPC['dataid'] > 0) {
            $wheresql.= " AND A.id=".intval($_GPC['dataid']);
        }
        if ($_GPC['orderid'] > 0) {
            $wheresql.= " AND A.orderid=".intval($_GPC['orderid']);
        }
        if ($_GPC['submit'] == '导出Excel') {
            $lists = db_getall('SELECT A.*,B.userimg,B.username,B.userphone,B.id AS Bid FROM '.table('users_sale').' A INNER JOIN '.table('users').' B ON A.userid=B.id', $wheresql, 'A.indate DESC,A.id DESC');
            $xlsData = array();
            foreach ($lists AS $item) {
                $enddate = $sale['enddate'];
                if ($sale['end_type'] == 'day') {
                    $enddate = $sale['end_day'] * 86400 + $item['indate'];
                } elseif ($sale['end_type'] == 'each') {
                    if ($sale['end_each'] == 'year') {
                        $enddate = mktime(23, 59, 59, 12, 31, date('Y',$item['indate']));
                    } elseif ($sale['end_each'] == 'month') {
                        $enddate = mktime(23, 59, 59, date('m',$item['indate']), date('t',$item['indate']), date('Y',$item['indate']));
                    } elseif ($sale['end_each'] == 'week') {
                        $enddate = mktime(23, 59, 59, date('m',$item['indate']), date('d',$item['indate']) - date('w',$item['indate']) + 7, date('Y',$item['indate']));
                    } elseif ($sale['end_each'] == 'day') {
                        $enddate = mktime(23, 59, 59, date('m',$item['indate']), date('d',$item['indate']), date('Y',$item['indate']));
                    }
                }
                if ($sale['status'] == '启用' && $enddate > SYS_TIME && $item['update'] == 0) {
                    $status_cn = '可使用';
                }elseif ($item['update'] > 0){
                    $status_cn = '已使用';
                }elseif ($enddate <= SYS_TIME){
                    $status_cn = '已过期';
                }else{
                    $status_cn = '不可用';
                }
                $item['enddate'] = $enddate;
                $item['status_cn'] = $status_cn;
                //
                $xlsData[] = array(
                    $item['id'],
                    $item['Bid'],
                    $item['username'],
                    $item['userphone'],
                    $item['from']?$item['from']:'-',
                    date("Y-m-d H:i:s", $item['indate']),
                    date("Y-m-d H:i:s", $item['enddate']),
                    $item['status_cn'],
                    $item['update']?date("Y-m-d H:i:s", $item['update']):'-',
                    $item['update']?'订单ID:'.$item['orderid']:'-'
                );
            }
            $this->load->library('pexcel');
            $xlsCell  = array('数据ID', '会员ID', '会员昵称', '手机号码', '领取端口', '领取时间', '到期时间', '状态', '使用时间', '使用方式');
            $othData = array();
            $othData[] = sale_name().'ID：'.$sale['id'];
            $othData[] = sale_name().'名称：'.$sale['title'];
            $othData[] = sale_name().'剩余量：'.$sale['num'];
            $othData[] = sale_name().'总数量：'.$sale['numall'];
            $othData[] = '导出时间：'.date("Y-m-d H:i:s", SYS_TIME);
            $this->pexcel->export(sale_name()."发放记录", $xlsCell, $xlsData, $othData);
        }
        $lists = db_getlist('SELECT A.*,B.userimg,B.username,B.userphone,B.id AS Bid FROM '.table('users_sale').' A INNER JOIN '.table('users').' B ON A.userid=B.id', $wheresql, 'A.indate DESC,A.id DESC', 20, $_GPC['page'], '*', 1);
        foreach ($lists['list'] AS $key=>$item) {
            $enddate = $sale['enddate'];
            if ($sale['end_type'] == 'day') {
                $enddate = $sale['end_day'] * 86400 + $item['indate'];
            } elseif ($sale['end_type'] == 'each') {
                if ($sale['end_each'] == 'year') {
                    $enddate = mktime(23, 59, 59, 12, 31, date('Y',$item['indate']));
                } elseif ($sale['end_each'] == 'month') {
                    $enddate = mktime(23, 59, 59, date('m',$item['indate']), date('t',$item['indate']), date('Y',$item['indate']));
                } elseif ($sale['end_each'] == 'week') {
                    $enddate = mktime(23, 59, 59, date('m',$item['indate']), date('d',$item['indate']) - date('w',$item['indate']) + 7, date('Y',$item['indate']));
                } elseif ($sale['end_each'] == 'day') {
                    $enddate = mktime(23, 59, 59, date('m',$item['indate']), date('d',$item['indate']), date('Y',$item['indate']));
                }
            }
            if ($sale['status'] == '启用' && $enddate > SYS_TIME && $item['update'] == 0) {
                $status_cn = '可使用';
            }elseif ($item['update'] > 0){
                $status_cn = '已使用';
            }elseif ($enddate <= SYS_TIME){
                $status_cn = '已过期';
            }else{
                $status_cn = '不可用';
            }
            $lists['list'][$key]['enddate'] = $enddate;
            $lists['list'][$key]['status_cn'] = $status_cn;
        }
        //
        tpl(get_defined_vars());
    }

    /**
     * 删除 用户的卡券
     */
    public function sale_user_del()
    {
        global $_GPC;
        db_delete(table('users_sale'), array('id'=>intval($_GPC['did'])));
        gourl(url('admin/sale_notes').'?id='.$_GPC['id']);
    }

    /**
     * 常见问题
     */
    public function help()
    {
        global $_GPC;
        if ($_GPC['action'] == 'del_all') {
            foreach ($_GPC['checkbox'] AS $iid) {
                if ($iid > 0) {
                    db_delete(table('help'), array('id'=>$iid));
                }
            }
            gourl(url(0));
        }
        //
        $page = $_GPC['page'];
        $_where = " 1=1 ";
        if ($_GPC['keyword']) {
            $_where.= " AND (`type` = '".$_GPC['keyword']."' OR `title` LIKE '%".$_GPC['keyword']."%') ";
        }
        $help = db_getlist(table('help'), $_where, 'id DESC', 15, intval($page), '*', 1);
        $help['next'] = ($help['totalpage']>$help['nowpage'])?1:0; //上一页
        $help['prev'] = ($help['nowpage']>1 && $help['totalpage']>1)?1:0; //下一页
        //
        tpl(get_defined_vars());
    }

    /**
     * 添加、修改 常见问题
     */
    public function help_add()
    {
        global $_GPC;
        $help_id = intval($_GPC['id']);
        $subtitle = '添加';
        if ($help_id > 0) {
            $help = db_getone(table('help'), array('id' => $help_id));
            if (empty($help)) {
                $help_id = 0;
            }else{
                $subtitle = '修改';
            }
        }
        //
        if ($_GPC['submit']) {
            $arr = $_arr = array();
            $arr['success'] = 0;
            //
            $_arr['type'] = $_GPC["type"];
            $_arr['title'] = $_GPC["title"];
            $_arr['content'] = $_GPC["content"];
            //
            if (empty($_arr['title'])) {
                $arr['message'] = '标题不能为空';
                json_echo($arr);
            }
            if (empty($_arr['content'])) {
                $arr['message'] = '内容不能为空';
                json_echo($arr);
            }
            if ($help_id > 0){
                //修改
                $arr['id'] = $help_id;
                if (db_update(table('help'), $_arr, array("id"=>$help_id))){
                    $arr['success'] = 1;
                    $arr['message'] = '修改成功';
                }
            }else{
                //新增
                $_arr['indate'] = SYS_TIME;
                $help_id = db_insert(table('help'), $_arr, true);
                $arr['id'] = $help_id;
                if ($help_id > 0){
                    $arr['success'] = 1;
                    $arr['message'] = '添加成功';
                }
            }
            json_echo($arr);
        }
        tpl(get_defined_vars());
    }

    /**
     * 删除 常见问题
     */
    public function help_del()
    {
        global $_GPC;
        $help_id = intval($_GPC['id']);
        $help = db_getone(table('help'), array('id'=>$help_id));
        if (empty($help)) {
            message(null, '删除失败：问题不存在！');
        }
        db_delete(table('help'), array('id'=>$help_id));
        message(null, '删除成功', url('admin/helpadd'));
    }

    /**
     * 查看资源
     */
    public function listup($parent1)
    {
        $parent = array($parent1);
        $getp = value($parent, 0, false, 'images');
        $_path = "uploadfiles/";
        $_gath = $this->input->get('path');
        $_nowval = $this->input->post('nowval');
        if ($_gath) {
            $this->session->set_userdata('sys:'.$getp.':listup_path', $_gath);
            $_path.= str_replace('|','/',trim($_gath,'|'))."/";
        }elseif ($_nowval && preg_match('/^'.str_replace('/','\/',$_path).'/i', $_nowval)){
            //首次默认路径
            $nowpath = dirname($_nowval);
            $nownane = substr($_nowval, strlen($nowpath) + 1);
            $_gath = str_replace("/", "|", substr($nowpath, strlen($_path)-1));
            $_path.= substr($nowpath, strlen($_path)-1)."/";
        }elseif (!isset($_GET['path'])) {
            $_gath = $this->session->userdata('sys:'.$getp.':listup_path');
            $_path.= str_replace('|','/',trim($_gath,'|'))."/";
        }
        $_path = str_replace("//", "/", $_path);
        $folder = '';
        $path = array();
        foreach(explode('|', $_gath) as $v){
            $folder.= ($v)?'|'.$v:'';
            if ($v) $path[$v] = $folder;
        }
        $_path = str_replace("..", "", $_path);
        $list = glob(FCPATH.$_path . '*', GLOB_BRACE);
        $dir = $file= array();
        if ($path) {
            $dir['uponeleveldir']['title'] = '...';
            $dir['uponeleveldir']['url'] = '';
            $dir['uponeleveldir']['img'] = '';
            $dir['uponeleveldir']['class'] = 'folder';
            $dir['uponeleveldir']['type'] = '0';
            $dir['uponeleveldir']['f'] = substr($_gath,0,strripos(rtrim($_gath,'|'),'|')).'|';;
        }
        $this->load->model('vupload');
        foreach ($list as $v){
            $filename = basename($v);
            if (is_dir($v)) {
                $dir[$filename]['title'] = $filename;
                $dir[$filename]['url'] = $_path.$filename;
                $dir[$filename]['img'] = '';
                $dir[$filename]['class'] = 'folder';
                $dir[$filename]['type'] = '0';
                $dir[$filename]['f'] = $_gath.'|'.$filename;
            } elseif (substr($filename,-10) != "_thumb.jpg" && substr($filename,-9) != "_cart.jpg") {
                $file[$filename]['title'] = $filename;
                $file[$filename]['url'] = $_path.$filename;
                $file[$filename]['img'] = fillurl($_path.$filename);
                $file[$filename]['thumb'] = $file[$filename]['img'];
                $file[$filename]['class'] = '';
                $file[$filename]['type'] = '1';
                $file[$filename]['f'] = '';
                $extension = pathinfo(BASE_PATH.$_path.$filename, PATHINFO_EXTENSION);
                if (in_array($extension, array('mp3','wma','wav','amr'))) {
                    $file[$filename]['thumb'] = fillurl('caches/statics/images/file_music.png');
                }elseif (in_array($extension, array('rm','rmvb','wmv','avi','mpg','mpeg','mp4'))) {
                    $file[$filename]['thumb'] = fillurl('caches/statics/images/file_video.png');
                }elseif (in_array($extension, array('gif','jpg','jpeg','png','bmp'))) {
                    if (!file_exists(BASE_PATH.$_path.$filename.'_thumb.jpg')) {
                        $this->vupload->img2thumb(BASE_PATH.$_path.$filename, BASE_PATH.$_path.$filename.'_thumb.jpg', 100, 0);
                    }
                    if (file_exists(BASE_PATH.$_path.$filename.'_thumb.jpg')) {
                        $file[$filename]['thumb'].= '_thumb.jpg';
                    }
                }else{
                    $file[$filename]['thumb'] = fillurl('caches/statics/images/file_other.png');
                }
            }
        }
        if (count($dir) > 1) {
            $inorder = array();
            foreach ($dir as $key => $val) {
                $inorder[$key] = ($val['title']=='...')?-999999:$val['title'];
            }
            array_multisort($inorder, SORT_ASC, $dir);
        }
        $listarr = array_merge($dir, $file);
        tpl(get_defined_vars());
    }

    /**
     * 上传 资源
     */
    public function upfile($parent1 = null, $parent2 = null, $parent3 = null)
    {
        $parent = array($parent1, $parent2, $parent3);
        $iname = value($parent, 0, false, 'file_img'); 	//表单名
        $tname = value($parent, 1, false, 'images'); 	//类型：images/videos/voices
        $fname = value($parent, 2);						//文件命名
        $allowed = value($_GET, 'allowed'); 			//格式限制
        $size = intval(value($_GET, 'size')); 			//大小限制KB
        $arr = array();
        $tname = in_array($tname, array('images','audio','voices','videos'))?$tname:'images';
        $arr['upload_path'] = FCPATH."uploadfiles/".$tname."/".date("Ym/");
        if ($tname == 'audio' || $tname == 'voices') {
            $arr['allowed_types'] = 'mp3|wma|wav|amr';
        }elseif ($tname == 'videos'){
            $arr['allowed_types'] = 'rm|rmvb|wmv|avi|mpg|mpeg|mp4';
        }else{
            $arr['allowed_types'] = 'gif|jpg|jpeg|png';
        }
        if ($allowed && $allowed != "undefined") {
            $arr['allowed_types'] = $allowed;
        }
        $arr['file_name'] = ($fname)?$fname:SYS_TIME.rand(10,99);
        if ($size > 0) {
            $arr['max_size'] = $size;
        }
        $this->load->model('vupload');
        $data = $this->vupload->upfile($arr, $iname);
        echo json_encode($data);
        exit();
    }

    /**
     * 删除文件
     */
    public function delup()
    {
        $_path = "uploadfiles";
        $_gath = str_replace("..", "", $this->input->get('path'));
        if (strpos($_gath, $_path) !== false) {
            if (file_exists(FCPATH.$_gath)) {
                @unlink(FCPATH.$_gath);
            }
            if (file_exists(FCPATH.$_gath.'_thumb.jpg')) {
                @unlink(FCPATH.$_gath.'_thumb.jpg');
            }
        }
    }


    /** **************************************************************************************** */
    /** **************************************************************************************** */
    /** **************************************************************************************** */


    private function role($type = 'view', $rolename = '') {
        if (!$this->rolerun($type, $rolename)) {
            message('权限不足', '权限不足，无法进行此操作！');
        }
    }
    private function rolerun($type = 'view', $rolename = '') {
        global $_A;
        if (empty($rolename)) {
            $rolename = $_A['segments'][2];
        }
        $replacearr = array(
            'users_add'=>'users',
        );
        if (isset($replacearr[$rolename])) {
            $rolename = $replacearr[$rolename];
        }
        if ($type == '1') {
            $type = 'edit';
        }
        if (empty($_A['_role'][$rolename][$type])) {
            return false;
        }else{
            return true;
        }
    }
}
