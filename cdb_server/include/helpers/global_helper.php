<?php
if ( ! defined('BASEPATH')) exit('No direct script access allowed');

/**
 * 获取表
 */
function table($table){
    return defined('BASE_DB_FORE')?BASE_DB_FORE.$table:$table;
}

/**
 * 获取值
 */
function value($obj, $key = '', $null_is_arr = false, $default = ''){
    if (is_int($key)) {
        if (isset($obj[$key])){
            $obj = $obj[$key];
        }else{
            $obj = "";
        }
    }elseif (!empty($key)){
        $arr = explode(".", str_replace("|", ".", $key));
        foreach ($arr as $val){
            if (isset($obj[$val])){
                $obj = $obj[$val];
            }else{
                $obj = "";break;
            }
        }
    }
    if ($default && empty($obj)) $obj = $default;
    if ($null_is_arr) {
        if ($null_is_arr === 'int') {
            $obj = intval($obj);
        }elseif (empty($obj)) {
            $obj = array();
        }
    }
    return $obj;
}

/**
 * $a=$b 则返回$c
 */
function isto($a, $b, $c){
    if ($a == $b){
        return $c;
    }else{
        return "";
    }
}

/**
 * 跳转
 */
function gourl($url = null){
    if (empty($url)){
        $url = get_url();
    }
    header("Location: ".$url);
    exit();
}

/**
 * $n=$v 则返回selected="selected"
 */
function sel($n, $v, $d = false){
    if ($d && empty($v)) return 'selected="selected"';
    return ($n == $v)?' selected="selected"':'';
}

/**
 * 给文字加颜色标签font
 */
function col($n, $c=''){
    if (!empty($c)){
        return "<font color='".$c."'>".$n."</font>";
    }else{
        return $n;
    }
}

/**
 * 给文字加颜色标签style
 */
function cot($color){
    if ($color){
        return " style='color:".$color.";'";
    }
}

/**
 * $n=$v 则返回checked="true"
 */
function che($n, $v, $d = false){
    if ($d && empty($v)) return 'checked="true"';
    $val = " value=\"".$v."\"";
    if (is_array($n)){
        $val.= (in_array($v, $n))?' checked="true"':'';
    }else{
        $val.= ($n == $v)?' checked="true"':'';
    }
    return $val;
}

/**
 * $n 包含,$v, 则返回checked="true"
 */
function ches($n, $v, $d = false){
    if ($d && empty($v)) return 'checked="true"';
    $val = " value=\"".$v."\"";
    $val.= (strpos($n, ",".$v.",") !== false)?' checked="true"':'';
    return $val;
}

/**
 * $n[$v] 存在则返回checked="true"
 */
function chi($n, $v){
    $val = '';
    if (!empty($v)){
        if (isset($n[$v])){
            $val = ' checked="true"';
        }
    }
    return $val;
}

/**
 * $n[$v] 存在则返回checked="true"
 */
function chrr($n, $v){
    $val = " value=\"".$v."\"";
    if (in_array($v, $n)){
        $val.= ' checked="true"';
    }
    return $val;
}

/**
 * 默认显示
 * @param $str
 * @param $val
 * @return mixed
 */
function nullshow($str, $val){
    return $str?$str:$val;
}

/**
 * 补零
 * @param $str
 * @param int $length
 * @param int $after
 * @return string
 */
function zerofill($str, $length = 0, $after = 1) {
    if (strlen($str) >= $length) {
        return $str;
    }
    $_str = '';
    for ( $i = 0; $i < $length; $i++ ){
        $_str .= '0';
    }
    if ($after) {
        $_ret = substr($_str.$str, $length*-1);
    }else{
        $_ret = substr($str.$_str, 0, $length);
    }
    return $_ret;
}
/**
 * 新建目录
 */
function make_dir($path){
    if(!file_exists($path)){
        make_dir(dirname($path));
        @mkdir($path,0777);
        @chmod($path,0777);
    }
}

/**
 *
 * 写入缓存文本
 * @param string $file_path 保存路径
 * @param array $config_arr 保存的数组
 */
function writecache($file_path, $config_arr){
    if (!isset($config_arr['auto_time'])) $config_arr['auto_time'] = SYS_TIME;
    if (!isset($config_arr['auto_time_text'])) $config_arr['auto_time_text'] = date('Y-m-d', SYS_TIME);
    $content = "<?php\r\n";
    $content .= "\$data = " . var_export($config_arr, true) . ";\r\n";
    $content .= "?>";
    $cache_file_path = FCPATH."caches".DIRECTORY_SEPARATOR."cache.".$file_path.".php";
    make_dir(dirname($cache_file_path));
    if (!file_put_contents($cache_file_path, $content, LOCK_EX))
    {
        $fp = @fopen($cache_file_path, 'wb+');
        if (!$fp)
        {
            exit('生成缓存文件失败');
        }
        if (!@fwrite($fp, trim($content)))
        {
            exit('生成缓存文件失败');
        }
        @fclose($fp);
    }
}

/**
 * 读取缓存文本
 * @param string $file_path    保存路径
 * @return array
 */
function getcache($file_path){
    $cache_file_path = FCPATH."caches".DIRECTORY_SEPARATOR."cache.".$file_path.".php";
    if(file_exists($cache_file_path)) {
        @include($cache_file_path);
        return isset($data)?$data:array();
    }else{
        return array();
    }
}

/**
 * 去除html
 * @param $text
 * @param int $length
 * @return mixed|string
 */
function get_html($text, $length = 255){
    $text = cut_str(strip_tags($text), $length, 0, "...");
    return $text;
}
/**
 *
 * 截取字符串
 * @param string $string 	字符串
 * @param int $length 	    截取长度
 * @param int $start 	    何处开始
 * @param string $dot 		超出尾部添加
 * @param string $charset 	默认编码
 * @return mixed|string
 */
function cut_str($string, $length, $start=0, $dot='', $charset = BASE_CHARSET)
{
    if (strtolower($charset) == 'utf-8'){
        if(get_strlen($string) <= $length) return $string;
        $strcut = str_replace(array('&amp;', '&quot;', '&lt;', '&gt;'), array('&', '"', '<', '>'), $string);
        $strcut = utf8_substr($strcut, $length, $start);
        $strcut = str_replace(array('&', '"', '<', '>'), array('&amp;', '&quot;', '&lt;', '&gt;'), $strcut);
        return $strcut.$dot;
    }else{
        $length=$length*2;
        if(strlen($string) <= $length) return $string;
        $string = str_replace(array('&amp;', '&quot;', '&lt;', '&gt;'), array('&', '"', '<', '>'), $string);
        $strcut = '';
        for($i = 0; $i < $length; $i++) {
            $strcut .= ord($string[$i]) > 127 ? $string[$i].$string[++$i] : $string[$i];
        }
        $strcut = str_replace(array('&', '"', '<', '>'), array('&amp;', '&quot;', '&lt;', '&gt;'), $strcut);
    }
    return $strcut.$dot;
}

/**
 * PHP获取字符串中英文混合长度
 * @param string $str 		字符串
 * @param string $charset	编码
 * @return float            返回长度，1中文=1位，2英文=1位
 */
function get_strlen($str,$charset = BASE_CHARSET){
    if(strtolower($charset)=='utf-8') $str = iconv('utf-8','GBK//IGNORE',$str);
    $num = strlen($str);
    $cnNum = 0;
    for($i=0;$i<$num;$i++){
        if(ord(substr($str,$i+1,1))>127){
            $cnNum++;
            $i++;
        }
    }
    $enNum = $num-($cnNum*2);
    $number = ($enNum/2)+$cnNum;
    return ceil($number);
}

/**
 * PHP截取UTF-8字符串，解决半字符问题。
 * @param string $str       源字符串
 * @param int $len          左边的子串的长度
 * @param int $start        何处开始
 * @return string           取出的字符串, 当$len小于等于0时, 会返回整个字符串
 */
function utf8_substr($str, $len, $start=0)
{
    $len=$len*2;
    for($i=0;$i<$len;$i++)
    {
        $temp_str=substr($str,0,1);
        if(ord($temp_str) > 127){
            $i++;
            if($i<$len){
                $new_str[]=substr($str,0,3);
                $str=substr($str,3);
            }
        }else{
            $new_str[]=substr($str,0,1);
            $str=substr($str,1);
        }
    }
    return join(array_slice($new_str,$start));
}

/**
 * 将字符串转换为数组
 * @param	string	$data	字符串
 * @return	array	返回数组格式，如果，data为空，则返回空数组
 */
function string2array($data) {
    if(is_array($data)) return $data;
    $data = trim($data);
    if($data == '') return array();
    if (strpos(strtolower($data), 'array') === 0) {
        @ini_set('display_errors', 'on');
        @eval("\$array = $data;");
        @ini_set('display_errors', 'off');
    }else{
        if (strpos($data, '{\\') === 0) {
            $data = stripslashes($data);
        }
        $array = json_decode($data, true);
    }
    return (isset($array)&&is_array($array))?$array:array();
}

/**
 * 将数组转换为字符串
 * @param	array	$data		数组
 * @param	int 	$isformdata	如果为0，则不使用new_stripslashes处理，可选参数，默认为1
 * @return	string	返回字符串，如果，data为空，则返回空
 */
function array2string($data, $isformdata = 1) {
    if ($data == '' || empty($data)) return '';
    if ($isformdata) $data = new_stripslashes($data);
    if (version_compare(PHP_VERSION,'5.3.0','<')){
        return addslashes(json_encode($data));
    }else{
        return addslashes(json_encode($data, JSON_FORCE_OBJECT));
    }
}

/**
 * 将数组转换为字符串 (已废弃)
 * @param	array	$data		数组
 * @param	int 	$isformdata	如果为0，则不使用new_stripslashes处理，可选参数，默认为1
 * @return	string	返回字符串，如果，data为空，则返回空
 */
function array2string_discard($data, $isformdata = 1) {
    if ($data == '' || empty($data)) return '';
    if ($isformdata) $data = new_stripslashes($data);
    return var_export($data, TRUE);
}

