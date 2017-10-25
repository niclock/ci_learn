<?php
defined('BASEPATH') OR exit('No direct script access allowed');
//
define('AL_TPL_ID',  "23810671");
define('AL_TPL_KEY', "5740bd81978e93362f3442b565803623");
define('AL_TPL_NAN', "G电科技");
define('AL_TPL_SMS_USERS', "SMS_64780076");     //验证码通知
//
class Sms extends CI_Model {

	public function __construct()
    {
        parent::__construct();
        $this->load->helper("communication");
	}

    /**
     * 检查网站是否支持短信
     * @return array
     */
    public function check() {
        $arr = array();
        $arr['success'] = 1;
        $arr['message'] = '';
        return $arr;
    }

    /**
     * 发送
     * @param string $phone         手机号码
     * @param int $text             附加内容（比如：①登录、找回密码等；②留空或者填0自动附加编号）
     * @param string $sessionname   session附加标识
     * @param string $type          1.message 验证码为短信 2.speech为语音
     * @return array                array(success=>,message=>,code=>,num=>)、success=1 发送成功
     */
    public function send($phone, $text = 0, $sessionname = '',$type) {
        $arr = array();
        $arr['success'] = 1;
        $arr['message'] = '';
        $arr['code'] = 0;
        $arr['text'] = $text;
        $arr['last4'] = substr(runMobile($phone), -4);
        //
        $check = $this->check();
        if (empty($check['success'])) {
            $arr['message'] = $check['message'];
            return $arr;
        }
        //
        if (!isMobile($phone)) {
            $arr['message'] = '手机号码错误！';
            return $arr;
        }
        //
        $repeat_user = intval($this->session->userdata('Sms:Repeat_user')) + 120;
        if ($repeat_user > SYS_TIME) {
            $arr['message'] = '发送频繁，120秒内只能发送一次！';
            return $arr;
        }
        //
        if ($text === 0) {
            $smsnum = rand(100,999);
            $this->session->set_userdata('Sms:Num_'.$sessionname.$phone, $smsnum);
            $text = '编号:'.$smsnum;
            $arr['text'] = $text;
            $arr['text_num'] = $smsnum;
        }

        $content = $this->_send($phone, $text,$type);
        if ($content['ok'] == '1') {
            $this->session->set_userdata('Sms:Repeat_user', SYS_TIME);
            $arr['success'] = 1;
            if ($text) {
                $arr['message'] = '验证码发送成功（'.$text.'）！';
            }else{
                $arr['message'] = '验证码发送成功！';
            }
            $arr['code'] = $content['code'];
        }else{
            $arr['message'] = $content['errinfo'];
        }
        return $arr;
    }

    /**
     * 验证
     * @param string $phone         手机号码
     * @param string $code          所验证的验证码
     * @param int $text             附加内容（比如：①登录、找回密码等；②留空或者填0自动附加编号）
     * @param string $sessionname   session附加标识
     * @return array                array(success=>,message=>,code=>,num=>)、success=1 验证成功
     */
    public function verify($phone, $code = '', $text = 0, $sessionname = '') {
        $arr = array();
        $arr['success'] = 0;
        $arr['message'] = '';
        $arr['code'] = $code;
        $arr['text'] = $text;
        //
        $check = $this->check();
        if (empty($check['success'])) {
            $arr['message'] = $check['message'];
            return $arr;
        }
        //
        if (!isMobile($phone)) {
            $arr['message'] = '手机号码错误！';
            return $arr;
        }
        //
        if (empty($code)) {
            $arr['message'] = '验证码错误！';
            return $arr;
        }
        //
        if ($text === 0) {
            $smsnum = $this->session->userdata('Sms:Num_'.$sessionname.$phone);
            $text = '编号:'.$smsnum;
            $arr['text'] = $text;
            $arr['text_num'] = $smsnum;
        }
        //
        $old = db_getone(table('sms'), array('ok'=>1, 'code'=>trim($code), 'phone'=>$phone, '`indate`>'=>SYS_TIME-1800));
        if ($old) {
            $arr['success'] = 1;
            $arr['message'] = '验证成功！';
        }else{
            $arr['message'] = '验证码不正确';
        }
        return $arr;
    }


    /**
     * @param $phone
     * @param $text
     * @param $type
     * @return array
     */
    public function _send($phone, $text,$type) {
        $arr = array();
        $arr['ok'] = 0;         //成功OK
        $arr['code'] = 0;       //验证码
        $arr['phone'] = 0;      //手机号码
        $arr['errno'] = 0;      //失败原因代码
        $arr['errinfo'] = '';   //失败原因
        $arr['fee'] = 0;        //扣除条数
        //
        $arr['phone'] = $phone; //手机号码
        //
        $check = $this->check();
        if (empty($check['success'])) {
            $arr['errno'] = 6;
            $arr['errinfo'] = $check['message'];
            return $arr;
        }
        if($type=='message'){
            $arr['code'] = generate_password(4,1);     //验证码
            $code = $arr['code'];
            if ($text) { $code.= "（".$text."）"; }

            $content = $this->_alipay(array('code'=>$code, 'product'=>'账号'), AL_TPL_NAN, AL_TPL_SMS_USERS, $arr);
            //
            $iarr = array();
            $iarr['ok'] = $arr['ok'];
            $iarr['phone'] = $arr['phone'];
            $iarr['code'] = $arr['code'];
            $iarr['setting'] = array2string($content);
            $iarr['indate'] = time();
            $iarr['inip'] = get_ip();
            $iarr['smstype'] = $content['smstype'];
            if ($text) {
                $iarr['text'] = $text;
            }
            db_insert(table('sms'), $iarr);

        }elseif ($type=='speech'){

            $content = $this->_speech($type,'get',30,'',$arr);
        }

        return $arr;
    }

