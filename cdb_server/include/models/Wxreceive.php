<?php
defined('BASEPATH') OR exit('No direct script access allowed');

//
class Wxreceive extends CI_Model {
    private $setting;
    private $cache_path;
    private $qrcode_path;

	public function __construct()
    {
        parent::__construct();
        $this->load->helper("communication");
        $this->setting = setting('openconnect');
        $this->cache_path = BASE_PATH.'caches'.DIRECTORY_SEPARATOR.'weixin'.DIRECTORY_SEPARATOR.'token_ticket'.DIRECTORY_SEPARATOR;
        $this->qrcode_path = BASE_PATH.'caches'.DIRECTORY_SEPARATOR.'weixin'.DIRECTORY_SEPARATOR.'qrcode'.DIRECTORY_SEPARATOR;
        if (!is_dir($this->cache_path)) { make_dir($this->cache_path); }
        if (!is_dir($this->qrcode_path)) { make_dir($this->qrcode_path); }
	}

    /**
     * 接收信息
     */
    public function receive()
    {
        global $_GPC;
        if (isset($_GPC['echostr'])) {
            //验证事件
            $tmpArr = array($this->setting['weixin']['token'], $_GPC["timestamp"], $_GPC["nonce"]);
            sort($tmpArr, SORT_STRING);
            $tmpStr = implode( $tmpArr );
            $tmpStr = sha1( $tmpStr );
            if( $tmpStr == $_GPC["signature"] ){
                echo $_GPC["echostr"];
            }
            exit();
        } elseif (isset($_GPC['signature']) || isset($_GPC['msg_signature'])) {
            //接收信息处理
            $post_str = isset($GLOBALS['HTTP_RAW_POST_DATA']) ? $GLOBALS['HTTP_RAW_POST_DATA'] : file_get_contents("php://input");
            if (empty($post_str)) return false;
            $post_obj = json_decode(xml2json($post_str), true);
            if (isset($post_obj['Encrypt']) && !isset($post_obj['FromUserName'])) {
                include_once "weixin/WXBizMsgCrypt.php";
                $this->wxcpt = new WXBizMsgCrypt($this->setting['weixin']['token'], $this->setting['weixin']['aeskey'], $this->setting['weixin']['appid']);
                $errCode = $this->wxcpt->DecryptMsg($_GPC['msg_signature'], $_GPC["timestamp"], $_GPC["nonce"], $post_str, $post_str);
                if ($errCode != 0) { exit (); }
                $post_obj = json_decode(xml2json($post_str), true);
            }
            $M = array();
            $M['openid'] = $M['fromuserid'] = value($post_obj, 'FromUserName');     //发送消息方ID（会员openid）
            $M['tousername'] = value($post_obj, 'ToUserName');                      //接收消息方ID（公众号原始id）
            $M['createtime'] = value($post_obj, 'CreateTime');            	        //消息创建时间
            $M['msgtype'] = value($post_obj, 'MsgType');                  	        //消息类型
            $M['eventtype'] = strtolower(value($post_obj, 'Event'));    	        //获取事件类型
            $M['rawdata'] = $post_obj;
            // 过滤重复信息
            $msgid = $post_obj['MsgId']?$post_obj['MsgId']:($post_obj['CreateTime'].$post_obj['MsgType'].$post_obj['Event']);
            $msgfile = BASE_PATH.'caches/weixin/msgid/'.$M['tousername'].'_'.$M['openid'].'.txt';
            if (file_exists($msgfile) && $msgid == @file_get_contents($msgfile)) { return false; }
            if (!is_dir(BASE_PATH.'caches/weixin/msgid/')) { make_dir(BASE_PATH.'caches/weixin/msgid/'); }
            @file_put_contents($msgfile, $msgid);
            // 收到用户发送的对话消息
            if ($M['msgtype'] == "text") {
                $M['text'] = trim(value($post_obj, 'Content'));
                $this->savemessage($M);
            }
            // 图片消息、语音消息、视频消息、小视频消息
            elseif (in_array($M['msgtype'], array('image','voice','video','shortvideo'))) {
                $media_id = value($post_obj, 'MediaId');
                $mediaurl = '';
                if ($M['msgtype'] == "image") {
                    $mediaurl = value($post_obj, "PicUrl");
                }
                $url = "http://file.api.weixin.qq.com/cgi-bin/media/get?access_token=".$this->token()."&media_id=".$media_id;
                $_html = ihttp_request($url);
                if(!is_error($_html)) {
                    $rethtml = @json_decode($_html['content'], true);
                    if (isset($rethtml['errmsg']) && in_array($rethtml['errmsg'], array('40001','42001'))) {
                        $this->error_code($rethtml['errcode']);
                        $_html = ihttp_request($url);
                        if(!is_error($_html)) {
                            $rethtml = @json_decode($_html['content'], true);
                        }
                    }
                    if (!isset($rethtml['errmsg'])) {
                        $_file = 'uploadfiles/weixin/'.str_replace('shortvideo','video',$M['msgtype']).'s/'.date('Ym/', SYS_TIME);
                        $nan = $media_id.str_replace(array('image','voice','video','shortvideo'), array('.jpg','.'.value($post_obj,"Format"),'.mp4','.mp4'), $M['msgtype']);
                        if ($M['msgtype'] == 'shortvideo') { $nan = "short_".$nan; }
                        $_dir = BASE_PATH.$_file;
                        make_dir($_dir);
                        $fp2 = @fopen($_dir.$nan,'a');
                        fwrite($fp2, $_html['content']);
                        fclose($fp2);
                        $mediaurl = $_file.$nan;
                        if (value($post_obj, "Recognition")) {
                            $mediaurl = array('text'=>$_file.$nan, 'recognition'=>value($post_obj, "Recognition"));
                        }
                    }
                }
                $M['text'] = $mediaurl;
                $this->savemessage($M);
            }
            //地理位置消息 (*2)
            elseif ($M['msgtype'] == "location") {
                $M['text'] = array(
                    'text'=>value($post_obj, "Label"),
                    'latitude'=>value($post_obj, "Location_X"),
                    'longitude'=>value($post_obj, "Location_Y"),
                    'scale'=>value($post_obj, "Scale")
                );
                $this->savemessage($M);
            }
            //链接消息
            elseif ($M['msgtype'] == "link") {
                $M['text'] = array(
                    'text'=>value($post_obj, "Title"),
                    'url'=>value($post_obj, "Url"),
                    'description'=>value($post_obj, "Description")
                );
                $this->savemessage($M);
            }
            //事件推送
            elseif ($M['msgtype'] == "event") {
                switch ($M['eventtype'])
                {
                    case "subscribe":                   //①关注的事件；②扫描带参数二维码事件（用户未关注时，进行关注后的事件推送）
                        $M['msgtype'] = 'follow';
                        $M['text'] = '::关注';
                        $eventkey = value($post_obj, "EventKey");
                        if (substr($eventkey,0,8)=='qrscene_') {
                            $M['text'] = array(
                                'text'=>'::扫描二维码关注',
                                'eventkey'=>substr($eventkey,8),
                                'ticket'=>value($post_obj, "Ticket")
                            );
                        }
                        $this->userwx($M['openid'], true);
                        $this->savemessage($M);
                        break;
                    case "scan":                        //扫描带参数二维码事件（用户已关注时的事件推送）
                        $M['msgtype'] = 'scan';
                        $M['text'] = array(
                            'text'=>'::扫描二维码进入',
                            'eventkey'=>value($post_obj, "EventKey"),
                            'ticket'=>value($post_obj, "Ticket")
                        );
                        $this->savemessage($M);
                        break;
                    case "unsubscribe":                 //取消关注消息
                        $M['msgtype'] = 'unfollow';
                        $M['text'] = '::取消关注';
                        $this->userwx($M['openid'], true);
                        $this->savemessage($M);
                        break;
                    case "view":                        //跳转URL
                        $M['msgtype'] = 'view';
                        $M['text'] = trim(value($post_obj, "EventKey"));
                        $this->savemessage($M);
                        break;
                    case "click":                       //点击菜单拉取消息时的事件
                        $M['msgtype'] = 'click';
                        $M['text'] = trim(value($post_obj, "EventKey"));
                        $this->savemessage($M);
                        break;
                    case "location":                    //上报地理位置事件（用户同意上报地理位置后，每次进入公众号会话时）
                        $M['msgtype'] = 'location_event';
                        $M['text'] = array(
                            'text'=>'::上报地理位置',
                            'latitude'=>value($post_obj, "Latitude"),
                            'longitude'=>value($post_obj, "Longitude"),
                            'precision'=>value($post_obj, "Precision")
                        );
                        $this->savemessage($M);
                        break;
                    case "enter_agent":                 //进入窗口事件
                        $M['msgtype'] = 'enter_agent';
                        $M['text'] = array(
                            'text'=>'::进入窗口',
                            'time'=>$M['createtime'],
                            'time_cn'=>date("Y-m-d H:i:s", $M['createtime'])
                        );
                        $this->savemessage($M);
                        break;
                    case "scancode_push":               //扫码推事件的事件
                        $M['msgtype'] = 'scancode_push';
                        $M['text'] = array(
                            'text'=>value($post_obj, "EventKey"),
                            'scantype'=>value($post_obj, "ScanCodeInfo|ScanType"),
                            'scanresult'=>value($post_obj, "ScanCodeInfo|ScanResult")
                        );
                        $this->savemessage($M);
                        break;
                    case "scancode_waitmsg":            //扫码推事件且弹出“消息接收中”提示框的事件
                        $M['msgtype'] = 'scancode_waitmsg';
                        $M['text'] = array(
                            'text'=>value($post_obj, "EventKey"),
                            'scantype'=>value($post_obj, "ScanCodeInfo|ScanType"),
                            'scanresult'=>value($post_obj, "ScanCodeInfo|ScanResult")
                        );
                        $this->savemessage($M);
                        break;
                    case "pic_sysphoto":                //(*1)弹出系统拍照发图的事件
                    case "pic_photo_or_album":          //(*1)弹出拍照或者相册发图的事件
                    case "pic_weixin":                  //(*1)弹出微信相册发图器的事件
                    case "location_select":             //(*2)弹出地理位置选择器的事件
                }
            }
        }
        return true;
    }

