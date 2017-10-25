<?php

class Mailer
{

	public function check() {
		$arr = array();
		$arr['success'] = 0;
		$arr['message'] = '';
		//
		$system = setting('system');
		if ($system['mail_host'] && $system['mail_username'] && $system['mail_password']) {
			$system['mail_port'] = $system['mail_port']?$system['mail_port']:'25';
			$arr['success'] = 1;
			return $arr;
		}else{
			$arr['message'] = '邮件系统正在升级中，暂时无法使用。';
			return $arr;
		}
	}

	public function smtp_mail($sendto_email, $subject, $body, $From='', $FromName='')
	{
		$arr = array();
		$arr['success'] = 0;
		$arr['message'] = '';
		//
		require_once(dirname(__FILE__).'/phpmailer/class.phpmailer.php');
		$mail = new PHPMailer();
		$system = setting('system');
		$From = $From?$From:$system['mail_username'];
		$FromName = $FromName?$FromName:($system['name']?$system['name']:BASE_NAME);
		//
		$mail->IsSMTP();
		$mail->Host = 		$system['mail_host'];
		$mail->SMTPDebug= 	0;
		$mail->SMTPAuth = 	true;
		$mail->Username = 	$system['mail_username'];
		$mail->Password = 	$system['mail_password'];
		$mail->Port = 		$system['mail_port']?$system['mail_port']:'25';
		$mail->From = 		$system['mail_username'];
		$mail->FromName =	$FromName;

		$mail->CharSet = 	BASE_CHARSET;
		$mail->Encoding = 	"base64";
		$mail->AddReplyTo($From, $FromName);
		$mail->AddAddress($sendto_email, "");
		$mail->IsHTML(true);
		$mail->Subject = 	$subject;
		$mail->Body =		$body;
		$mail->AltBody =	"text/html";
		if ($mail->Send()) {
			$arr['success'] = 1;
			return $arr;
		}else{
			$arr['message'] = $mail->ErrorInfo;
			return $arr;
		}
	}
}
?>