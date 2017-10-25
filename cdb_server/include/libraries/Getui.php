<?php

/**
 * 个推接口
 * Class Getui
 */
class Getui
{
    var $HOST =             'http://sdk.open.api.igexin.com/apiex.htm';
    var $APPKEY =           'xbzmFXzu6zA11QqBSH5Eu9';
    var $APPID =            '6aiftFuEx0A42Ucr6DQbl';
    var $MASTERSECRET =     'WXbwO58XK46CymH5iDy7h8';

    public function __construct()
    {
        require_once(dirname(__FILE__) . '/' . 'getui/IGt.Push.php');
    }

    /**
     * 保存至信箱并发送提醒
     * @param $array
     */
    public function message($array)
    {
        db_insert(table('message'), $array);
        $this->information($array['userid'], 'message', $array['title'], $array['subtitle']);
    }

    /**
     * 发送信息
     * @param int $userid
     * @param string $content   [message | giveback]
     * @param string $title     IOS在后台运行时提醒标题
     * @param string $body      IOS在后台运行时提醒副标题
     * @param int $expiretime   有效时间，默认10分钟
     * @return bool
     */
    public function information($userid, $content, $title = '', $body = '', $expiretime = 10)
    {
        if ($userid && $content) {
            $push_cid = db_getone(table('users'), array('id'=>$userid), '', 'push_cid');
            if ($push_cid) {
                $igt = new IGeTui($this->HOST, $this->APPKEY, $this->MASTERSECRET);
                $message = new IGtSingleMessage();
                $message->set_isOffline(true);
                $message->set_offlineExpireTime(60000 * $expiretime);
                $message->set_data($this->IGtTransmissionTemplateDemo($userid, $content, $title, $body));
                $target = new IGtTarget();
                $target->set_appId($this->APPID);
                $target->set_clientId($push_cid);
                $response = $igt->pushMessageToSingle($message, $target);
                if ($response['result'] == 'ok') {
                    return true;
                }
            }
        }
        return false;
    }


    /**
     * 透传消息模板
     * @param $userid
     * @param $content
     * @param string $title
     * @param string $body
     * @return IGtTransmissionTemplate
     */
    private function IGtTransmissionTemplateDemo($userid, $content, $title = 'Title', $body ='body')
    {
        $template = new IGtTransmissionTemplate();
        $template->set_appId($this->APPID);                 //应用appid
        $template->set_appkey($this->APPKEY);               //应用appkey
        $template->set_transmissionType(1);                 //透传消息类型
        $template->set_transmissionContent($content);       //透传内容
        //APN高级推送
        $apn = new IGtAPNPayload();
        $alertmsg = new DictionaryAlertMsg();
        $alertmsg->body = $body;
        $alertmsg->actionLocKey = "ActionLockey";
        $alertmsg->locKey = "LocKey";
        $alertmsg->locArgs = array("locargs");
        $alertmsg->launchImage = "launchimage";
        //IOS8.2 支持
        $alertmsg->title = $title;
        $alertmsg->titleLocKey = "TitleLocKey";
        $alertmsg->titleLocArgs = array("TitleLocArg");
        //
        $apn->alertMsg = $alertmsg;
        $apn->badge = users_badge($userid);
        $apn->sound = "";
        $apn->add_customMsg("payload", "payload");
        $apn->contentAvailable = 1;
        $apn->category = "ACTIONABLE";
        $template->set_apnInfo($apn);
        //
        return $template;
    }
}