/**
 * @param $array
 * @return array
 */
function object_array($array){
    if(is_object($array)){
        $array = (array)$array;
    }
    if(is_array($array)){
        foreach($array as $key=>$value){
            $array[$key] = object_array($value);
        }
    }
    return $array;
}

/**
 * @param string $source  传的是文件，还是xml的string的判断
 * @param bool|false $simplexml
 * @return string
 */
function xml2json($source, $simplexml = false) {
    if ($simplexml) {
        if(is_file($source)){
            $xml_array = @simplexml_load_file($source);
        }else{
            $xml_array = @simplexml_load_string($source, NULL, LIBXML_NOCDATA);
        }
    }else{
        $xml_array = xml2array($source);
    }
    $json = json_encode($xml_array);
    return $json;
}

/**
 * @param $XML
 * @return array
 */
function xml2array($XML) {
    $CI = & get_instance();
    $CI->load->library('x2a');
    return $CI->x2a->xmltoarray($XML);
}

/**
 * 返回经stripslashes处理过的字符串或数组
 * @param array|string $string 需要处理的字符串或数组
 * @return mixed
 */
function new_stripslashes($string) {
    if(!is_array($string)) return stripslashes($string);
    foreach($string as $key => $val) $string[$key] = new_stripslashes($val);
    return $string;
}

/**
 * 返回经addslashes处理过的字符串或数组
 * @param array|string $string 需要处理的字符串或数组
 * @return mixed
 */
function new_addslashes($string){
    if(!is_array($string)) return addslashes($string);
    foreach($string as $key => $val) $string[$key] = new_addslashes($val);
    return $string;
}

/**
 * 返回经trim处理过的字符串或数组
 * @param $string
 * @return array|string
 */
function new_trim($string) {
    if(!is_array($string)) return trim($string);
    foreach($string as $key => $val) $string[$key] = new_trim($val);
    return $string;
}

/**
 * 合拼数组
 * @return array
 */
function _array_merge()
{
    $arg_list = func_get_args();
    $arr = array();
    $j = count($arg_list);
    if ($j > 0) {
        for ($i = 0; $i < $j; $i++) {
            if (is_array($arg_list[$i])) {
                $arr = array_merge($arr, $arg_list[$i]);
            }
        }
    }
    return $arr;
}

/**
 * @param null $p
 * @param array $a
 * @param string $page
 * @return string
 */
function systemurl($p = null, $a = array(), $page = '')
{
    global $_A;
    static $ES_URL = array();
    $m5 = is_array($a)?implode('',$a):$a;
    $m5 = md5($p.$m5.$page);
    if (isset($ES_URL[$m5])) {
        return $ES_URL[$m5];
    }
    if (isset($ES_URL['CI'])) {
        $CI = $ES_URL['CI'];
    }else{
        $CI = $ES_URL['CI'] = & get_instance();
    }
    if (is_numeric($p)) {
        $p = $CI->base->url[intval($p)];
    }elseif (in_array($p, array('now','index'))) {
        $p = $CI->base->url[$p];
    }else{
        $p = $page."/".$p;
        $p = $CI->config->site_url($p)."/";
    }
    $_a = '';
    if (is_array($a)) {
        $_a = '';
        foreach($a AS $k=>$v) {
            $_a.= $k."=".$v."&";
        }
        $_a = rtrim($_a,'&');
    }elseif ($a) {
        $_a = $a;
    }
    if (isset($_A['u']['userid'])) $_a.= "&ui=".$_A['u']['userid'];
    if (isset($_A['al']['id'])) $_a.= "&al=".$_A['al']['id'];
    if (isset($_A['uf']['id'])) $_a.= "&uf=".$_A['uf']['id'];
    if ($_a) {
        $_a = "?".ltrim(ltrim($_a,'&'),'?');
    }else{
        $_a = "?index=".generate_password(5);
    }
    return $ES_URL[$m5] = $p.$_a;
}

/**
 * 加密 openid
 * @param string $string      明文 或 密文
 * @param string $operation   DECODE表示解密,其它表示加密
 * @param string $key         密匙
 * @param int $expiry         密文有效期
 * @return string
 */
function authcode($string, $operation = 'DECODE', $key = '', $expiry = 0) {
    $ckey_length = 4;
    $key = md5($key != '' ? $key : BASE_ENCRYPTION);
    $keya = md5(substr($key, 0, 16));
    $keyb = md5(substr($key, 16, 16));
    $keyc = $ckey_length ? ($operation == 'DECODE' ? substr($string, 0, $ckey_length): substr(md5(microtime()), -$ckey_length)) : '';

    $cryptkey = $keya.md5($keya.$keyc);
    $key_length = strlen($cryptkey);

    $string = $operation == 'DECODE' ? base64_decode(substr($string, $ckey_length)) : sprintf('%010d', $expiry ? $expiry + time() : 0).substr(md5($string.$keyb), 0, 16).$string;
    $string_length = strlen($string);

    $result = '';
    $box = range(0, 255);

    $rndkey = array();
    for($i = 0; $i <= 255; $i++) {
        $rndkey[$i] = ord($cryptkey[$i % $key_length]);
    }

    for($j = $i = 0; $i < 256; $i++) {
        $j = ($j + $box[$i] + $rndkey[$i]) % 256;
        $tmp = $box[$i];
        $box[$i] = $box[$j];
        $box[$j] = $tmp;
    }

    for($a = $j = $i = 0; $i < $string_length; $i++) {
        $a = ($a + 1) % 256;
        $j = ($j + $box[$a]) % 256;
        $tmp = $box[$a];
        $box[$a] = $box[$j];
        $box[$j] = $tmp;
        $result .= chr(ord($string[$i]) ^ ($box[($box[$a] + $box[$j]) % 256]));
    }

    if($operation == 'DECODE') {
        if((substr($result, 0, 10) == 0 || substr($result, 0, 10) - time() > 0) && substr($result, 10, 16) == substr(md5(substr($result, 26).$keyb), 0, 16)) {
            return substr($result, 26);
        } else {
            return '';
        }
    } else {
        return $keyc.str_replace('=', '', base64_encode($result));
    }

}

/**
 * 获取当前页面地址
 * @return string
 */
function get_url() {
    global $_A;
    return $_A['url']['now'].get_get();
}

/**
 * @return string
 */
function url() {
    global $_A;
    $str_list = func_get_args();
    $str = isset($str_list[0])?$str_list[0]:'';
    if (count($str_list) > 1) {
        $str =  implode("/", $str_list);
    }
    if ($str === 0) {
        return $_A['url']['now'];
    }elseif (is_int($str) && $str > 1 && $str < 10) {
        return $_A['url'][$str];
    }
    return $_A['url']['index'].($str?trim($str, '/').'/':'');
}

/**
 * @param $str
 * @return string
 */
function urlApi($str) {
    return url($str?'api/'.$str:'api');
}

/**
 * 安全过滤函数
 *
 * @param $string
 * @return string
 */
function safe_replace($string) {
    $string = str_replace('%20','',$string);
    $string = str_replace('%27','',$string);
    $string = str_replace('%2527','',$string);
    $string = str_replace('*','',$string);
    $string = str_replace('"','&quot;',$string);
    $string = str_replace("'",'',$string);
    $string = str_replace('"','',$string);
    $string = str_replace(';','',$string);
    $string = str_replace('<','&lt;',$string);
    $string = str_replace('>','&gt;',$string);
    $string = str_replace("{",'',$string);
    $string = str_replace('}','',$string);
    $string = str_replace('\\','',$string);
    return $string;
}

/**
 * 去除或保留链接中的参数
 * @param string|null $param   要去除或保留的参数名称
 * @param string|null $baoliu  留空为去除，其他为保留
 * @param array $array         自定义参数组，留空为$_GET参数组
 * @return string
 */
function get_get($param = null, $baoliu = null, $array = array()) {
    if (!empty($array) && is_array($array)) {
        $get = $array;
    }else{
        $CI =& get_instance();
        $get = $CI->input->get();
    }
    $text = "";
    if ($param){
        $str = str_replace("|", ",", $param);
        $arr = explode(',', $str);
        if ($baoliu){
            $get1 = array();
            foreach($arr as $value){
                $get1[$value] = $get[$value];
            }
            $get = $get1;
        }else{
            foreach($arr as $value){
                unset($get[$value]);
            }
        }
    }
    if ($get){
        foreach($get as $k=>$v){
            $text .="{$k}={$v}&";
        }
    }
    $text = !empty($text)?"?".substr($text,0,-1):'';
    return $text;
}

/**
 * 获取地址(去除链接参数)
 * @param string $str     变量,用半角逗号隔开
 * @param string $baoliu  采用保留方式
 * @param array $array    链接自定变量
 * @param int $allurl     1保留全路径,0不保留
 * @return string
 */
function get_link($str = '', $baoliu = '', $array = array(), $allurl = 1) {
    global $_A;
    $get = get_get($str, $baoliu, $array);
    if (empty($get)) {
        $get = '?index='.generate_password(5);
    }
    $_url = $_A['url']['now'];
    $index = $_A['url']['index'];
    if (!isset($_A['url']['now'])) {
        $CI =& get_instance();
        $_url = $CI->config->site_url($CI->uri->uri_string()).'/';
        $index = $CI->config->site_url().'/';
    }
    if (!$allurl){
        $_url = substr($_url, strlen($index) - 1);
    }
    return $_url.$get;
}

/**
 * @param string $linkname      连接名称
 * @param string $var           变量值
 * @param string $filter        其他过滤参数
 * @return string
 */
function get_by_order($linkname, $var, $filter = '') {
    $src = 'by_order|by_desc';
    $src.= $filter?'|'.$filter:'';
    $myurl = get_link($src).'&by_order='.$var;
    if ($_GET['by_order'] == $var && $_GET['by_desc'] == 'desc') {
        $fillmyurl = '<a href="' . $myurl . '&by_desc=asc">' . $linkname . '↓</a>';
    }elseif ($_GET['by_order'] == $var && $_GET['by_desc'] == 'asc') {
        $fillmyurl = '<a href="'.$myurl.'&by_desc=desc">'.$linkname.'↑</a>';
    }else{
        $fillmyurl = '<a href="'.$myurl.'&by_desc=desc">'.$linkname.'</a>';
    }
    return $fillmyurl;
}

