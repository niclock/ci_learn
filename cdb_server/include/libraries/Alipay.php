<?php
require_once 'alipay/AopSdk.php';

class Alipay
{
    var $HOST = 'https://openapi.alipay.com/gateway.do';
    public $config;

    public function __construct()
    {
        $setting = setting('pay');
        $this->config = $setting['alipay'];
    }

    /**
     * 设置参数
     * @param $arr
     */
    public function config($arr)
    {
        if ($arr && is_array($arr)) {
            foreach ($arr AS $key=>$val) {
                $this->config[$key] = $val;
            }
        }
    }

    /**
     * 生成订单参数
     * @param $array
     * @return string
     */
    public function orderInfo($array)
    {
        $aop = new AopClient;
        $aop->gatewayUrl = $this->HOST;
        $aop->appId = $this->config['appid'];
        $aop->rsaPrivateKey = $this->config['rsaprikey'];
        $aop->format = "json";
        $aop->charset = "UTF-8";
        $aop->signType = "RSA";
        $aop->alipayrsaPublicKey = $this->config['rsapublickey'];
        //
        $request = new AlipayTradeAppPayRequest();
        $request->setNotifyUrl(url('payment/alipay_notify'));
        $request->setBizContent(json_encode($array));
        //
        return $aop->sdkExecute($request);
    }

    /**
     * 通知验证
     * @return bool
     */
    public function notifyCheck()
    {
        $aop = new AopClient;
        $aop->alipayrsaPublicKey = $this->config['rsapublickey'];
        return $aop->rsaCheckV1($_POST, NULL, "RSA");
    }

    /**
     * 退款接口
     * @param $array
     * @return array
     */
    public function refund($array)
    {
        $aop = new AopClient ();
        $aop->gatewayUrl = $this->HOST;
        $aop->appId = $this->config['appid'];
        $aop->rsaPrivateKey = $this->config['rsaprikey'];
        $aop->alipayrsaPublicKey = $this->config['rsapublickey'];
        $aop->apiVersion = '1.0';
        $aop->signType = 'RSA';
        $aop->postCharset = 'UTF-8';
        $aop->format = 'json';
        //
        $request = new AlipayTradeRefundRequest ();
        $request->setBizContent(json_encode($array));
        $result = $aop->execute($request);
        //
        $responseNode = str_replace(".", "_", $request->getApiMethodName()) . "_response";
        return object_array($result->$responseNode);
    }

}