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
    <script type="text/javascript" src="{#$JS_PATH#}artdialog/artDialog.js?skin=default"></script>
    <script type="text/javascript" src="{#$JS_PATH#}My97DatePicker/WdatePicker.js"></script>
    <script type="text/javascript">
        $(function(){
            $(".mainBox").css('min-height', $(window).height() - 195);
        });
    </script>
    <style type="text/css">
        th a{text-decoration:underline;}
        th a:hover{color:#00A0E9;}
        del{color:#aaa}
        .unamebox{height:26px}
        .unamebox em{background:#f80;color:#fff;padding:0 2px;height:16px;line-height:16px;display:inline-block;margin-left:1px}
        .unamebox .u-box{display:inline-block;vertical-align:middle}
        .unamebox .u-box .u-group a{color:#fff;background-color:#BDBDBD;padding:0 2px;border-radius:2px;height:16px;font-size:12px;line-height:16px;display:inline-block}
        .unamebox .u-box .u-group a:hover{background-color:#9A9898}
        .avatar img{vertical-align:middle;width:26px;padding-right:3px}
        #text-tooltip{position:absolute;background-color:#fff;padding:8px;border:1px solid #cc7116}
        #text-tooltip img{display:block;margin:10px 0 0;max-width:300px;max-height:300px}
        .savatypebox label{padding-left:15px;}
        .savatypebox label.disabled{text-decoration:line-through;color:#777;}
        .savatypebox label input{margin-right:2px;margin-top:3px;vertical-align:top;}
        .filtertable,.filtertable table{width:100%}
        .filtertable table tr td{width:33.3%;padding-right:20px;-webkit-box-sizing:border-box;-moz-box-sizing:border-box;box-sizing:border-box}
        .filtertable table tr td.last{width:33.3%;padding-right:0}
        .filtertable table tr td.fill{width:99.9%;padding-right:0}
        .filtertable table tr td div{display:block;font-weight:700}
        .filtertable table tr td input,.filtertable table tr td select{display:block;width:100%;margin-bottom:10px;-webkit-box-sizing:border-box;-moz-box-sizing:border-box;box-sizing:border-box}
        .filtertable table tr td input.btnGray{min-width:100px;width:auto;float:right;background-color:#4AA8EC;color:#fff}
        .filtertable table tr td input.excel{margin-left:10px;background-color:#EEE;color:#666}
        .filtertable table tr td input.amass{margin-left:10px;background-color:#EEE;color:#666}
        .filtertable .filterlr .filterl{width:49.8%;float:left;}
        .filtertable .filterlr .filterr{width:49.8%;float:right;}
        .fastselectstatus{float:left;color:#666;font-weight:400!important}
        .btnGray.status{background-color:#fff;padding:6px 5px;font-weight:400;text-decoration:underline}
        .btnGray.status:hover{color:#1b7bdd}
        .btnGray.status.cancel{color:red;margin-left:15px}
        .btnGray.status.cancel:hover{color:#ff947a}
        .tbew{position:relative;cursor:pointer;overflow:visible!important;}
        .tbew span:hover {color:#ff0000;}
        .erweima {display:none;position:absolute;top:5px;left:0;border: 1px solid #ff661b;background-color:#ffffff;}
        .erweima img {width:150px; height: 150px; display: table; background:url("{#$IMG_PATH#}loading.gif") no-repeat; background-position: center; background-size: 100px;}
    </style>
</head>
<body>
<div id="dcWrap">

    {#tpl('_top')#}
    <!-- dcHead 结束 -->
    {#tpl('_left', 'users')#}


    <table style="display:none;">
        <tbody id="ranktemp">
        <tr>
            <td>
                <input type="hidden" name="rank[***][id]" value="***"/>
                <input type="text" name="rank[***][name]" value="" size="20" class="inpMain rank_name" />
            </td>
            <td class="ranklvgroup">
                <div style="display:inline-block">
                    <div class="input-group left">
                        <span class="input-group-addon">积分≤</span>
                        <input type="text" name="rank[***][min]" value="0" size="10" class="inpMain rank_min form-control" />
                        <span class="input-group-addon">分</span>
                    </div>
                </div>
            </td>
            <td align="center"><a href="javascript:;" onclick="_dellv(this);">删除</a></td>
        </tr>
        </tbody>
    </table>


    <div id="dcMain">
        <!-- 当前位置 -->
        <div id="urHere">管理中心<b>&gt;</b><strong>会员列表</strong> </div>
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
                    <li><a href="#main">会员列表</a></li>
                    <li><a href="#ranklv">会员等级</a></li>
                    <li><a href="#add">添加会员</a></li>
                </ul>
                <div class="items">
                    <div id="main" class="tabbody">
                        <div class="filter" style="margin-top:15px;margin-left:0;">
                            <form action="{#url(0)#}" method="get" class="filtertable" id="filtertable">
                                <table>
                                    <tr>
                                        <td>
                                            <div class="filterlr">
                                                <div class="filterl">
                                                    <div>会员 ID</div>
                                                    <input name="userid" type="text" class="inpMain" value="{#$_GPC['userid']#}"/>
                                                </div>
                                                <div class="filterr">
                                                    <div>手机号码</div>
                                                    <input name="userphone" type="text" class="inpMain" value="{#$_GPC['userphone']#}"/>
                                                </div>
                                            </div>
                                        </td>
                                        <td>
                                            <div class="filterlr">
                                                <div class="filterl">
                                                    <div>注册时间</div>
                                                    <input id="stime" name="stime" value="{#$_GPC['stime']#}" onclick="WdatePicker({maxDate:'#F{$dp.$D(\'etime\')}'})" class="inpMain">
                                                </div>
                                                <div class="filterr">
                                                    <div>至</div>
                                                    <input id="etime" name="etime" value="{#$_GPC['etime']#}" onclick="WdatePicker({minDate:'#F{$dp.$D(\'stime\')}'})" class="inpMain">
                                                </div>
                                            </div>
                                        </td>
                                        <td class="last">
                                            <div class="filterlr">
                                                <div>会员等级</div>
                                                <select name="point_lv" data-val="{#$_GPC['point_lv']#}">
                                                    <option value=""></option>
                                                    {#foreach $users_rank AS $item#}
                                                        <option value="{#$item['id']#}">{#$item['name']#}</option>
                                                    {#/foreach#}
                                                </select>
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
                                                    <div>主账号ID</div>
                                                    <input name="masterid" type="text" class="inpMain" value="{#$_GPC['masterid']#}"/>
                                                </div>
                                            </div>
                                        </td>
                                        <td class="last">
                                            <div class="filterlr">
                                                <div>快速搜索</div>
                                                <select name="type" data-val="{#$_GPC['type']#}">
                                                    <option value=""></option>
                                                    <option value="管理员">管理员</option>
                                                    <option value="商家">商家</option>
                                                    <option value="非商家">非商家</option>
                                                    <option value="商家子账号">商家子账号</option>
                                                    <option value="商家主账号">商家主账号</option>
                                                    <option value="商家同步号">商家同步号</option>
                                                    <option value="商家非同步号">商家非同步号</option>
                                                    <option value="商家测试店">商家测试店</option>
                                                    <option value="商家非测试店">商家非测试店</option>
                                                </select>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="3" class="fill">
                                            <div class="fastselectstatus">
                                                快速搜索:
                                                <a class="btnGray status" href="{#url(0)#}?type={#urlencode('管理员')#}">管理员</a>
                                                <a class="btnGray status" href="{#url(0)#}?type={#urlencode('商家')#}">商家</a>
                                                <a class="btnGray status" href="{#url(0)#}?type={#urlencode('非商家')#}">非商家</a>
                                                <a class="btnGray status" href="{#url(0)#}?type={#urlencode('商家子账号')#}">商家子账号</a>
                                                <a class="btnGray status" href="{#url(0)#}?type={#urlencode('商家主账号')#}">商家主账号</a>
                                                <a class="btnGray status" href="{#url(0)#}?type={#urlencode('商家同步号')#}">商家同步号</a>
                                                <a class="btnGray status" href="{#url(0)#}?type={#urlencode('商家非同步号')#}">商家非同步号</a>
                                                <a class="btnGray status" href="{#url(0)#}?type={#urlencode('商家测试店')#}">商家测试店</a>
                                                <a class="btnGray status" href="{#url(0)#}?type={#urlencode('商家非测试店')#}">商家非测试店</a>
                                                {#if $_where != '1=1'#}
                                                    <a class="btnGray status cancel" href="{#url(0)#}">取消筛选</a>
                                                {#/if#}
                                            </div>

                                            <input class="btnGray" name="submit" type="submit" value="" style="display:none;"/>
                                            <input class="btnGray excel" name="submit" type="submit" value="导出商家Excel" />
                                            <input class="btnGray excel" name="submit" type="submit" value="导出Excel" />
                                            <input class="btnGray" name="submit" type="submit" value="搜索" />
                                        </td>
                                    </tr>
                                </table>
                            </form>
                        </div>

                        <form name="action" method="post" action="{#get_url()#}" id="saveform">
                            <table width="100%" border="0" cellpadding="8" cellspacing="0" class="tableBasic">
                                <tr>
                                    <th width="22" align="center"><input name='chkall' type='checkbox' id='chkall' onclick='selectcheckbox(this.form)' value='check'></th>
                                    <th width="50" align="center">{#get_by_order('ID', 'id', 'page')#}</th>
                                    <th align="left">会员昵称</th>
                                    <th align="left">手机号码</th>
                                    <th align="center">设备数量</th>
                                    <th align="center">{#get_by_order('总余额', 'money', 'page')#}|{#get_by_order('不可提现', 'money_not', 'page')#}</th>
                                    <th align="center">{#get_by_order('可用积分', 'point', 'page')#}</th>
                                    <th align="center">{#get_by_order('累计积分', 'point_plus', 'page')#}</th>
                                    <th align="center"><span title="会员等级（也叫：积分等级）">会员等级</span></th>
                                    <th align="center">{#get_by_order('注册时间', 'regdate', 'page')#}</th>
                                    <th align="center">{#get_by_order('登录次数', 'loginnum', 'page')#}</th>
                                    <th align="center">推广员ID</th>
                                    <th align="center">主账号ID</th>
                                    <th width="50" align="center">操作</th>
                                </tr>
                                {#foreach from=$users['list'] item=item#}
                                    {#$usercode = '88'|cat:zerofill($item['id'], 8)#}
                                    <tr data-id="{#$item.id#}" data-wxopenid="{#$item.wx_openid#}" data-img="{#$item.userimg|fillurl#}" data-username="{#$item['username']#}">
                                        <td align="center"><input type="checkbox" name="checkbox[]" value="{#$item['id']#}" /></td>
                                        <td align="center">{#$item['id']#}</td>
                                        <td class="unamebox avatar tbew" id="tbew-{#$usercode#}" onmouseover="xianma('{#$usercode#}');" onmouseout="xianmay('{#$usercode#}');">
                                            {#if $item.userimg#}
                                                <img data-src="{#$item.userimg|fillurl#}" src="{#$item.userimg|avatar_fillurl:"/46"#}">
                                            {#/if#}
                                            <a target="_blank" href="javascript:void(0);" id="erweima-{#$usercode#}" class="erweima">
                                                <img src="{#$IMG_PATH#}loading.gif" id="erweimaimg-{#$usercode#}"/>
                                            </a>
                                            <div class="u-box">
                                                <div class="u-name">
                                                    {#$item['username']#}
                                                    {#if $item['isadmin']#}<em title="后台管理员">后台</em>{#/if#}
                                                    {#if $item['isdealer']#}
                                                        {#if $item['masterid']>0#}
                                                            <em title="商家子账号">子商家</em>
                                                        {#else#}
                                                            <em title="商家用户">商家</em>
                                                        {#/if#}
                                                        {#if $item['mastersync']>0#}
                                                            <em title="资料同主账号">同</em>
                                                        {#/if#}
                                                        {#if $item['istest']>0#}
                                                            <em title="测试商家">测</em>
                                                        {#/if#}
                                                    {#/if#}
                                                </div>
                                            </div>
                                        </td>
                                        <td>{#$item['userphone']#}</td>
                                        <td align="center">{#$item['cdbnum']#}</td>
                                        <td align="center">{#$item['money']#} | {#$item['money_not']#}</td>
                                        <td align="center">{#$item['point']#}</td>
                                        <td align="center">{#$item['point_plus']#}</td>
                                        <td align="center">{#users_rank($item['point_plus'])#}</td>
                                        <td align="center">{#date("Y-m-d H:i:s", $item['regdate'])#}</td>
                                        <td align="center">{#$item['loginnum']#}</td>
                                        <td align="center">
                                            {#if $item['from_id']#}
                                                <a href="{#url('admin/users')#}?userid={#$item['from_id']#}" title="点击查看推广员">{#$item['from_id']#}</a>
                                            {#else#}
                                                -
                                            {#/if#}
                                        </td>
                                        <td align="center">
                                            {#if $item['masterid']#}
                                                <a href="{#url('admin/users')#}?userid={#$item['masterid']#}" title="点击查看主账号">{#$item['masterid']#}</a>
                                            {#else#}
                                                -
                                            {#/if#}
                                        </td>
                                        <td align="center">
                                            <a href="{#url('admin/users_add')#}?id={#$item['id']#}&ctx={#urlencode(get_url())#}">编辑</a>
                                        </td>
                                    </tr>
                                    {#foreachelse#}
                                    <tr>
                                        <td colspan="14" align="center">暂无会员</td>
                                    </tr>
                                {#/foreach#}
                            </table>
                            <div class="action">
                                <select name="action">
                                    <option value="0">请选择...</option>
                                    <option value="dealer_is">设为商家</option>
                                    <option value="dealer_no">取消商家</option>
                                    <option value="admin_is">设为管理员</option>
                                    <option value="admin_no">取消管理员</option>
                                </select>
                                <input name="submit" class="btn" type="submit" value="执行" />
                            </div>
                        </form>
                        <div id="pagelist">
                            <a href="javascript:void(0);" style="cursor:default">总数量{#$users['total']#}个</a>
                            <span id="jspage">{#$users['page_html']#}</span>
                        </div>
                    </div>
                    <div id="ranklv" class="tabbody">
                        <form action="{#url(0)#}" method="post">
                            <table width="100%" border="0" cellpadding="8" cellspacing="0" class="tableBasic">
                                <thead>
                                <tr>
                                    <th align="left" width="150">等级名称（<a href="javascript:;" onclick="_addlv();">添加</a>）</th>
                                    <th align="left">积分条件（填写-1为最大上限）</th>
                                    <th width="70">操作</th>
                                </tr>
                                </thead>
                                <tbody id="ranklist"></tbody>
                            </table>
                            <table width="100%" border="0" cellpadding="8" cellspacing="0" class="tableBasic">
                                <tr>
                                    <td width="150"></td>
                                    <td>
                                        <input name="action" type="hidden" value="rank">
                                        <input name="submit" class="btn" type="submit" value="提交" />
                                    </td>
                                </tr>
                            </table>
                        </form>
                    </div>
                    <div id="add" class="tabbody">
                        <form action="{#get_url()#}" method="post" id="addform">
                            <table width="100%" border="0" cellpadding="8" cellspacing="0" class="tableBasic tableAuto">
                                <tr>
                                    <td width="110" align="right">会员昵称</td>
                                    <td>
                                        <input type="text" name="username" value="" size="50" class="inpMain"/>
                                    </td>
                                </tr>
                                <tr>
                                    <td align="right"><font color="red">*</font> 手机号码</td>
                                    <td>
                                        <input type="text" name="userphone" value="" size="50" class="inpMain"/>
                                    </td>
                                </tr>
                                <tr>
                                    <td align="right">登录密码</td>
                                    <td>
                                        <input type="text" name="password" value="" size="50" class="inpMain"/>
                                    </td>
                                </tr>
                                <tr>
                                    <td align="right">是否商家</td>
                                    <td>
                                        <label><input type="radio" name="isdealer" value="0" checked> 否</label>
                                        <label><input type="radio" name="isdealer" value="1"> 是</label>
                                    </td>
                                </tr>
                                <tr>
                                    <td align="right">所属推广员</td>
                                    <td>
                                        <div class="inpBox" style="display:inline-block;">
                                            <input type="hidden" class="useridipt" name="from_id" value="0">
                                            <input type="text" value="" size="50" class="inpMain" placeholder="输入会员姓名/手机号查找" onkeydown="return _ifenter(this);"/><input type="button" value="搜索" class="inpMain inpMain-s" onclick="_getuser(this);">
                                            <ul></ul>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td></td>
                                    <td>
                                        <input class="btn" type="submit" value="提交" />
                                        <input type="hidden" name="act" value="add">
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

<div id="rankdata" style="display:none;">
{#json_encode(array_values($users_rank))#}
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
                        tthis.parents("td").find("input.useridipt").val($(this).attr("data-id"));
                        tthis.prev("input").val($(this).attr("data-title"));
                        tthis.next("ul").hide();
                        $(".translucentbackground").hide();
                    });
                    tthis.next("ul").html($intemp).show();
                }
            }
        });
    }
    function _addlv(data) {
        var rankid = data&&data.id?data.id:Math.round(Math.random() * 10000);
        var $intemp = $($("#ranktemp").html().replace(/\*\*\*/g, rankid));
        //
        if (data) {
            if (data.name) {
                $intemp.find(".rank_name").val(data.name);
            }
            if (data.min) {
                $intemp.find(".rank_min").val(data.min);
            }
        }
        //
        $intemp.find(".rank_min").blur(function(){
            var tthis = $(this);
            if (tthis.val() != runNum(tthis.val())) {
                tthis.val(runNum(tthis.val()));
            }
            if (runNum(tthis.val()) < -1) {
                tthis.val("-1");
            }
        });
        //
        $("#ranklist").append($intemp);
    }
    function _dellv(obj) {
        if (confirm("确定删除吗？")) {
            $(obj).parents("tr").remove();
        }
    }
    function xianma(sn) {
        var obj = $("#erweimaimg-" + sn);
        if (obj.attr("data-i") !== 'true') {
            obj.attr("data-i", "true");
            obj.attr('src', "{#urlApi('other/users_qrcode')#}?sn=" + sn);
        }
        var w = document.getElementById('tbew-' + sn).offsetWidth;
        document.getElementById('erweima-' + sn).setAttribute("href", "{#urlApi('other/users_qrcode')#}?sn=" + sn);
        document.getElementById('erweima-' + sn).style.left = (w - 5) + "px";
        document.getElementById('erweima-' + sn).style.display = "block";
    }
    function xianmay(sn) {
        document.getElementById('erweima-' + sn).style.display = "none";
    }
    $(function(){
        //
        $('#saveform').submit(function() {
            if (!confirm("确定操作吗？")) {
                return false;
            }
        });
        //
        $('#filtertable').submit(function() {
            $.alert("稍等...", 5000);
        });
        //转移推广员事件
        $('#shiftform').submit(function() {
            //
            if (runNum($(this).find('input[name="touserid"]').val()) == 0) {
                if (!confirm('推广员留空，确定删除推广员？')) {
                    return false;
                }
            }
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
                                    window.location.reload();
                                }
                            }, {
                                title: '继续操作',
                                click: function(){
                                    $("#shiftform").find("div.inpBox:eq(0)").find("input[type='hidden']").val("");
                                    $("#shiftform").find("div.inpBox:eq(0)").find("input[type='text']").val("");
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
        //添加会员事件
        $('#addform').submit(function() {
            //
            if ($(this).find('input[name="userphone"]').val() == "") {
                alert("请输入手机号码");
                return false;
            }
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
                                    window.location.reload();
                                }
                            }, {
                                title: '继续操作',
                                click: function(){
                                    $("#addform").find("input[name='username']").val("");
                                    $("#addform").find("input[name='userphone']").val("");
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
        //
        document.forms['action'].reset();
        //
        $.each(eval($("#rankdata").html()), function(index, data){
            _addlv(data);
        });
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