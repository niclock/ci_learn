<!DOCTYPE html>
{#_head_html()#}
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=Edge,chrome=1" />
    <title>管理中心 - {#$_A['BASE_NAME']#}</title>
    <link href="{#$NOW_PATH#}css/public.css" rel="stylesheet" type="text/css">
    <style type="text/css">
        .selbox select {
            width: 100px;
        }
    </style>
    <script type="text/javascript" src="{#$JS_PATH#}jquery.min.js"></script>
    <script type="text/javascript" src="{#$JS_PATH#}jquery.alert.js"></script>
    <script type="text/javascript" src="{#$JS_PATH#}jquery.form.min.js"></script>
    <script type="text/javascript" src="{#$JS_PATH#}My97DatePicker/WdatePicker.js"></script>
    <script type="text/javascript" src="{#$NOW_PATH#}js/global.js"></script>
    <script type="text/javascript" src="{#$NOW_PATH#}js/jquery.tab.js"></script>
    <script type="text/javascript" src="{#$NOW_PATH#}js/jquery.autoTextarea.js"></script>
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
    {#tpl('_left', 'cdb')#}

    <div id="dcMain">
        <!-- 当前位置 -->
        <div id="urHere">管理中心<b>&gt;</b><strong>设备管理</strong> <b>&gt;</b><strong>{#$subtitle#}设备</strong></div>
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
                    <li><a href="#main">{#$subtitle#}设备</a></li>
                    <li><a href="{#url('admin/cdb')#}">返回列表</a></li>
                </ul>
                <div class="items">
                    <form action="{#get_url()#}" method="post" id="saveform">
                        <div id="main" class="tabbody">
                            <table width="100%" border="0" cellpadding="8" cellspacing="0" class="tableBasic tableAuto">
                                <tr>
                                    <td width="110" align="right">识别编码</td>
                                    <td>
                                        <input {#if $id > 0#}disabled="disabled"{#/if#} type="text" name="sn" value="{#$data['sn']#}" size="60" class="inpMain" placeholder="是唯一的，只能添加不能修改"/>
                                        {#if $id > 0#}<span class="cue" style="color:red">不可修改！！</span>{#/if#}
                                    </td>
                                </tr>
                                {#if $id == 0#}
                                    <tr>
                                        <td style="background-color:#F9F8FF" align="right">追加数量</td>
                                        <td style="background-color:#F9F8FF">
                                            <input type="text" name="addnum" value="{#$data['addnum']|intval#}" size="10" class="inpMain" />
                                            <label><input type="checkbox" name="skiprep" value="1"> 绕过重复</label>，
                                            <span class="cue">选填，本次提交批量追加数量</span>
                                        </td>
                                    </tr>
                                {#/if#}
                                <tr>
                                    <td align="right">设备名称</td>
                                    <td>
                                        <input type="text" name="title" value="{#$data['title']#}" size="60" class="inpMain" />
                                    </td>
                                </tr>
                                <tr>
                                    <td align="right">设备分类</td>
                                    <td>
                                        <select name="type" data-val="{#$data['type']#}">
                                            <option value=""></option>
                                            <option value="充电宝">充电宝</option>
                                            <option value="雨伞">雨伞</option>
                                        </select>
                                    </td>
                                </tr>
                                <tr>
                                    <td align="right">后台排序</td>
                                    <td>
                                        <input type="text" name="inorder" value="{#$data['inorder']|intval#}" size="10" class="inpMain" />
                                        <span class="cue">仅供后台使用方便，越大越靠前</span>
                                    </td>
                                </tr>
                                <tr>
                                    <td align="right">是否启用</td>
                                    <td style="height:30px;">
                                        {#if $data['status'] === '使用中'#}
                                            <label><input type="radio" class="check" name="status"{#che($data['status'], '使用中')#}> 使用中</label>　
                                        {#else#}
                                            <label><input type="radio" class="check" name="status"{#che(nullshow($data['status'],'启用'), '启用')#}> 启用</label>　
                                            <label><input type="radio" class="check" name="status"{#che($data['status'], '禁用')#}> 禁用</label>
                                        {#/if#}
                                    </td>
                                </tr>
                                <tr>
                                    <td align="right">所属会员</td>
                                    <td>
                                        <div class="inpBox" style="display:inline-block;">
                                            <input type="hidden" class="useridipt" name="userid" value="{#$data['userid']#}">
                                            <input type="text" value="{#$data['userinfo']['username']#}" size="60" class="inpMain" placeholder="输入会员姓名/手机号查找" onkeypress="return _ifenter(this);" onkeyup="return _ifnull(this);"/><input type="button" value="搜索" class="inpMain inpMain-s" onclick="_getuser(this);">
                                            <ul></ul>
                                        </div>
                                        留空时所有商家都可以扫码录入到自己的账户下
                                    </td>
                                </tr>
                                {#if $id > 0#}
                                    <tr>
                                        <td style="background-color:#F9F8FF" align="right">二维码</td>
                                        <td style="background-color:#F9F8FF">
                                            <a href="{#urlApi('other/cdb_qrcode')#}?sn={#$data['sn']#}" target="_blank">
                                                <img src="{#urlApi('other/cdb_qrcode')#}?sn={#$data['sn']#}" style="max-width:200px;">
                                            </a>
                                        </td>
                                    </tr>
                                {#/if#}
                            </table>
                        </div>
                        <table width="100%" border="0" cellpadding="8" cellspacing="0" class="tableBasic tableAuto">
                            <tr>
                                <td width="110"></td>
                                <td>
                                    {#if $id > 0 && $data['status'] == '使用中'#}
                                        <input class="btn" type="button" value="设备使用中禁止修改" style="cursor:no-drop"/>
                                    {#else#}
                                        <input class="btn" type="submit" value="提交" />
                                    {#/if#}
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
    function _ifnull(obj) {
        if ($(obj).val() === "") {
            $(obj).prev().val("0");
        }
    }
    function _ifenter(obj) {
        var e = event;
        var keyNum = e.which || e.keyCode;
        if(keyNum===13){
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
        //保存数据事件
        $('#saveform').submit(function() {
            $.alert('正在保存...', 0);
            //
            $(this).ajaxSubmit({
                dataType : 'json',
                success : function (data) {
                    if (data != null && data.success != null && data.success) {
                        $.alert(data.message);
                        setTimeout(function(){
                            {#if $id > 0#}
                                window.location.reload();
                            {#else#}
                                window.location.href = '{#url('admin/cdb')#}';
                            {#/if#}
                        }, 800);
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
    });
</script>
</body>
</html>