    /**
     * @param string $url
     * @return array
     */
    public function jssdkConfig($url = '')
    {
        $weixin = $this->setting['weixin'];
        $appid = $weixin['appid'];
        $secret = $weixin['secret'];
        if (empty($appid) || empty($secret)) {
            return error(-1, "参数丢失！");
        }
        $jsapiTicket = $this->jsapi_ticket();
        if (is_error($jsapiTicket)) {
            $jsapiTicket = $jsapiTicket['message'];
        }
        $nonceStr = generate_password(16);
        $timestamp = SYS_TIME;
        $url = $url?$url:get_url();

        $string1 = "jsapi_ticket={$jsapiTicket}&noncestr={$nonceStr}&timestamp={$timestamp}&url={$url}";
        $signature = sha1($string1);

        $config = array(
            "appId"		=> $appid,
            "nonceStr"	=> $nonceStr,
            "timestamp" => "$timestamp",
            "signature" => $signature,
        );
        return $config;
    }

    /**
     * @return array|mixed
     */
    public function jsapi_ticket()
    {
        $weixin = $this->setting['weixin'];
        $appid = $weixin['appid'];
        $secret = $weixin['secret'];
        if (empty($appid) || empty($secret)) {
            return error(-1, "参数丢失！");
        }
        static $jsapiticket = array();
        if (!is_null($jsapiticket[$appid])) {
            return $jsapiticket[$appid];
        }
        $file = $this->cache_path.$appid.".jsapi_ticket.php";
        if (file_exists($file)) {
            @include $file;
            if (isset($ticket_time) && $ticket_time + 7000 > SYS_TIME && isset($ticket_str)) {
                $jsapiticket[$appid] = $ticket_str;
                return $ticket_str;
            }
        }
        $url = "https://api.weixin.qq.com/cgi-bin/ticket/getticket?access_token=".$this->token()."&type=jsapi";
        $content = ihttp_request($url);
        if(is_error($content)) {
            $error = '获取微信公众号jsapi_ticket失败, 请稍后重试！错误详情: ' . $content['message'];
            return error(-1, $error);
        }
        $ticket = @json_decode($content['content'], true);
        $this->error_code($ticket, true);
        if(empty($ticket) || intval(($ticket['errcode'])) != 0) {
            return error(-1, '获取微信公众号 jsapi_ticket 结果错误, 错误信息: ' . $ticket['errmsg']);
        }
        $ticket_str = $ticket['ticket'];
        $ticket_time = SYS_TIME + $ticket['expires_in'] - 200;
        if ($ticket_str) {
            file_put_contents($file,
                '<?php defined(\'BASEPATH\') OR exit(\'No direct script access allowed'.date("Y-m-d H:i:s").'\');
                $ticket_time='.$ticket_time.';$ticket_str=\''.$ticket_str.'\'; ?>');
        }
        $jsapiticket[$appid] = $ticket_str;
        return $ticket_str;
    }

