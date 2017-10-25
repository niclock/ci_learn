{#$setting = setting('system')#}
<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, minimum-scale=1, user-scalable=no">
	<meta name="format-detection" content="telephone=no" />
	<meta name="apple-mobile-web-app-capable" content="yes">
	<meta name="apple-mobile-web-app-status-bar-style" content="black">
	<title>{#$setting['title']#}</title>
	<style>
        *{-webkit-box-sizing:border-box;-moz-box-sizing:border-box;box-sizing:border-box;list-style:none;outline:0;padding:0;margin:0}
        body,html{background-color:#f3f4f5;}
        .head{width:100%;height:210px;background:#fff url({#$NOW_PATH#}index/banner.jpg) center no-repeat;background-size:cover}
        .head .logo{display:block;text-align:center;padding-top:50px}
        .head .logo img{width:80px;height:80px}
        .head .title{color:#fff;font-size:16px;text-align:center;padding-top:20px}
        .userhead{position:fixed;z-index:1;top:15px;left:20px;width:40px;height:40px;}
        .userhead img{width:100%;height:100%;}
        .info{background-color:#fff;margin-top:15px;padding:20px 16px}
        .info .title{text-align:center;font-size:20px;padding:10px 0;font-weight:700}
        .info .content{padding-top:20px}
        .info .content img{width:100%;height:100%}
        .popupbox{display:none;position:fixed;top:0;left:0;width:100%;height:100%;z-index:2;background-color:rgba(0,0,0,.7)}
        .popupbox .table{display:table;text-align:center;width:100%;height:100%}
        .popupbox .cell{display:table-cell;vertical-align:middle}
        .popupbox .popup{background-color:#fff;display:inline-block;width:90%;max-width:480px}
        .popupbox .popup .title{height:48px;line-height:48px;background-color:#f8f8f8;border:1px solid #eee;text-align:left;padding:0 15px;font-size:18px;min-width:180px}
        .popupbox .popup .inbox{padding:26px 38px}
        .popupbox .popup .inbox input{border:1px solid #ddd;font-size:18px;height:46px;line-height:46px;padding:0 10px;margin:20px 0 12px;width:100%;display:block}
        .popupbox .popup .intis{text-align:right;padding-right:20px;color:#ff5722}
        .popupbox .popup .btns{margin-top:5px;padding:12px 10px;text-align:right;border-top:1px solid #eee;}
        .popupbox .popup .btns a{display:inline-block;color:#ff5722;font-size:18px;padding:5px 16px;text-decoration:none}
        .popupbox .popup .btns a:first-child{color:#aaa}
        .popupbox .popup .btns a.hover{color:#ff5722}
        .tisbox{position:fixed;top:0;left:0;z-index:9999;width:100%;height:100%;background-color:rgba(0,0,0,.7)}
        .tisbox .table{display:table;text-align:center;width:100%;height:100%}
        .tisbox .cell{display:table-cell;vertical-align:middle}
        .tisbox .tis{display:inline-block;padding:16px 20px;max-width:90%;font-size:18px;background-color:#fff;border-radius:8px}
        .downbox .flex{position:fixed;left:0;bottom:0;width:100%;background-color:#ff5722;color:#fff;display:-webkit-box;display:-webkit-flex;display:flex}
        .downbox .logo{display:block}
        .downbox .logo img{display:block;margin:10px;width:40px;height:40px}
        .downbox .center{-webkit-box-flex:1;-webkit-flex:1;flex:1;line-height:20px}
        .downbox .center .title{margin-top:10px;font-size:16px}
        .downbox .center .subtitle{margin-top:2px;font-size:14px}
        .downbox .btn{background-color:#fff;color:#ff5722;height:32px;line-height:32px;padding:0 8px;margin-top:15px;margin-right:13px}
        .relabox{position:relative}
        .relabox button{position:absolute;right:0;font-size:14px;top:0;bottom:0;padding:0 10px;background-color:#ff5925;border:0;color:#fff}
        .infobox{margin:20px;padding:20px;border-radius:2px;font-size:16px;background-color:#ffffff;box-shadow:0 1px 3px rgba(0,0,0,.1);}
        .infobox p{padding:10px 0;margin:0;color:#666;border-bottom:1px dashed #f1f1f1;}
        .infobox p em{display:block;float:right;text-align:right;color:#333;font-style:normal;font-size:17px;}
        .infobox p.content{text-align:center;border:0;color:#333333;margin:5px 0 -5px;}
        .infobox .buttonbox{margin-top:20px;margin-bottom:5px;}
        .infobox .buttonbox .button{height:48px;line-height:48px;border-radius:3px;background:#4caf50;color:#fff;text-decoration:none;text-align:center;display:block;padding:0 8px;position:relative;overflow:hidden;outline:0;border:none;}
        .infobox .buttonbox .button.deeporange{background:#ff5722;color:#fff;}
        .infobox .buttonbox .explain,.infobox .buttonbox .giveback{display:block;text-align:center;margin-top:15px;color:#4caf50;text-decoration:underline}
        .infobox .buttonbox .explain{margin-top:18px;}
        .infobox .buttonbox .xiaochengxu{width:100%;display:block;margin:0 auto}
        .okimg{width:38%;max-width:280px;border:5px solid #4caf50;border-radius:50%;}
        .okinfo{margin-top:10px;line-height:28px;font-size:18px;color:#4caf50;}
        .okinfo span{border-bottom:1px dashed #4caf50;font-weight:600}
        .explaininfo{text-align:left}
        .explaininfo p{padding:5px 0;line-height:22px;}
        .xiaochengxuBox {display:none;position:fixed;top:0;left:0;width:100%;height:100%;z-index:9;background-color:rgba(0, 0, 0, 0.8)}
        .xiaochengxuBox .table-box {display:table;width:100%;height:100%;text-align:center;}
        .xiaochengxuBox .table-box .table-cell{display:table-cell;width:100%;height:100%;vertical-align:middle;}
        .xiaochengxuBox .table-box .table-cell .text{text-align:center;color:#ffffff;font-size:18px;margin-bottom:8px;}
        .xiaochengxuBox .table-box .table-cell img{width:68%;}
        .givebackbox .inbox .text{font-size:18px;color:#4caf50;}
        .givebackbox .inbox .next{background-image:url({#$NOW_PATH#}index/next.png);background-repeat:no-repeat;background-position:center;background-size:contain;width:38px;height:38px;margin:10px auto;}
    </style>
    <script type="text/javascript" src="http://apps.bdimg.com/libs/zepto/1.1.4/zepto.min.js"></script>
    <script type="text/javascript">
        var userid = parseInt({#intval($_A['user']['id'])#}),
            cdbuserid = parseInt({#intval($cdb['userid'])#}),
            jsapiParameters = {};
        //
        function __down() {
            window.location.href = 'http://s.gengdian.net/app/';
        }
        function __tis(tis) {
            $("div.tisbox").remove();
            if (typeof tis === 'undefined') return;
            //
            var intemp = '<div class="tisbox">' +
                '<div class="table">' +
                '<div class="cell">' +
                '<div class="tis">' + tis + '</div>' +
                '</div>' +
                '</div>' +
                '</div>';
            $("body").append(intemp);
        }
        function __user() {
            if (userid === 0) {
                $(".loginbox").show();
                return;
            }
            $(".userbox").show();
        }
        function __getSms(type) {
            var obj = $(".loginbox");
            var codeObj = obj.find("#codebtn");
            if (codeObj.text() !== '获取验证码') return;
            var phone = obj.find("#login_username").val();
            if (/^1[34578]\d{9}$/.test(phone)|| /^1(3|4|5|7|8)\d{11}$/.test(phone)) {


                __tis("正在获取验证码...");
                //
                $.ajax({
                    url: '{#url('api/users/sms')#}',
                    data: {
                        userphone: obj.find("#login_username").val(),
                        type: type
                    },
                    type: 'POST',
                    dataType: 'json',
                    success: function (response) {
                        if (response.success === 1) {
                            var second = 120;
                            codeObj.text(second + '秒后重试');
                            var codeInter = setInterval(function () {
                                second--;
                                if (second <= 0) {
                                    codeObj.text('获取验证码');
                                    clearInterval(codeInter);
                                } else {
                                    codeObj.text(second + '秒后重试');
                                }
                            }, 1000);
                            __tis("【手机尾号: " + response.last4 + "】<br/>" + response.message, 8000);
                        } else {
                            __tis(response.message);
                        }
                        setTimeout(function () {
                            __tis()
                        }, 3000)
                    },
                    error: function () {
                        __tis();
                        alert("网络繁忙，请稍后再试！");
                    }
                });
            }else {
                alert("请输入正确的手机号码！");
                obj.find("#login_username").focus();
                return;
            }
        }
        function __login() {
            var obj = $(".loginbox");
            __tis("正在登录...");
            //
            $.ajax({
                url: '{#url('api/users/login')#}',
                data: {
                    userphone: obj.find("#login_username").val(),
                    code: obj.find("#login_code").val(),
                    fromid: '{#$userid#}',
                    {#if $wx_openid#}wx_openid: 'in'{#/if#}
                },
                type: 'POST',
                dataType: 'json',
                success: function(data) {
                    if (data.success === 1) {
                        //登录成功
                        __tis("登陆成功");
                        window.location.href = '{#get_link('action')#}&action=__pay';
                        userid = data.message.id;
                    }else{
                        //登录失败
                        __tis();
                        alert(data.message);
                        obj.show();
                    }
                },
                error: function() {
                    //登录错误
                    __tis();
                    alert("网络繁忙，请稍后再试！");
                }
            });
        }
        function __out() {
            __tis("正在退出...");
            //
            $.ajax({
                url: '{#url('api/users/out')#}',
                type: 'POST',
                data: {
                    clear:'wx_openid'
                },
                dataType: 'json',
                success: function() {
                    __tis("退出成功");
                    setTimeout(function(){
                        window.location.href = '{#get_link('action')#}&action=reuser';
                    }, 300);
                }
            });
        }
        function __pay(act) {
            if (userid === 0) {
                $(".loginbox").show();
                return;
            }
            if (userid === cdbuserid) {
                return;
            }
            //
            if (act === 'borrow') {
                //已付押金直接借用
                $(".borrowbox").show();
            } else if (act === 'weixin') {
                //微信支付押金借用
                var payid = '102{#$_A['user']['id']#}_' + new Date().getTime() + '0' + Math.round(Math.random() * 10000);
                var __callpay = function() {
                    if (typeof WeixinJSBridge === "undefined"){
                        if( document.addEventListener ){
                            document.addEventListener('WeixinJSBridgeReady', __jsApiCall, false);
                        }else if (document.attachEvent){
                            document.attachEvent('WeixinJSBridgeReady', __jsApiCall);
                            document.attachEvent('onWeixinJSBridgeReady', __jsApiCall);
                        }
                    }else{
                        __jsApiCall();
                    }
                };
                __tis("微信安全支付打开中...");
                $.ajax({
                    url: '{#url('payment/wxpay_jsapi')#}',
                    data: {
                        sn: '{#$cdb['sn']#}',       //设配编号
                        payid: payid,               //订单id
                        openid: "{#$wx_openid#}"       //openid
                    },
                    type: 'POST',
                    dataType: 'json',
                    success: function(data) {
                        if (data.success === 1) {
                            jsapiParameters = data.message;
                            __callpay();
                        }else{
                            __tis(); alert(data.message);
                        }
                    },
                    error: function() {
                        __tis(); alert("网络繁忙，请稍后再试！");
                    }
                });
            }
        }
        function __jsApiCall() {
            __tis();
            //
            WeixinJSBridge.invoke('getBrandWCPayRequest', jsapiParameters, function (res) {
                if (res.err_msg === 'get_brand_wcpay_request:ok') {
                    $(".infobox").html($(".infobox_hide").html());
                    $(".okbox").show();
                } else {
                    if (res.err_msg === 'get_brand_wcpay_request:cancel') {
                        alert("您已取消支付！");
                    } else {
                        alert('启动微信支付失败，详细错误为: ' + res.err_msg);
                    }
                }
            });
        }
        function __borrow() {
            __tis("正在借用...");
            $.ajax({
                url: '{#url('api/users/borrow')#}',
                data: {
                    sn: '{#$cdb['sn']#}'       //设配编号
                },
                type: 'POST',
                dataType: 'json',
                success: function(data) {
                    __tis();
                    if (data.success === 1) {
                        $(".okbox").show();
                    }else{
                        alert(data.message);
                    }
                },
                error: function() {
                    __tis(); alert("网络繁忙，请稍后再试！");
                }
            });
        }
        //
        $(function(){
            {#if $_GPC['action'] == '__pay'#}$(".paybutton").click();{#/if#}
            //
            var winHeight = $(window).height();
            $(window).resize(function(){
                if ($(window).height() < winHeight - 10) {
                    $(".downbox").hide();
                }else{
                    $(".downbox").show();
                }
            });
            //检测是否有订单未付款弹出提示
            if (userid > 0) {
                $.ajax({
                    url: '{#url('api/users/order_lists')#}',
                    data: {
                        act: 'await'
                    },
                    type: 'POST',
                    dataType: 'json',
                    success: function(data) {
                        if (data.success === 1) {
                            if (confirm('您有' + data.message + '个订单【未结算】，请结算后再继续使用~')) {
                                $(".xiaochengxuBox").show();
                            }
                        }
                    }
                });
            }
        });
    </script>
</head>
<body>

<div class="head">
    <div class="logo">
        <img src="{#$IMG_PATH#}logo.png">
    </div>
    <div class="title">分享不断电 · 生活不掉线</div>
</div>

<div class="userhead" onclick="__user();">
    <img src="{#$NOW_PATH#}index/user.png">
</div>

<div class="xiaochengxuBox">
   <div class="table-box">
       <div class="table-cell">
           <div class="text">亲，请使用小程序结算~</div>
           <img src="{#$NOW_PATH#}index/xiaochengxu.jpg">
       </div>
   </div>
</div>

{#if $cdb#}

    <div class="infobox">
        {#if $_A['browser'] == 'weixin' && $cdb['type'] == '充电宝'#}
            {#if $cdb['userid'] == 0#}
                <p>设备编码：<em>{#$cdb['sn']#}</em></p>
                <p class="content">此设备尚未投入使用！</p>
                <div class="buttonbox">
                    <div class="button deeporange" onclick="$('.givebackbox').show();">如何归还设备？</div>
                </div>
            {#elseif $cdb['userid'] == $_A['user']['id']#}
                <p>设备编码：<em>{#$cdb['sn']#}</em></p>
                <p>借用会员：<em>{#card_format($cdb['userinfo']['userphone'])#}</em></p>
                <p class="content">此设备正在被您借用！</p>
                <div class="buttonbox">
                    <div class="button deeporange" onclick="$('.givebackbox').show();">如何归还设备？</div>
                </div>
            {#elseif $cdb['status'] != '启用'#}
                <p>设备编码：<em>{#$cdb['sn']#}</em></p>
                <p>借用会员：<em>{#card_format($cdb['userinfo']['userphone'])#}</em></p>
                <p class="content">此设备正在被借用！</p>
                <div class="buttonbox">
                    <div class="button deeporange" onclick="$('.givebackbox').show();">如何归还设备？</div>
                </div>
            {#else#}
                <p>借用设备：<em>{#$cdb['title']#}</em></p>
                <p>设备编码：<em>{#$cdb['sn']#}</em></p>
                {#if $_A['user']['id'] > 0#}
                    <p>借用押金：<em>{#$smarty.const.DEPOSIT#}元</em></p>
                {#/if#}
                <p>借出门店：<em>{#$cdb['userinfo']['username']#}</em></p>
                <div class="buttonbox">
                    {#if depositNum() > 0#}
                        <div class="button paybutton" onclick="__pay('borrow');">立即借用（已付押金）</div>
                    {#else#}
                        <div class="button paybutton" onclick="__pay('weixin');">
                            {#if $_A['user']['id'] > 0#}
                                微信支付（押金{#$smarty.const.DEPOSIT#}元）
                            {#else#}
                                立即借用
                            {#/if#}
                        </div>
                    {#/if#}
                    {#if $_A['user']['id'] > 0#}
                        <div class="explain" onclick="$('.explainbox').show();">押金说明</div>
                    {#/if#}
                    <div class="giveback" onclick="$('.givebackbox').show();">如何归还设备?</div>
                </div>
            {#/if#}
        {#else#}
            <p style="border:0">设备编码：<em>{#$cdb['sn']#}</em></p>
            <div class="buttonbox">
                {#if $cdb['type'] == '雨伞'#}
                    <img src="{#$NOW_PATH#}index/xiaochengxu.jpg" class="xiaochengxu">
                    {#*<div class="button paybutton" onclick="__down();">微信暂不支持借用雨伞功能</div>*#}
                {#/if#}
                <div class="giveback" onclick="$('.givebackbox').show();">如何归还设备?</div>
            </div>
        {#/if#}
    </div>

    <div class="infobox_hide" style="display:none;">
        <p>设备编码：<em>{#$cdb['sn']#}</em></p>
        <p>借用会员：<em>{#card_format($_A['user']['userphone'])#}</em></p>
        <p class="content">此设备正在被您借用！</p>
        <div class="buttonbox">
            <div class="button deeporange" onclick="$('.givebackbox').show();">如何归还设备？</div>
        </div>
    </div>

{#/if#}

<div class="loginbox popupbox">
    <div class="table">
        <div class="cell">
            <div class="popup">
                <div class="title">验证身份</div>
                <div class="inbox">
                    <input id="login_username" type="tel" placeholder="请输入您的手机号">
                    <div class="relabox">
                        <input id="login_code" type="tel" placeholder="短信验证码">
                        <button id="codebtn" onclick="__getSms('message');">获取验证码</button>
                    </div>
                  <!--  <div class="intis" onclick="alert('请联系G电客服：');">没有收到验证码？</div>-->

                    <div class="intis" onclick="__getSms('speech')">
                        没有收到短信,请按这里语音验证
                    </div>
                </div>
                <div class="btns">
                    <a href="javascript:void(0);" onclick="$('.loginbox').hide();">取消</a>
                    <a href="javascript:void(0);" onclick="$('.loginbox').hide();__login();">确定</a>
                </div>
            </div>
        </div>
    </div>
</div>

<div class="okbox popupbox">
    <div class="table">
        <div class="cell">
            <div class="popup">
                <div class="title">借用成功</div>
                <div class="inbox">
                    <img class="okimg" src="{#$TEM_PATH#}assets/images/payok.png">
                    <div class="okinfo">
                        借用成功<br/>
                        设备编码：<span>{#$cdb['sn']#}</span>
                    </div>
                </div>
                <div class="btns">
                    <a href="javascript:void(0);" class="hover" onclick="$('.okbox').hide();$('.givebackbox').show();">如何归还设备?</a>
                </div>
            </div>
        </div>
    </div>
</div>

<div class="givebackbox popupbox">
    <div class="table">
        <div class="cell">
            <div class="popup">
                <div class="title">归还设备</div>
                <div class="inbox">
                    <div class="text">① 下载G电 APP，搜索附近G家</div>
                    <div class="next"></div>
                    <div class="text">② G家商家进行扫码</div>
                    <div class="next"></div>
                    <div class="text">③ 支付成功即完成归还</div>
                </div>
                <div class="btns">
                    <a href="javascript:void(0);" onclick="$('.givebackbox').hide();">返回</a>
                    <a href="javascript:void(0);" onclick="__down();">归还移动电源</a>
                </div>
            </div>
        </div>
    </div>
</div>

<div class="explainbox popupbox">
    <div class="table">
        <div class="cell">
            <div class="popup">
                <div class="title">押金说明</div>
                <div class="inbox">
                    <div class="explaininfo">
                        <p>押金{#$smarty.const.DEPOSIT#}元，移动电源及数据线归还后，原路退回支付账户。</p>
                        <p>1元/小时，封顶6元/天。</p>
                        <p>移动电源与数据线配套借还。</p>
                    </div>
                </div>
                <div class="btns">
                    <a href="javascript:void(0);" class="hover" onclick="$('.explainbox').hide();">确定</a>
                </div>
            </div>
        </div>
    </div>
</div>

<div class="borrowbox popupbox">
    <div class="table">
        <div class="cell">
            <div class="popup">
                <div class="title">借用提醒</div>
                <div class="inbox">
                    <div style="text-align:left;line-height:26px;">
                        您已支付押金，<br/>点击【确定】立即借用。
                    </div>
                </div>
                <div class="btns">
                    <a href="javascript:void(0);" onclick="$('.borrowbox').hide();">取消</a>
                    <a href="javascript:void(0);" class="hover" onclick="$('.borrowbox').hide();__borrow();">确定</a>
                </div>
            </div>
        </div>
    </div>
</div>

<div class="userbox popupbox">
    <div class="table">
        <div class="cell">
            <div class="popup">
                <div class="title">会员</div>
                <div class="inbox">
                    <div style="text-align:left;line-height:26px;">
                        尊贵的 “{#$_A['user']['username']#}” 您好！<br/>确定退出登录吗？
                    </div>
                </div>
                <div class="btns">
                    <a href="javascript:void(0);" onclick="$('.userbox').hide();">返回</a>
                    <a href="javascript:void(0);" class="hover" onclick="$('.userbox').hide();__out();">退出</a>
                </div>
            </div>
        </div>
    </div>
</div>

<div class="info">
    <div class="title">G电做什么</div>
    <div class="content">
        <img src="{#$NOW_PATH#}index/info-1.jpg">
        <img src="{#$NOW_PATH#}index/info-2.jpg">
        <img src="{#$NOW_PATH#}index/info-3.jpg">
        <img src="{#$NOW_PATH#}index/info-4.jpg">
    </div>
</div>

<div class="downbox">
    <div class="flex">
        <div class="logo"><img src="{#$IMG_PATH#}logo.png"></div>
        <div class="center">
            <div class="title">G电 · 共享服务</div>
            <div class="subtitle">分享不断电 · 生活不掉线</div>
        </div>
        <div class="btn" onclick="__down();">下载客户端</div>
    </div>
</div>

</body>
</html>
