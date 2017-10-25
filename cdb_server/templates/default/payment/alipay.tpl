{#*支付宝接口*#}
<!--jspage_top-->
<script type="text/javascript">
    var ___alipay_app = function() {
        var data = {#json_encode($arr)#};
        var payOK = '{#$_GPC['payok']#}';
        var payErr = '{#$_GPC['payerr']#}';
        if (typeof data !== 'object') data = {};
        //
        if (data !== null && data.success !== null && data.success) {
            //支付
            var aliPayPlus = api.require('aliPayPlus');
            aliPayPlus.payOrder({
                orderInfo: data.message
            }, function(rep, err) {
                if (parseInt(rep.code) === 9000) {
                    api.toast({msg:"支付成功！", location:'bottom'});
                    eval("if (typeof " + payOK + " === 'function') { " + payOK + "('alipay'); }");
                }else{
                    api.toast({msg:"支付失败：" + rep.code +" "+ (rep.statusMessage?rep.statusMessage:''), location:'bottom'});
                    eval("if (typeof " + payErr + " === 'function') { " + payErr + "('" + rep.code + "', 'alipay'); }");
                }
            });
        }else{
            api.toast({msg:data.message, location:'bottom'});
        }
    };
    ___alipay_app();
</script>
<!--jspage_bottom-->