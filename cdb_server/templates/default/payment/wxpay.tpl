{#*微信支付接口*#}
<!--jspage_top-->
<script type="text/javascript">
    var ___wxpay_app = function() {
        api.showProgress({title: '', text: '正在加载', modal: true});
        setTimeout(function(){ api.hideProgress(); }, 2000);
        var data = {#json_encode($arr)#};
        var payOK = '{#$_GPC['payok']#}';
        var payErr = '{#$_GPC['payerr']#}';
        if (typeof data !== 'object') data = {};
        //
        if (data !== null && data.success !== null && data.success) {
            //支付
            var wxPay = api.require('wxPay');
            wxPay.config({
                apiKey: data.setting.app_appid,
                mchId: data.setting.app_mchid,
                partnerKey: data.setting.app_apikey,
                notifyUrl: data.setting.notifyurl
            }, function(ret, err){
                if (ret.status){
                    //配置支付成功
                    wxPay.pay({
                        description: data.setting.subject,
                        totalFee: data.setting.total_fee,
                        tradeNo: '{#$payid#}',
                        detail: data.setting.body,
                        attach: '{#$orderid#}',
                        feeType: 'CNY',
                        timeStart: '{#date("YmdHis", $smarty.const.SYS_TIME)#}',
                        timeExpire: '{#date("YmdHis", ($smarty.const.SYS_TIME + 600))#}',
                        goodsTag: data.setting.subject
                    },function(rep, err){
                        //支付返回
                        if (rep.status){
                            api.toast({msg:"支付成功！", location:'bottom'});
                            eval("if (typeof " + payOK + " === 'function') { " + payOK + "('wxpay'); }");
                        }else{
                            if (err.code === -1) err.code = '系统维护，请选择其他支付方式';
                            if (err.code === -2) err.code = '用户取消';
                            api.toast({msg:"支付失败：" + err.code + " " + (err.msg || ''), location:'bottom'});
                            eval("if (typeof " + payErr + " === 'function') { " + payErr + "('" + rep.code + "', 'wxpay'); }");
                        }
                    });
                }else{
                    api.toast({msg:"加载支付失败！", location:'bottom'});
                }
            });
        }else{
            api.toast({msg:data.message, location:'bottom'});
        }
    };
    ___wxpay_app();
</script>
<!--jspage_bottom-->