    /**
     * 短信模板通知
     * @param string $phone     手机号码
     * @param array $data       模板数据
     * @param int $tid          模板ID（一般以SMS_开头）
     * @return array
     */
    public function tempmsg($phone, $data, $tid) {
        $rrr = array();
        $rrr['success'] = 0;
        $rrr['message'] = '';
        //
        $arr = array();
        $arr['ok'] = 0;         //成功OK
        $arr['phone'] = 0;      //手机号码
        $arr['errno'] = 0;      //失败原因代码
        $arr['errinfo'] = '';   //失败原因
        $arr['fee'] = 0;        //扣除条数
        //
        $arr['phone'] = $phone; //手机号码
        if (!isMobile($phone)) {
            $rrr['message'] = '手机号码错误！';
            return $rrr;
        }
        //
        $check = $this->check();
        if (empty($check['success'])) {
            $rrr['message'] = $check['message'];
            return $rrr;
        }
        //
        $content = $this->_alipay($data, AL_TPL_NAN, $tid, $arr);
        //
        $template_box = db_getone(table('smstmplmsg'), array('tid'=>$tid), '', 'template');
        if (empty($template_box)) {
            $rrr['message'] = '短信模板参数错误！';
            return $rrr;
        }
        $template_box = str_replace(array("\r\n", "\r", "\n"), '<br/>', trim($template_box));
        preg_match_all('/\$\{(.*?)\}/', $template_box, $matchs);
        foreach ($matchs[0] AS $kk=>$mat) {
            $template_box = str_replace($mat, $data[$matchs[1][$kk]], $template_box);
        }
        //
        $iarr = array();
        $iarr['ok'] = $arr['ok'];
        $iarr['phone'] = $arr['phone'];
        $iarr['setting'] = array2string($content);
        $iarr['indate'] = time();
        $iarr['inip'] = get_ip();
        $iarr['smstype'] = $content['smstype'];
        $iarr['text'] = $template_box;
        db_insert(table('sms'), $iarr);
        //
        if ($arr['ok'] == 1) {
            $rrr['success'] = 1;
            $rrr['message'] = '短信发送成功';
        }else{
            $rrr['message'] = $arr['errinfo'];
        }
        return $rrr;
    }

    private function _alipay($parr = array(), $signname, $templatecode, &$arr) {
        include_once "sms/aliyun/TopSdk.php";
        $aliyun_c = new TopClient;
        $aliyun_c->appkey = AL_TPL_ID;
        $aliyun_c->secretKey = AL_TPL_KEY;
        $alireq = new AlibabaAliqinFcSmsNumSendRequest;
        $alireq->setExtend("123456");
        $alireq->setSmsType("normal");
        $alireq->setSmsFreeSignName($signname);
        $alireq->setSmsParam(json_encode($parr));
        $alireq->setRecNum(runMobile($arr['phone']));
        $alireq->setSmsTemplateCode($templatecode);
        $resp = $aliyun_c->execute($alireq);
        $content = object_array($resp);
        if (empty($content['code']) && $content['result']['err_code'] == 0) {
            $arr['ok'] = 1;
            $arr['fee'] = 1;
        }
        $arr['errno'] = $content['code'];
        $arr['errinfo'] = "失败: ".$content['sub_msg'];
        $content['smstype'] = 'aliyun';
        return $content;
    }


    /**
     * 获取语音验证码
     * @param $type
     * @param string $httpType
     * @param int $second
     * @param string $data
     * @return array
     * @throws WxPayException
     */
     private function _speech($type=null,$httpType='get',$second=30,$data = '', &$arr){

        $url="https://api.gengdian.net/v2/users/sms";
        if(isset($arr['phone'])){

            $url=$url."?userphone=".runMobile($arr['phone']);
        }
        if(isset($type)){
            $url=$url."&type=".$type;
        }
        $ch = curl_init();

        //设置超时
        curl_setopt($ch, CURLOPT_TIMEOUT, $second);

        curl_setopt($ch,CURLOPT_URL,$url);
        curl_setopt($ch,CURLOPT_RETURNTRANSFER,1);
        curl_setopt($ch,CURLOPT_SSL_VERIFYPEER,0);
        curl_setopt($ch,CURLOPT_SSL_VERIFYHOST,0);
        curl_setopt($ch,CURLOPT_HEADER,0);
        $type = strtolower($httpType);
        switch ($httpType){
            case 'get':
                break;
            case 'post':
                //post请求配置
                curl_setopt($ch, CURLOPT_POST,1);
                curl_setopt($ch, CURLOPT_POSTFIELDS, $data);
                break;
        }

        $result = json_decode(curl_exec($ch),true);

        if($result){
            // 关闭cURL资源，并且释放系统资源
            curl_close($ch);
            $arr['ok'] = 1;
            $arr['fee'] = 1;

            return $result;
        } else {
            $error = curl_errno($ch);
            curl_close($ch);

           // $arr['errno'] =
            $arr['errinfo'] = "失败: ".$error;
            throw new WxPayException("curl出错，错误码:$error");
        }


    }


}
?>