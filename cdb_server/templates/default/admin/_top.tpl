<div id="dcHead">
    <div id="head">
        <div class="logo">
            <a href="{#url('admin')#}"><img src="{#$NOW_PATH#}images/dclogo.gif" alt="logo"></a>
        </div>
        <div class="nav">
            <ul>
                {#*<li class="M">
                    <a href="JavaScript:void(0);" class="topAdd">新建</a>
                    <div class="drop mTopad">
                        <a href="#">#</a>
                    </div>
                </li>*#}
                <li><a href="{#url()#}" target="_blank">查看站点</a></li>
            </ul>
            <ul class="navRight">
                <li class="noLeft"><a href="{#url('users')#}">您好，{#$_A['user']['username']#}</a></li>
                <li><a href="{#url()#}">首页</a></li>
                <li class="noRight"><a href="javascript:;" onclick="out();">退出</a></li>
            </ul>
        </div>
    </div>
</div>
<script type="text/javascript">
    $(function(){
        var idTabsWidth = 0;
        $(".idTabs ul li").each(function(){
            idTabsWidth+= $(this).width();
        });
        $("#dcWrap").css({'min-width': idTabsWidth + 226});
    });
    function out() {
        $.alert("稍等...", 0);
        $.ajax({
            type: "POST",
            url: "{#urlApi('users/out')#}",
            dataType: 'json',
            success: function (data) {
                if (data !== null && data.success !== null && data.success) {
                    $.alert(data.message);
                    setTimeout(function(){
                        window.location.reload();
                    }, 500);
                } else {
                    $.alertk(data.message);
                }
            },error : function () {
                $.alert("网络繁忙，请稍后再试！");
            }
        });
    }
</script>