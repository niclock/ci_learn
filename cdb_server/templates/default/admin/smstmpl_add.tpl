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
</head>
<body>
<div id="dcWrap">

    {#tpl('_top')#}
    <!-- dcHead 结束 -->
    {#tpl('_left', 'smstmpl')#}

    <div id="dcMain" class="fare">
        <!-- 当前位置 -->
        <div id="urHere">管理中心<b>&gt;</b><strong>短信通知模板</strong> <b>&gt;</b><strong>{#$subtitle#}模板</strong></div>
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
                    <li><a href="#main">{#$subtitle#}模板</a></li>
                    <li><a href="{#url('admin/smstmpl')#}">返回列表</a></li>
                </ul>
                <div class="items">
                    <div id="main" class="tabbody">
                        <form action="{#get_url()#}" method="post" id="saveform">
                            <input type="hidden" name="submit" value="1">
                            <table width="100%" border="0" cellpadding="8" cellspacing="0" class="tableBasic">
                                <tr>
                                    <td width="80" align="right">模板ID</td>
                                    <td>
                                        <input type="text" name="tid" value="{#$smstmpl['tid']#}" size="40" class="inpMain" />
                                    </td>
                                </tr>
                                <tr>
                                    <td align="right">模板名称</td>
                                    <td>
                                        <input type="text" name="title" value="{#$smstmpl['title']#}" size="60" class="inpMain" />
                                    </td>
                                </tr>
                                <tr>
                                    <td align="right">模板内容</td>
                                    <td>
                                        <textarea class="inpMain" name="template" cols="60" rows="3">{#$smstmpl['template']#}</textarea>
                                    </td>
                                </tr>
                                <tr>
                                    <td></td>
                                    <td>
                                        <input class="btn" type="submit" value="提交" />
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
<script type="text/javascript">
    $(function(){
        //保存数据事件
        $('#saveform').submit(function() {
            $.alert('正在保存...', 0);
            $(this).ajaxSubmit({
                dataType : 'json',
                success : function (data) {
                    if (data != null && data.success != null && data.success) {
                        $.alert(data.message);
                        setTimeout(function(){
                            window.location.href = '{#url('admin/smstmpl')#}';
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
    });
</script>
</body>
</html>