/**
 * @param $str
 * @return string
 */
function get_smarty_request($str){
    $CI =& get_instance();
    $str=rawurldecode($str);
    $strtrim=rtrim($str,']');
    if (substr($strtrim,0,4)=='GET['){
        $getkey=substr($strtrim,4);
        return $CI->input->get($getkey);
    }elseif (substr($strtrim,0,5)=='POST['){
        $getkey=substr($strtrim,5);
        return $CI->input->post($getkey);
    }elseif (substr($strtrim,0,6)=='PGEST['){
        $getkey=substr($strtrim,6);
        return $CI->input->post($getkey)?$CI->input->post($getkey):$CI->input->get($getkey);
    }else{
        return $str;
    }
}

/**
 * @param string $title       提示标题
 * @param string $body        提示正文内容
 * @param array $links        显示链接组或链接
 * @param string $gotolinks   自动跳转链接
 * @param string $gototime    自动跳转链接时间
 */
function message($title = '', $body = '', $links = array(), $gotolinks = '', $gototime = '3') {
    $CI =& get_instance();
    if ($title && empty($body)) {
        $body = $title;
    }
    header ( "Content-type: text/html; charset=".BASE_CHARSET );
    $CI->cs->showmsg($title, $body, $links, $gotolinks, $gototime);
}

/**
 * @return string
 */