    /**
     * 获取token
     * @return array|mixed
     */
    public function token($isrest = false)
    {
        $weixin = $this->setting['weixin'];
        $appid = $weixin['appid'];
        $secret = $weixin['secret'];
        if (empty($appid) || empty($secret)) {
            return error(-1, "参数丢失！");
        }
        static $accesstoken = array();
        if ($isrest) {
            $accesstoken = array();
        }
        if (!is_null($accesstoken[$appid])) {
            return $accesstoken[$appid];
        }
        $file = $this->cache_path.$appid.".access_token.php";
        if (file_exists($file)) {
            @include $file;
            if (isset($token_time) && $token_time + 7000 > SYS_TIME && isset($token_str)) {
                $accesstoken[$appid] = $token_str;
                return $token_str;
            }
        }
        $url = "https://api.weixin.qq.com/cgi-bin/token?grant_type=client_credential&appid=".$appid."&secret=".$secret;
        $content = ihttp_request($url);
        if(is_error($content)) {
            $error = '获取微信公众号授权失败, 请稍后重试！错误详情: ' . $content['message'];
            return error(-1, $error);
        }
        $token = @json_decode($content['content'], true);
        if(empty($token) || !is_array($token) || empty($token['access_token']) || empty($token['expires_in'])) {
            $errorinfo = substr($content['meta'], strpos($content['meta'], '{'));
            $errorinfo = @json_decode($errorinfo, true);
            $error = '获取微信公众号授权失败, 请稍后重试！ 公众平台返回原始数据为: 错误代码-' . $errorinfo['errcode'] . '，错误信息-' . $errorinfo['errmsg'];
            return error(-1, $error);
        }
        $token = $token['access_token'];
        $expires = SYS_TIME + $token['expires_in'] - 200;
        if ($token) {
            file_put_contents($file,
                '<?php defined(\'BASEPATH\') OR exit(\'No direct script access allowed'.date("Y-m-d H:i:s").'\');
                $token_time='.$expires.';$token_str=\''.$token.'\'; ?>');
        }
        $accesstoken[$appid] = $token;
        return $token;
    }

