<!DOCTYPE html>
{#_head_html()#}
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=Edge,chrome=1" />
    <title>管理中心 - {#$_A['BASE_NAME']#}</title>
    <link href="{#$NOW_PATH#}css/public.css" rel="stylesheet" type="text/css">
    <script type="text/javascript" src="{#$JS_PATH#}jquery.min.js"></script>
    <script type="text/javascript" src="{#$JS_PATH#}jquery.alert.js"></script>
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
    {#tpl('_left', 'smstmpl')#}

    <div id="dcMain" class="smstmpl">
        <!-- 当前位置 -->
        <div id="urHere">管理中心<b>&gt;</b><strong>短信通知模板</strong></div>
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
                    <li><a href="#main">短信通知模板</a></li>
                    <li><a href="{#url('admin/smstmpl_add')#}">+添加短信模板</a></li>
                </ul>
                <div class="items">
                    <div id="main" class="tabbody">
                        <table width="100%" border="0" cellpadding="8" cellspacing="0" class="tableBasic">
                            <tr>
                                <th align="left">模板ID</th>
                                <th align="left">模板名称</th>
                                <th align="left">模板内容</th>
                                <th align="center" width="80">操作</th>
                            </tr>
                            {#foreach from=$smstmplmsg item=item#}
                                <tr>
                                    <td align="left">{#$item['tid']#}</td>
                                    <td align="left">{#$item['title']#}</td>
                                    <td align="left">{#$item['template']#}</td>
                                    <td align="center"><a href="{#url('admin/smstmpl_add')#}?id={#$item['id']#}">编辑</a> | <a href="{#url('admin/smstmpl')#}?did={#$item['id']#}" onclick="return confirm('确认删除吗？');return false;">删除</a></td>
                                </tr>
                                {#foreachelse#}
                                <tr>
                                    <td colspan="4" align="center">暂无</td>
                                </tr>
                            {#/foreach#}
                        </table>
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
</html>