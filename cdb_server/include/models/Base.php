<?php
$_A = $_GPC = array();
class Base extends CI_Model {
    public $url = array();

	public function __construct()
    {
		global $_A,$_GPC;
        parent::__construct();
        date_default_timezone_set("PRC");

        define('SYS_TIME', time());                 //时间戳
        define('ONLINE_IP', $this->get_ip());       //客户IP

		$this->load->library('session');
        $this->load->library('cs');

		$this->load->model('ddb');
        $this->load->helper('global');
        $this->load->helper('cookie');

        //基本参数赋值
		$this->__urlinit();
		$_A['url'] = $this->url;
        //
        $this->url['get'] = $this->input->get();
        $this->url['post'] = $this->input->post();
        $this->url['cookie'] = $this->input->cookie();
		$_GPC = array_merge($this->url['get'], $this->url['post'], $this->url['cookie']);

		$_A['SYS_TIME'] = SYS_TIME;
		$_A['ONLINE_IP'] = ONLINE_IP;

        $this->cs->data('segments', $this->uri->segments);
        $this->cs->assign('urlarr',$this->url);
        $this->cs->assign('TIME', SYS_TIME);
        $this->cs->assign('BASE_NAME', defined('JS_PATH')?BASE_NAME:'网站名称');
        $this->cs->assign('JS_PATH', defined('JS_PATH')?JS_PATH:'/');
        $this->cs->assign('TEM_PATH', BASE_URI.'templates/'.BASE_TEMP.'/');
        $this->cs->assign('CSS_PATH', defined('CSS_PATH')?CSS_PATH:'/');
        $this->cs->assign('IMG_PATH', defined('IMG_PATH')?IMG_PATH:'/');

		$_A['segments'] = $this->uri->segments;
		$_A['module'] = $this->uri->segment(2);

        $system = setting('system');
		$_A['BASE_NAME'] = $system['title']?$system['title']:BASE_NAME;
		$_A['BASE_URI'] = BASE_URI;
		$_A['BASE_PATH'] = BASE_PATH;
		$_A['JS_PATH'] = JS_PATH;
		$_A['CSS_PATH'] = CSS_PATH;
		$_A['IMG_PATH'] = IMG_PATH;

        $this->domain();

        $user_agent = $_SERVER['HTTP_USER_AGENT'];
        if (strpos($user_agent, 'AlipayClient') !== false) {
            $_A['browser'] = 'alipay';
        }elseif (strpos($user_agent, 'MicroMessenger') !== false) {
            $_A['browser'] = 'weixin';
        }elseif ($_GPC['__browser_from'] == 'app') {
            $_A['browser'] = 'app';
        }else{
            $_A['browser'] = 'none';
            $this->load->library('mobile');
            if (!$this->mobile->isMobile()) {
                $_A['browser'] = 'pc';
            }
        }

        if ($_GPC['__Access-Control-Allow-Origin']) {
            header('Access-Control-Allow-Origin:*');
            header('Access-Control-Allow-Methods:GET,POST,PUT,DELETE,OPTIONS');
            header('Access-Control-Allow-Headers:Content-Type, browserFrom, browserSn, token, Access-Control-Allow-Origin');
        }
        //file_put_contents('url.txt', get_url() . "\r\n", FILE_APPEND);
	}

	private function __urlinit()
	{
		$segs = $this->uri->segment_array();
		$text = '';
		$this->url[0] = rtrim($this->config->site_url(), '/').'/';
		foreach ($segs as $key=>$segment) {
			$text.= $segment.'/';
			$this->url[$key] = rtrim($this->config->site_url($text), '/').'/';
		}
		$this->url['now'] = $this->url[count($segs)];
		$this->url['index'] = $this->url[0];
	}

    /**
     * 静态域名判断
     */
    public function domain()
    {
        global $_A;
        //
        if (!is_static()) {
            //不符合静态环境
            return ;
        }
        if ($_SERVER['SERVER_NAME'] != STATIC_URL) {
            //域名不是静态的
            return ;
        }
        //
        $buildup = $_A['segments'][1].'/'.$_A['segments'][2];
        if (!in_array($buildup, array('uploadfiles/imgextra', 'users/iptoareaid')))
        {
            show_error("The controller/method pair you requested was not found.", 404, "Not Found");
        }
    }

    /**
     * 加载类文件函数
     * @param $path
     * @return bool
     */
    public static function inc($path)
    {
        static $incclasses = array();
        $key = md5($path);
        if (isset($incclasses[$key])) {
            return true;
        }
        if (file_exists($path)) {
            include $path;
            $incclasses[$key] = true;
            return true;
        }
        return false;
    }

    /**
     * 加载类文件函数
     * @param $path
     * @return bool
     */
    public static function apprun($path)
    {
        static $incclasses = array();
        $_path = FCPATH.'addons/'.$path.'/apprun.php';
        $key = md5($_path);
        if (isset($incclasses[$key])) {
            return true;
        }
        if (file_exists($_path)) {
            include $_path;
            $incclasses[$key] = true;
            return true;
        }
        return false;
    }

    private function get_ip(){
        if (getenv('HTTP_CLIENT_IP') and strcasecmp(getenv('HTTP_CLIENT_IP'),'unknown')) {
            $onlineip = getenv('HTTP_CLIENT_IP');
        }elseif (getenv('HTTP_X_FORWARDED_FOR') and strcasecmp(getenv('HTTP_X_FORWARDED_FOR'),'unknown')) {
            $onlineip = getenv('HTTP_X_FORWARDED_FOR');
        }elseif (getenv('REMOTE_ADDR') and strcasecmp(getenv('REMOTE_ADDR'),'unknown')) {
            $onlineip = getenv('REMOTE_ADDR');
        }elseif (isset($_SERVER['REMOTE_ADDR']) and $_SERVER['REMOTE_ADDR'] and strcasecmp($_SERVER['REMOTE_ADDR'],'unknown')) {
            $onlineip = $_SERVER['REMOTE_ADDR'];
        }else{
            $onlineip = '0,0,0,0';
        }
        preg_match("/\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}/", $onlineip, $match);
        return $onlineip = $match[0] ? $match[0] : 'unknown';
    }
}
?>