    /**
     * 发送文本消息
     * @param $userid
     * @param $text
     * @return array
     */
    public function text($userid, $text)
    {
        $openid = $this->idORopenid($userid);
        if (empty($openid)) {
            return error(-1, "用户不存在！");
        }
        $send = array();
        $send['touser'] = $openid;
        $send['msgtype'] = 'text';
        $send['text'] = array('content' => $this->encode($this->send2text(str_replace("\r\n", "\n", $text))));
        $Request = $this->sendCustomNotice($send);
        if (is_error($Request)) {
            return error(-1, $Request['message']);
        }else{
            return error(0, '成功');
        }
    }

    /**
     * 发送图片
     * @param $userid
     * @param $img
     * @param string $waittis
     * @return array
     */
    public function img($userid, $img, $waittis = '')
    {
        $openid = $this->idORopenid($userid);
        if (empty($openid)) {
            return error(-1, "用户不存在！");
        }
        $Request = $this->media($img, 'image', $waittis, $openid);
        if (is_error($Request)) {
            return error(-1, $Request['message']);
        }else{
            return error(0, '成功');
        }
    }
    public function image($userid, $img, $waittis = '') { return $this->img($userid, $img, $waittis); }

    /**
     * 发送语音
     * @param $userid
     * @param $voice
     * @param string $waittis
     * @return array
     */
    public function voice($userid, $voice, $waittis = '')
    {
        $openid = $this->idORopenid($userid);
        if (empty($openid)) {
            return error(-1, "用户不存在！");
        }
        $Request = $this->media($voice, 'voice', $waittis, $openid);
        if (is_error($Request)) {
            return error(-1, $Request['message']);
        }else{
            return error(0, '成功');
        }
    }

