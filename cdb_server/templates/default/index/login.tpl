<!DOCTYPE html>
{#_head_html()#}
<head>
    <title>{#$_A['BASE_NAME']#}</title>
    <meta http-equiv="content-type" content="text/html; charset=utf-8" />
    <meta name="renderer" content="webkit">
    <meta http-equiv="X-UA-Compatible" content="IE=Edge,chrome=1" />
    <link rel="stylesheet" type="text/css" href="{#$TEM_PATH#}assets/css/index.css"/>
    <script type="text/javascript" src="{#$JS_PATH#}jquery.min.js"></script>
    <script type="text/javascript" src="{#$JS_PATH#}jquery.alert.js"></script>
    <script type="text/javascript" src="{#$JS_PATH#}jquery.form.min.js"></script>
    <script type="text/javascript" src="{#$JS_PATH#}artdialog/artDialog.js?skin=default"></script>
</head>
<body>

<div class="login">
    <div class="message">{#$_A['BASE_NAME']#} - 系统登录</div>
    <div id="darkbannerwrap"></div>

    <form action="{#urlApi('users/login')#}" method="post" id="saveform">
        <input name="userphone" placeholder="请输入手机号码" required="" type="text">
        <hr class="hr15">
        <input name="userpass" placeholder="请输入密码" required="" type="password">
        <hr class="hr15">
        <input value="登录" style="width:100%;" type="submit">
        <hr class="hr20">
    </form>

</div>

<div class="copyright">© {#date("Y")#} {#$_A['BASE_NAME']#}</div>

<script type="text/javascript">
    $(function(){
        $('#saveform').submit(function() {
            $.alert('登录中...', 0);
            //
            $(this).ajaxSubmit({
                dataType : 'json',
                success : function (data) {
                    if (data !== null && data.success !== null && data.success) {
                        $.alert(data.message);
                        setTimeout(function(){
                            window.location.href = "{#$_GPC['ctx']#}";
                        }, 500);
                    } else {
                        $.alertk(data.message);
                    }
                },
                error : function () {
                    $.alertk("网络繁忙，请稍后再试！");
                }
            });
            return false;
        });
    });
</script>
</body>
</html>