function get_ip(){
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

/**
 * @param $text
 * @param string $pass
 * @return string
 */
function md52($text, $pass = ''){
    $_text = md5($text) . $pass;
    return md5($_text);
}


/**
 * 随机字符串
 * @param int $length 随机字符长度
 * @param string $type
 * @return string 1数字、2大小写字母、21小写字母、22大写字母、默认全部;
 */
function generate_password( $length = 8 ,$type = '') {
    // 密码字符集，可任意添加你需要的字符
    switch ($type){
        case '1':
            $chars = '0123456789';
            break;
        case '2':
            $chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';
            break;
        case '21':
            $chars = 'abcdefghijklmnopqrstuvwxyz';
            break;
        case '22':
            $chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
            break;
        default:
            $chars = $type?$type:'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
            break;
    }
    $passwordstr = '';
    $max = strlen($chars) - 1;
    for ( $i = 0; $i < $length; $i++ ){
        $passwordstr .= $chars[ mt_rand(0, $max) ];
    }
    return $passwordstr;
}
function str_random($length, $chars = '0123456789') {
    return generate_password($length, $chars);
}

/**
 * 截取指定字符串
 * @param $str
 * @param string $ta
 * @param string $tb
 * @return string
 */
function get_subto($str, $ta = '', $tb = ''){
    if ($ta && strpos($str, $ta) !== false){
        $str = substr($str, strpos($str, $ta) + strlen($ta));
    }
    if ($tb && strpos($str, $tb) !== false){
        $str = substr($str, 0, strpos($str, $tb));
    }
    return $str;
}

/**
 * 相对路径补全
 * @param string $str
 * @return string
 */
function fillurl($str = ''){
    if (empty($str)) return $str;
    if (substr($str,0,2) == "//" ||
        substr($str,0,7) == "http://" ||
        substr($str,0,8) == "https://" ||
        substr($str,0,6) == "ftp://" ||
        substr($str,0,1) == "/" ||
        substr(str_replace(' ','',$str),0,11) == "data:image/")
    {
        return $str;
    }else{
        return BASE_URI.$str;
    }
}
if (!function_exists('toimage')) {
    function toimage($src = '') {
        return fillurl($src);
    }
}
if (!function_exists('tomedia')) {
    function tomedia($src = '') {
        return fillurl($src);
    }
}

/**
 * 生成缩略图路径
 * @param $path
 * @param $size
 * @return string
 */
function thumburl($path, $size) {
    $url = fillurl($path);
    if (strexists($url, BASE_URI.'uploadfiles/') && !strexists($url, BASE_URI.'uploadfiles/thumb/')) {
        $url = str_replace(BASE_URI.'uploadfiles/', BASE_URI.'uploadfiles/thumb/', $url).'_'.$size.'.jpg';
    }
    return $url;
}

/**
 * 微信头像大小
 * @param $str
 * @param string $r
 * @return string
 */
function avatar_fillurl($str, $r = "/0") {
    if (leftexists($str, "http") && rightexists($str, "/0")) {
        $str = substr($str, 0, -2);
        $str .= $r;
    }
    return fillurl($str);
}

/**
 * 关键词分割整理
 * @param string $str
 * @return string
 */
function replykey($str = ''){
    if (empty($str)) return $str;
    $strarr = explode(",", $str);
    $strtext = "";
    foreach($strarr as $val){
        if ($val) $strtext.= '<em class="replykey" title="'.$val.'">'.cut_str($val,5,0,'...').'</em>';
    }
    return $strtext;
}

/**
 * 打散字符串，只留为数字的项
 * @param $delimiter
 * @param $string
 * @return array
 */
function explode_int($delimiter, $string) {
    $array = explode($delimiter, $string);
    foreach ($array AS $k=>$v) {
        if (!is_numeric($v)) {
            unset($array[$k]);
        }
    }
    return $array;
}

/**
 * 中国正常GCJ02坐标---->百度地图BD09坐标
 * 腾讯地图用的也是GCJ02坐标
 * @param float $lat 纬度
 * @param float $lng 经度
 * @return array
 */
function map_gcj02_to_bd09($lat, $lng){
    $x_pi = 3.14159265358979324 * 3000.0 / 180.0;
    $x = $lng;
    $y = $lat;
    $z =sqrt($x * $x + $y * $y) + 0.00002 * sin($y * $x_pi);
    $theta = atan2($y, $x) + 0.000003 * cos($x * $x_pi);
    $lng = $z * cos($theta) + 0.0065;
    $lat = $z * sin($theta) + 0.006;
    return array('lng'=>$lng,'lat'=>$lat);
}

/**
 * 百度地图BD09坐标---->中国正常GCJ02坐标
 * 腾讯地图用的也是GCJ02坐标
 * @param double $lat 纬度
 * @param double $lng 经度
 * @return array();
 */
function map_bd09_to_gcj02($lat,$lng){
    $x_pi = 3.14159265358979324 * 3000.0 / 180.0;
    $x = $lng - 0.0065;
    $y = $lat - 0.006;
    $z = sqrt($x * $x + $y * $y) - 0.00002 * sin($y * $x_pi);
    $theta = atan2($y, $x) - 0.000003 * cos($x * $x_pi);
    $lng = $z * cos($theta);
    $lat = $z * sin($theta);
    return array('lng'=>$lng,'lat'=>$lat);
}

/**
 * 格式化导出csv
 * @param $text
 * @return mixed|string
 */
function _csv($text){
    $text = str_replace('"','""', $text);
    $text = '"'.$text.'"';
    $text = strip_tags($text);
    return $text;
}

/**
 * 检测日期格式
 * @param string $str  需要检测的字符串
 * @return bool
 */
function is_date($str){
    $strArr = explode('-',$str);
    if(empty($strArr) || count($strArr) != 3){
        return false;
    } else {
        list($year, $month, $day) = $strArr;
        if (checkdate($month,$day,$year)) {
            return true;
        } else {
            return false;
        }
    }
}

/**
 * 检测时间格式
 * @param string $str  需要检测的字符串
 * @return bool
 */
function is_time($str){
    $strArr = explode(':',$str);
    if(empty($strArr) || count($strArr) != 2){
        return false;
    } else {
        list($hour, $minute) = $strArr;
        if (intval($hour) > 23 || intval($minute) > 59) {
            return false;
        } else {
            return true;
        }
    }
}

/**
 * 检测手机号码格式
 * @param string $str       需要检测的字符串
 * @return bool
 */
function isMobile($str) {
    if (preg_match("/^1(3|4|5|7|8)\d{9}$/",$str)) {
        return true;
    }elseif (preg_match("/^1(3|4|5|7|8)\d{11}$/",$str)) {
        return true;
    }else{
        return false;
    }
}
function isMobile_sub($str) {
    if (preg_match("/^1(3|4|5|7|8)\d{11}$/",$str)) {
        return true;
    }else{
        return false;
    }
}
function runMobile($str) {
    if (preg_match("/^1(3|4|5|7|8)\d{9}$/",$str)) {
        return $str;
    }elseif (preg_match("/^1(3|4|5|7|8)\d{11}$/",$str)) {
        return substr($str, 0, 11);
    }else{
        return '';
    }
}

/**
 * 检测邮箱格式
 * @param string $str 需要检测的字符串
 * @return int
 */
function isMail($str){
    $RegExp='/^[a-z0-9][a-z\.0-9-_]+@[a-z0-9_-]+(?:\.[a-z]{0,3}\.[a-z]{0,2}|\.[a-z]{0,3}|\.[a-z]{0,2})$/i';
    return preg_match($RegExp,$str);
}

/**
 * 阵列数组
 * @param $keys
 * @param $src
 * @param bool $default
 * @return array
 */
function array_elements($keys, $src, $default = FALSE) {
    $return = array();
    if(!is_array($keys)) {
        $keys = array($keys);
    }
    foreach($keys as $key) {
        if(isset($src[$key])) {
            $return[$key] = $src[$key];
        } else {
            $return[$key] = $default;
        }
    }
    return $return;
}

/**
 * 模板输出
 * @param string $file
 * @param null $_param
 * @param null $_smd5
 */
function tpl($file = '', $_param = null, $_smd5 = null) {
    get_instance()->cs->show($file, $_param, $_smd5);
}

/**
 * 模板返回
 * @param string $file
 * @param null $_param
 * @param null $_smd5
 * @return mixed|string
 */
function fetch($file = '', $_param = null, $_smd5 = null) {
    return get_instance()->cs->show_fetch($file, $_param, $_smd5);
}

/**
 * @param string $file
 * @return string
 */
function tpl_fetch($file = '') {
    define('___TPL_FETCH_FILE',  $file);
    return BASE_PATH.'include/views/tpl_fetch.php';
}

/**
 * 模板输出 (指定系统文件)
 * @param string $file
 * @return string
 */
function template($file = '') {
    $filesite = "";
    switch($file) {
        case 'header':
            $filesite = BASE_PATH."addons/system/template/header_fun.tpl";
            break;
        case 'footer':
            $filesite = BASE_PATH."addons/system/template/footer.tpl";
            break;
        case 'reply_right':
            $filesite = BASE_PATH."addons/system/template/reply/_right.tpl";
            break;
    }
    return $filesite?get_instance()->cs->fetch($filesite):'';
}


/**
 * 判断字符串存在(包含)
 * @param string $string
 * @param string $find
 * @return bool
 */
function strexists($string, $find) {
    return !(strpos($string, $find) === FALSE);
}

/**
 * 判断字符串开头包含
 * @param string $string        //原字符串
 * @param string $find          //判断字符串
 * @param bool|false $lower     //是否不区分大小写
 * @return int
 */
function leftexists($string, $find, $lower = false) {
    if ($lower) {
        $string = strtolower($string);
        $find = strtolower($find);
    }
    return (substr($string, 0, strlen($find)) == $find);
}

/**
 * 判断字符串结尾包含
 * @param string $string        //原字符串
 * @param string $find          //判断字符串
 * @param bool|false $lower     //是否不区分大小写
 * @return int
 */
function rightexists($string, $find, $lower = false) {
    if ($lower) {
        $string = strtolower($string);
        $find = strtolower($find);
    }
    return (substr($string, strlen($find)*-1) == $find);
}

/**
 * 删除开头指定字符串
 * @param $string
 * @param $find
 * @param bool $lower
 * @return string
 */
function leftdelete($string, $find, $lower = false) {
    if (leftexists($string, $find, $lower)) {
        $string = substr($string, strlen($find));
    }
    return $string?$string:'';
}

/**
 * 删除结尾指定字符串
 * @param $string
 * @param $find
 * @param bool $lower
 * @return string
 */
function rightdelete($string, $find, $lower = false) {
    if (rightexists($string, $find, $lower)) {
        $string = substr($string, 0, strlen($find) * -1);
    }
    return $string;
}

/**
 * @param $errno
 * @param string $message
 * @return array
 */
function error($errno, $message = '') {
    return array(
        'errno' => $errno,
        'message' => $message,
    );
}

/**
 * @param $data
 * @return bool
 */
function is_error($data) {
    if (empty($data) || !is_array($data) || !array_key_exists('errno', $data) || (array_key_exists('errno', $data) && $data['errno'] == 0)) {
        return false;
    } else {
        return true;
    }
}

/**
 * 版本比较
 * @param $version1
 * @param $version2
 * @return mixed
 */
function ver_compare($version1, $version2) {
    if(strlen($version1) <> strlen($version2)) {
        $version1_tmp = explode('.', $version1);
        $version2_tmp = explode('.', $version2);
        if(strlen($version1_tmp[1]) == 1) {
            $version1 .= '0';
        }
        if(strlen($version2_tmp[1]) == 1) {
            $version2 .= '0';
        }
    }
    return version_compare($version1, $version2);
}

/**
 * 获取或设置
 * @param $setname
 * @return array
 */
function setting($setname, $array = false) {
    static $settingname = array();
    if (empty($setname)) {
        return array();
    }
    if ($array === false && isset($settingname[$setname])) {
        return $settingname[$setname];
    }
    $setting = array();
    $setrow = db_getone(table('setting'), array('title'=>$setname));
    if (!empty($setrow)) {
        $setting = string2array($setrow['setting']);
    }else{
        db_insert(table('setting'), array('title'=>$setname));
    }
    if ($array !== false) {
        $setting = $array;
        db_update(table('setting'), array('setting'=>(is_array($array)?array2string($array):$array)), array('title'=>$setname));
    }
    $settingname[$setname] = $setting;
    return $setting;
}

/**
 * 获取设置值
 * @param $setname
 * @param $keyname
 * @return mixed
 */
function settingfind($setname, $keyname) {
    $array = setting($setname);
    return $array[$keyname];
}

/**
 * @param $source_image
 * @return bool
 */
function QRcodepng2jpg($source_image) {
    try{
        $photoSize = getimagesize($source_image);
        $pw = $photoSize[0];
        $ph = $photoSize[1];
        $dstImage = imagecreatetruecolor($pw, $ph);
        imagecolorallocate($dstImage, 255, 255, 255);
        $srcImage = imagecreatefrompng($source_image);
        imagecopyresampled($dstImage, $srcImage, 0, 0, 0, 0, $pw, $ph, $pw, $ph);
        imagejpeg($dstImage, $source_image);
        imagedestroy($srcImage);
        return true;
    }catch (Exception $e){
        return false;
    }
}

/**
 * 查询分页列表
 * @param string $table     表名称
 * @param string $where     查询条件，默认空
 * @param string $order     排序方式，默认空
 * @param int $row          每页显示，默认10
 * @param int $page         当前页，默认1
 * @param string $field     读取字段名称
 * @param int $pagehtml     读取分页代码，默认0
 * @return array (total=>总数量,perpage=>每页显示,nowpage=>当前页,totalpage=>总页数,list=>数据列表)
 */
function db_getlist($table, $where='', $order='', $row=10, $page=1, $field='*', $pagehtml=0) {
    return get_instance()->ddb->getlist($table, $where, $order, $row, $page, $field, $pagehtml);
}

/**
 * 查询统计
 * @param string  $sql
 * @param array   $wherearr
 * @return mixed
 */
function db_total($sql, $wherearr = array()) {
    return get_instance()->ddb->get_total($sql, $wherearr);
}

/**
 * 查询行数统计
 * @param string  $sql
 * @param array   $wherearr
 * @return mixed
 */
function db_count($sql, $wherearr = array()) {
    return get_instance()->ddb->get_count($sql, $wherearr);
}

/**
 * 查询第一条数据
 * @param string  $sql         数据表名称 或 sql语句
 * @param array   $wherearr    查询条件 支持数组 或 条件字符串
 * @param string  $ordersql    排序（不包含ORDER BY）
 * @param string  $field       指定字段并返回
 * @return mixed
 */
function db_getone($sql, $wherearr = array(), $ordersql = '', $field = '') {
    return get_instance()->ddb->getone($sql, $wherearr, $ordersql, $field);
}

/**
 * 查询全部数据
 * @param string  $sql         数据表名称 或 sql语句
 * @param array   $wherearr    查询条件 支持数组 或 条件字符串
 * @param string  $ordersql    排序（不包含ORDER BY）
 * @return mixed
 */
function db_getall($sql, $wherearr = array(), $ordersql = '', $field = '') {
    return get_instance()->ddb->getall($sql, $wherearr, $ordersql, $field);
}

/**
 * 更新数据
 * @param string  $table       数据表名称
 * @param array   $data        要更新的数据组
 * @param array   $where       更新条件 支持数组 或 条件字符串
 * @return mixed
 */
function db_update($table, $data = array(), $where = array()) {
    global $IS_ADMIN_DB;
    if ($IS_ADMIN_DB === true) {
        global $_A;
        //记录操作
        $lists = db_getall($table, $where);
        foreach ($lists AS $list) {
            $beaf = db_before_after($list, $data);
            if ($beaf['before']) {
                $IS_ADMIN_DB = false;
                db_insert(table('users_notes'), array(
                    'type'=>'update',
                    'userid'=>$_A['user']['id'],
                    'username'=>$_A['user']['username'],
                    'table'=>$table,
                    'before'=>array2string_discard($beaf['before']),
                    'content'=>array2string_discard($beaf['after']),
                    'where'=>array2string_discard($where),
                    'indate'=>SYS_TIME,
                    'inip'=>ONLINE_IP,
                ));
                $IS_ADMIN_DB = true;
            }
        }
    }
    return get_instance()->ddb->update($table, $data, $where);
}

/**
 * 插入数据
 * @param string  $table       数据表名称
 * @param array   $data        要插入的数据组
 * @param bool    $retid       是否返回主键值
 * @return mixed
 */
function db_insert($table, $data = array(), $retid = false){
    global $IS_ADMIN_DB;
    if ($IS_ADMIN_DB === true) {
        global $_A;
        //记录操作
        $IS_ADMIN_DB = false;
        db_insert(table('users_notes'), array(
            'type'=>'insert',
            'userid'=>$_A['user']['id'],
            'username'=>$_A['user']['username'],
            'table'=>$table,
            'content'=>array2string_discard($data),
            'indate'=>SYS_TIME,
            'inip'=>ONLINE_IP,
        ));
        $IS_ADMIN_DB = true;
    }
    return get_instance()->ddb->insert($table, $data, $retid);
}

/**
 * 删除数据
 * @param string  $table       数据表名称
 * @param array   $where       删除条件 支持数组 或 条件字符串
 * @param string  $glue        删除数组型条件连接符 AND 或 OR
 * @return mixed
 */
function db_delete($table, $where = array(), $glue = 'AND'){
    global $IS_ADMIN_DB;
    if ($IS_ADMIN_DB === true) {
        global $_A;
        //记录操作
        if (strtolower($glue) == "or") {
            $lists = db_getall($table, db_or_where($where));
        }else{
            $lists = db_getall($table, $where);
        }
        foreach ($lists AS $list) {
            $IS_ADMIN_DB = false;
            db_insert(table('users_notes'), array(
                'type'=>'delete',
                'userid'=>$_A['user']['id'],
                'username'=>$_A['user']['username'],
                'table'=>$table,
                'before'=>array2string_discard($list),
                'where'=>array2string_discard($where),
                'indate'=>SYS_TIME,
                'inip'=>ONLINE_IP,
            ));
            $IS_ADMIN_DB = true;
        }
    }
    return get_instance()->ddb->delete($table, $where, $glue);
}


/**
 * 执行一条sql
 * @param string  $sql       完整的SQL
 * @param array   $wherearr
 * @return mixed
 */
function db_query($sql, $wherearr = array()) {
    return get_instance()->ddb->query($sql, $wherearr);
}

/**
 * 简化执行一条sql
 * @param string  $sql        完整的SQL
 * @param array   $wherearr
 * @return mixed
 */
function db_query_simple($sql, $wherearr = array()) {
    return get_instance()->ddb->query_simple($sql, $wherearr);
}

/**
 * 运行多条sql
 * @param string  $sql        完整的SQL，多条SQL用 ;+换行 隔开
 * @return mixed
 */
function db_run($sql) {
    return get_instance()->ddb->run($sql);
}

/**
 * 简化运行多条sql
 * @param string  $sql        完整的SQL，多条SQL用 ;+换行 隔开
 * @return mixed
 */
function db_run_simple($sql) {
    return get_instance()->ddb->run_simple($sql);
}

/**
 * 事务开始
 */
function db_trans_start() {
    return get_instance()->ddb->trans_start();
}

/**
 * 事务完成
 */
function db_trans_complete() {
    return get_instance()->ddb->trans_complete();
}

/**
 * 查询表字段是否存在
 * @param string $table       数据表名称
 * @param string $fieldname   字段名称
 * @return mixed
 */
function db_fieldexists($table, $fieldname = '') {
    return get_instance()->ddb->fieldexists($table, $fieldname);
}

/**
 * 查询索引是否存在
 * @param string $table       数据表名称
 * @param string $indexname   索引名称
 * @return mixed
 */
function db_indexexists($table, $indexname = '') {
    return get_instance()->ddb->indexexists($table, $indexname);
}

/**
 * 查询表是否存在
 * @param string $table        数据表名称
 * @return mixed
 */
function db_tableexists($table){
    return get_instance()->ddb->tableexists($table);
}

/**
 * @param $str
 * @return array|int|string
 */
function db_escape($str) {
    return get_instance()->ddb->escape($str);
}
function db_escape_str($str) {
    return get_instance()->ddb->escape_str($str);
}
function db_escape_like_str($str) {
    return get_instance()->ddb->escape_like_str($str);
}
function db_escape_identifiers($str) {
    return get_instance()->ddb->escape_identifiers($str);
}
function db_addcheck($str) {
    return get_instance()->ddb->addcheck($str);
}
function db_checksql($str) {
    return get_instance()->ddb->checksql($str);
}
function db_array2string($str) {
    if (is_array($str)) {
        foreach ($str AS $key=>$item) {
            $str[$key] = is_array($item)?array2string($item):$item;
        }
    }
    return $str;
}
function db_or_where($where) {
    if (is_array($where)) {
        $_where = '';
        foreach ($where AS $key=>$item) {
            $_where.= "OR `".$key."`='".$item."' ";
        }
        $where = leftdelete($_where, 'OR');
    }
    return $where;
}
function db_before_after($list, $data) {
    foreach ($list AS $key=>$item) {
        if (!isset($data[$key]) || $data[$key] == $item) {
            unset($list[$key]);
        }
    }
    foreach ($data AS $key=>$item) {
        if (!isset($list[$key])) {
            unset($data[$key]);
        }
    }
    ksort($list);
    ksort($data);
    return array('before'=>$list, 'after'=>$data);
}

/**
 * 返回根据距离sql排序语句
 * @param $lat
 * @param $lng
 * @param string $latName
 * @param string $lngName
 * @return string
 */
function db_acos($lat , $lng, $latName = 'lat', $lngName = 'lng') {
    $lat = floatval($lat);
    $lng = floatval($lng);
    $order = 'ACOS(
		SIN(('.$lat.' * 3.1415) / 180) * SIN(('.$latName.' * 3.1415) / 180) + COS(('.$lat.' * 3.1415) / 180) * COS(('.$latName.' * 3.1415) / 180) * COS(
			('.$lng.' * 3.1415) / 180 - ('.$lngName.' * 3.1415) / 180
		)
	) * 6380';
    return $order;
}