    /**
     * 发送视频
     * @param $userid
     * @param $video
     * @param string $waittis
     * @return array
     */
    public function video($userid, $video, $waittis = '')
    {
        $openid = $this->idORopenid($userid);
        if (empty($openid)) {
            return error(-1, "用户不存在！");
        }
        $Request = $this->media($video, 'video', $waittis, $openid);
        if (is_error($Request)) {
            return error(-1, $Request['message']);
        }else{
            return error(0, '成功');
        }
    }

    /**
     * 发送图文消息
     * @param $userid
     * @param $newdata
     * @return array
     */
    public function news($userid, $newdata)
    {
        $openid = $this->idORopenid($userid);
        if (empty($openid)) {
            return error(-1, "用户不存在！");
        }
        $image_text_msg = $this->newshandle($newdata);
        $send = array();
        $send['touser'] = $openid;
        $send['msgtype'] = 'news';
        $send['news']['articles'] = $image_text_msg;
        $Request = $this->sendCustomNotice($send);
        if (is_error($Request)) {
            return error(-1, $Request['message']);
        }else{
            return error(0, '成功');
        }
    }

    /**
     * 发送模板消息
     * @param string $userid
     * @param string $tmid          模板ID
     * @param array  $conarr        模板数据
     * @param string $tmurl         链接地址
     * @param string $topcolor      头部颜色
     * @return bool|mixed
     */
    public function tempmsg($userid = '', $tmid = '', $conarr = array(), $tmurl = '', $topcolor = '#44B549')
    {
        $openid = $this->idORopenid($userid);
        if (empty($openid)) {
            return error(-1, "用户不存在！");
        }
        if (empty($conarr)) {
            return error(-1, "模板数据不能为空！");
        }
        foreach ($conarr AS $key=>$item) {
            if (!is_array($item)) {
                $conarr[$key] = array('value'=>$item);
            }
        }
        $token = $this->token();
        if(is_error($token)){
            return $token;
        }
        if ($tmurl && !leftexists($tmurl, "http")) {
            $tmurl = "http://".$tmurl;
        }
        if ($tmurl) {
            $tmurl = url('users/wxauto').'?continue=1&ctx='.urlencode($tmurl);
        }
        $arr = array();
        $arr['touser'] = $openid;
        $arr['template_id'] = $tmid;
        $arr['url'] = $tmurl;
        $arr['topcolor'] = $topcolor?$topcolor:"#44B549";
        $arr['data'] = $conarr;
        //
        $url = 'https://api.weixin.qq.com/cgi-bin/message/template/send?access_token='.$token;
        $response = ihttp_post($url, json_encode($arr));
        if(is_error($response)) {
            return error(-1, "访问公众平台接口失败, 错误: {$response['message']}");
        }
        $result = @json_decode($response['content'], true);
        if(empty($result)) {
            return error(-1, "接口调用失败, 元数据: {$response['meta']}");
        } elseif(!empty($result['errcode'])) {
            return error(-1, "访问微信接口错误, 错误代码: {$result['errcode']}, 错误信息: {$result['errmsg']},错误详情：{$this->error_code($result['errcode'])}");
        }
        return $result;
    }

    /**
     * 微信模板通知
     * @param int $userid
     * @param string $tid
     * @param array $tempdata
     * @param string $data_url
     * @return bool
     */
    public function tempmsg_notice($userid, $tid = '', $tempdata = array(), $data_url = '')
    {
        if (defined('NO_WXTEMPMSG')) {
            return true;
        }
        $openid = db_getone(table('users'), array('id'=>$userid), '', 'wx_openid');
        $tmpl = db_getone(table('wxtmplmsg'), array('tid'=>$tid));
        if ($tmpl) {
            $tmpl['data'] = $tempdata;
            $tmpl['data_url'] = $data_url?$data_url:'';
            //微信模板通知
            if ($tmpl['tempid']) {
                $this->tempmsg($openid, $tmpl['tempid'], $tmpl['data'], $tmpl['data_url']);
            }
            $title = is_array($tmpl['data']['first'])?$tmpl['data']['first']['value']:$tmpl['data']['first'];
            //保存到聊天记录
            db_insert(table('message'), array(
                'userid'=>$userid,
                'openid'=>$openid,
                'type'=>"weixin_template",
                'tobe'=>1,
                'title'=>$title,
                'content'=>array2string($tmpl),
                'appcall'=>0,
                'indate'=>SYS_TIME
            ));
            return true;
        }
        return false;
    }

