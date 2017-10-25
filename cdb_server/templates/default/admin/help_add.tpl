<!DOCTYPE html>
{#_head_html()#}
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=Edge,chrome=1" />
    <title>管理中心 - {#$_A['BASE_NAME']#}</title>
    <link href="{#$NOW_PATH#}css/public.css" rel="stylesheet" type="text/css">
    <style type="text/css">
        .formfile-inputbox img.img-thumbnail {
            max-width: 130px !important;
            max-height: 200px !important;
        }
        .wapcon {
            margin:3px 0 5px;display:block;
        }
        .wapcon input{
            vertical-align: middle;
            margin-top: -2px;
        }
    </style>
    <script type="text/javascript" src="{#$JS_PATH#}jquery.min.js"></script>
    <script type="text/javascript" src="{#$JS_PATH#}jquery.alert.js"></script>
    <script type="text/javascript" src="{#$JS_PATH#}jquery.form.min.js"></script>
    <script type="text/javascript" src="{#$NOW_PATH#}js/global.js"></script>
    <script type="text/javascript" src="{#$NOW_PATH#}js/jquery.tab.js"></script>
    <script type="text/javascript" src="{#$NOW_PATH#}js/jquery.autoTextarea.js"></script>

    <script charset="utf-8" src="{#$NOW_PATH#}js/kindeditor/kindeditor.js"></script>
    <script charset="utf-8" src="{#$NOW_PATH#}js/kindeditor/lang/zh_CN.js"></script>
    <script charset="utf-8" src="{#$NOW_PATH#}js/kindeditor/plugins/code/prettify.js"></script>

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
    {#tpl('_left', 'help')#}

    <div id="dcMain">
        <!-- 当前位置 -->
        <div id="urHere">管理中心<b>&gt;</b><strong>常见问题列表</strong> <b>&gt;</b><strong>{#$subtitle#}常见问题</strong></div>
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
                    <li><a href="#main">{#$subtitle#}常见问题</a></li>
                    <li><a href="{#url('admin/help')#}">返回列表</a></li>
                </ul>
                <div class="items">
                    <div id="main" class="tabbody">
                        <form action="{#get_url()#}" method="post" id="saveform">
                            <table width="100%" border="0" cellpadding="8" cellspacing="0" class="tableBasic">
                                <tr>
                                    <td width="90" align="right">问题</td>
                                    <td>
                                        <input type="text" name="title" value="{#$help['title']#}" size="80" class="inpMain" />
                                    </td>
                                </tr>
                                <tr>
                                    <td align="right">类别</td>
                                    <td>
                                        <input type="text" name="type" value="{#$help['type']#}" size="80" class="inpMain" />
                                    </td>
                                </tr>
                                <tr>
                                    <td align="right" valign="top">详细内容</td>
                                    <td class="form-uetext">
                                        <textarea id="content" name="content" style="width:780px;height:400px;" class="textArea">{#value($help,'content')#}</textarea>
                                    </td>
                                </tr>
                                <tr>
                                    <td></td>
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
    </div>
    <div class="clear"></div>
    {#tpl('_foot')#}
    <!-- dcFooter 结束 -->
    <div class="clear"></div>
</div>
<!-- KindEditor -->
<script>
    window.editor1 = null;
    KindEditor.ready(function(K) {
        window.editor1 = K.create('textarea[name="content"]', {
            cssPath : '{#$NOW_PATH#}js/kindeditor/plugins/code/prettify.css',
            uploadJson : '{#$NOW_PATH#}js/kindeditor/php/upload_json.php',
            fileManagerJson : '{#$NOW_PATH#}js/kindeditor/php/file_manager_json.php',
            allowFileManager : true,
            afterCreate : function() {
                var self = this;
                K.ctrl(document, 13, function() {
                    self.sync();
                });
                K.ctrl(self.edit.doc, 13, function() {
                    self.sync();
                });
            }
        });
        prettyPrint();
    });
</script>
<!-- /KindEditor -->
<script type="text/javascript">
    $(function(){
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
            if (window.editor1 !== null) {
                window.editor1.sync();
            }
            //
            $.alert('正在保存...', 0);
            $(this).ajaxSubmit({
                dataType : 'json',
                success : function (data) {
                    if (data != null && data.success != null && data.success) {
                        $.alert(data.message);
                        setTimeout(function(){
                            window.location.href = '{#url('admin/help')#}';
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