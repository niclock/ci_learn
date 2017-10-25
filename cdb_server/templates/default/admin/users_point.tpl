<!DOCTYPE html>
{#_head_html()#}
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=Edge,chrome=1" />
    <title>管理中心 - {#$_A['BASE_NAME']#}</title>
    <link href="{#$NOW_PATH#}css/public.css" rel="stylesheet" type="text/css">
    <script type="text/javascript" src="{#$JS_PATH#}jquery.min.js"></script>
    <script type="text/javascript" src="{#$JS_PATH#}jquery.alert.js"></script>
    <script type="text/javascript" src="{#$JS_PATH#}jquery.form.min.js"></script>
    <script type="text/javascript" src="{#$NOW_PATH#}js/global.js"></script>
    <script type="text/javascript" src="{#$NOW_PATH#}js/jquery.tab.js"></script>
    <script type="text/javascript" src="{#$JS_PATH#}My97DatePicker/WdatePicker.js"></script>
    <script type="text/javascript">
        $(function(){
            $(".mainBox").css('min-height', $(window).height() - 195);
        });
    </script>
    <style type="text/css">
        th a{text-decoration:underline;}
        th a:hover{color:#00A0E9;}
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
        .btnGray.cancel{color:red;background-color:#fff;padding:6px 5px;font-weight:400;text-decoration:underline;float:right;margin-right:10px;}
        .btnGray.cancel:hover{color:#ff947a}
        .subtitle{float:right;color:#bbb;padding-left:3px;}
        .userid{float:right;color:#BBBBBB}
        .userid:hover{color:#4AA8EC}
    </style>
</head>
<body>
<div id="dcWrap">

    {#tpl('_top')#}
    <!-- dcHead 结束 -->
    {#tpl('_left', 'users_point')#}


    <div id="dcMain">
        <!-- 当前位置 -->
        <div id="urHere">管理中心<b>&gt;</b><strong>会员积分账户</strong> </div>
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
                    <li><a href="#main">积分记录</a></li>
                    <li><a href="#change">积分操作</a></li>
                </ul>
                <div class="items">
                    <div id="main" class="tabbody">
                        <div class="filter" style="margin-top:15px;margin-left:0;">
                            <form action="{#url(0)#}" method="get" class="filtertable" id="filtertable">
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
                                                    <div>时间筛选</div>
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
                                            <div class="filterlr">
                                                <div class="filterl">
                                                    <div>推广员ID</div>
                                                    <input name="from_id" type="text" class="inpMain" value="{#$_GPC['from_id']#}"/>
                                                </div>
                                                <div class="filterr">
                                                    <div>订单 ID</div>
                                                    <input name="orderid" type="text" class="inpMain" value="{#$_GPC['orderid']#}"/>
                                                </div>
                                            </div>
                                        </td>
                                        <td class="last">
                                            <div>业务名称</div>
                                            <input name="keyword" type="text" class="inpMain" value="{#$_GPC['keyword']#}"/>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="3" class="fill">
                                            <input class="btnGray" name="submit" type="submit" value="" style="display:none;"/>
                                            <input class="btnGray excel" name="submit" type="submit" value="导出Excel" />
                                            <input class="btnGray" name="submit" type="submit" value="搜索" />
                                            {#if $_where != $wheresql#}
                                                <a class="btnGray status cancel" href="{#url(0)#}">取消筛选</a>
                                            {#/if#}
                                        </td>
                                    </tr>
                                </table>
                            </form>
                        </div>

                        <table width="100%" border="0" cellpadding="8" cellspacing="0" class="tableBasic">
                            <tr>
                                <th width="50" align="center">{#get_by_order('数据ID', 'id', 'page')#}</th>
                                <th width="120" align="left">{#get_by_order('流水号', 'indate', 'page')#}</th>
                                <th align="left">会员昵称</th>
                                <th align="left">手机号码</th>
                                <th align="left">类型</th>
                                <th align="left">业务名称</th>
                                <th align="center">{#get_by_order('变化(元)', 'setup', 'page')#}</th>
                                <th align="center">剩余</th>
                                <th align="center">推广员ID</th>
                                <th align="center">{#get_by_order('时间', 'indate', 'page')#}</th>
                            </tr>
                            {#foreach from=$lists['list'] item=item#}
                                <tr data-id="{#$item.id#}" data-img="{#$item.userimg|fillurl#}" data-username="{#$item['username']#}">
                                    <td align="center">{#$item['id']#}</td>
                                    <td>{#$item['id']#}{#$item['indate']#}</td>
                                    <td class="unamebox avatar">
                                        {#if $item.userimg#}
                                            <img data-src="{#$item.userimg|fillurl#}" src="{#$item.userimg|avatar_fillurl:"/46"#}">
                                        {#/if#}
                                        {#$item['username']#}
                                        <a title="点击查看会员资料" class="userid" href="{#url('admin/users')#}?userid={#$item['userid']#}">会员ID:{#$item['userid']#}</a>
                                    </td>
                                    <td>{#$item['userphone']#}</td>
                                    <td align="left">
                                        {#if $item['type']=='money'#}余额{#/if#}
                                        {#if $item['type']=='point'#}积分{#/if#}

                                        {#if $item['subtype']#}
                                            <div class="subtitle">{#$item['subtype']#}</div>
                                        {#/if#}
                                    </td>
                                    <td>
                                        {#$item['title']#}
                                        {#if $item['orderid']#}
                                            <a href="{#url('admin/orderinfo')#}?id={#$item['orderid']#}" class="subtitle">订单ID:{#$item['orderid']#}</a>
                                        {#/if#}
                                        {#if $item['subtitle']#}
                                            <div class="subtitle">状态:{#$item['subtitle']#}</div>
                                        {#/if#}
                                    </td>
                                    <td align="center">
                                        {#floatval($item['setup'])#}
                                    </td>
                                    <td align="center">
                                        {#floatval($item['after'])#}
                                    </td>
                                    <td align="center">
                                        {#if $rolofromid#}
                                            {#if $item['from_id']#}
                                                <a href="{#url('admin/users_point')#}?userid={#$item['from_id']#}" title="点击查看推广员积分记录">{#$item['from_id']#}</a>
                                            {#else#}
                                                -
                                            {#/if#}
                                        {#else#}
                                            {#if $item['from_id']#}
                                                有
                                            {#else#}
                                                -
                                            {#/if#}
                                        {#/if#}
                                    </td>
                                    <td align="center">{#date("Y-m-d H:i:s", $item['indate'])#}</td>
                                </tr>
                                {#foreachelse#}
                                <tr>
                                    <td colspan="10" align="center">暂无数据</td>
                                </tr>
                            {#/foreach#}
                        </table>
                        <div id="pagelist">
                            <a href="javascript:void(0);" style="cursor:default">总数量{#$lists['total']#}个</a>
                            {#$lists['page_html']#}
                        </div>
                    </div>
                    <div id="change" class="tabbody">
                        <form action="{#get_url()#}" method="post" id="changeform">
                            <table width="100%" border="0" cellpadding="8" cellspacing="0" class="tableBasic tableAuto">
                                <tr>
                                    <td width="110" align="right">选择会员</td>
                                    <td>
                                        <div class="inpBox" style="display:inline-block;">
                                            <input type="hidden" name="userid" value="0">
                                            <input type="text" value="" size="50" class="inpMain" placeholder="输入会员姓名/手机号查找" onkeydown="return _ifenter(this);"/><input type="button" value="搜索" class="inpMain inpMain-s" onclick="_getuser(this);">
                                            <ul></ul>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td align="right">增减数量</td>
                                    <td>
                                        <label><input type="radio" class="check" name="type" value="1" checked>增加</label>　
                                        <label><input type="radio" class="check" name="type" value="0">减少</label>
                                        <label style="margin-left:10px;">
                                            <input type="text" name="number" value="0" size="10" class="inpMain" />
                                        </label>
                                    </td>
                                </tr>
                                <tr>
                                    <td align="right">操作说明</td>
                                    <td>
                                        <textarea name="content" class="inpMain" rows="3" cols="60"></textarea>
                                    </td>
                                </tr>
                                <tr>
                                    <td></td>
                                    <td>
                                        <input class="btn" type="submit" value="提交" />
                                        <input class="btnGray" id="resetchange" type="reset" value="重置" />
                                        <label style="margin-left:5px;"><input type="checkbox" class="check" name="addplus" value="1" checked>同时增减到累计积分</label>　
                                        <input type="hidden" name="act" value="change">
                                    </td>
                                </tr>
                            </table>
                        </form>
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

<div class="translucentbackground" style="display:none" onclick="_hidetranbg(this);"></div>
<script type="text/javascript">
    function _hidetranbg(obj) {
        $(obj).hide();
        $(".inpBox>ul").hide();
    }
    function _ifenter(obj) {
        var e = event;
        var keyNum = e.which || e.keyCode;
        if(keyNum==13){
            $(obj).next("input[type='button']").click();
            return false;
        }
    }
    function _getuser(obj) {
        var tthis = $(obj),
                key = tthis.prev("input").val();
        $.alert('正在搜索...', 0);
        $(".translucentbackground").show();
        $.ajax({
            type: 'POST',
            url: '{#get_url('act|key')#}',
            data: {
                act: 'getuser',
                key:tthis.prev("input").val()
            },
            dataType: 'html',
            success: function(html) {
                if (html.indexOf("data-id") == -1) {
                    $.alert("没有搜索到任何数据");
                    tthis.next("ul").html("").hide();
                    $(".translucentbackground").hide();
                }else{
                    $.alert(0);
                    var $intemp = $(html);
                    $intemp.click(function(){
                        tthis.parents("td").find("input[name='userid']").val($(this).attr("data-id"));
                        tthis.prev("input").val($(this).attr("data-title"));
                        tthis.next("ul").hide();
                        $(".translucentbackground").hide();
                    });
                    tthis.next("ul").html($intemp).show();
                }
            }
        });
    }
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
        //增减事件
        $('#changeform').submit(function() {
            //
            $.alert('正在提交...', 0);
            $(this).ajaxSubmit({
                dataType : 'json',
                success : function (data) {
                    if (data != null && data.success != null && data.success) {
                        $.confirm({
                            title: data.message,
                            button: [{
                                title: '完成操作',
                                click: function(){
                                    $(".idTabs .tab li:eq(0) a").click();
                                    window.location.reload();
                                }
                            }, {
                                title: '继续操作',
                                click: function(){
                                    $("#changeform").find("textarea[name='content']").val("");
                                }
                            }]
                        });
                    } else {
                        $.alertk(data.message);
                    }
                },
                error : function () {
                    $.alertk("提交失败！");
                }
            });
            return false;
        });
    });
</script>
</body>
</html>