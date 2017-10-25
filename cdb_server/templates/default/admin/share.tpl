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
    {#tpl('_left', 'share')#}

    <div id="dcMain">
        <!-- 当前位置 -->
        <div id="urHere">管理中心<b>&gt;</b><strong>分享设置</strong> </div>
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
                    <li><a href="#main">分享设置</a></li>
                </ul>
                <div class="items">
                    <form action="{#url(0)#}" method="post">
                        <div id="main" class="tabbody">
                            <table width="100%" border="0" cellpadding="8" cellspacing="0" class="tableBasic">
                                <tr>
                                    <th width="131">名称</th>
                                    <th>内容</th>
                                </tr>
                                <tr>
                                    <td align="right">分享标题</td>
                                    <td>
                                        <input type="text" name="title" value="{#$setting['title']#}" size="80" class="inpMain" /> 长度小于80个汉字
                                    </td>
                                </tr>
                                <tr>
                                    <td align="right">分享描述</td>
                                    <td>
                                        <input type="text" name="desc" value="{#$setting['desc']#}" size="80" class="inpMain" /> 长度小于120个汉字
                                    </td>
                                </tr>
                                <tr>
                                    <td align="right">微信APPID</td>
                                    <td>
                                        <input type="text" name="wx_appid" value="{#$setting['wx_appid']#}" size="80" class="inpMain" />
                                    </td>
                                </tr>
                                <tr>
                                    <td align="right">微博APPKEY</td>
                                    <td>
                                        <input type="text" name="wb_appkey" value="{#$setting['wb_appkey']#}" size="80" class="inpMain" />
                                    </td>
                                </tr>
                                <tr>
                                    <td align="right">微博分享描述</td>
                                    <td>
                                        <input type="text" name="wb_desc" value="{#$setting['wb_desc']#}" size="80" class="inpMain" /> 长度小于140个汉字
                                    </td>
                                </tr>
                                <tr>
                                    <td align="right">分享LOGO</td>
                                    <td>
                                        {#tpl_form_image("thumb", $setting['thumb'])#}
                                    </td>
                                </tr>
                                <tr>
                                    <td align="right" valign="top">邀请好友规则</td>
                                    <td class="form-uetext">
                                        <textarea id="rule" name="rule" style="width:780px;height:400px;" class="textArea">{#value($setting,'rule')#}</textarea>
                                    </td>
                                </tr>
                            </table>
                        </div>
                        <table width="100%" border="0" cellpadding="8" cellspacing="0" class="tableBasic">
                            <tr>
                                <td width="131"></td>
                                <td>
                                    <input name="submit" class="btn" type="submit" value="提交" />
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

</body>

<!-- KindEditor -->
<script>
    window.editor1 = null;
    KindEditor.ready(function(K) {
        window.editor1 = K.create('textarea[name="rule"]', {
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
</html>