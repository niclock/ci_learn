<!DOCTYPE html>
{#_head_html()#}
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=Edge,chrome=1" />
    <title>管理中心 - {#$_A['BASE_NAME']#}</title>
    <link href="{#$NOW_PATH#}css/public.css" rel="stylesheet" type="text/css">
    <style type="text/css">
        .tags em {display:inline-block;padding:1px 4px;background:#C5C5C5;color:#fff;border-radius:2px;}
    </style>
    <script type="text/javascript" src="{#$JS_PATH#}jquery.min.js"></script>
    <script type="text/javascript" src="{#$JS_PATH#}jquery.alert.js"></script>
    <script type="text/javascript" src="{#$JS_PATH#}jquery.form.min.js"></script>
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
        <div id="urHere">管理中心<b>&gt;</b><strong>{#sale_name()#}</strong> </div>
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
                    <li><a href="#main">{#sale_name()#}列表</a></li>
                    <li><a href="{#url('admin/sale_add')#}">+添加{#sale_name()#}</a></li>
                </ul>
                <div class="items">
                    <div id="main" class="tabbody">

                        <div class="filter" style="margin-top:15px;margin-left:0;">
                            <form action="{#url(0)#}" method="get">
                                <input name="keyword" type="text" class="inpMain" value="{#$_GPC['keyword']#}" size="20" placeholder="{#sale_name()#}名称"/>
                                <input class="btnGray" type="submit" value="搜索" />
                            </form>
                        </div>

                        <form name="action" method="post" action="{#url(0)#}" id="saveform">
                            <table width="100%" border="0" cellpadding="8" cellspacing="0" class="tableBasic">
                                <tr>
                                    <th width="22" align="center"><input name='chkall' type='checkbox' id='chkall' onclick='selectcheckbox(this.form)' value='check'></th>
                                    <th width="40" align="center">编号</th>
                                    <th align="left">{#sale_name()#}名称</th>
                                    <th align="left">兑换码</th>
                                    <th align="left">剩余/总数</th>
                                    <th align="left">折扣</th>
                                    <th align="left">自动获得</th>
                                    <th align="center">时间</th>
                                    <th width="60" align="center">状态</th>
                                    <th width="70" align="center">操作</th>
                                </tr>
                                {#foreach from=$sale['list'] item=item#}
                                    <tr data-id="{#$item.id#}">
                                        <td align="center"><input type="checkbox" name="checkbox[]" value="{#$item['id']#}" /></td>
                                        <td align="center">{#$item['id']#}</td>
                                        <td>
                                            {#$item['title']#}
                                        </td>
                                        <td>{#$item['code']#}</td>
                                        <td>{#$item['num']#}/{#$item['numall']#}</td>
                                        <td>
                                            {#if $item['sale_type'] == 'C'#}
                                                核销兑奖
                                            {#else#}
                                                {#floatval($item['sale'])#}
                                                {#if $item['sale_type'] == 'T'#}
                                                    小时
                                                {#elseif $item['sale_type'] == 'P'#}
                                                    %
                                                {#else#}
                                                    元
                                                {#/if#}
                                                {#if $item['min'] > 0#}（满{#$item['min']#}）{#/if#}
                                            {#/if#}
                                        </td>
                                        <td class="tags">
                                            {#foreach explode(",", $item['autoget']) AS $auto#}
                                                {#if $autoget[$auto]#}<em>{#$autoget[$auto]#}</em>{#/if#}
                                            {#/foreach#}
                                        </td>
                                        <td align="center">
                                            {#if $item['end_type'] == 'fixed'#}
                                                {#date("Y-m-d H:i:s", $item['startdate'])#} ~ {#date("Y-m-d H:i:s", $item['enddate'])#}
                                            {#elseif $item['end_type'] == 'day'#}
                                                领取后{#$item['end_day']|intval#}天过期
                                            {#elseif $item['end_type'] == 'each'#}
                                                {#if $item['end_each'] == 'day'#}
                                                    领取后当天过期
                                                {#elseif $item['end_each'] == 'week'#}
                                                    领取后本周过期
                                                {#elseif $item['end_each'] == 'month'#}
                                                    领取后本月过期
                                                {#elseif $item['end_each'] == 'year'#}
                                                    领取后本年过期
                                                {#/if#}
                                            {#/if#}
                                        </td>
                                        <td align="center">{#$item['status']#}</td>
                                        <td align="center">
                                            <a href="{#url('admin/sale_add')#}?id={#$item['id']#}">编辑</a> |
                                            <a href="{#url('admin/sale_notes')#}?id={#$item['id']#}">记录</a>
                                        </td>
                                    </tr>
                                    {#foreachelse#}
                                    <tr>
                                        <td colspan="10" align="center">暂无{#sale_name()#}</td>
                                    </tr>
                                {#/foreach#}
                            </table>
                            <div class="action">
                                <select name="action">
                                    <option value="0">请选择...</option>
                                    <option value="ordinary">启用</option>
                                    <option value="disabled">禁用</option>
                                    <option value="del_all">删除</option>
                                </select>
                                <input name="submit" class="btn" type="submit" value="执行" />
                            </div>
                        </form>
                    </div>
                    <div id="pagelist">
                        <a href="javascript:void(0);" style="cursor:default">总数量{#$sale['total']#}个</a>
                        {#$sale['page_html']#}
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
        $("td.tags").each(function(){
            if ($(this).find("em").length <= 0) {
                $(this).html("无")
            }
        });
        //
        $('#saveform').submit(function() {
            if (!confirm("确定操作吗？")) {
                return false;
            }
        });
        //
        document.forms['action'].reset();
    });
</script>
</body>
</html>