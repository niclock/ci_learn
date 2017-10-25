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
    <script type="text/javascript" src="{#$JS_PATH#}artdialog/artDialog.js?skin=default"></script>
    <script type="text/javascript">
        $(function(){
            $(".mainBox").css('min-height', $(window).height() - 195);
        });
    </script>
    <style type="text/css">
        .filtertable,.filtertable table{width:100%}
        .filtertable table tr td{width:33.3%;padding-right:20px;-webkit-box-sizing:border-box;-moz-box-sizing:border-box;box-sizing:border-box}
        .filtertable table tr td.last{width:33.3%;padding-right:0}
        .filtertable table tr td.fill{width:99.9%;padding-right:0}
        .filtertable table tr td div{display:block;font-weight:700;white-space:nowrap;overflow:hidden;text-overflow:ellipsis}
        .filtertable table tr td input,.filtertable table tr td select{display:block;width:100%;margin-bottom:10px;-webkit-box-sizing:border-box;-moz-box-sizing:border-box;box-sizing:border-box}
        .filtertable table tr td input.btnGray{width:100px;float:right;background-color:#4AA8EC;color:#fff}
        .filtertable table tr td input.excel{margin-left:10px;background-color:#EEE;color:#666}
        .filtertable .filterlr .filterl{width:49%;float:left;}
        .filtertable .filterlr .filterr{width:49%;float:right;}
        .btnGray.cancel{color:red;background-color:#fff;padding:6px 5px;font-weight:400;text-decoration:underline;float:right;margin-right:10px;}
        .btnGray.cancel:hover{color:#ff947a}
        .tbew{ position:relative; cursor: pointer}
        .tbew span:hover {color:#ff0000;}
        .erweima {display:none;position:absolute;top:5px;left:0;border: 1px solid #ff661b;background-color:#ffffff;}
        .erweima img {width:150px; height: 150px; display: table; background:url("{#$IMG_PATH#}loading.gif") no-repeat; background-position: center; background-size: 100px;}
    </style>
</head>
<body>
<div id="dcWrap">

    {#tpl('_top')#}
    <!-- dcHead 结束 -->
    {#tpl('_left', 'cdb')#}

    <div id="dcMain">
        <!-- 当前位置 -->
        <div id="urHere">管理中心<b>&gt;</b><strong>设备管理</strong> </div>
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
                    <li><a href="#main">设备列表</a></li>
                    <li><a href="{#url('admin/cdb_add')#}">+添加设备</a></li>
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
                                                    <div>编号 ID</div>
                                                    <input name="id" type="text" class="inpMain" value="{#$_GPC['id']#}"/>
                                                </div>
                                                <div class="filterr">
                                                    <div>识别编号</div>
                                                    <input name="sn" type="text" class="inpMain" value="{#$_GPC['sn']#}"/>
                                                </div>
                                            </div>
                                        </td>
                                        <td>
                                            <div>状态</div>
                                            <select name="status" data-val="{#$_GPC['status']#}">
                                                <option value=""></option>
                                                <option value="使用中">使用中</option>
                                                <option value="启用">启用</option>
                                                <option value="禁用">禁用</option>
                                            </select>
                                        </td>
                                        <td class="last">
                                            <div>分类</div>
                                            <select name="type" data-val="{#$_GPC['type']#}">
                                                <option value=""></option>
                                                <option value="充电宝">充电宝</option>
                                                <option value="雨伞">雨伞</option>
                                            </select>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <div>会员ID</div>
                                            <input name="userid" type="text" class="inpMain" value="{#$_GPC['userid']#}"/>
                                        </td>
                                        <td>
                                            <div class="filterlr">
                                                <div class="filterl">
                                                    <div>添加时间</div>
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
                                                <div class="filterl">
                                                    <div>更新时间</div>
                                                    <input id="sutime" name="sutime" value="{#$_GPC['sutime']#}" onclick="WdatePicker({maxDate:'#F{$dp.$D(\'eutime\')}'})" class="inpMain">
                                                </div>
                                                <div class="filterr">
                                                    <div>至</div>
                                                    <input id="eutime" name="eutime" value="{#$_GPC['eutime']#}" onclick="WdatePicker({minDate:'#F{$dp.$D(\'sutime\')}'})" class="inpMain">
                                                </div>
                                            </div>
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

                        <form name="action" method="post" action="{#url(0)#}" id="saveform">
                            <table width="100%" border="0" cellpadding="8" cellspacing="0" class="tableBasic tableAuto">
                                <tr>
                                    <th width="22" align="center"><input name='chkall' type='checkbox' id='chkall' onclick='selectcheckbox(this.form)' value='check'></th>
                                    <th width="40" align="center">编号</th>
                                    <th align="left">识别编码</th>
                                    <th align="left">名称</th>
                                    <th align="center">分类</th>
                                    <th align="center">会员ID</th>
                                    <th width="80" align="center">状态</th>
                                    <th width="130" align="center">添加时间</th>
                                    <th width="130" align="center">更新时间</th>
                                    <th width="70" align="center">操作</th>
                                </tr>
                                {#foreach from=$lists['list'] item=item#}
                                    <tr data-id="{#$item.id#}" data-title="{#$item['title']#}">
                                        <td align="center"><input type="checkbox" name="checkbox[]" value="{#$item['id']#}" /></td>
                                        <td align="center">{#$item['id']#}</td>
                                        <td class="tbew" id="tbew-{#$item['sn']#}" onmouseover="xianma('{#$item['sn']#}');" onmouseout="xianmay('{#$item['sn']#}');">
                                            <span id="span-{#$item['sn']#}">{#$item['sn']#}</span>
                                            <a target="_blank" href="javascript:void(0);" id="erweima-{#$item['sn']#}" class="erweima">
                                                <img src="{#$IMG_PATH#}loading.gif" id="erweimaimg-{#$item['sn']#}"/>
                                            </a>
                                        </td>
                                        <td>{#$item['title']#}</td>
                                        <td align="center">{#$item['type']#}</td>
                                        <td align="center">
                                            <a href="{#url('admin/users')#}?userid={#$item['userid']#}" target="_blank">{#$item['userid']#}</a>
                                        </td>
                                        <td align="center">{#$item['status']#}</td>
                                        <td align="center">{#date("Y-m-d H:i:s", $item['indate'])#}</td>
                                        <td align="center">{#date("Y-m-d H:i:s", $item['update'])#}</td>
                                        <td align="center">
                                            <a href="{#url('admin/cdb_add')#}?id={#$item['id']#}">编辑</a> |
                                            <a href="{#url('admin/cdb')#}?action=del&id={#$item['id']#}"
                                               onclick="return confirm('确认删除吗？\r\n\r\n注意：将同时删除该分店的核销员身份！');return false;">删除</a>
                                        </td>
                                    </tr>
                                    {#foreachelse#}
                                    <tr>
                                        <td colspan="10" align="center">暂无数据</td>
                                    </tr>
                                {#/foreach#}
                            </table>
                            <div class="action">
                                <select name="action">
                                    <option value="0">请选择...</option>
                                    <option value="del_all">删除</option>
                                </select>
                                <input name="submit" class="btn" type="submit" value="执行" />
                            </div>
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
        $('#saveform').submit(function() {
            if (!confirm("确认删除吗？\r\n\r\n注意：将同时删除该分店的核销员身份！")) {
                return false;
            }
        });
        document.forms['action'].reset();
    });
    function xianma(sn) {
        var obj = $("#erweimaimg-" + sn);
        if (obj.attr("data-i") !== 'true') {
            obj.attr("data-i", "true");
            obj.attr('src', "{#urlApi('other/cdb_qrcode')#}?sn=" + sn);
        }
        var w = document.getElementById('tbew-' + sn).offsetWidth;
        document.getElementById('erweima-' + sn).setAttribute("href", "{#urlApi('other/cdb_qrcode')#}?sn=" + sn);
        document.getElementById('erweima-' + sn).style.left = (w - 5) + "px";
        document.getElementById('erweima-' + sn).style.display = "block";
    }
    function xianmay(sn) {
        document.getElementById('erweima-' + sn).style.display = "none";
    }
</script>
</body>
</html>