    /**
     * 获取当前身份的openid
     * @return string
     */
    public function openid()
    {
        global $_A,$_GPC;
        $_A['wx_base_openid'] = $this->session->userdata('wx_base_openid');
        if (empty($_A['wx_base_openid']) || strlen($_A['wx_base_openid']) < 10) {
            $weixin = $this->setting['weixin'];
            $appid = $weixin['appid'];
            $secret = $weixin['secret'];
            //
            if ($_GPC['wx_get_openid'] == 'true' && $_GPC['code']) {
                $this->load->helper('communication');
                $wxurl = 'https://api.weixin.qq.com/sns/oauth2/access_token?appid='.$appid;
                $wxurl.= '&secret='.$secret.'&code='.$_GPC['code'].'&grant_type=authorization_code';
                $resp = ihttp_request($wxurl);
                $openid = '';
                if (!is_error($resp)) {
                    $arr = @json_decode($resp['content'], true);
                    $openid = $arr['openid'];
                }
                $this->session->set_userdata('wx_base_openid', $openid);
                if ($openid) { gourl(get_link('wx_get_openid|code')); }
            }else{
                $callback = urlencode(get_link('wx_get_openid').'&wx_get_openid=true');
                $wxurl = 'https://open.weixin.qq.com/connect/oauth2/authorize?appid='.$appid;
                $wxurl.= '&redirect_uri='.$callback.'&response_type=code&scope=snsapi_base&state=STATE#wechat_redirect';
                gourl($wxurl);
            }
        }
        return $_A['wx_base_openid'];
    }

    /**
     * 获取用户基本信息
     * @param int|string $userstr       会员ID 或者 OPENID
     * @param bool $isup                是否强制更新数据
     * @return array|mixed
     */
    public function userwx($userstr, $isup = false)
    {
        global $_A;
        if (is_numeric($userstr)) {
            $user = ($_A['user']['id']==$userstr)?$_A['user']:db_getone(table('users'), array('id'=>$userstr));
            $userstr = $user['wx_openid'];
        }
        if (empty($userstr) || strlen($userstr) < 10) {
            return array();
        }
        $row = db_getone(table('users_wx'), array('openid'=>$userstr));
        if (empty($row)) {
            $isup = true;
        }
        if ($isup) {
            $url = 'https://api.weixin.qq.com/cgi-bin/user/info?access_token='.$this->token().'&openid='.$userstr.'&lang=zh_CN';
            $response = ihttp_get($url);
            if (is_error($response)) {
                return array();
            }
            $result = @json_decode($response['content'], true);
            if (empty($result)) {
                return array();
            }
            $iarr = array();
            $iarr['openid'] = $result['openid'];
            $iarr['subscribe'] = $result['subscribe'];
            if ($result['subscribe']) {
                $iarr['nickname'] = $result['nickname'];
                $iarr['headimgurl'] = $result['headimgurl'];
                $iarr['info'] = array2string($result);
            }
            $iarr['update'] = SYS_TIME;
            if (empty($row)) {
                $id = db_insert(table('users_wx'), $iarr, true);
            }else{
                db_update(table('users_wx'), $iarr, array('id'=>$row['id']));
                $id = $row['id'];
            }
            $row = $iarr;
            $row['id'] = $id;
        }
        if ($row) {
            $row['info'] = string2array($row['info']);
        }
        return $row;
    }

    /**
     * 生成访问可获取身份的连接
     * @param $url
     * @param bool $clearid
     * @return string
     */
    public function url($url, $clearid = false)
    {
        if (!strexists($url, 'users/wxauto')) {
            $url = url('users/wxauto').'?ctx='.urlencode($url);
        }
        if ($clearid) {
            $url.= strexists($url, '?')?'&':'?';
            $url.= 'clearid=1';
        }
        return $url;
    }

    /** *********************************************************************************************/
    /** *********************************************************************************************/
    /** *********************************************************************************************/
    /** *********************************************************************************************/

