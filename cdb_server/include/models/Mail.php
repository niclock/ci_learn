<?php
defined('BASEPATH') OR exit('No direct script access allowed');

class Mail extends CI_Model {

	public function __construct()
    {
        parent::__construct();
        $this->load->library('mailer');
	}

    /**
     * 通用邮件发送
     * @param $email
     * @param string $title     标题
     * @param string $content   内容
     * @return array
     */
    public function common($email, $title = '', $content = '') {
        $arr = array();
        $arr['success'] = 0;
        $arr['message'] = '';
        //
        $sendmail = $this->mailer->smtp_mail($email, $title, $content);
        if (empty($sendmail['success'])) {
            db_insert(table('log'), array('type'=>'mail', 'content'=>$sendmail['message'], 'indate_cn'=>date("Y-m-d H:i:s", SYS_TIME)));
            $arr['message'] = '服务器繁忙请稍后再试！';
            return $arr;
        }
        $arr['success'] = 1;
        $arr['message'] = '邮件发送成功！';
        return $arr;
    }

    /**
     * 发送
     * @param string $email         手机号码
     * @param string $text          附加内容（比如：①登录、找回密码等）
     * @param string $sessionname   session附加标识
     * @return array                array(success=>,message=>)、success=1 发送成功
     */
    public function send($email, $text = '', $sessionname = '') {
        $arr = array();
        $arr['success'] = 1;
        $arr['message'] = '';
        //
        if (!isMail($email)) {
            $arr['message'] = '邮箱地址错误！';
            return $arr;
        }
        //
        $check = $this->mailer->check();
        if (empty($check['success'])) {
            $arr['message'] = $check['message'];
            return $arr;
        }
        //
        $repeat_user = intval($this->session->userdata('Mail:Repeat_user')) + 60;
        if ($repeat_user > SYS_TIME) {
            $arr['message'] = '发送频繁，60秒内只能发送一次！';
            return $arr;
        }
        //

        $system = setting('system');
        $tname = ($system['name']?$system['name']:BASE_NAME);
        $tcode = generate_password(6);
        //
        $sendmail = $this->mailer->smtp_mail(
            $email,
            '【'.$tname.'】'.$text,
            '您的的验证码是：<span style="font-family:\'Microsoft Yahei\',Verdana,Simsun,sans-serif;font-size:14px;font-weight:bold;color:#2a2a2a;border-bottom-width:1px;border-bottom-style:dashed;border-bottom-color:rgb(204,204,204);z-index:1;position:static;" onclick="return false;" data="'.$tcode.'">'.$tcode.'</span>。有效期为30分钟，如非本人操作，请忽略本邮件（邮件为系统发出，请勿回复）'
        );
        if (empty($sendmail['success'])) {
            db_insert(table('log'), array('type'=>'mail', 'content'=>$sendmail['message'], 'indate_cn'=>date("Y-m-d H:i:s", SYS_TIME)));
            $arr['message'] = '服务器繁忙请稍后再试！';
            return $arr;
        }
        $this->session->set_userdata('Mail:Repeat_user', SYS_TIME);
        $this->session->set_userdata('Mail:code_'.$sessionname.$email, $tcode);
        $arr['message'] = '验证码发送成功！';
        return $arr;
    }

    /**
     * 验证
     * @param string $email         手机号码
     * @param string $code          所验证的验证码
     * @param string $sessionname   session附加标识
     * @return array                array(success=>,message=>,code=>)、success=1 验证成功
     */
    public function verify($email, $code = '', $sessionname = '') {
        $arr = array();
        $arr['success'] = 0;
        $arr['message'] = '';
        $arr['code'] = $code;
        //
        if (!isMail($email)) {
            $arr['message'] = '邮箱地址错误！';
            return $arr;
        }
        //
        $check = $this->mailer->check();
        if (empty($check['success'])) {
            $arr['message'] = $check['message'];
            return $arr;
        }
        //
        if (empty($code)) {
            $arr['message'] = '验证码错误！-0';
            return $arr;
        }
        //
        $tcode = $this->session->userdata('Mail:code_'.$sessionname.$email);
        if ($tcode != $code) {
            $arr['message'] = '验证码错误！';
            return $arr;
        }
        $arr['success'] = 1;
        $arr['message'] = '验证成功！';
        return $arr;
    }
}
?>