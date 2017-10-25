<!DOCTYPE html>
{#_head_html()#}
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=Edge,chrome=1" />
    <title>管理中心 - {#$_A['BASE_NAME']#}</title>
    <link href="{#$NOW_PATH#}css/public.css" rel="stylesheet" type="text/css">
    <style type="text/css">
        .cok {
            display: inline-block;
            height: 20px;
            line-height: 20px;
            padding: 0 5px;
            background: #3f9bdd;
            color: #fff;
            border-radius: 2px;
            margin-right: 5px;
            vertical-align: middle
        }
    </style>
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
    {#tpl('_left', 'pay')#}

    <div id="dcMain">
        <!-- 当前位置 -->
        <div id="urHere">管理中心<b>&gt;</b><strong>支付设置</strong> </div>
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
                    <li><a href="#main">支付宝</a></li>
                    <li><a href="#weixin">微信公众号</a></li>
                    <li><a href="#wxxiaoapp">微信小程序</a></li>
                    <li><a href="#weixinapp">微信APP</a></li>
                    <li><a href="#credit">信用支付</a></li>
                    <li><a href="#over">余额支付</a></li>
                </ul>
                <div class="items">
                    <form action="{#url(0)#}" method="post" enctype="multipart/form-data">
                        <div id="main" class="tabbody">
                            <table width="100%" border="0" cellpadding="8" cellspacing="0" class="tableBasic">
                                <tr>
                                    <th width="131">名称</th>
                                    <th>内容</th>
                                </tr>
                                <tr>
                                    <td align="right">APP移动支付</td>
                                    <td>
                                        <label><input type="radio" class="check" name="alipay[openapp]"{#che(value($setting,'alipay|openapp'),'1')#}> 开通</label>　
                                        <label><input type="radio" class="check" name="alipay[openapp]"{#che(intval(value($setting,'alipay|openapp')),'0')#}> 关闭</label>
                                    </td>
                                </tr>
                                <tr>
                                    <td align="right">应用ID</td>
                                    <td>
                                        <input type="text" name="alipay[appid]" value="{#$setting['alipay']['appid']#}" size="60" class="inpMain"/>
                                        (APPID)
                                    </td>
                                </tr>
                                <tr>
                                    <td align="right">商户秘钥<br/>(rsaPriKey)</td>
                                    <td>
                                        <textarea class="inpMain" style="width:427px;height:80px;" name="alipay[rsaprikey]">{#$setting['alipay']['rsaprikey']#}</textarea>

                                    </td>
                                </tr>
                                <tr>
                                    <td align="right">支付宝公钥<br/>(rsaPublicKey)</td>
                                    <td>
                                        <textarea class="inpMain" style="width:427px;height:80px;" name="alipay[rsapublickey]">{#$setting['alipay']['rsapublickey']#}</textarea>

                                    </td>
                                </tr>
                            </table>
                        </div>
                        <div id="weixin" class="tabbody">
                            <table width="100%" border="0" cellpadding="8" cellspacing="0" class="tableBasic">
                                <tr>
                                    <th width="131">名称</th>
                                    <th>内容</th>
                                </tr>
                                <tr>
                                    <td align="right">微信公众号支付</td>
                                    <td>
                                        <label><input type="radio" class="check" name="weixin[open]"{#che(value($setting,'weixin|open'),'1')#}> 开通</label>　
                                        <label><input type="radio" class="check" name="weixin[open]"{#che(intval(value($setting,'weixin|open')),'0')#}> 关闭</label>
                                    </td>
                                </tr>
                                <tr>
                                    <td align="right">身份标识(AppID)</td>
                                    <td>
                                        <input type="text" name="weixin[appid]" value="{#$setting['weixin']['appid']#}" size="60" class="inpMain" />
                                    </td>
                                </tr>
                                <tr>
                                    <td align="right">身份密钥(AppSecret)</td>
                                    <td>
                                        <input type="text" name="weixin[secret]" value="{#$setting['weixin']['secret']#}" size="60" class="inpMain" />
                                    </td>
                                </tr>
                                <tr>
                                    <td align="right">微信支付商户号(MchId)</td>
                                    <td>
                                        <input type="text" name="weixin[mchid]" value="{#$setting['weixin']['mchid']#}" size="60" class="inpMain" />
                                    </td>
                                </tr>
                                <tr>
                                    <td align="right">商户支付密钥(API密钥)</td>
                                    <td>
                                        <input type="text" name="weixin[apikey]" value="{#$setting['weixin']['apikey']#}" size="60" class="inpMain" />
                                    </td>
                                </tr>
                                <tr>
                                    <td align="right">支付证书<br/>（上传后不会有记录）</td>
                                    <td>
                                        <table width="100%" border="0" cellpadding="8" cellspacing="0" class="tableBasic">
                                            <tbody>
                                            <tr>
                                                <td>
                                                    <input type="file" name="wx_cert" class="inpMain" />
                                                    {#if $setting['wx_cert']#}<span class="cok">已传</span>{#/if#}下载证书 cert.zip 中的 apiclient_cert.pem 文件
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <input type="file" name="wx_cert_key" class="inpMain" />
                                                    {#if $setting['wx_cert_key']#}<span class="cok">已传</span>{#/if#}下载证书 cert.zip 中的 apiclient_key.pem 文件
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <input type="file" name="wx_cert_rootca" class="inpMain" />
                                                    {#if $setting['wx_cert_rootca']#}<span class="cok">已传</span>{#/if#}下载证书 cert.zip 中的 rootca.pem 文件
                                                </td>
                                            </tr>
                                            </tbody>
                                        </table>
                                    </td>
                                </tr>
                            </table>
                        </div>
                        <div id="wxxiaoapp" class="tabbody">
                            <table width="100%" border="0" cellpadding="8" cellspacing="0" class="tableBasic">
                                <tr>
                                    <th width="131">名称</th>
                                    <th>内容</th>
                                </tr>
                                <tr>
                                    <td align="right">微信小程序支付</td>
                                    <td>
                                        <label><input type="radio" class="check" name="weixin[openxiaoapp]"{#che(value($setting,'weixin|openxiaoapp'),'1')#}> 开通</label>　
                                        <label><input type="radio" class="check" name="weixin[openxiaoapp]"{#che(intval(value($setting,'weixin|openxiaoapp')),'0')#}> 关闭</label>
                                    </td>
                                </tr>
                                <tr>
                                    <td align="right">身份标识(AppID)</td>
                                    <td>
                                        <input type="text" name="weixin[xiaoapp_appid]" value="{#$setting['weixin']['xiaoapp_appid']#}" size="60" class="inpMain" />
                                    </td>
                                </tr>
                                <tr>
                                    <td align="right">身份密钥(AppSecret)</td>
                                    <td>
                                        <input type="text" name="weixin[xiaoapp_secret]" value="{#$setting['weixin']['xiaoapp_secret']#}" size="60" class="inpMain" />
                                    </td>
                                </tr>
                                <tr>
                                    <td align="right">微信支付商户号(MchId)</td>
                                    <td>
                                        <input type="text" name="weixin[xiaoapp_mchid]" value="{#$setting['weixin']['xiaoapp_mchid']#}" size="60" class="inpMain" />
                                    </td>
                                </tr>
                                <tr>
                                    <td align="right">商户支付密钥(API密钥)</td>
                                    <td>
                                        <input type="text" name="weixin[xiaoapp_apikey]" value="{#$setting['weixin']['xiaoapp_apikey']#}" size="60" class="inpMain" />
                                    </td>
                                </tr>
                                <tr>
                                    <td align="right">支付证书<br/>（上传后不会有记录）</td>
                                    <td>
                                        <table width="100%" border="0" cellpadding="8" cellspacing="0" class="tableBasic">
                                            <tbody>
                                            <tr>
                                                <td>
                                                    <input type="file" name="wxxiaoapp_cert" class="inpMain" />
                                                    {#if $setting['wxxiaoapp_cert']#}<span class="cok">已传</span>{#/if#}下载证书 cert.zip 中的 apiclient_cert.pem 文件
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <input type="file" name="wxxiaoapp_cert_key" class="inpMain" />
                                                    {#if $setting['wxxiaoapp_cert_key']#}<span class="cok">已传</span>{#/if#}下载证书 cert.zip 中的 apiclient_key.pem 文件
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <input type="file" name="wxxiaoapp_cert_rootca" class="inpMain" />
                                                    {#if $setting['wxxiaoapp_cert_rootca']#}<span class="cok">已传</span>{#/if#}下载证书 cert.zip 中的 rootca.pem 文件
                                                </td>
                                            </tr>
                                            </tbody>
                                        </table>
                                    </td>
                                </tr>
                            </table>
                        </div>
                        <div id="weixinapp" class="tabbody">
                            <table width="100%" border="0" cellpadding="8" cellspacing="0" class="tableBasic">
                                <tr>
                                    <th width="131">名称</th>
                                    <th>内容</th>
                                </tr>
                                <tr>
                                    <td align="right">APP移动支付</td>
                                    <td>
                                        <label><input type="radio" class="check" name="weixin[openapp]"{#che(value($setting,'weixin|openapp'),'1')#}> 开通</label>　
                                        <label><input type="radio" class="check" name="weixin[openapp]"{#che(intval(value($setting,'weixin|openapp')),'0')#}> 关闭</label>
                                    </td>
                                </tr>
                                <tr>
                                    <td align="right">身份标识(AppID)</td>
                                    <td>
                                        <input type="text" name="weixin[app_appid]" value="{#$setting['weixin']['app_appid']#}" size="60" class="inpMain" />
                                    </td>
                                </tr>
                                <tr>
                                    <td align="right">身份密钥(AppSecret)</td>
                                    <td>
                                        <input type="text" name="weixin[app_secret]" value="{#$setting['weixin']['app_secret']#}" size="60" class="inpMain" />
                                    </td>
                                </tr>
                                <tr>
                                    <td align="right">微信支付商户号(MchId)</td>
                                    <td>
                                        <input type="text" name="weixin[app_mchid]" value="{#$setting['weixin']['app_mchid']#}" size="60" class="inpMain" />
                                    </td>
                                </tr>
                                <tr>
                                    <td align="right">商户支付密钥(API密钥)</td>
                                    <td>
                                        <input type="text" name="weixin[app_apikey]" value="{#$setting['weixin']['app_apikey']#}" size="60" class="inpMain" />
                                    </td>
                                </tr>
                                <tr>
                                    <td align="right">支付证书<br/>（上传后不会有记录）</td>
                                    <td>
                                        <table width="100%" border="0" cellpadding="8" cellspacing="0" class="tableBasic">
                                            <tbody>
                                            <tr>
                                                <td>
                                                    <input type="file" name="wxapp_cert" class="inpMain" />
                                                    {#if $setting['wxapp_cert']#}<span class="cok">已传</span>{#/if#}下载证书 cert.zip 中的 apiclient_cert.pem 文件
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <input type="file" name="wxapp_cert_key" class="inpMain" />
                                                    {#if $setting['wxapp_cert_key']#}<span class="cok">已传</span>{#/if#}下载证书 cert.zip 中的 apiclient_key.pem 文件
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <input type="file" name="wxapp_cert_rootca" class="inpMain" />
                                                    {#if $setting['wxapp_cert_rootca']#}<span class="cok">已传</span>{#/if#}下载证书 cert.zip 中的 rootca.pem 文件
                                                </td>
                                            </tr>
                                            </tbody>
                                        </table>
                                    </td>
                                </tr>
                            </table>
                        </div>
                        <div id="credit" class="tabbody">
                            <table width="100%" border="0" cellpadding="8" cellspacing="0" class="tableBasic">
                                <tr>
                                    <th width="131">名称</th>
                                    <th>内容</th>
                                </tr>
                                <tr>
                                    <td align="right">芝麻信用免押金</td>
                                    <td>
                                        <label><input type="radio" class="check" name="credit[zhima_open]"{#che(value($setting,'credit|zhima_open'),'1')#}> 开通</label>　
                                        <label><input type="radio" class="check" name="credit[zhima_open]"{#che(intval(value($setting,'credit|zhima_open')),'0')#}> 关闭</label>
                                    </td>
                                </tr>
                                <tr>
                                    <td align="right">芝麻分认证要求</td>
                                    <td>
                                        <input type="text" name="credit[zhima_fen]" value="{#intval($setting['credit']['zhima_fen'])#}" size="30" class="inpMain" /> <font color="red">请慎重修改！</font>
                                    </td>
                                </tr>
                                <tr>
                                    <td align="right">信用免押可借数</td>
                                    <td>
                                        <input type="text" name="credit[borrow_num]" value="{#intval($setting['credit']['borrow_num'])#}" size="30" class="inpMain" /> 使用信用最多能免押金借用多少个设备（默认0不限制）
                                    </td>
                                </tr>
                                <tr>
                                    <td align="right">白名单信用免押金</td>
                                    <td>
                                        <label><input type="radio" class="check" name="credit[white_open]"{#che(value($setting,'credit|white_open'),'1')#}> 开通</label>　
                                        <label><input type="radio" class="check" name="credit[white_open]"{#che(intval(value($setting,'credit|white_open')),'0')#}> 关闭</label>
                                    </td>
                                </tr>
                            </table>
                        </div>
                        <div id="over" class="tabbody">
                            <table width="100%" border="0" cellpadding="8" cellspacing="0" class="tableBasic">
                                <tr>
                                    <th width="131">名称</th>
                                    <th>内容</th>
                                </tr>
                                <tr>
                                    <td align="right">开通余额支付</td>
                                    <td>
                                        <label><input type="radio" class="check" name="over[open]"{#che(value($setting,'over|open'),'1')#}> 开通</label>　
                                        <label><input type="radio" class="check" name="over[open]"{#che(intval(value($setting,'over|open')),'0')#}> 关闭</label>
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