    /**
     * 保存事件记录
     * @param array $M
     * @param int $tobe     0收到信息（客户发给系统）、1发送信息（系统发给客户）
     * @return bool|mixed
     */
    private function savemessage($M = array(), $tobe = 0)
    {
        global $_A;
        $M['type'] = $M['msgtype'];
        $_A['M'] = $M;
        if (empty($M['openid']) || empty($M['tousername'])) return false;
        $iarr = array(
            'userid'=>0,    //微信粉丝不一定是会员所以会员ID填0
            'openid'=>$M['openid'],
            'type'=>'weixin_'.$M['type'],
            'tobe'=>$tobe,
            'eventkey'=>is_array($M['text'])&&isset($M['text']['eventkey'])?$M['text']['eventkey']:'',
            'content'=>is_array($M['text'])?array2string($M['text']):$M['text'],
            'setting'=>array2string(array('rawdata'=>$M['rawdata'])),
            'indate'=>($M['createtime'] && $M['createtime']>0)?$M['createtime']:SYS_TIME
        );
        //
        if (empty($tobe)) {
            $this->load->model('userevent');
            $this->userevent->wxmessage($M['openid'], $M);
        }
        return db_insert(table('message_wx'), $iarr ,true);
    }


    /**
     * 处理错误
     * @param $content
     * @param bool $replace
     * @return string
     */
    private function error_code(&$content, $replace = false)
    {
        $code = $content;
        if (is_array($code) && isset($code['errcode'])) {
            $code = $code['errcode'];
        }
        $errors = @include "weixin/errmsg_corp.php";
        $code = strval($code);
        if($code == '40001' || $code == '40014' || $code == '42001') {
            $file = $this->cache_path.$this->setting['weixin']['appid'].".access_token.php";
            if (file_exists($file)) {
                @unlink($file);
            }
            $returntxt = $errors[$code]?$errors[$code]:'微信公众平台授权异常, 系统已修复这个错误';
            $returntxt.= '【请刷新页面后重试】';
        }else{
            if($errors[$code]) {
                $returntxt = $errors[$code];
            } else {
                $returntxt = '未知错误'.$code;
            }
        }
        if ($replace && is_array($content) && isset($content['errmsg'])) {
            $content['errmsg'] = $returntxt;
        }
        return $returntxt;
    }

    /**
     * 发送客服信息
     * @param $data
     * @return array|mixed|string
     */
    private function sendCustomNotice($data)
    {
        if(empty($data)) {
            return error(-1, '参数错误');
        }
        $token = $this->token();
        if(is_error($token)){
            return $token;
        }
        $url = "https://api.weixin.qq.com/cgi-bin/message/custom/send?access_token=".$token;
        $response = ihttp_request($url, urldecode(json_encode($data)));
        if(is_error($response)) {
            return error(-1, "访问公众平台接口失败, 错误: {$response['message']}");
        }
        $result = @json_decode($response['content'], true);
        if(empty($result)) {
            return error(-1, "接口调用失败, 元数据: {$response['meta']}");
        } elseif(!empty($result['errcode'])) {
            return error(-1, "访问微信接口错误：{$this->error_code($result['errcode'])}");
        }
        return $result;
    }

    /**
     * 发送多媒体信息
     * @param $content
     * @param $type
     * @param $tis
     * @param $openid
     * @return array|mixed|string
     */
    private function media($content, $type, $tis, $openid)
    {
        if ($tis) {
            $media_id = $this->media_upload($content, $type, $openid, $tis);
        }else{
            $media_id = $this->media_upload($content, $type);
        }
        if (empty($media_id)) {
            $newarr = array(
                'title'=>'点击查看'.str_replace(array('image','voice','video'), array('图片','语音','视频'), $type),
                'description'=>'',
                'url'=>url("api/showmedia/")."?type=".$type."&value=".urlencode($content)
            );
            if ($type == 'image') {
                $newarr['picurl'] = fillurl($content);
            }
            $send = array();
            $send['touser'] = $openid;
            $send['msgtype'] = 'news';
            $send['news']['articles'][] = $this->encode($newarr);
        }else{
            $send = array();
            $send['touser'] = $openid;
            $send['msgtype'] = $type;
            $send[$type] = array('media_id' => $media_id);
        }
        return $this->sendCustomNotice($send);
    }

