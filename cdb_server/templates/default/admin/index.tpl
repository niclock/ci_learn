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
    {#tpl('_left')#}

    <div id="dcMain">
        <!-- 当前位置 -->
        <div id="urHere">管理中心</div>
        <div id="index" class="mainBox" style="padding-top:18px;height:auto!important;min-height:550px;">

            <div id="douApi"></div>

            <table width="100%" border="0" cellspacing="0" cellpadding="0" class="indexBoxTwo">
                <tr>
                    <td width="65%" valign="top" class="pr">
                        <div class="indexBox">
                            <div class="boxTitle">网站基本信息</div>
                            <ul>
                                <table width="100%" border="0" cellspacing="0" cellpadding="7" class="tableBasic">
                                    <tr>
                                        <td width="120">订单总数：</td>
                                        <td>
                                            <strong><a href="{#url('admin/order')#}">{#db_count(table('order'))#}</a></strong>
                                        </td>
                                        <td width="100">会员总数：</td>
                                        <td><strong><a href="{#url('admin/users')#}">{#db_count(table('users'))#}</a></strong></td>
                                    </tr>
                                    <tr>
                                        <td>产品总数：</td>
                                        <td colspan="3"><strong><a href="{#url('admin/cdb')#}">{#db_count(table('cdb'))#}</a></strong></td>
                                    </tr>
                                    <tr>
                                        <td>站点网址：</td>
                                        <td><strong>{#$smarty.const.BASE_URI#}</strong></td>
                                        <td>数据库：</td>
                                        <td><strong>MySQL</strong></td>
                                    </tr>
                                    <tr>
                                        <td>待办事务：</td>
                                        <td colspan="3">
                                            {#$tisNum = 0#}

                                            {#if $_A['_role']['deposit']['refund']#}
                                                {#$dealer = db_count(table('pay'), "`status`='退款中' AND `type`='deposit'")#}
                                                {#if $dealer > 0#}
                                                    {#$tisNum = $tisNum + $dealer#}
                                                    <strong class="waitset"><a href="{#url('admin/deposit')#}?status=退款中">押金退款申请: {#$dealer#}</a></strong>
                                                {#/if#}
                                            {#/if#}

                                            {#$dealer = db_count(table('order_join'), "`status`='审核中'")#}
                                            {#if $dealer > 0#}
                                                {#$tisNum = $tisNum + $dealer#}
                                                <strong class="waitset"><a href="{#url('admin/join_dealer')#}?status=审核中">商家入驻: {#$dealer#}</a></strong>
                                            {#/if#}

                                            {#$agents = db_count(table('joinagents'), "`update`=0")#}
                                            {#if $agents > 0#}
                                                {#$tisNum = $tisNum + $agents#}
                                                <strong class="waitset"><a href="{#url('admin/join_agents')#}?status=未阅读">代理商申请: {#$agents#}</a></strong>
                                            {#/if#}

                                            {#if $tisNum == 0#}
                                                无
                                            {#/if#}
                                        </td>
                                    </tr>
                                </table>
                            </ul>
                        </div>
                    </td>
                    <td valign="top" class="pl">
                        <div class="indexBox">
                            <div class="boxTitle">最近登录记录</div>
                            <ul>
                                <table width="100%" border="0" cellspacing="0" cellpadding="7" class="tableBasic">
                                    <tr>
                                        <th width="45%">IP地址</th>
                                        <th width="55%">登录时间</th>
                                    </tr>
                                    {#ddb_pc set="数据表:users_notes,列表名:lists,显示数目:3,排序:indate desc" where={#$wheresql#}#}
                                    {#foreach from=$lists item=item#}
                                        <tr>
                                            <td align="center">{#$item['inip']#}</td>
                                            <td align="center">{#date('Y-m-d H:i:s', $item['indate'])#}</td>
                                        </tr>
                                    {#foreachelse#}
                                        <tr>
                                            <td colspan="2" align="center">暂无</td>
                                        </tr>
                                    {#/foreach#}
                                </table>
                            </ul>
                        </div>
                    </td>
                </tr>
            </table>
            <div class="indexBox">
                <div class="boxTitle">服务器信息</div>
                <ul>
                    <table width="100%" border="0" cellspacing="0" cellpadding="7" class="tableBasic">
                        <tr>
                            <td width="120" valign="top">PHP 版本：</td>
                            <td valign="top">{#$smarty.const.PHP_VERSION#}</td>
                            <td width="100" valign="top">MySQL 版本：</td>
                            <td valign="top">{#mysql_get_server_info()#}</td>
                            <td width="100" valign="top">服务器操作系统：</td>
                            <td valign="top">{#$smarty.const.PHP_OS#}({#$smarty.const.ONLINE_IP#})</td>
                        </tr>
                        <tr>
                            <td valign="top">文件上传限制：</td>
                            <td valign="top">{#ini_get('upload_max_filesize')#}</td>
                            <td valign="top">GD 库支持：</td>
                            <td valign="top">{#$isgd#}</td>
                            <td valign="top">Web 服务器：</td>
                            <td valign="top">{#$web_server#}</td>
                        </tr>
                    </table>
                </ul>
            </div>
        </div>
    </div>
    <div class="clear"></div>
    {#tpl('_foot')#}
    <!-- dcFooter 结束 -->
    <div class="clear"></div>
</div>

</body>
</html>