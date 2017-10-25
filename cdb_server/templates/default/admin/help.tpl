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
    <script type="text/javascript">
        $(function(){
            $(".mainBox").css('min-height', $(window).height() - 195);
        });
    </script>
    <style type="text/css">
        #put{cursor:pointer;}
        .ispc{cursor:pointer}
        .ispc:hover{text-decoration:underline}
    </style>
</head>
<body>
<div id="dcWrap">

    {#tpl('_top')#}
    <!-- dcHead 结束 -->
    {#tpl('_left', 'help')#}

    <div id="dcMain">
        <!-- 当前位置 -->
        <div id="urHere">管理中心<b>&gt;</b><strong>常见问题列表</strong> </div>
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
                    <li><a href="#main">常见问题列表</a></li>
                    <li><a href="{#url('admin/help_add')#}">+添加问题</a></li>
                </ul>
                <div class="items">
                    <div id="main" class="tabbody">

                        <div class="filter" style="margin-top:15px;margin-left:0;">
                            <form action="{#url(0)#}" method="get">
                                <input name="keyword" type="text" class="inpMain" value="{#$_GPC['keyword']#}" size="20" />
                                <input class="btnGray" type="submit" value="搜索" />
                            </form>
                        </div>

                        <form name="action" method="post" action="{#url(0)#}" id="saveform">
                            <table width="100%" border="0" cellpadding="8" cellspacing="0" class="tableBasic">
                                <tr>
                                    <th width="22" align="center"><input name='chkall' type='checkbox' id='chkall' onclick='selectcheckbox(this.form)' value='check'></th>
                                    <th width="40" align="center">编号</th>
                                    <th align="center">类型</th>
                                    <th align="left">问题名称</th>
                                    <th align="left">简略答案</th>
                                    <th width="40" align="center">阅读/次</th>
                                    <th width="140" align="center">添加日期</th>
                                    <th width="80" align="center">操作</th>
                                </tr>
                                {#foreach from=$help['list'] item=item#}
                                    <tr data-id="{#$item.id#}">
                                        <td align="center"><input type="checkbox" name="checkbox[]" value="{#$item['id']#}" /></td>
                                        <td align="center">{#$item['id']#}</td>
                                        <td align="center">{#$item['type']#}</td>
                                        <td align="left">{#$item['title']#}</td>
                                        <td align="left">{#get_html($item['content'], 50)#}</td>
                                        <td align="center">{#$item['view']#}</td>
                                        <td align="center">{#date("Y-m-d H:i:s", $item['indate'])#}</td>
                                        <td align="center">
                                            <a href="{#url('admin/help_add')#}?id={#$item['id']#}">编辑</a> |
                                            <a href="{#url('admin/help_del')#}?id={#$item['id']#}" onclick="return confirm('确认删除吗？');return false;">删除</a>
                                        </td>
                                    </tr>
                                    {#foreachelse#}
                                    <tr>
                                        <td colspan="8" align="center">暂无文章</td>
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
                        <a href="javascript:void(0);" style="cursor:default">总数量{#$help['total']#}个</a>
                        {#$help['page_html']#}
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