/**
 * 分页
 * @param $total
 * @param $pageIndex
 * @param int $pageSize
 * @param string $url
 * @param array $context
 * @return string
 */
function pagination($total, $pageIndex, $pageSize = 15, $url = '', $context = array('before' => 5, 'after' => 4)) {
    global $_A;
    $pdata = array(
        'tcount' => 0,
        'tpage' => 0,
        'cindex' => 0,
        'findex' => 0,
        'pindex' => 0,
        'nindex' => 0,
        'lindex' => 0,
        'options' => ''
    );

    $pdata['tcount'] = $total;
    $pdata['tpage'] = ceil($total / $pageSize);
    if($pdata['tpage'] <= 1) {
        return '';
    }
    $cindex = $pageIndex;
    $cindex = min($cindex, $pdata['tpage']);
    $cindex = max($cindex, 1);
    $pdata['cindex'] = $cindex;
    $pdata['findex'] = 1;
    $pdata['pindex'] = $cindex > 1 ? $cindex - 1 : 1;
    $pdata['nindex'] = $cindex < $pdata['tpage'] ? $cindex + 1 : $pdata['tpage'];
    $pdata['lindex'] = $pdata['tpage'];


    if($url) {
        $pdata['faa'] = 'href="?' . str_replace('*', $pdata['findex'], $url) . '"';
        $pdata['paa'] = 'href="?' . str_replace('*', $pdata['pindex'], $url) . '"';
        $pdata['naa'] = 'href="?' . str_replace('*', $pdata['nindex'], $url) . '"';
        $pdata['laa'] = 'href="?' . str_replace('*', $pdata['lindex'], $url) . '"';
    } else {
        $_GET['page'] = $pdata['findex'];
        $pdata['faa'] = 'href="' . $_A['url']['now'] . '?' . http_build_query($_GET) . '"';
        $_GET['page'] = $pdata['pindex'];
        $pdata['paa'] = 'href="' . $_A['url']['now'] . '?' . http_build_query($_GET) . '"';
        $_GET['page'] = $pdata['nindex'];
        $pdata['naa'] = 'href="' . $_A['url']['now'] . '?' . http_build_query($_GET) . '"';
        $_GET['page'] = $pdata['lindex'];
        $pdata['laa'] = 'href="' . $_A['url']['now'] . '?' . http_build_query($_GET) . '"';
    }

    $html = '<div><ul class="pagination pagination-centered">';
    if($pdata['cindex'] > 1) {
        $html .= "<li><a {$pdata['faa']} class=\"pager-nav\">首页</a></li>";
        $html .= "<li><a {$pdata['paa']} class=\"pager-nav\">&laquo;上一页</a></li>";
    }
    if(!$context['before'] && $context['before'] != 0) {
        $context['before'] = 5;
    }
    if(!$context['after'] && $context['after'] != 0) {
        $context['after'] = 4;
    }

    if($context['after'] != 0 && $context['before'] != 0) {
        $range = array();
        $range['start'] = max(1, $pdata['cindex'] - $context['before']);
        $range['end'] = min($pdata['tpage'], $pdata['cindex'] + $context['after']);
        if ($range['end'] - $range['start'] < $context['before'] + $context['after']) {
            $range['end'] = min($pdata['tpage'], $range['start'] + $context['before'] + $context['after']);
            $range['start'] = max(1, $range['end'] - $context['before'] - $context['after']);
        }
        for ($i = $range['start']; $i <= $range['end']; $i++) {

            if($url) {
                $aa = 'href="?' . str_replace('*', $i, $url) . '"';
            } else {
                $_GET['page'] = $i;
                $aa = 'href="?' . http_build_query($_GET) . '"';
            }
            $html .= ($i == $pdata['cindex'] ? '<li class="active"><a href="javascript:;">' . $i . '</a></li>' : "<li><a {$aa}>" . $i . '</a></li>');
        }
    }

    if($pdata['cindex'] < $pdata['tpage']) {
        $html .= "<li><a {$pdata['naa']} class=\"pager-nav\">下一页&raquo;</a></li>";
        $html .= "<li><a {$pdata['laa']} class=\"pager-nav\">尾页</a></li>";
    }
    $html .= '</ul></div>';
    return $html;
}

/**
 * 秒 （转） 年、天、时、分、秒
 * @param $time
 * @return array|bool
 */
function sec2time($time){
    if (is_numeric($time)){
        $value = array(
            "years" => 0, "days" => 0, "hours" => 0,
            "minutes" => 0, "seconds" => 0,
        );
        /*
        if($time >= 31536000){
            $value["years"] = floor($time/31536000);
            $time = ($time%31536000);
        }
        */
        if($time >= 86400){
            $value["days"] = floor($time/86400);
            $time = ($time%86400);
        }
        if($time >= 3600){
            $value["hours"] = floor($time/3600);
            $time = ($time%3600);
        }
        if($time >= 60){
            $value["minutes"] = floor($time/60);
            $time = ($time%60);
        }
        $value["seconds"] = floor($time);
        return (array) $value;
    }else{
        return (bool) FALSE;
    }
}

/**
 * 年、天、时、分、秒 （转） 秒
 * @param $value
 * @return int
 */
function time2sec($value) {
    $time = intval($value["seconds"]);
    $time+= intval($value["minutes"]*60);
    $time+= intval($value["hours"]*3600);
    $time+= intval($value["days"]*86400);
    $time+= intval($value["years"]*31536000);
    return $time;
}

/**
 * 阿拉伯数字转化为中文
 * @param $num
 * @return string
 */
function chinanum($num){
    $china = array('零','一','二','三','四','五','六','七','八','九');
    $arr = str_split($num);
    $txt = '';
    for ($i=0;$i<count($arr);$i++){
        $txt.= $china[$arr[$i]];
    }
    return $txt;
}

/**
 * 阿拉伯数字转化为中文（用于星期，七改成日）
 * @param $num
 * @return string
 */
function chinanumZ($num){
    return str_replace("七", "日", chinanum($num));
}

/**
 * 浏览器类型
 * @return string
 */
