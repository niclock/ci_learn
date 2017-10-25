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
    {#tpl('_left', 'system')#}

    <div id="dcMain">
        <!-- 当前位置 -->
        <div id="urHere">管理中心<b>&gt;</b><strong>系统设置</strong> </div>
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
                    <li><a href="#main">常规设置</a></li>
                    <li><a href="#mail">邮件服务器</a></li>
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
                                    <td align="right">站点名称</td>
                                    <td>
                                        <input type="text" name="name" value="{#$setting['name']#}" size="80" class="inpMain" />
                                    </td>
                                </tr>
                                <tr>
                                    <td align="right">网站名称</td>
                                    <td>
                                        <input type="text" name="title" value="{#$setting['title']#}" size="80" class="inpMain" />
                                    </td>
                                </tr>
                                <tr>
                                    <td align="right">客服电话</td>
                                    <td>
                                        <input type="text" name="tel_num" value="{#$setting['tel_num']#}" size="80" class="inpMain" />
                                        <p class="cue">例如：0771-1234567</p>
                                    </td>
                                </tr>
                                <tr>
                                    <td align="right">卡券名称</td>
                                    <td>
                                        <input type="text" name="sale_name" value="{#$setting['sale_name']#}" size="80" class="inpMain" />
                                        <p class="cue">例如：现金券；留空默认：优惠券</p>
                                    </td>
                                </tr>
                                <tr>
                                    <td align="right">认领密码</td>
                                    <td>
                                        <input type="hidden" name="_claim_pass" value="{#$setting['claim_pass']#}">
                                        <input type="text" name="claim_pass" value="" placeholder="留空不修改{#if $setting['claim_pass']#}（已设置）{#else#}（未设置）{#/if#}" size="80" class="inpMain" />
                                        <p class="cue">注明：商家认领设备时需要输入的密码，填写0则不需要密码</p>
                                    </td>
                                </tr>
                            </table>
                        </div>
                        <div id="mail" class="tabbody">
                            <table width="100%" border="0" cellpadding="8" cellspacing="0" class="tableBasic">
                                <tr>
                                    <th width="131">名称</th>
                                    <th>内容</th>
                                </tr>
                                <tr>
                                    <td align="right">SMTP服务器</td>
                                    <td>
                                        <input type="text" name="mail_host" value="{#$setting['mail_host']#}" size="80" class="inpMain" />
                                        <p class="cue">一般邮件服务器地址为：smtp.domain.com，如果是本机则对应localhost即可</p>
                                    </td>
                                </tr>
                                <tr style="display:none;">
                                    <td align="right">使用SSL方式</td>
                                    <td>
                                        <label><input type="radio" class="check" name="mail_ssl"{#che(value($setting,'mail_ssl'),'1')#}>是</label>　
                                        <label><input type="radio" class="check" name="mail_ssl"{#che(intval(value($setting,'mail_ssl')),'0')#}>否</label>
                                    </td>
                                </tr>
                                <tr>
                                    <td align="right">服务器端口</td>
                                    <td>
                                        <input type="text" name="mail_port" value="{#$setting['mail_port']#}" size="80" class="inpMain" />
                                        <p class="cue">一般服务器端口为：25</p>
                                    </td>
                                </tr>
                                <tr>
                                    <td align="right">发件邮箱</td>
                                    <td>
                                        <input type="text" name="mail_username" value="{#$setting['mail_username']#}" size="80" class="inpMain" />
                                    </td>
                                </tr>
                                <tr>
                                    <td align="right">发件邮箱密码</td>
                                    <td>
                                        <input type="password" name="mail_password" value="{#$setting['mail_password']#}" size="80" class="inpMain" />
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
</html>