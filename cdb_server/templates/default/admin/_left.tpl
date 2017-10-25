<div id="dcLeft">
    <div id="menu" style="display:none;">
        <ul class="top">
            <li><a href="{#url('admin')#}"><i class="home"></i><em>管理首页</em></a></li>
        </ul>
        <ul class="drawer">
            <li class="dmenu"><a href="javascript:;"><i class="system"></i><em>系统设置</em></a></li>
            <ul>
                <li><a href="{#url('admin/system')#}"><i class="system"></i><em>网站设置</em></a></li>
                <li><a href="{#url('admin/pay')#}"><i class="pay"></i><em>支付设置</em></a></li>
                <li><a href="{#url('admin/share')#}"><i class="share"></i><em>分享设置</em></a></li>
            </ul>
        </ul>
        <ul class="drawer">
            <li class="dmenu"><a href="javascript:;"><i class="weixinM"></i><em>消息设置</em></a></li>
            <ul>
                <li><a href="{#url('admin/smstmpl')#}"><i class="smstmpl"></i><em>短信通知模板</em></a></li>
            </ul>
        </ul>
        <ul class="drawer">
            <li class="dmenu"><a href="javascript:;"><i class="cancel"></i><em>产品管理</em></a></li>
            <ul>
                <li><a href="{#url('admin/cdb')#}"><i class="cdb"></i><em>设备管理</em></a></li>
            </ul>
        </ul>
        <ul class="drawer">
            <li class="dmenu"><a href="javascript:;"><i class="users"></i><em>会员管理</em></a></li>
            <ul>
                {#if $_A['_role']['users']['view']#}
                    <li><a href="{#url('admin/users')#}"><i class="users"></i><em>会员管理</em></a></li>
                {#/if#}
                <li><a href="{#url('admin/users_point')#}"><i class="users_point"></i><em>积分管理</em></a></li>
                <li><a href="{#url('admin/users_money')#}"><i class="users_money"></i><em>余额管理</em></a></li>
            </ul>
        </ul>
        <ul class="drawer">
            <li class="dmenu"><a href="javascript:;"><i class="users"></i><em>商户合作</em></a></li>
            <ul>
                <li><a href="{#url('admin/join_dealer')#}"><i class="join_dealer"></i><em>商家入驻</em></a></li>
                <li><a href="{#url('admin/join_agents')#}"><i class="join_agents"></i><em>代理商申请</em></a></li>
            </ul>
        </ul>
        <ul class="drawer">
            <li class="dmenu"><a href="javascript:;"><i class="plugin"></i><em>销售管理</em></a></li>
            <ul>
                <li><a href="{#url('admin/order')#}"><i class="order"></i><em>订单管理</em></a></li>
                {#if $_A['_role']['deposit']['view']#}
                    <li><a href="{#url('admin/deposit')#}"><i class="deposit"></i><em>押金管理</em></a></li>
                {#/if#}
            </ul>
        </ul>
        <ul class="drawer">
            <li class="dmenu"><a href="javascript:;"><i class="plugin"></i><em>营销中心</em></a></li>
            <ul>
                <li><a href="{#url('admin/sale')#}"><i class="sale"></i><em>优惠卡券</em></a></li>
            </ul>
        </ul>
        <ul class="drawer">
            <li class="dmenu"><a href="javascript:;"><i class="manager"></i><em>客服中心</em></a></li>
            <ul class="bot">
                <li><a href="{#url('admin/help')#}"><i class="help"></i><em>常见问题</em></a></li>
            </ul>
        </ul>
    </div>
</div>
<script type="text/javascript">
    var menu = $("#menu");
    {#if $param#}
        var _menu = menu.find(".{#$param#}");
        _menu.parent().parent().addClass("cur");
        _menu.parents("ul").show();
        _menu.parents("ul").prev().addClass("cur");
    {#/if#}
    menu.find("ul.drawer").each(function(){
        if ($(this).find("ul").length > 0 && $(this).find("ul").find("li").length <= 0) {
            $(this).hide();
        }
    });
    menu.show();
    $(function(){
        $(".dmenu").click(function(){
            var tthis = $(this),
                drawer = $("ul.drawer");
            if (tthis.hasClass("cur")) {
                tthis.removeClass("cur");
                tthis.next("ul").slideUp();
            }else{
                drawer.find(".dmenu").removeClass("cur");
                drawer.find("ul").hide();
                tthis.addClass("cur");
                tthis.next("ul").slideDown();
            }
        });
    });
</script>