<!DOCTYPE html>
{#_head_html()#}
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=Edge,chrome=1" />
    <title>管理中心 - {#$_A['BASE_NAME']#}</title>
    <link href="{#$NOW_PATH#}css/public.css" rel="stylesheet" type="text/css">
    <style type="text/css">
        .avatar{height:30px;line-height:30px;}
        .avatar img{vertical-align:middle;width:26px;padding-right:3px}
        #text-tooltip{position:absolute;background-color:#fff;padding:8px;border:1px solid #cc7116}
        #text-tooltip img{display:block;margin:10px 0 0;max-width:300px;max-height:300px}
        .filtertable,.filtertable table{width:100%}
        .filtertable table tr td{width:33.3%;padding-right:20px;-webkit-box-sizing:border-box;-moz-box-sizing:border-box;box-sizing:border-box}
        .filtertable table tr td.last{width:33.3%;padding-right:0}
        .filtertable table tr td.fill{width:99.9%;padding-right:0}
        .filtertable table tr td div{display:block;font-weight:700}
        .filtertable table tr td input,.filtertable table tr td select{display:block;width:100%;margin-bottom:10px;-webkit-box-sizing:border-box;-moz-box-sizing:border-box;box-sizing:border-box}
        .filtertable table tr td input.btnGray{width:100px;float:right;background-color:#4AA8EC;color:#fff}
        .filtertable table tr td input.excel{margin-left:10px;background-color:#EEE;color:#666}
        .filtertable .filterlr .filterl{width:49.8%;float:left;}
        .filtertable .filterlr .filterr{width:49.8%;float:right;}
        .subtitle{float:right;color:#bbb;padding-left:3px;}
        .btnGray.cancel{color:red;background-color:#fff;padding:6px 5px;font-weight:400;text-decoration:underline;float:right;margin-right:10px;}
        .btnGray.cancel:hover{color:#ff947a}
        .userid{float:right;color:#BBBBBB}
        .userid:hover{color:#4AA8EC}
    </style>
    <script type="text/javascript" src="{#$JS_PATH#}jquery.min.js"></script>
    <script type="text/javascript" src="{#$JS_PATH#}jquery.alert.js"></script>
    <script type="text/javascript" src="{#$JS_PATH#}jquery.form.min.js"></script>
    <script type="text/javascript" src="{#$JS_PATH#}My97DatePicker/WdatePicker.js"></script>
    <script type="text/javascript" src="{#$NOW_PATH#}js/global.js"></script>
    <script type="text/javascript" src="{#$NOW_PATH#}js/jquery.tab.js"></script>
    <script type="text/javascript">
        $(function(){
            $(".mainBox").css('min-height', $(window).height() - 195);
        });
    </script>
</head>
<body>
<div id="dcWrap">

    {#tpl('_top')#}
    <!-- dcHead 结束 -->
    {#tpl('_left', 'sale')#}

    <div id="dcMain">
        <!-- 当前位置 -->
        <div id="urHere">管理中心<b>&gt;</b><strong>{#sale_name()#}</strong><b>&gt;</b><strong>【{#$sale['title']#}】发放记录</strong> </div>
        <div id="index" class="mainBox" style="padding-top:18px;height:auto!important;min-height:550px;">

            <script type="text/javascript">
                $(function(){
                    var idTabs = $(".idTabs");
                    idTabs.idTabs();
                    idTabs.find(".tab li a[href='"+getcookie('__:idTabs:{#$_A['segments'][2]#}')+"']").click();
                    idTabs.find(".tab li a").click(function(){var href = $(this).attr("href"); if (href.substring(0,1) == "#"){ addCookie("__:idTabs:{#$_A['segments'][2]#}", href); }});
                });
            </script>

            <div class="idTabs">
                <ul class="tab">
                    <li><a href="#main">记录列表</a></li>
                </ul>
                <div class="items">
                    <div id="main" class="tabbody">

                        <div class="filter" style="margin-top:15px;margin-left:0;">
                            <form action="{#url(0)#}" method="get" class="filtertable" id="filtertable">
                                <input type="hidden" name="id" value="{#$_GPC['id']#}">
                                <table>
                                    <tr>
                                        <td>
                                            <div>会员 ID</div>
                                            <input name="userid" type="text" class="inpMain" value="{#$_GPC['userid']#}"/>
                                        </td>
                                        <td>
                                            <div>手机号码</div>
                                            <input name="userphone" type="text" class="inpMain" value="{#$_GPC['userphone']#}"/>
                                        </td>
                                        <td class="last">
                                            <div class="filterlr">
                                                <div class="filterl">
                                                    <div>领取时间</div>
                                                    <input id="stime" name="stime" value="{#$_GPC['stime']#}" onclick="WdatePicker({maxDate:'#F{$dp.$D(\'etime\')}'})" class="inpMain">
                                                </div>
                                                <div class="filterr">
                                                    <div>至</div>
                                                    <input id="etime" name="etime" value="{#$_GPC['etime']#}" onclick="WdatePicker({minDate:'#F{$dp.$D(\'stime\')}'})" class="inpMain">
                                                </div>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <div>会员昵称</div>
                                            <input name="username" type="text" class="inpMain" value="{#$_GPC['username']#}"/>
                                        </td>
                                        <td>
                                            <div>数据 ID</div>
                                            <input name="dataid" type="text" class="inpMain" value="{#$_GPC['dataid']#}"/>
                                        </td>
                                        <td class="last">
                                            <div>订单 ID</div>
                                            <input name="orderid" type="text" class="inpMain" value="{#$_GPC['orderid']#}"/>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="3" class="fill">
                                            <input class="btnGray" name="submit" type="submit" value="" style="display:none;"/>
                                            <input class="btnGray excel" name="submit" type="submit" value="导出Excel" />
                                            <input class="btnGray" name="submit" type="submit" value="搜索" />
                                            {#if $_where != $wheresql#}
                                                <a class="btnGray cancel" href="{#url(0)#}?id={#$_GPC['id']#}">取消筛选</a>
                                            {#/if#}
                                        </td>
                                    </tr>
                                </table>
                            </form>
                        </div>

                        <form name="action" method="post" action="{#url(0)#}" id="saveform">
                            <table width="100%" border="0" cellpadding="8" cellspacing="0" class="tableBasic">
                                <tr>
                                    <th width="50" align="center">数据ID</th>
                                    <th align="left">会员昵称</th>
                                    <th align="left">手机号码</th>
                                    <th align="left">领取端口</th>
                                    <th align="left">领取时间</th>
                                    <th align="left">到期时间</th>
                                    <th align="left">使用时间</th>
                                    <th align="left">使用方式</th>
                                    <th width="60" align="center">操作</th>
                                </tr>
                                {#foreach from=$lists['list'] item=item#}
                                    <tr data-id="{#$item.id#}" data-img="{#$item.userimg|fillurl#}" data-username="{#$item['username']#}">
                                        <td align="center">{#$item['id']#}</td>
                                        <td class="unamebox avatar">
                                            {#if $item.userimg#}
                                                <img data-src="{#$item.userimg|fillurl#}" src="{#$item.userimg|avatar_fillurl:"/46"#}">
                                            {#/if#}
                                            {#$item['username']#}
                                            <a title="点击查看会员资料" class="userid" href="{#url('admin/users')#}?userid={#$item['userid']#}">会员ID:{#$item['userid']#}</a>
                                        </td>
                                        <td>{#$item['userphone']#}</td>
                                        <td>
                                            {#if $item['from']#}
                                                {#$item['from']#}
                                            {#else#}
                                                -
                                            {#/if#}

                                        </td>
                                        <td>{#date("Y-m-d H:i:s", $item['indate'])#}</td>
                                        <td>
                                            {#date("Y-m-d H:i:s", $item['enddate'])#}
                                            <div class="subtitle">{#$item['status_cn']#}</div>
                                        </td>
                                        <td>
                                            {#if $item['update']#}
                                                {#date("Y-m-d H:i:s", $item['update'])#}
                                            {#else#}
                                                -
                                            {#/if#}
                                        </td>
                                        <td>
                                            {#if $item['update']#}
                                                {#$saleinfo = string2array($item['saleinfo'])#}
                                                {#if $saleinfo['sale_type'] == 'C'#}
                                                    <a href="{#url('admin/users')#}?userid={#$item['orderid']#}">会员ID:{#$item['orderid']#}</a>
                                                {#else#}
                                                    <a href="{#url('admin/orderinfo')#}?id={#$item['orderid']#}">订单ID:{#$item['orderid']#}</a>
                                                {#/if#}
                                            {#else#}
                                                -
                                            {#/if#}
                                        </td>
                                        <td align="center">
                                            <a href="{#url('admin/sale_user_del')#}?id={#$_GPC['id']#}&did={#$item['id']#}" onclick="return confirm('确认删除吗？');return false;">删除</a>
                                        </td>
                                    </tr>
                                    {#foreachelse#}
                                    <tr>
                                        <td colspan="9" align="center">暂无记录</td>
                                    </tr>
                                {#/foreach#}
                            </table>
                        </form>
                    </div>
                    <div id="pagelist">
                        <a href="javascript:void(0);" style="cursor:default">总数量{#$lists['total']#}个</a>
                        {#$lists['page_html']#}
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="clear"></div>
    {#tpl('_foot')#}
    <!-- dcFooter 结束 -->
    <div class="clear"></div>
</div>
<script type="text/javascript">
    $(function(){
        //
        $(".avatar").find("img").mouseover(function(e){
            var _text = $(this).parents("tr").attr("data-username");
            var _img = $(this).attr("data-src");
            _img = (_img)?"<img src='"+_img+"'/>":'';
            if (!_text) return;
            $tooltip = $("<div id='text-tooltip'>"+_text+_img+"</div>"); //创建 div 元素
            $("body").append($tooltip); //把它追加到文档中
            $("#text-tooltip").css({
                "top": (e.pageY+5) + "px",
                "left":  (e.pageX+10)  + "px"
            }).show("fast");   //设置x坐标和y坐标，并且显示
        }).mouseout(function(){
            $("#text-tooltip").remove();  //移除
        }).mousemove(function(e){
            $("#text-tooltip").css({
                "top": (e.pageY+5) + "px",
                "left":  (e.pageX+10)  + "px"
            });
        });
    });
</script>
</body>
</html>