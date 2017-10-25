<?php
//自定义配置
include('cache.config.php');
include('cache.offsite.php');
include('config_db.php');
include('safe.php');

//网站名称、关键词、描述
define('BASE_NAME', (defined('DIY_BASE_NAME')&&DIY_BASE_NAME)?DIY_BASE_NAME:'网站名称');
define('BASE_KEYWORDS', (defined('DIY_BASE_KEYWORDS')&&DIY_BASE_KEYWORDS)?DIY_BASE_KEYWORDS:'');
define('BASE_DESCRIPTION', (defined('DIY_BASE_DESCRIPTION')&&DIY_BASE_DESCRIPTION)?DIY_BASE_DESCRIPTION:'');

//网址
define('BASE_URL', (isset($_SERVER['SERVER_PORT'])&&$_SERVER['SERVER_PORT']=='443'?'https://':'http://').$_SERVER['HTTP_HOST']);

//根目录
define('BASE_DIR', (isset($__proself)&&$__proself)?$__proself:'/');

//网址(含目录)
define('BASE_URI', BASE_URL.BASE_DIR);

//静态网址
//define('STATIC_URL', 'static.jialajiao.com');
//define('STATIC_URI', (isset($_SERVER['SERVER_PORT'])&&$_SERVER['SERVER_PORT']=='443'?'https://':'http://').STATIC_URL.BASE_DIR);

//首页文件
define('BASE_IPAGE', (defined('DIY_BASE_IPAGE'))?DIY_BASE_IPAGE:'index.php');

//底部信息
define('BOTTOM_INFO', (defined('DIY_BOTTOM_INFO')&&DIY_BOTTOM_INFO)?DIY_BOTTOM_INFO:'广西更电科技有限公司 版权所有 备案号：<a href="http://www.miitbeian.gov.cn/" target="_blank">桂ICP备16005295号-1</a><br/>地址：广西南宁市佛子岭路18号德利 AICC(B2栋) 联系电话：0771-5536563 传真：0771-5536561');

//定义框架路径
define('BASE_PATH', dirname(dirname(__FILE__)).DIRECTORY_SEPARATOR);

//模板文件夹
define('BASE_TEMP', 'default');

//静态文件
define('JS_PATH', BASE_URI.'caches/statics/js/'); //JS
define('CSS_PATH', BASE_URI.'caches/statics/css/'); //CSS
define('IMG_PATH', BASE_URI.'caches/statics/images/'); //img

//网页编码
define('BASE_CHARSET', 'UTF-8');

//CI框架目录
define('CI_APPLICATION', 'include');

//加密密钥
define('BASE_ENCRYPTION', 'cdb_wei');

//数据库
define('BASE_DB_HOST', $__dbhost);
define('BASE_DB_NAME', $__dbname);
define('BASE_DB_USER', $__dbuser);
define('BASE_DB_PASS', $__dbpass);
define('BASE_DB_FORE', $__dbpre);

//当前版本（CSS、JS 版本）
define('ES_RELEASE', 100000001);




//押金（元）
define('DEPOSIT', 88.00);

//商家收益 - 借出（固定金额:=元）
define('INCOME_BORROW', 0);

//商家收益 - 归还（浮动金额:*租金）
define('INCOME_GIVEBACK', 0);