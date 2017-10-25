{#*关于我们*#}

<div style="line-height:18px;background:#ffffff;text-align:center;font-size:16px;padding:0 0 20px 0">

    <img style="width: 40%;margin-top: 20px;" src="{#$TEM_PATH#}assets/images/logo2.png">
    <p>G电共享电源</p>
    <p style="padding-bottom:50px">v<span id="version"></span></p>

    <p>联系电话：{#settingfind('system', 'tel_num')#}</p>
    <p>客服QQ：1925688583</p>
    <p>电子邮箱：1925688583@qq.com</p>
    <p style="padding-bottom:50px">官方网站：www.gengdian.net</p>

    <p>&copy;广西更电科技有限公司</p>
</div>
<script>
    $JS = {
        created: function() {
            $A.apiReady(function(){
                $JS.$el.find("#version").text(api.appVersion);
            }, null, true);
        },
        refresh: false
    };
</script>