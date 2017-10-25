<!DOCTYPE html>
{#_head_html()#}
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=Edge,chrome=1" />
    <title>管理中心 - {#$_A['BASE_NAME']#}</title>
    <link href="{#$NOW_PATH#}css/public.css" rel="stylesheet" type="text/css">
    <style type="text/css">
        .Ltitle {margin:15px 0;font-size:16px;color:#666;}
        #pagelist{height:20px;margin:5px 0;}
        #pagelist a{padding:4px 10px;}
        .group_ids label {margin-right:8px;}
        .group_ids label input {vertical-align:middle;margin-top:-2px;}
        .tablerole td.top{cursor:pointer;}
        .tablerole td.top:hover{color:#1c6a9e;text-decoration:underline}
        .tablerole .role_setting strong{cursor:pointer;}
        .tablerole .role_setting strong:hover{color:#1c6a9e;text-decoration:underline}
        .dealershow{display:none}
    </style>
    <script type="text/javascript" src="{#$JS_PATH#}jquery.min.js"></script>
    <script type="text/javascript" src="{#$JS_PATH#}jquery.alert.js"></script>
    <script type="text/javascript" src="{#$JS_PATH#}jquery.form.min.js"></script>
    <script type="text/javascript" src="{#$JS_PATH#}My97DatePicker/WdatePicker.js"></script>
    <script type="text/javascript" src="{#$NOW_PATH#}js/global.js"></script>
    <script type="text/javascript" src="{#$NOW_PATH#}js/jquery.tab.js"></script>
    <script type="text/javascript" src="{#$NOW_PATH#}js/jquery.autoTextarea.js"></script>
    <script type="text/javascript" src="{#$TEM_PATH#}assets/js/receiver_json.js"></script>
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
    {#tpl('_left', 'users')#}

    <div id="dcMain">
        <!-- 当前位置 -->
        <div id="urHere">管理中心<b>&gt;</b><strong>会员列表</strong> <b>&gt;</b><strong>{#$subtitle#}会员</strong></div>
        <div id="index" class="mainBox" style="padding-top:18px;height:auto!important;min-height:550px;">

            <script type="text/javascript">
                $(function(){
                    var idTabs = $(".idTabs");
                    idTabs.find(".tab li a").click(function(){
                        var href = $(this).attr("href");
                        if (href == "#money" || href == "#point") {
                            $("#submitTable").hide();
                        }else if (href.substring(0,1) == "#"){
                            $("#submitTable").show();
                        }
                    });
                    idTabs.idTabs();
                    idTabs.find(".tab li a[href='"+getcookie('__:idTabs:{#$_A['segments'][2]#}')+"']").click();
                    idTabs.find(".tab li a").click(function(){var href = $(this).attr("href"); if (href.substring(0,1) == "#"){ addCookie("__:idTabs:{#$_A['segments'][2]#}", href); }});
                });
            </script>
            <div class="idTabs">
                <ul class="tab">
                    <li><a href="#main">基本信息</a></li>
                    <li><a href="#dealer">商家信息</a></li>
                    <li><a href="#money">余额记录</a></li>
                    <li><a href="#point">积分记录</a></li>
                    <li><a href="#role">后台权限</a></li>
                    <li><a href="{#if $_GPC['ctx']#}{#$_GPC['ctx']#}{#else#}{#url('admin/users')#}{#/if#}">返回列表</a></li>
                </ul>
                <div class="items">
                    <form action="{#get_url()#}" method="post" id="saveform">
                        <div id="main" class="tabbody">
                            <table width="100%" border="0" cellpadding="8" cellspacing="0" class="tableBasic">
                                <tr>
                                    <td width="110" align="right">会员名称</td>
                                    <td>
                                        <input type="text" name="username" value="{#$users['username']#}" size="80" class="inpMain" />
                                    </td>
                                </tr>
                                <tr>
                                    <td align="right">手机号码</td>
                                    <td>
                                        <input type="text" name="userphone" value="{#$users['userphone']#}" size="80" class="inpMain" />
                                    </td>
                                </tr>
                                <tr>
                                    <td align="right">登录密码</td>
                                    <td>
                                        <input type="text" name="userpass" value="" size="80" class="inpMain" placeholder="留空不修改，仅用于管理员登录后台使用"/>
                                    </td>
                                </tr>
                                <tr>
                                    <td align="right">邮箱地址</td>
                                    <td>
                                        <input type="text" name="useremail" value="{#$users['useremail']#}" size="80" class="inpMain" />
                                    </td>
                                </tr>
                                <tr>
                                    <td style="background-color:#F9F8FF" align="right">二维码</td>
                                    <td style="background-color:#F9F8FF">
                                        <a href="{#urlApi('other/users_qrcode')#}?sn=88{#zerofill($users['id'], 8)#}" target="_blank">
                                            <img src="{#urlApi('other/users_qrcode')#}?sn=88{#zerofill($users['id'], 8)#}" style="max-width:200px;">
                                        </a><br/>
                                        会员/商家编号：88{#zerofill($users['id'], 8)#}
                                    </td>
                                </tr>
                            </table>
                        </div>
                        <div id="dealer" class="tabbody">
                            <table width="100%" border="0" cellpadding="8" cellspacing="0" class="tableBasic tableAuto">
                                <tbody>
                                    <tr>
                                        <td width="110" align="right">是否商家</td>
                                        <td>
                                            <label><input onchange="ondealer(this);" type="radio" class="check" name="isdealer"{#che(value($users,'isdealer'),'1')#}> 是</label>　
                                            <label><input onchange="ondealer(this);" type="radio" class="check" name="isdealer"{#che(intval(value($users,'isdealer')),'0')#}> 否</label>
                                        </td>
                                    </tr>
                                    <tr class="dealershow">
                                        <td align="right"></td>
                                        <td>
                                            <label><input type="checkbox" class="check" name="istest" value="1"{#if $users['istest']#} checked{#/if#}> 是否测试店 (测试商家)</label>　
                                            <label><input type="checkbox" class="check" name="isentry" value="1"{#if $users['isentry']#} checked{#/if#}> 允许录入设备</label>　
                                        </td>
                                    </tr>
                                    <tr class="dealershow">
                                        <td align="right">设置主账号</td>
                                        <td>
                                            <div class="inpBox" style="display:inline-block;">
                                                <input type="hidden" name="masterid" value="{#$users['masterid']#}">
                                                <input type="text" onkeyup="_deluser(this)" value="{#$masterid_name#}" size="60" class="inpMain" placeholder="输入会员姓名/手机号查找" onkeydown="return _ifenter(this);"/><input type="button" value="搜索" class="inpMain inpMain-s" onclick="_getuser(this);">
                                                <ul></ul>
                                            </div> 如果设置主账号，所得收益全归主账号
                                        </td>
                                    </tr>
                                    <tr class="dealershow">
                                        <td align="right"></td>
                                        <td>
                                            <label><input type="checkbox" class="check" name="mastersync" value="1"{#if $users['mastersync']#} checked{#/if#}> 区域、位置、图片与主账号同步（设置主账号有效）</label>　
                                            <script>
                                                $("input[name='mastersync']").change(function () {
                                                    if ($(this).is(":checked")) {
                                                        $(".synchide").hide()
                                                    } else {
                                                        $(".synchide").show()
                                                    }
                                                });
                                            </script>
                                        </td>
                                    </tr>
                                </tbody>
                                <tbody class="synchide"{#if $users['mastersync']#} style="display:none"{#/if#}>
                                    <tr>
                                        <td align="right">所属区域</td>
                                        <td class="selbox">
                                            <input type="hidden" name="province_cn" value="{#$users_lbs['province_cn']#}">
                                            <input type="hidden" name="city_cn" value="{#$users_lbs['city_cn']#}">
                                            <input type="hidden" name="area_cn" value="{#$users_lbs['area_cn']#}">

                                            <select id="select1" name="province" data-val="{#$users_lbs['province']#}">
                                                <option value="0">=选择区域=</option>
                                            </select>
                                            <select id="select2" name="city" data-val="{#$users_lbs['city']#}" style="display:none;"></select>
                                            <select id="select3" name="area" data-val="{#$users_lbs['area']#}" style="display:none;"></select>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right">地址位置</td>
                                        <td>
                                            <input type="text" id="map" name="map" value="{#$users_lbs['map']['title']#}" size="60" class="inpMain" placeholder="点击打开地图标注"/>
                                            <script type="text/javascript" src="{#$JS_PATH#}baidu_map/jquery.baidu_map.js"></script>
                                            <script type="text/javascript" src="http://api.map.baidu.com/api?v=2.0&ak=eDsGxG65jw27rKR2hGfhRIBp"></script>
                                            <script type="text/javascript">
                                                $(function(){
                                                    $("#map").baidu_map({"title":"{#$users_lbs['address']#}","lat":"{#$users_lbs['map']['lat']#}","lng":"{#$users_lbs['map']['lng']#}"});
                                                });
                                            </script>
                                        </td>
                                    </tr>
                                    <tr class="dealershow">
                                        <td align="right">门店相片</td>
                                        <td>
                                            <script>
                                                window.__upfile_thumb_width = 1080;
                                                window.__upfile_thumb_height = 2048;
                                            </script>
                                            {#tpl_form_imagemore("albums", $users['albums'], 20)#}
                                        </td>
                                    </tr>
                                    <tr class="dealershow">
                                        <td align="right">是否显示</td>
                                        <td>
                                            <label><input type="radio" class="check" name="disabled"{#che(intval(value($users,'disabled')),'0')#}> 显示</label>
                                            <label><input type="radio" class="check" name="disabled"{#che(value($users,'disabled'),'1')#}> 隐藏</label>　
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                        <div id="group" class="tabbody">
                            <table width="100%" border="0" cellpadding="8" cellspacing="0" class="tableBasic">
                                <tr>
                                    <td width="110" align="right">积分等级</td>
                                    <td>
                                        {#users_rank($users['point_plus'])#}<span class="cue">（根据积分自动升降，无需修改）</span>
                                    </td>
                                </tr>
                                <tr>
                                    <td align="right">会员标签</td>
                                    <td class="group_ids">
                                        {#$users['group_ids'] = explode(",", trim($users['group_ids'], ","))#}
                                        {#foreach $users_group AS $item#}
                                            <label><input type="checkbox" class="check" name="group_ids[]"{#chrr($users['group_ids'], $item['id'])#}>{#$item['name']#}</label>
                                        {#foreachelse#}
                                            (未添加标签)
                                        {#/foreach#}
                                    </td>
                                </tr>
                                <tr>
                                    <td align="right">分销等级</td>
                                    <td>
                                        <select name="channel_id" data-val="{#$users['channel_id']#}">
                                            {#foreach $channel_setting['vip'] AS $item#}
                                                <option value="{#$item['id']#}">{#$item['name']#}</option>
                                            {#/foreach#}
                                        </select>
                                        <label>&nbsp;&nbsp;<input type="checkbox" id="autoend" name="autoend"> 自动到期</label>
                                        <input type="text" name="autoend_date" size="30" onclick="WdatePicker({doubleCalendar:true,dateFmt:'yyyy-MM-dd HH:mm:ss'});" value="{#if $users_channel#}{#date("Y-m-d H:i:s", $users_channel['enddate'])#}{#/if#}" class="inpMain" style="display:none;">
                                        <script type="text/javascript">
                                            $(function(){
                                                var autoend = $("#autoend");
                                                var autoend_date = $("input[name=autoend_date]");
                                                autoend.click(function(){
                                                    if ($(this).is(":checked")) {
                                                        autoend_date.show();
                                                    }else{
                                                        autoend_date.hide();
                                                    }
                                                });
                                                {#if $users_channel#}
                                                autoend.prop("checked", true);
                                                autoend_date.show();
                                                {#/if#}
                                            });
                                        </script>
                                    </td>
                                </tr>
                            </table>
                        </div>
                        <div id="money" class="tabbody">
                            <div class="Ltitle">
                                当前余额：&yen;{#$users['money']#}
                            </div>
                            <table width="100%" border="0" cellpadding="8" cellspacing="0" class="tableBasic">
                                <thead>
                                <tr>
                                    <th align="left">序号</th>
                                    <th align="left">说明</th>
                                    <th align="left">时间</th>
                                    <th align="center">变化值</th>
                                    <th align="center">变化后</th>
                                    <th align="center">其他说明</th>
                                </tr>
                                </thead>
                                <tbody id="pagelist-money">
                                {#foreach from=$Lmoney['list'] item=item#}
                                    <tr>
                                        <td align="left">{#$item['_n']#}</td>
                                        <td align="left">{#$item['title']#}</td>
                                        <td align="left">{#date("m-d H:i", $item['indate'])#} 周{#chinanumZ(date("N", $item['indate']))#}</td>
                                        <td align="center">{#if $item['setup'] > 0#}+{#/if#}{#$item['setup']#}</td>
                                        <td align="center">{#$item['after']#}</td>
                                        <td align="center">
                                            {#if $item['subtitle']#}
                                                {#if $item['subtitle']=='申请完成'#}
                                                    <div class="subtitle success">{#$item['subtitle']#}</div>
                                                {#elseif $item['subtitle']=='申请驳回'#}
                                                    <div class="subtitle cancel">{#$item['subtitle']#}</div>
                                                {#else#}
                                                    <div class="subtitle">{#$item['subtitle']#}</div>
                                                {#/if#}
                                            {#else#}
                                                无
                                            {#/if#}
                                        </td>
                                    </tr>
                                    {#foreachelse#}
                                    <tr>
                                        <td colspan="6" align="center">暂无数据</td>
                                    </tr>
                                {#/foreach#}
                                {#if $Lmoney['page_html']#}
                                    <tr>
                                        <td colspan="6" align="center">
                                            <div id="pagelist" data-id="pagelist-money">{#str_replace("&page=", "&mpage=", $Lmoney['page_html'])#}</div>
                                        </td>
                                    </tr>
                                {#/if#}
                                </tbody>
                            </table>
                        </div>
                        <div id="point" class="tabbody">
                            <div class="Ltitle">
                                当前积分：{#$users['point']#}，累计积分：{#$users['point_plus']#}
                            </div>
                            <table width="100%" border="0" cellpadding="8" cellspacing="0" class="tableBasic">
                                <thead>
                                <tr>
                                    <th align="left">序号</th>
                                    <th align="left">说明</th>
                                    <th align="left">时间</th>
                                    <th align="center">变化值</th>
                                    <th align="center">变化后</th>
                                </tr>
                                </thead>
                                <tbody id="pagelist-point">
                                {#foreach from=$Lpoint['list'] item=item#}
                                    <tr>
                                        <td align="left">{#$item['_n']#}</td>
                                        <td align="left">{#$item['title']#}</td>
                                        <td align="left">{#date("m-d H:i", $item['indate'])#} 周{#chinanumZ(date("N", $item['indate']))#}</td>
                                        <td align="center">{#if $item['setup'] > 0#}+{#/if#}{#$item['setup']#}</td>
                                        <td align="center">{#$item['after']#}</td>
                                    </tr>
                                    {#foreachelse#}
                                    <tr>
                                        <td colspan="5" align="center">暂无数据</td>
                                    </tr>
                                {#/foreach#}
                                {#if $Lpoint['page_html']#}
                                    <tr>
                                        <td colspan="5" align="center">
                                            <div id="pagelist" data-id="pagelist-point">{#str_replace("&page=", "&ppage=", $Lpoint['page_html'])#}</div>
                                        </td>
                                    </tr>
                                {#/if#}
                                </tbody>
                            </table>
                        </div>
                        <div id="role" class="tabbody">
                            <table width="100%" border="0" cellpadding="8" cellspacing="0" class="tableBasic tableRole tablerole">
                                <tr>
                                    <td width="110" align="right" class="top">销售管理</td>
                                    <td>
                                        <ul class="role_setting">
                                            <li>
                                                <strong>押金管理</strong>
                                                <label><input type="checkbox" value="1"{#if $_role['deposit']['view']#} checked{#/if#} name="role[deposit][view]">查看</label>
                                                <label><input type="checkbox" value="1"{#if $_role['deposit']['refund']#} checked{#/if#} name="role[deposit][refund]">退款</label>
                                                <label><input type="checkbox" value="1"{#if $role['deposit_notify']#} checked{#/if#} name="deposit_notify">通知</label>
                                            </li>
                                        </ul>
                                    </td>
                                </tr>
                                <tr>
                                    <td align="right" class="top">会员管理</td>
                                    <td>
                                        <ul class="role_setting">
                                            <li>
                                                <strong>会员管理</strong>
                                                <label><input type="checkbox" value="1"{#if $_role['users']['view']#} checked{#/if#} name="role[users][view]">查看</label>
                                                <label><input type="checkbox" value="1"{#if $_role['users']['edit']#} checked{#/if#} name="role[users][edit]">修改</label>
                                            </li>
                                        </ul>
                                    </td>
                                </tr>
                            </table>
                        </div>
                        <table width="100%" border="0" cellpadding="8" cellspacing="0" class="tableBasic" id="submitTable">
                            <tr>
                                <td width="110"></td>
                                <td>
                                    <input class="btn" type="submit" value="提交" />
                                    <input type="hidden" name="submit" value="1">
                                </td>
                            </tr>
                        </table>
                    </form>
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
    function _deluser(obj) {
        var tthis = $(obj);
        if ($.trim(tthis.val()) == "") {
            tthis.prev("input").val("");
        }
    }
    function _getuser(obj) {
        var tthis = $(obj);
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
                        tthis.parents("td").find("input[name='masterid']").val($(this).attr("data-id"));
                        tthis.prev("input").val($(this).attr("data-title"));
                        tthis.next("ul").hide();
                        $(".translucentbackground").hide();

                    });
                    tthis.next("ul").html($intemp).show();
                }
            }
        });
    }
    function ondealer(obj) {
        if ($(obj).val() == '1') {
            $("tr.dealershow").show();
        }else{
            $("tr.dealershow").hide();
        }
    }
    $(function(){
        $("input[name='isdealer']:checked").change();
        //
        var select1 = $("#select1");
        var select2 = $("#select2");
        var select3 = $("#select3");
        //初始化TAB
        $("#topmenu a").each(function(index){
            $(this).attr("d-index", index);
            $(this).click(function(){
                $("#topmenu a").removeClass("active");
                $(this).addClass("active");
                $("table#tabtable").hide().eq($(this).attr("d-index")).show();
            });
        });
        $("#topmenu a:eq(0)").click();
        //保存数据事件
        $('#saveform').submit(function() {
            //
            $.alert('正在保存...', 0);
            $("input[name='province_cn']").val(select1.find("option:selected").text());
            $("input[name='city_cn']").val(select2.find("option:selected").text());
            $("input[name='area_cn']").val(select3.find("option:selected").text());
            //
            $(this).ajaxSubmit({
                dataType : 'json',
                success : function (data) {
                    if (data != null && data.success != null && data.success) {
                        $.alert(data.message);
                        setTimeout(function(){
                            window.location.reload();
                        }, 500);
                    } else {
                        $.alertk(data.message);
                    }
                },
                error : function () {
                    $.alertk("保存失败！");
                }
            });
            return false;
        });
        //
        $.each(area, function(i, obj) {
            if (obj.parent == 0 && obj.name.length > 0) {
                var option = '<option value="'+obj.id+'" data-val="0">'+obj.name+'</option>';
                select1.append(option);
            }
        });
        select1.change(function(){
            var tthis = $(this);
            select2.html("").hide();
            select3.html("").hide();
            $("input[name='province_cn']").val(tthis.find("option:selected").text());
            if (tthis.val() == "" || tthis.val() == "0" || !tthis.val()) {
                return;
            }
            var city = city_childs(tthis.val());
            $.each(city, function(i, obj) {
                var option = '<option value="'+obj.id+'" data-val="0">'+obj.name+'</option>';
                select2.append(option);
            });
            select2.show();
            if (select2.attr("data-val")) {
                select2.val(select2.attr("data-val")).attr("data-val", "").change();
            }else{
                select2.change()
            }
        });
        select2.change(function(){
            var tthis = $(this);
            select3.html("").hide();
            $("input[name='city_cn']").val(tthis.find("option:selected").text());
            if (tthis.val() == "" || tthis.val() == "0" || !tthis.val()) {
                return;
            }
            var city = city_childs(tthis.val());
            $.each(city, function(i, obj) {
                var option = '<option value="'+obj.id+'" data-val="0">'+obj.name+'</option>';
                select3.append(option);
            });
            select3.show();
            if (select3.attr("data-val")) {
                select3.val(select3.attr("data-val")).attr("data-val", "").change();
            }else{
                select3.change();
            }
        });
        select3.change(function(){
            var tthis = $(this);
            $("input[name='area_cn']").val(tthis.find("option:selected").text());
        });
        if (select1.attr("data-val")) {
            select1.val(select1.attr("data-val")).attr("data-val", "").change();
        }
        //
        var tablerole = $(".tablerole");
        tablerole.find("td.top").click(function(){
            if ($(this).attr("data-checked") == "true") {
                $(this).attr("data-checked", "false");
                $(this).next("td").find(".role_setting").find("input[type='checkbox']").prop("checked", false);
            }else{
                $(this).attr("data-checked", "true");
                $(this).next("td").find(".role_setting").find("input[type='checkbox']").prop("checked", true);
            }
        });
        tablerole.find(".role_setting").find("strong").click(function(){
            if ($(this).attr("data-checked") == "true") {
                $(this).attr("data-checked", "false");
                $(this).parent("li").find("input[type='checkbox']").prop("checked", false);
            }else{
                $(this).attr("data-checked", "true");
                $(this).parent("li").find("input[type='checkbox']").prop("checked", true);
            }
        });
    });
    function city_childs(pid) {
        var citys = [];
        $.each(area, function(i, obj) {
            if (obj.parent == pid && obj.name.length > 0) {
                citys.push(obj);
            }
        });
        return citys;
    }
</script>
</body>
</html>