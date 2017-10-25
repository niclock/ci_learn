{#*0元免支付*#}
<!--jspage_top-->
<script type="text/javascript">
    var ___free_app = function() {
        var payOK = '{#$_GPC['payok']#}';
        //
        api.toast({msg:"支付成功！", location:'bottom'});
        try { eval("if (typeof " + payOK + " === 'function') { " + payOK + "('free'); }") }catch (e) {}
    };
    ___free_app();
</script>
<!--jspage_bottom-->