function get_device_type() {
    $agent = strtolower($_SERVER['HTTP_USER_AGENT']);
    $type = 'other';
    if (strexists($agent, 'iphone') || strexists($agent, 'ipad')) {
        $type = 'ios';
    }
    if (strexists($agent, 'android')) {
        $type = 'android';
    }
    return $type;
}

function isIos() {
    return get_device_type() == 'ios';
}

function isAndroid() {
    return get_device_type() == 'android';
}

/** ************************************************************************************/
/** ************************************************************************************/
/** ************************************************************************************/


/**
 * 获取通知管理员
 * @param $type
 * @return array|mixed
 */
function get_notify_users($type) {
    if (in_array($type, array('deposit_notify'))) {
        $list = db_getall("SELECT A.*,B.".$type." FROM ".table('users')." A INNER JOIN ".table('admin_role')." B ON A.id=B.userid WHERE B.".$type."=1", "", "A.id ASC");
    }
    return isset($list)?$list:array();
}

/**
 * @param $param
 */
function json_echo($param) {
    global $_GPC;
    //
    $json = json_encode($param);
    $callback = $_GPC['callback'];
    if ($callback) {
        echo $callback.'('.$json.')';
    }else{
        echo $json;
    }
    exit();
}
function json_sure($message, $code = 0) {
    $param = array(
        'success'=>1,
        'message'=>$message,
        'code'=>$code
    );
    json_echo($param);
}
function json_error($message, $code = 0) {
    $param = array(
        'success'=>0,
        'message'=>$message,
        'code'=>$code
    );
    json_echo($param);
}

function _head_html() {
    $user_agent = $_SERVER['HTTP_USER_AGENT'];
    if (strexists($user_agent, 'WebKit/') || strexists($user_agent, 'Chrome/') || strexists($user_agent, 'MSIE')) {
        return '<html>';
    }
    return '';
}

function get_array($arr, $i = 1) {
    $array = array();
    $j = 1;
    foreach ($arr AS $item) {
        $array[] = $item;
        if ($i >= $j) {
            break;
        }
        $j++;
    }
    return $array;
}

/**
 * 获取卡券名称
 */
function sale_name() {
    $system = setting('system');
    return nullshow($system['sale_name'], '优惠券');
}

/**
 * @return array|mixed
 */
function the_user() {
    global $_A,$_GPC;
    $CI = & get_instance();
    $_A['user'] = array();
    //
    $user = array();
    $userid = $CI->session->userdata('userid');
    if ($_GPC['__browser_sn']) {
        $user = db_getone(table('users'), array('browser_sn'=>$_GPC['__browser_sn']));
    }elseif ($userid) {
        $user = db_getone(table('users'), array('id'=>$userid));
    }
    if (empty($user)) {
        if ($userid) {
            $CI->session->set_userdata('userid', '');
            setcookie('__:proxy:userid', '', SYS_TIME - 1, BASE_DIR);
        }
    }else{
        $user['setting'] = string2array($user['setting']);
        $_A['user'] = $user;
    }
    return $_A['user'];
}

/**
 * 小时转天/小时
 * @param $hour
 * @return string
 */
function forum_hour2day($hour)
{
    $hour = intval($hour);
    if ($hour > 24) {
        $day = floor($hour / 24);
        $hour-= $day * 24;
        return $day.'天'.$hour.'小时';
    }
    return $hour.'小时';
}

/**
 * 时间格式化
 * @param $date
 * @return false|string
 */
function date_year($date)
{
    if (date("Y", $date) == date("Y", SYS_TIME)) {
        return date("m-d H:i:s", $date);
    }else{
        return date("Y-m-d H:i:s", $date);
    }
}

/**
 * 时间格式化
 * @param $date
 * @return false|string
 */
function forum_date($date)
{
    $dur = SYS_TIME - $date;
    if ($date > strtotime(date("Y-m-d"))) {
        //今天
        if ($dur < 60) {
            return max($dur, 1) . '秒前';
        }elseif ($dur < 3600) {
            return floor($dur / 60) . '分钟前';
        }elseif ($dur < 86400) {
            return floor($dur / 3600) . '小时前';
        }else{
            return date("H:i", $date);
        }
    }elseif ($date > strtotime(date("Y-m-d", strtotime("-1 day")))) {
        //昨天
        return '昨天';
    }elseif ($date > strtotime(date("Y-m-d", strtotime("-2 day")))) {
        //前天
        return '前天';
    }elseif ($dur > 86400) {
        //x天前
        return floor($dur / 86400) . '天前';
    }
    return date("Y-m-d", $date);
}

/**
 * 用户名、邮箱、手机账号、银行卡号中间字符串以*隐藏
 * @param $str
 * @return mixed|string
 */
function card_format($str) {
    if (strpos($str, '@')) {
        $email_array = explode("@", $str);
        $prevfix = (strlen($email_array[0]) < 4) ? "" : substr($str, 0, 3); //邮箱前缀
        $count = 0;
        $str = preg_replace('/([\d\w+_-]{0,100})@/', '***@', $str, -1, $count);
        return $prevfix.$str;
    }
    if (isMobile_sub($str)){
        return substr($str, 0, 3)."****".substr($str, -6);
    }
    if (isMobile($str)){
        return substr($str, 0, 3)."****".substr($str, -4);
    }
    $pattern = '/([\d]{4})([\d]{4})([\d]{4})([\d]{4})([\d]{0,})?/i';
    if (preg_match($pattern, $str)) {
        return preg_replace($pattern, '$1 **** **** **** $5', $str);
    }
    $pattern = '/([\d]{4})([\d]{4})([\d]{4})([\d]{0,})?/i';
    if (preg_match($pattern, $str)) {
        return preg_replace($pattern, '$1 **** **** $4', $str);
    }
    $pattern = '/([\d]{4})([\d]{4})([\d]{0,})?/i';
    if (preg_match($pattern, $str)) {
        return preg_replace($pattern, '$1 **** $3', $str);
    }
    return substr($str, 0, 3)."***".substr($str, -1);
}

/**
 * 数字每4位加一空格
 * @param $str
 * @return string
 */
function four_format($str) {
    if (!is_numeric($str)) return $str;
    //
    $text = '';
    for ($i=0;$i<strlen($str);$i++) {
        $text.= $str[$i];
        if ($i % 4 == 3) {
            $text.= " ";
        }
    }
    return $text;
}

/**
 * 银行代号
 * @param int $str
 * @return array|mixed
 */
function get_bank($str = 0) {
    $e2c = array(
        'alipay'=>'支付宝',
        'wxpay'=>'微信支付',
        'icbcb2c'=>'中国工商银行',
        'abc'=>'中国农业银行',
        'ccb'=>'中国建设银行',
        'spdb'=>'上海浦东发展银行',
        'bocb2c'=>'中国银行',
        'cmb'=>'招商银行',
        'cib'=>'兴业银行',
        'gdb'=>'广发银行',
        'postgc'=>'中国邮政储蓄银行',
        'comm'=>'交通银行',
        'bjbank'=>'北京银行',
        'shrcb'=>'上海农商银行',
        'cmbc'=>'中国民生银行',
        'hzcbb2c'=>'杭州银行',
        'ceb-debit'=>'中国光大银行',
        'shbank'=>'上海银行',
        'nbbank'=>'宁波银行',
        'spabank'=>'平安银行',
        'bjrcb'=>'北京农村商业银行'
    );
    $c2e = array(
        '支付宝'=>'alipay',
        '微信支付'=>'wxpay',
        '中国工商银行'=>'icbcb2c',
        '中国农业银行'=>'abc',
        '中国建设银行'=>'ccb',
        '上海浦东发展银行'=>'spdb',
        '中国银行'=>'bocb2c',
        '招商银行'=>'cmb',
        '兴业银行'=>'cib',
        '广发银行'=>'gdb',
        '中国邮政储蓄银行'=>'postgc',
        '交通银行'=>'comm',
        '北京银行'=>'bjbank',
        '上海农商银行'=>'shrcb',
        '中国民生银行'=>'cmbc',
        '杭州银行'=>'hzcbb2c',
        '中国光大银行'=>'ceb-debit',
        '上海银行'=>'shbank',
        '宁波银行'=>'nbbank',
        '平安银行'=>'spabank',
        '北京农村商业银行'=>'bjrcb'
    );
    if ($str == 0) {
        return $e2c;
    }elseif ($str == 1) {
        return $c2e;
    }else{
        return isset($e2c[$str])?$e2c[$str]:$c2e[$str];
    }
}

/**
 * 分割在结尾添加
 * @param $str
 * @param int $len
 * @param string $append
 * @return string
 */
function num_format($str, $len = 4, $append = ' '){
    if (preg_match("/([\x81-\xfe][\x40-\xfe])/", $str, $match)) {
        return $str;
    }
    $str = trim($str);
    $text = "";
    for ($i=0; $i<ceil(strlen($str)/$len); $i++){
        $text.= substr($str, $i*$len, $len) . $append;
    }
    return trim($text);
}

/**
 * 远程图片生成本地图片
 * @param $str
 * @param string $append
 * @return string
 */
function static_img($str, $append = '') {
    if (substr($str,0,2) == "//" ||
        substr($str,0,7) == "http://" ||
        substr($str,0,8) == "https://" ||
        substr($str,0,6) == "ftp://")
    {
        $exp = substr($str, strrpos($str, '.') + 1);
        if (!in_array($exp , array('bmp', 'jpg', 'gif', 'jpeg', 'png'))) {
            $exp = 'jpg';
        }
        $a = md5($str);
        $cre = 'uploadfiles/imgextra'.$append.'/i'.substr($a, 0, 1).'/'.substr($a, 1, 2).'/';
        $php_path = BASE_PATH.$cre.$a.'.php';
        if (!file_exists($php_path)) {
            make_dir(BASE_PATH.$cre);
            $save_txt = 'defined(\'BASEPATH\') OR exit(\'No direct script access allowed\');';
            $save_txt.= '$original=\''.$str.'\';$translation=\'\';';
            file_put_contents($php_path, '<?php '.$save_txt.'?>');
        }
        return static_url().$cre.$a.'.'.$exp;
    }else{
        return fillurl($str);
    }
}

