<?php
defined('BASEPATH') OR exit('No direct script access allowed');

require_once(dirname(__FILE__) . '/' . '../../libraries/weixin/WxPay.Api.php');
require_once(dirname(__FILE__) . '/' . '../../libraries/weixin/WxPay.Notify.php');
require_once("notify.php");

/**
 * 微信支付
 * Class PayNotifyCallBack
 */
class PayNotifyCallBack extends WxPayNotify
{
    /**
     * 查询订单并处理
     * @param $transaction_id
     * @return bool
     */
    public function Queryorder($transaction_id)
    {
        $input = new WxPayOrderQuery();
        $input->SetTransaction_id($transaction_id);
        $result = WxPayApi::orderQuery($input);
        if (array_key_exists("return_code", $result)
            && array_key_exists("result_code", $result)
            && $result["return_code"] == "SUCCESS"
            && $result["result_code"] == "SUCCESS")
        {
            $notify = payment_notify($result['out_trade_no'], '微信', WXPC_PAYTYPE);
            if (!is_error($notify)) {
                return true;
            }
        }
        return false;
    }

    /**
     * 重写回调处理函数
     * @param array $data
     * @param string $msg
     * @return bool
     */
    public function NotifyProcess($data, &$msg)
    {
        if(!array_key_exists("transaction_id", $data)){
            $msg = "输入参数不正确";
            return false;
        }
        //查询订单，判断订单真实性
        if(!$this->Queryorder($data["transaction_id"])){
            $msg = "订单查询失败";
            return false;
        }
        return true;
    }
}