    /**
     * 上传素材
     * @param string $url               素材原地址
     * @param string $type              素材类型 分别有图片（image）、语音（voice）、视频（video）和缩略图（thumb）
     * @param string $waittisopenid     上传素材等候提示对象openid
     * @param string $waittis           上传素材等候提示
     * @return mixed                    返回media_id素材ID
     */
    private function media_upload($url, $type, $waittisopenid = '', $waittis = '正在查询中，请等待......')
    {
        $cmd5 = md5($url);
        $cmd5t = "media_upload_".$cmd5;
        $tmp = db_getone(table('tmp'), array('title'=>$cmd5t, '`indate`>'=>(SYS_TIME - 259200)),"`indate` DESC");
        if (empty($tmp)) {
            $extension = pathinfo($url, PATHINFO_EXTENSION);
            if ($type == 'video' && $extension != "mp4") {
                $tmp = array();
            }else{
                $tmp = array();
                $urlpath = $url;
                if (!file_exists($urlpath)) {
                    $urlpath = BASE_PATH.$url;
                }
                if (file_exists($urlpath)) {
                    if ($waittisopenid && !defined('_ISEMULATOR')) {
                        $this->sendCustomNotice(array(
                            'touser'=>$waittisopenid,
                            'msgtype'=>'text',
                            'text'=>array('content'=>$this->encode($this->send2text($waittis)))
                        ));
                    }
                    $data = array('media' => '@'.$urlpath);
                    $sendapi = "https://api.weixin.qq.com/cgi-bin/media/upload?access_token=".$this->token()."&type=".$type;
                    $resp = ihttp_request($sendapi, $data);
                    $respcon = @json_decode($resp['content'], true);
                    if ($respcon['errcode'] == "41005") {
                        $resp = $this->https_request($sendapi, $data);
                        $respcon = @json_decode($resp, true);
                    }
                    $this->error_code($respcon);
                    $media_id = $respcon['media_id'];
                    if ($media_id) {
                        $tmp = array();
                        $tmp['title'] = $cmd5t;
                        $tmp['value'] = $media_id;
                        $tmp['indate'] = $respcon['created_at'];
                        $tmp['content'] = $type;
                        db_delete(table('tmp'), "`title` LIKE 'media_upload_%' AND `indate`<".(SYS_TIME - 259200)."");
                        db_insert(table('tmp'), $tmp, true);
                    }
                }
            }
        }
        return $tmp['value'];
    }

    /**
     * 处理图文内容
     * @param $data
     * @return array
     */
    private function newshandle($data)
    {
        $array = $data;
        foreach($array AS $key=>$val) {
            if (!is_array($val)) {
                unset($array[$key]);
            }
        }
        if (empty($array)) {
            $array = array(0=>$data);
        }else{
            $array = $data;
        }
        $image_text_msg = array();
        foreach($array AS $item) {
            if ($item['url'] && !leftexists($item['url'], "http")) {
                $item['url'] = "http://".$item['url'];
            }
            $image_text_msg[] = $this->encode(array(
                'title'=>$item['title'],
                'description'=>$item['desc'],
                'url'=>$item['url'],
                'picurl'=>$item['img']
            ));
        }
        return $image_text_msg;
    }

    /**
     * ID获取openid
     * @param $str
     * @return mixed
     */
    private function idORopenid($str)
    {
        if ($str > 0) {
            $str = db_getone(table('users'), array('id'=>$str), '', 'wx_openid');
        }
        return $str;
    }

    private function encode($string) {
        if(!is_array($string)) return str_replace(array("%3A", "%2F", "%3a", "%2f", "%40"), array(":", "/", ":", "/", "@"), urlencode(str_replace('"','\"',$string)));
        foreach($string as $key => $val) $string[$key] = $this->encode($val);
        return $string;
    }

    private function decode($string) {
        if(!is_array($string)) return urldecode($string);
        foreach($string as $key => $val) $string[$key] = $this->decode($val);
        return $string;
    }

    private function send2text($content) {
        if ($content) {
            $content = preg_replace("/\[url=(.+?)\](.+?)\[\/url\]/is","<a href=\"\\1\">\\2</a>",$content);
            $content = preg_replace("/\[\/(.+?)\]/is", "/$1", $content);
        }
        return$content;
    }

    private function https_request($url, $data)
    {
        $ch = curl_init($url);
        curl_setopt ($ch, CURLOPT_SAFE_UPLOAD, false);
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
        curl_setopt($ch, CURLOPT_POST, 1);
        curl_setopt($ch, CURLOPT_POSTFIELDS, $data);
        curl_setopt($ch, CURLOPT_TIMEOUT, 10);
        $res = curl_exec($ch);
        return $res;
    }
}
?>