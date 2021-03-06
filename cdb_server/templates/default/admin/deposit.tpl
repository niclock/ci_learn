<!DOCTYPE html>
{#_head_html()#}
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=Edge,chrome=1" />
    <title>管理中心 - {#$_A['BASE_NAME']#}</title>
    <link href="{#$NOW_PATH#}css/public.css" rel="stylesheet" type="text/css">
    <style>
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
    </style>
    <script type="text/javascript" src="{#$JS_PATH#}jquery.min.js"></script>
    <script type="text/javascript" src="{#$JS_PATH#}jquery.alert.js"></script>
    <script type="text/javascript" src="{#$NOW_PATH#}js/global.js"></script>
    <script type="text/javascript" src="{#$NOW_PATH#}js/jquery.tab.js"></script>
    <script type="text/javascript" src="{#$JS_PATH#}My97DatePicker/WdatePicker.js"></script>
    <script type="text/javascript" src="{#$JS_PATH#}artdialog/artDialog.js?skin=default"></script>
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
    {#tpl('_left', 'deposit')#}

    <div id="dcMain" class="smstmpl">
        <!-- 当前位置 -->
        <div id="urHere">管理中心<b>&gt;</b><strong>押金管理</strong></div>
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
                    <li><a href="#main">押金管理</a></li>
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
                                                    <div>商户编号</div>
                                                    <input name="payid" type="text" class="inpMain" value="{#$_GPC['payid']#}"/>
                                                </div>
                                            </div>
                                        </td>
                                        <td>
                                            <div class="filterlr">
                                                <div class="filterl">
                                                    <div>付款时间</div>
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
                                                    <div>会员ID</div>
                                                    <input name="userid" value="{#$_GPC['userid']#}" class="inpMain">
                                                </div>
                                                <div class="filterr">
                                                    <div>会员昵称</div>
                                                    <input name="username" value="{#$_GPC['username']#}" class="inpMain">
                                                </div>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <div>付款金额</div>
                                            <input name="money" type="text" class="inpMain" value="{#$_GPC['money']#}"/>
                                        </td>
                                        <td>
                                            <div>状态</div>
                                            <div class="filterlr">
                                                <select name="status" data-val="{#$_GPC['status']#}">
                                                    <option value=""></option>
                                                    <option value="已付款">已付款(未使用)</option>
                                                    <option value="使用中">已付款(使用中)</option>
                                                    <option value="退款中">退款中</option>
                                                    <option value="已退款">已退款</option>
                                                </select>
                                            </div>
                                        </td>
                                        <td class="last">
                                            <div class="filterlr">
                                                <div class="filterl">
                                                    <div>退款时间</div>
                                                    <input id="rstime" name="rstime" value="{#$_GPC['rstime']#}" onclick="WdatePicker({maxDate:'#F{$dp.$D(\'retime\')}'})" class="inpMain">
                                                </div>
                                                <div class="filterr">
                                                    <div>至</div>
                                                    <input id="retime" name="retime" value="{#$_GPC['retime']#}" onclick="WdatePicker({minDate:'#F{$dp.$D(\'rstime\')}'})" class="inpMain">
                                                </div>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="3" class="fill">
                                            <div class="fastselectstatus">
                                                快速搜索:
                                                <a class="btnGray status" href="{#url(0)#}?status={#urlencode('已付款')#}">已付款</a>
                                                <a class="btnGray status" href="{#url(0)#}?status={#urlencode('使用中')#}">使用中</a>
                                                <a class="btnGray status" href="{#url(0)#}?status={#urlencode('退款中')#}">退款中</a>
                                                <a class="btnGray status" href="{#url(0)#}?status={#urlencode('已退款')#}">已退款</a>
                                                {#if $_where != $wheresql#}
                                                    <a class="btnGray status cancel" href="{#url(0)#}">取消筛选</a>
                                                {#/if#}
                                            </div>

                                            <input class="btnGray" name="submit" type="submit" value="" style="display:none;"/>
                                            <input class="btnGray" name="submit" type="submit" value="搜索" />
                                        </td>
                                    </tr>
                                </table>
                            </form>
                        </div>
                        <table width="100%" border="0" cellpadding="8" cellspacing="0" class="tableBasic">
                            <tr>
                                <th align="center">ID</th>
                                <th align="left">商户编号</th>
                                <th align="left">支付方式</th>
                                <th align="left">会员</th>
                                <th align="left">金额</th>
                                <th align="center">状态</th>
                                <th align="center">付款时间</th>
                                <th align="center">退款时间</th>
                                <th align="center" width="70">操作</th>
                            </tr>
                            {#foreach from=$lists['list'] item=item#}
                                <tr>
                                    <td align="center">{#$item['id']#}</td>
                                    <td>{#$item['payid']#}</td>
                                    <td>{#$item['payfrom']#}{#if $item['subpayfrom']#}-{#$item['subpayfrom']#}{#/if#}</td>
                                    <td>{#$item['username']#}<a class="tdsub" href="{#url('admin/users')#}?userid={#$item['userid']#}" target="_blank">ID: {#$item['userid']#}</a> </td>
                                    <td>&yen;{#$item['money']#}</td>
                                    <td align="center" class="status">{#$item['status']#}</td>
                                    <td align="center">{#date("Y-m-d H:i", $item['paydate'])#}</td>
                                    <td align="center">{#if $item['retdate'] > 0#}{#date("Y-m-d H:i", $item['retdate'])#}{#else#}-{#/if#}</td>
                                    <td align="center">{#if $item['status'] == '退款中'#}<a href="javascript:;" data-payid="{#$item['payid']#}" onclick="dosubmit(this);" data-retmsg="{#$item['retmsg']#} ({#date("Y-m-d H:i:s", $item['retdate'])#})">同意退款</a>{#else#}-{#/if#}</td>
                                </tr>
                                {#foreachelse#}
                                <tr>
                                    <td colspan="9" align="center">暂无数据</td>
                                </tr>
                            {#/foreach#}
                        </table>
                        <div id="pagelist">
                            <a href="javascript:void(0);" style="cursor:default">总数量{#$lists['total']#}个</a>
                            <span id="jspage">{#$lists['page_html']#}</span>
                        </div>
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

</body>
<script>
    $(function(){
        $("td.status").each(function(){
            if ($(this).text() === '退款中') {
                $(this).css("color", "red");
            }
        });
    });
    function dosubmit(obj) {
        var payid = $(obj).attr("data-payid"),
            title = '同意退款',
            content = '同意申请退款操作！<br/>上次返回：<u>' + $(obj).attr("data-retmsg") + '</u>',
            buttons = [{
                name: '同意',
                focus: true,
                callback: function () {
                    window.location.href = "{#get_link('act|payid|ctx')#}&act=ret&payid=" + payid + "&ctx=" + encodeURIComponent(window.location.href);
                    return false;
                }
            },{
                name: '取消',
                callback: function () {
                    return true;
                }
            }];
        art.dialog({
            title: title,
            fixed: true,
            lock: true,
            opacity: '.3',
            content: content,
            button: buttons
        });
    }
</script>
</html>