/**
 * 返回静态根目录地址
 * @return string
 */
function static_url() {
    if (is_static() && defined('STATIC_URI')) {
        return STATIC_URI;
    }else{
        return BASE_URI;
    }
}

/**
 * 是否符合静态环境
 * @return bool
 */
function is_static() {
    if (!defined('STATIC_URL') || !STATIC_URL || in_array(substr($_SERVER['SERVER_NAME'],0,3), array('127', '172', '192', '10.'))) {
        return false;
    }else{
        return true;
    }
}


/**
 * 保留两位小数点
 * @param $str
 * @param bool $float
 * @return float
 */
function store_float($str, $float = false) {
    $str = sprintf("%.2f", floatval($str));
    if ($float === true) {
        $str = floatval($str);
    }
    return $str;
}

/**
 * 匿名
 * @param $name
 * @param int $anony
 * @return string
 */
function store_anonyname($name, $anony = 0) {
    if ($anony && $name) {
        $name_temp = mb_substr($name, 0, 1);
        if ($name_temp == $name) {
            $name_temp = "匿名";
        }else{
            $name_temp.= "***".mb_substr($name, -1, 1);
        }
        $name = $name_temp;
    }
    if (empty($name)) {
        $name_arr = explode(".", get_ip());
        $name = $name_arr[0].".".$name_arr[1].".*.*";
    }
    return $name;
}


/**
 * 获取会员等级
 * @param $point_plus
 * @return mixed
 */
function users_rank($point_plus) {
    $setting = setting('users_rank');
    $lastname = ''; $rankname = ''; $min = 0;
    foreach ($setting AS $item) {
        if ($item['min'] == -1) {
            $lastname = $item['name'];
        }elseif ($point_plus <= $item['min'] && ($item['min'] <= $min || $min == 0)) {
            $min = $item['min'];
            $rankname = $item['name'];
        }
    }
    if (empty($rankname) && !empty($lastname)) {
        $rankname = $lastname;
    }
    return nullshow($rankname, '默认会员');
}

/**
 * 获取会员等级信息
 * @param $point_plus
 * @return mixed
 */
function users_rank_info($point_plus) {
    $setting = setting('users_rank');
    $lastarr = array(); $rankarr = array(); $min = 0;
    foreach ($setting AS $item) {
        if ($item['min'] == -1) {
            $lastarr = $item;
        }elseif ($point_plus <= $item['min'] && ($item['min'] <= $min || $min == 0)) {
            $min = $item['min'];
            $rankarr = $item;
        }
    }
    if (empty($rankarr) && !empty($lastarr)) {
        $rankarr = $lastarr;
    }
    return $rankarr;
}

/**
 * 查询或更新会员地理位置
 * @param $userid
 * @param array $data
 * @return array|bool|mixed
 */
function users_lbs($userid, $data = array()) {
    if ($userid <= 0) {
        return false;
    }
    $row = db_getone(table('users_lbs'), array('userid'=>$userid));
    if (empty($row)) {
        db_insert(table('users_lbs'), array('userid'=>$userid));
        $row = db_getone(table('users_lbs'), array('userid'=>$userid));
    }
    if (empty($row)) {
        return false;
    }
    if (is_array($data) && $data) {
        if (is_array($data['map'])) {
            $data['map'] = array2string($data['map']);
        }
        db_trans_start();
        db_update(table('users_lbs'), $data, array('id'=>$row['id']));
        foreach ($data AS $key=>$val) {
            $row[$key] = $val;
        }
        users_cdbnum($userid);
        db_trans_complete();
    }
    $row['map'] = string2array($row['map']);
    return $row;
}

/**
 * 更新子账号数量
 * @param $userid
 */
function users_findnum($userid) {
    if ($userid > 0) {
        $num = db_count(table('users'), array('masterid'=>$userid, 'mastersync'=>1));
        db_update(table('users'), array('findnum'=>intval($num)), array('id'=>$userid));
    }
}

/**
 * 更新用户设备数量
 * @param $userid
 * @return int|mixed
 */
function users_cdbnum($userid) {
    if ($userid > 0) {
        $num_cdb = db_count(table('cdb'), array('userid'=>$userid, 'type'=>'充电宝', 'status'=>'启用'));
        $num_ys = db_count(table('cdb'), array('userid'=>$userid, 'type'=>'雨伞', 'status'=>'启用'));
        $cdbnum = $num_cdb + $num_ys;
        db_update(table('users'), array('cdbnum'=>$cdbnum, 'num_cdb'=>$num_cdb, 'num_ys'=>$num_ys), array('id'=>$userid));
        return $cdbnum;
    }
    return 0;
}

/**
 * 用户总提示信息数量
 * @param $userid
 * @return array
 */
function users_badge($userid) {
    $arr = array(
        'message'=>0,   //消息
        'notback'=>0,   //未还
        'mysale'=>0,    //可用优惠券
        'tisnum'=>0     //提示总数
    );
    if ($userid > 0) {
        $arr['message'] = db_count(table('message'), array('userid'=>$userid, 'tobe'=>1, 'viewdate'=>0));
        $arr['notback'] = db_count(table('order'), array('userid'=>$userid, '(`retuserid`=0 OR `ret`>0)'=>null));
        //优惠券
        $fields = 'A.end_type,A.end_day,A.end_each,A.enddate,B.indate AS indateB,B.update AS updateB';
        $mysale = db_getall('SELECT '.$fields.' FROM '.table('sale').' A INNER JOIN '.table('users_sale').' B ON A.id=B.saleid',
            array('B.userid'=>$userid, 'A.status'=>'启用'), 'A.id DESC');
        foreach($mysale AS $key=>$item) {
            if ($item['end_type'] == 'day'){
                $item['enddate'] = $item['end_day'] * 86400 + $item['indateB'];
            }elseif ($item['end_type'] == 'each'){
                if ($item['end_each'] == 'year') {
                    $item['enddate'] = mktime(23, 59, 59, 12, 31, date('Y',$item['indateB']));
                } elseif ($item['end_each'] == 'month') {
                    $item['enddate'] = mktime(23, 59, 59, date('m',$item['indateB']), date('t',$item['indateB']), date('Y',$item['indateB']));
                } elseif ($item['end_each'] == 'week') {
                    $item['enddate'] = mktime(23, 59, 59, date('m',$item['indateB']), date('d',$item['indateB']) - date('w',$item['indateB']) + 7, date('Y',$item['indateB']));
                } elseif ($item['end_each'] == 'day') {
                    $item['enddate'] = mktime(23, 59, 59, date('m',$item['indateB']), date('d',$item['indateB']), date('Y',$item['indateB']));
                }
            }
            if ($item['enddate'] > SYS_TIME && $item['updateB'] == 0) {
                $arr['mysale']++;
            }
        }
    }
    foreach ($arr AS $key=>$num) {
        if ($key != 'tisnum') $arr['tisnum']+= $num;
    }
    //
    return $arr;
}

/**
 * 设备详情（或归还中的设备）
 * @param $sn
 * @return array|mixed
 */
function cdb_info($sn) {
    global $_A;
    if ($sn == 'giveback') {
        //归还中的设备
        $cdb = db_getone('SELECT A.* FROM '.table('cdb').' A INNER JOIN '.table('order').' B ON A.sn=B.sn', array('B.userid'=>$_A['user']['id'], 'B.ret>'=>0), 'B.ret ASC,B.retdate ASC');
        if (empty($cdb)) {
            return '设备不存在（请求操作超时）！';
        }
    }else{
        //指定sn的设备
        $cdb = db_getone(table('cdb'), array('sn'=>$sn));
        if (empty($cdb)) {
            return '设备不存在！';
        }
    }
    $cdb['cdbinfo'] = $cdb;
    $cdb['userinfo'] = db_getone(table('users'), array('id'=>$cdb['userid']));
    return $cdb;
}

/**
 * 套餐租用费用
 * @param int $indate 开始借用时间戳
 * @param int $enddate 结束借用时间戳
 * @param int $saleTime 抵借用多少小时
 * @param string $type  设备类型
 * @return int 返回租金（元）
 */
function cdb_totalMoney($indate, $enddate = 0, $saleTime = 0, $type = '') {
    $CI = & get_instance();
    $CI->load->library('cdbx');
    return $CI->cdbx->totalMoney($indate, $enddate, $saleTime, $type);
}

/**
 * 租用时间差(不够1个小时算一个小时)
 * @param int $s    开始时间戳
 * @param int $e    结束时间戳
 * @return string
 */
function cdb_time_diff($s, $e) {
    $d = $e - $s;
    if ($d > 86400) {
        $day = floor($d / 86400);
        $hour = ceil(($d - ($day * 86400)) / 3600);
        if ($hour > 0) {
            return $day.'天'.$hour.'小时';
        }else{
            return $day.'天';
        }
    }elseif ($d > 3600) {
        return ceil($d / 3600).'小时';
    }elseif ($d > 60) {
        return ceil($d / 60).'分钟';
    }elseif ($d > 10) {
        return $d.'秒';
    }else{
        return '刚刚';
    }
}

/**
 * 获取用户优惠券
 * @param int $userid 会员id
 * @param int $row 每页获取数量
 * @param int $page 当前页
 * @param string $type
 * @return array
 */
function user_sales($userid, $row = 500, $page = 1, $type = 'TPF') {
    $wheresql = 'B.userid='.intval($userid);
    if ($type) {
        $wherein = '';
        for ($i = 0; $i < strlen($type); $i++) {
            $temp = substr($type, $i, 1);
            if ($temp) {
                $wherein .= "'" . $temp . "',";
            }
        }
        $wherein = trim($wherein, ',');
        if ($wherein) {
            $wheresql .= " AND A.sale_type IN (" . $wherein . ")";
        }
    }
    //
    $fields = 'A.*,B.userid,B.id AS idB,B.indate AS indateB,B.update AS updateB,B.sendnum';
    $lists = db_getlist('SELECT '.$fields.' FROM '.table('sale').' A INNER JOIN '.table('users_sale').' B ON A.id=B.saleid',
        $wheresql, 'B.id DESC', $row, $page);
    $newarr = array();
    $newarr['A'] = array();   //全部
    $newarr['B'] = array();   //可用的
    $newarr['C'] = array();   //已使用
    $newarr['D'] = array();   //过期的
    $newarr['E'] = array();   //不可用
    foreach($lists['list'] AS $key=>$item) {
        if ($item['end_type'] == 'day') {
            $item['enddate'] = $item['end_day'] * 86400 + $item['indateB'];
        } elseif ($item['end_type'] == 'each') {
            if ($item['end_each'] == 'year') {
                $item['enddate'] = mktime(23, 59, 59, 12, 31, date('Y',$item['indateB']));
            } elseif ($item['end_each'] == 'month') {
                $item['enddate'] = mktime(23, 59, 59, date('m',$item['indateB']), date('t',$item['indateB']), date('Y',$item['indateB']));
            } elseif ($item['end_each'] == 'week') {
                $item['enddate'] = mktime(23, 59, 59, date('m',$item['indateB']), date('d',$item['indateB']) - date('w',$item['indateB']) + 7, date('Y',$item['indateB']));
            } elseif ($item['end_each'] == 'day') {
                $item['enddate'] = mktime(23, 59, 59, date('m',$item['indateB']), date('d',$item['indateB']), date('Y',$item['indateB']));
            }
        }
        if ($item['sale_type'] == 'C') {
            //兑换券编码
            $item['exchangesn'] = '18' . zerofill($item['idB'], 8);
        }
        if ($item['status'] == '启用' && $item['enddate'] > SYS_TIME && $item['updateB'] == 0) {
            $item['status_cn'] = '可使用';
            $newarr['B'][] = $item;
        }elseif ($item['updateB'] > 0){
            $item['status_cn'] = '已使用';
            $newarr['C'][] = $item;
        }elseif ($item['enddate'] <= SYS_TIME){
            $item['status_cn'] = '已过期';
            $newarr['D'][] = $item;
        }else{
            $item['status_cn'] = '不可用';
            $newarr['E'][] = $item;
        }
        $newarr['A'][] = $item;
    }
    $lists['list'] = $newarr;
    return $lists;
}

/**
 * 根据会员优惠券ID获取优惠券详情
 */
function user_sale_info($idB) {
    $fields = 'A.*,B.userid,B.id AS idB,B.indate AS indateB,B.update AS updateB,B.sendnum';
    $item = db_getone('SELECT '.$fields.' FROM '.table('sale').' A INNER JOIN '.table('users_sale').' B ON A.id=B.saleid', "B.id=".$idB." AND A.sale_type='C'");
    if ($item) {
        if ($item['end_type'] == 'day') {
            $item['enddate'] = $item['end_day'] * 86400 + $item['indateB'];
        } elseif ($item['end_type'] == 'each') {
            if ($item['end_each'] == 'year') {
                $item['enddate'] = mktime(23, 59, 59, 12, 31, date('Y',$item['indateB']));
            } elseif ($item['end_each'] == 'month') {
                $item['enddate'] = mktime(23, 59, 59, date('m',$item['indateB']), date('t',$item['indateB']), date('Y',$item['indateB']));
            } elseif ($item['end_each'] == 'week') {
                $item['enddate'] = mktime(23, 59, 59, date('m',$item['indateB']), date('d',$item['indateB']) - date('w',$item['indateB']) + 7, date('Y',$item['indateB']));
            } elseif ($item['end_each'] == 'day') {
                $item['enddate'] = mktime(23, 59, 59, date('m',$item['indateB']), date('d',$item['indateB']), date('Y',$item['indateB']));
            }
        }
        $item['exchangesn'] = '18' . zerofill($item['idB'], 8);
        $item['userinfo'] = db_getone(table('users'), array('id'=>$item['userid']));
    }
    //
    $info = array();
    if ($item['status'] == '启用' && $item['enddate'] > SYS_TIME && $item['updateB'] == 0) {
        $item['cancel_ids'] = explode_int(',', $item['cancel_ids']);
        $info = $item;
    }
    return $info;
}

/**
 * 根据订单获取适用的优惠券
 * @param $orderinfo
 * @return array
 */
function my_order_sale($orderinfo) {
    global $_A;
    //
    if (intval($orderinfo['id']) == 0 || $orderinfo['retmoney'] <= 0) {
        return array();
    }
    $lists = user_sales($_A['user']['id'], 500, 1, 'TPF');
    $array = $lists['list']['B']; //可用的
    if (empty($array)) {
        return array();
    }
    $inorder = array();
    //判断满足可用 及 重新按最大低值金额排序
    foreach ($array AS $key=>$item) {
        if ($item['min'] > 0 && $orderinfo['retmoney'] < $item['min']) {
            unset($array[$key]);
        }else{
            if ($item['sale_type'] == 'T') {
                $saleMoney = $orderinfo['retmoney'] - cdb_totalMoney($orderinfo['indate'], $orderinfo['retdate'], $item['sale']);
            }elseif ($item['sale_type'] == 'P') {
                $saleMoney = $item['sale'] / 100 * $orderinfo['retmoney'];
            }elseif ($item['sale_type'] == 'F') {
                $saleMoney = $item['sale'];
            }else{
                continue;
            }
            if ($saleMoney >= 0) {
                $inorder[$key] = $saleMoney;
                $array[$key]['saleMoney'] = $saleMoney;
            }else{
                unset($array[$key]);
            }

        }
    }
    array_multisort($inorder, SORT_DESC, $array);
    //
    return $array;
}

/**
 * 标记优惠券已使用
 * @param int $idB      用户优惠券ID
 * @param int $orderid  订单ID
 * @return bool
 */
function used_users_sale($idB, $orderid){
    if ($idB > 0 && $orderid > 0) {
        $row = db_getone(table('users_sale'), array('id'=>$idB));
        if ($row) {
            $sale = db_getone(table('sale'), array('id'=>$row['saleid']));
            $array = array(
                'saleinfo'=>    array2string($sale),
                'orderid'=>     $orderid,
                'update'=>      SYS_TIME
            );
            db_update(table('users_sale'), $array, array('id'=>$row['id']));
        }
        return true;
    }
    return false;
}

/**
 * 获取关联账号切换
 * @param $userid
 * @return array|mixed
 */
function user_switch($userid){
    $user = db_getone(table('users'), array('id'=>$userid));
    $list = array();
    if ($user) {
        $list = db_getall(table('users'), "`userphone` LIKE '".runMobile($user['userphone'])."%'");
    }
    return $list;
}

/**
 * 获取顶级主账号
 * @param $userinfo
 * @return mixed
 */
function masterUser($userinfo) {
    if ($userinfo['masterid'] > 0) {
        $masteruser = db_getone(table('users'), array('id'=>$userinfo['masterid']));
        if ($masteruser) {
            return masterUser($masteruser);
        }
    }
    return $userinfo;
}

/**
 * 可以租用多少台设备
 */
function depositNum() {
    global $_A;
    return intval(db_count(table('pay'), array('userid'=>$_A['user']['id'], 'type'=>'deposit', 'status'=>'已付款')));
}

/**
 * 可用押金pay数据
 */
function depositPay() {
    global $_A;
    return db_getone(table('pay'), array('userid'=>$_A['user']['id'], 'type'=>'deposit', 'status'=>'已付款'));
}

/**
 * 页面提示
 * @param string $title
 * @param string $msg
 * @return string
 */
function page_tis($title = '', $msg = '') {
    if ($msg == '' && $title != '') {
        $msg = $title;
        $title = '';
    }
    if ($title) {
        echo '<script>$JS = {title: "'.$title.'"}</script>';
    }
    echo "<div style='margin:50px 10px;text-align:center;font-size:15px;color:#888'>".nullshow($msg, '抱歉，您访问的页面不存在……')."</div>";
    exit();
}

/**
 * 检查是否登录
 */
function user_check() {
    global $_A;
    if (empty($_A['user']['id'])) {
        echo '<script>
            $JS = {
                created: function(noToast) {
                    var self = this;
                    if (noToast !== true) $A.toast("登录超时，请重新登录！");
                    $A.login(function(){ self.pullToRefreshTrigger(); });
                },
                activated: function() {
                    if (parseInt($A.user.id) === 0) $A.routerBack(-1);
                }
            }
        </script>';
        page_tis('<div onclick="$JS.created(true);">登录超时，点击这里重新登录！</div>');
    }
}

/**
 * 获取用户支付openid
 */
function wx_pay_openid() {
    global $_A;
    //
    if ($_A['browser'] != 'weixin') {
        return '';
    }
    $CI = & get_instance();
    $CI->load->library('wx');
    return $CI->wx->pay_openid();
}

/**
 * 获取证书路径
 * @param $key
 * @param bool $isOld
 * @return string
 */
function payCert($key, $isOld = false)
{
    $pay_cert = setting($isOld===true?'old_pay_cert':'pay_cert');
    if (isset($pay_cert[$key])) {
        $certpath = BASE_PATH . DIRECTORY_SEPARATOR . 'caches' . DIRECTORY_SEPARATOR . 'paycert' . DIRECTORY_SEPARATOR;
        make_dir($certpath);
        if ($isOld === true) { $certpath.= 'old_'; }
        $certpath.= $key.'.pem';
        $certText = $pay_cert[$key];
        file_put_contents($certpath, $certText);
        if (file_exists($certpath)) {
            return $certpath;
        }
    }
    return '';
}
/**
 * 获取广告图片的
 * @param $type
 * @param $second
 * @param $httpType
 * @param $data
 * @return array
 */
function getNewList($type=null,$httpType='get',$second=30,$data = ''){

    $url="https://api.gengdian.net/v2/other/news";
    if(isset($type)){
        $url=$url."?type=".$type;
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
    //  var_dump($result);
    if($result){
        // 关闭cURL资源，并且释放系统资源
        curl_close($ch);
        return $result;
    } else {
        $error = curl_errno($ch);
        curl_close($ch);
        throw new WxPayException("curl出错，错误码:$error");
    }


}