{#*用户借用设备-充电宝*#}

{#$system = setting('system')#}
{#$setting = setting('pay')#}
<div class="page-selectpay-box">
    <div class="page-success-box">
        <p>借用设备：<em>{#$cdb['title']#}</em></p>
        <p id="sn">设备编码：<em>{#$cdb['sn']#}</em></p>
        <p>借用押金：<em>{#$smarty.const.DEPOSIT#}元</em></p>
        <p>借出门店：<em>{#$cdb['userinfo']['username']#}</em></p>
    </div>
    <div class="content-block" id="payList">
        {#if $setting['credit']['zhima_open'] || $setting['credit']['white_open']#}
            <a href="#" onclick="$JS.credit();" class="button-fill button-big button color-credit">信用支付<span>免付押金</span></a>
        {#/if#}
        {#if depositNum() > 0#}
            <a href="#" onclick="$JS.borrow();" class="button-fill button-big button color-deeporange">立即借用（已付押金）</a>
        {#else#}
            {#if $setting['over']['open']#}
                <a href="#" onclick="$JS.pay('over');" class="button-fill button-big button color-orange">余额支付（押金{#$smarty.const.DEPOSIT#}元）</a>
            {#/if#}
            {#if $setting['alipay']['openapp']#}
                <a href="#" onclick="$JS.pay('alipay');" class="button-fill button-big button color-blue">支付宝（押金{#$smarty.const.DEPOSIT#}元）</a>
            {#/if#}
            {#if $setting['weixin']['openapp']#}
                <a href="#" onclick="$JS.pay('wxpay');" class="button-fill button-big button color-green">微信支付（押金{#$smarty.const.DEPOSIT#}元）</a>
            {#/if#}
        {#/if#}
        <div class="pay-help-tis">
            30分钟内免费，1元/小时，6元封顶一天<br/>
            如需帮助，请拨打客服电话 {#settingfind('system', 'tel_num')#}
        </div>
        <p class="buttons-row button-explain">
            <a href="#" onclick="$JS.explain();" class="button-big button">押金说明</a>
        </p>
    </div>
</div>

<!-- 芝麻信用 Popup -->
<div class="popup popup-up" id="apply-selectpay-zhima-popup">
    <div class="view navbar-fixed">
        <div class="pages">
            <div class="page">
                <div class="navbar">
                    <div class="navbar-inner">
                        <div class="left">
                            <a href="javascript:void(0)" onclick="$A.routerBack({popup:'#apply-selectpay-zhima-popup'})" class="link"><i class="icon material-icons">close</i></a>
                        </div>
                        <div class="center">芝麻信用认证</div>
                    </div>
                </div>
                <div class="page-content page-zhima-box">
                    <form class="list-block">
                        <img src="{#$TEM_PATH#}assets/images/zhima_logo.png" class="zhima-logo">
                        <ul>
                            <li>
                                <div class="item-content">
                                    <div class="item-inner">
                                        <div class="item-title label">证件类型</div>
                                        <div class="item-input">
                                            <select id="zhima_cert_type">
                                                <option value="IDENTITY_CARD">身份证</option>
                                                <option value="PASSPORT">护照</option>
                                            </select>
                                        </div>
                                    </div>
                                </div>
                            </li>
                            <li>
                                <div class="item-content">
                                    <div class="item-inner">
                                        <div class="item-title label">证件号码</div>
                                        <div class="item-input">
                                            <input type="text" placeholder="请输入证件号码" id="zhima_cert_no">
                                        </div>
                                    </div>
                                </div>
                            </li>
                            <li>
                                <div class="item-content">
                                    <div class="item-inner">
                                        <div class="item-title label">真实姓名</div>
                                        <div class="item-input">
                                            <input type="text" placeholder="请输入真是姓名" id="zhima_realname">
                                        </div>
                                    </div>
                                </div>
                            </li>
                        </ul>
                        <div class="content-block-title">芝麻信用 <u>≥590分</u> 可享免押金借用</div>
                    </form>
                    <div class="content-block">
                        <a href="#" onclick="$JS.zhimaAuthenticate()" class="button-fill button-big button">提&nbsp;交</a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- 白名单信用 Popup -->
<div class="popup popup-up" id="apply-selectpay-white-popup">
    <div class="view navbar-fixed">
        <div class="pages">
            <div class="page">
                <div class="navbar">
                    <div class="navbar-inner">
                        <div class="left">
                            <a href="javascript:void(0)" onclick="$A.routerBack({popup:'#apply-selectpay-white-popup'})" class="link"><i class="icon material-icons">close</i></a>
                        </div>
                        <div class="center">白名单信用认证</div>
                    </div>
                </div>
                <div class="page-content page-white-box">
                    <form class="list-block">
                        <ul>
                            <li>
                                <div class="item-content">
                                    <div class="item-inner">
                                        <div class="item-title label">手机号码</div>
                                        <div class="item-input">
                                            <input type="text" value="{#substr($_A['user']['userphone'], 0, 3)#}****{#substr($_A['user']['userphone'], -4)#}" disabled>
                                        </div>
                                    </div>
                                </div>
                            </li>
                            <li>
                                <div class="item-content">
                                    <div class="item-inner">
                                        <div class="item-title label">证件类型</div>
                                        <div class="item-input">
                                            <select id="white_cert_type">
                                                <option value="IDENTITY_CARD">身份证</option>
                                                <option value="PASSPORT">护照</option>
                                            </select>
                                        </div>
                                    </div>
                                </div>
                            </li>
                            <li>
                                <div class="item-content">
                                    <div class="item-inner">
                                        <div class="item-title label">证件号码</div>
                                        <div class="item-input">
                                            <input type="text" placeholder="请输入证件号码" id="white_cert_no">
                                        </div>
                                    </div>
                                </div>
                            </li>
                        </ul>
                        <div class="content-block-title">白名单信用可享免押金借用</div>
                    </form>
                    <div class="content-block">
                        <a href="#" onclick="$JS.whiteAuthenticate()" class="button-fill button-big button">提&nbsp;交</a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- 收费标准 Popup -->
<div class="popup popup-up" id="apply-selectpay-standard-popup">
    <div class="view navbar-fixed">
        <div class="pages">
            <div class="page">
                <div class="navbar">
                    <div class="navbar-inner">
                        <div class="left">
                            <a href="javascript:void(0)" onclick="$A.routerBack({popup:'#apply-selectpay-standard-popup'})" class="link"><i class="icon material-icons">close</i></a>
                        </div>
                        <div class="center">收费标准</div>
                    </div>
                </div>
                <div class="page-content page-standard-box">
                    <div class="list-block">
                        <div class="list-group">
                            <ul>
                                <li class="list-group-title">收费标准</li>
                                <li>
                                    <div class="item-content">
                                        <div class="item-inner">
                                            <div class="item-title">30分钟内</div>
                                            <div class="item-after">免费</div>
                                        </div>
                                    </div>
                                </li>
                                <li>
                                    <div class="item-content">
                                        <div class="item-inner">
                                            <div class="item-title">每1小时</div>
                                            <div class="item-after">1元</div>
                                        </div>
                                    </div>
                                </li>
                                <li>
                                    <div class="item-content">
                                        <div class="item-inner">
                                            <div class="item-title">24小时最高收费</div>
                                            <div class="item-after">6元</div>
                                        </div>
                                    </div>
                                </li>
                            </ul>
                            <div class="content-block-title color-red" style="text-align:right">封顶收费88元/次&nbsp;</div>
                        </div>
                    </div>
                    <div class="content-block">
                        <a href="#" onclick="$A.routerBack({popup:'#apply-selectpay-standard-popup'})" class="button-fill button-big button">返&nbsp;&nbsp;回</a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- 借用成功 Popup -->
<div class="popup popup-up" id="apply-selectpay-payok-popup">
    <div class="view navbar-fixed">
        <div class="pages">
            <div class="page theme-green">
                <div class="navbar">
                    <div class="navbar-inner">
                        <div class="left">
                            <a href="javascript:void(0)" onclick="$A.routerBack({popup: '#apply-selectpay-payok-popup'});" class="link"><i class="icon material-icons">close</i></a>
                        </div>
                        <div class="center">借用成功</div>
                    </div>
                </div>
                <div class="page-content">
                    <div class="payok-wrap">
                        <div class="circle"></div>
                        <div class="top"></div>
                        <div class="bottom"></div>
                        <div class="container">
                            <img src="{#$TEM_PATH#}assets/images/payok.png">
                            <div></div>
                        </div>
                    </div>
                    <div class="payok-text" style="">借用成功</div>
                    <div class="page-selectpay-box">
                        <div class="page-success-box">
                            <p>借用设备：<em>{#$cdb['title']#}</em></p>
                            <p id="sn">设备编码：<em>{#$cdb['sn']#}</em></p>
                            <p>借用押金：<em>{#$smarty.const.DEPOSIT#}元</em></p>
                            <p>借出门店：<em>{#$cdb['userinfo']['username']#}</em></p>
                        </div>
                    </div>
                    <div class="content-block">
                        <a href="#" onclick="$A.routerBack({popup: '#apply-selectpay-payok-popup'});" class="button button-fill button-big">确&nbsp;&nbsp;定</a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<style>
    .actions-modal-group{padding-bottom:8px;}
    .page-selectpay-box .pay-help-tis {text-align:center;padding:12px 0;font-size:14px;line-height:24px;}
    .page-selectpay-box .button {margin-bottom:15px;}
    .page-selectpay-box .button.button-big {height:46px;line-height:46px;}
    .page-selectpay-box .color-credit {background-color:#16bba2 !important;}
    .page-selectpay-box .color-credit em.zhima{background:url("{#$TEM_PATH#}assets/images/zhima.png") center no-repeat;background-size:contain;vertical-align:middle;width:30px;height:24px;display:inline-block;margin-top:-2px;}
    .page-selectpay-box .color-credit span{display:inline-block;vertical-align:middle;padding:2px 3px 2px 1px;background-color:#ffffff;color:#16bba2;height:16px;line-height:16px;margin-left:15px;border-radius:0 2px 2px 0;font-size:12px;margin-top:-2px;position:relative;}
    .page-selectpay-box .color-credit span:before{position:absolute;content:"";top:0;left:-10px;width:0;height:0;border-top:10px solid transparent;border-right:10px solid #ffffff;border-bottom:10px solid transparent;}
    .page-zhima-box .zhima-logo {width:50%;max-width:500px;display:block;margin:0 auto 30px;}
    .page-zhima-box .content-block-title {text-align:right}
    .page-standard-box .list-block {margin-top:0;}
    .page-standard-box .list-block .item-after {color:#212121;font-size:16px;}
    .page-explain-box p {padding:8px 0;margin:0;}
    .page-success-box {margin:20px;padding:20px;border-radius:8px;font-size:16px;background-color:#e4e4e4;}
    .page-success-box p {padding:6px 0;margin:0;color:#666;}
    .page-success-box p em {display:block;float:right;text-align:right;color:#333;}
    .page-await-box {line-height:22px;}
    .page-await-box em {color:#ff5722;font-weight:bold;padding:0 5px;}
    .page-await-box em.green {color:#4caf50;}
    .credit-actions em{float:right;background-color:#16bba2;padding:2px 5px;height:18px;line-height:18px;color:#fff;margin-top:13px;font-size:12px;border-radius:2px;}
    @media screen and (min-height:560px){.button-explain{position:fixed;left:32px;right:32px;bottom:0;margin-bottom:0;}}
    /** 成功打钩动画 */
    .payok-wrap {position:relative;width:120px;height:120px;margin:36px auto 0;transform:rotate(270deg);overflow:hidden;}
    .payok-wrap .circle {height:100%;box-sizing:border-box;border:5px solid #4caf50;border-radius:50%;z-index:9999;}
    .payok-wrap .circle:before {content:'';position:absolute;display:block;width:100%;height:50%;box-sizing:border-box;top:50%;left:0;border:5px solid #4caf50;border-top:transparent;border-radius:0 0 50% 50%/ 0 0 100% 100%;z-index:2;}
    .payok-wrap .top,.payok-wrap .bottom {position:absolute;left:0;width:100%;height:50%;box-sizing:border-box;background:#f8f8f8;}
    .payok-wrap .top {top:0;z-index:1;transform-origin:center bottom;animation:.5s payok-wrap-back-half linear .5s;animation-fill-mode:forwards;}
    .payok-wrap .bottom {top:50%;transform-origin:center top;animation:.5s payok-wrap-front-half linear;animation-fill-mode:forwards;z-index:9;}
    .payok-wrap .container {width:100px;height:100px;border-radius:50%;top:6px;left:7px;position:absolute;z-index:999;overflow:hidden;transform:rotate(90deg);}
    .payok-wrap .container img {width:100px;height:100px;}
    .payok-wrap .container div {position:absolute;top:0;left:0;width:100px;height:100px;animation:payok-wrap-first 1.8s;-moz-animation:payok-wrap-first 1.8s;-webkit-animation:payok-wrap-first 1.8s;-o-animation:payok-wrap-first 1.8s;background:#f8f8f8;border-radius:50%;animation-fill-mode:forwards;animation-delay:0.8s;}
    .payok-text {text-align:center;color:#319635;margin:25px auto 0;padding-bottom:5px;font-size:22px;}
    @keyframes payok-wrap-front-half{0%{transform:rotate( 0 );}99%{transform:rotate( 180deg );opacity:1;}100%{transform:rotate( 180deg );opacity:0;}}
    @keyframes payok-wrap-back-half{0%{transform:rotate( 0 );}99%{transform:rotate( 180deg );opacity:1;}100%{transform:rotate( 180deg );opacity:0;}}
    @keyframes payok-wrap-first{0%{left:0;}100%{left:100px;}}
    @-moz-keyframes payok-wrap-first{0%{left:0;}100%{left:100px;}}
    @-webkit-keyframes payok-wrap-first{0%{left:0;}100%{left:100px;}}
    @-o-keyframes payok-wrap-first{0%{left:0;}100%{left:100px;}}
</style>

<script>
    $JS = {
        created: function() {
            if ($JS.$el.find("#payList").find("a").length === 0) {
                $JS.$el.find("#payList").html('<div class="color-red" style="text-align:center;font-size:20px;">支付功能维护中...</div>')
            }
            if (window.__apply_explain_popup !== true) {
                //自动弹出押金说明
                //window.__apply_explain_popup = true;
                //$JS.explain();
            }
            $JS.$el.find(".navbar .right").html('<a href="javascript:void(0)" onclick="$JS.standard();" class="link" style="font-size:16px;">收费标准&nbsp;</a>');
            $JS.monitor();
            //检测是否有订单未付款弹出提示
            var awaitCall = function(num) {
                $A.params.lockBack = true;
                $A.app.modal({
                    text: '<div class="page-await-box">您有' + num + '个订单<em class="green">未结算</em>，请结算后再继续使用~</div>',
                    title: '亲：',
                    buttons: [{
                        text: '取消',
                        onClick: function () {
                            $A.params.lockBack = false;
                        }
                    }, {
                        text: '立即结清',
                        bold: true,
                        onClick: function () {
                            $A.params.lockBack = false;
                            $A.ajax({
                                url: 'https://api.gengdian.net/v2/users/giveback',
                                data: {
                                    act: 'mark'
                                },
                                dataType: 'json',
                                beforeSend: true,
                                complete: true,
                                error: true,
                                success: function(res) {
                                    if (res.ret === 1) {
                                        $JS.allowActivated = true;
                                        $A.giveBack(true);
                                    }else{
                                        $A.toast(res.msg);
                                    }
                                }
                            });
                        }
                    }]
                });
            };
            $A.ajax({
                url: 'https://api.gengdian.net/v2/users/order_lists',
                data: {
                    act: 'await'
                },
                dataType: 'json',
                timeout: 10000,
                beforeSend: true,
                complete: true,
                error: true,
                success: function(res) {
                    if (res.ret === 1 && res.data.await > 0) {
                        awaitCall(res.data.await);
                    }
                }
            });
        },
        destroy: function() {
            window.__apply_explain_popup = false;
        },
        activated: function() {
            if ($JS.allowActivated === true) {
                $JS.allowActivated = false;
                $JS.pullToRefreshTrigger();
            }
        },
        /**
         * 查看押金说明
         */
        explain: function() {
            $A.alert('<div class="page-explain-box">' +
                '<p>押金{#$smarty.const.DEPOSIT#}元，移动电源及数据线归还后，原路退回支付账户。</p>' +
                '<p>1元/小时，封顶6元/天。</p>' +
                '<p>移动电源与数据线配套借还。</p>' +
                '</div>', '押金说明（充电宝）');
        },
        /**
         * 查看收费标准
         */
        standard: function() {
            $A.routerLoad({popup: '#apply-selectpay-standard-popup'});
        },
        /**
         * 点击信用支付
         */
        credit: function() {
            var buttons = [];
            buttons.push({
                text: '请选择体系',
                label: true
            });
            {#if $setting['credit']['zhima_open']#}
            buttons.push({
                text: '<div class="credit-actions">芝麻信用<em>590分及以上免付押金</em></div>',
                type: 'zhima'
            });
            {#/if#}
            {#if $setting['credit']['white_open']#}
            buttons.push({
                text: '<div class="credit-actions">白名单信用<em>免付押金</em></div>',
                type: 'white'
            });
            {#/if#}
            $A.actions(buttons, function(index){
                if (typeof buttons[index] !== 'undefined' && buttons[index]['type']) {
                    var type = buttons[index]['type'];
                    if (type === 'zhima') {
                        $JS.zhima();
                    }else if (type === 'white') {
                        $JS.white();
                    }
                }
            });
        },
        /**
         * 点击芝麻信用
         */
        zhima: function() {
            $A.ajax({
                url: 'https://api.gengdian.net/v2/credit/zhima/admittance',
                dataType: 'json',
                timeout: 10000,
                beforeSend: true,
                complete: true,
                error: true,
                success: function(res) {
                    if (res.ret === -1) {
                        //未登录事件
                        $A.toast(res.msg);
                        $A.login(function(){ $JS.pullToRefreshTrigger(); });
                        return;
                    }
                    if (res.ret === -2) {
                        //未认证评分事件
                        $A.routerLoad({popup: '#apply-selectpay-zhima-popup'});
                        return;
                    }
                    if (res.ret === 1) {
                        $JS.borrow_zhima();
                    }else{
                        api.confirm({
                            title: '芝麻信用',
                            msg: res.msg,
                            buttons: ['重新认证', '关闭提示']
                        }, function(ret, err) {
                            if (ret.buttonIndex == 1) {
                                $A.routerLoad({popup: '#apply-selectpay-zhima-popup'});
                            }
                        });
                    }
                }
            });
        },
        /**
         * 使用芝麻借用
         */
        borrow_zhima: function() {
            $A.ajax({
                url: 'https://api.gengdian.net/v2/payment/borrow_zhima',
                data: {
                    sn: '{#$cdb['sn']#}'       //设配编号
                },
                dataType: 'json',
                timeout: 10000,
                beforeSend: true,
                complete: true,
                error: true,
                success: function(res) {
                    if (res.ret === -1) {
                        //未登录事件
                        $A.toast(res.msg);
                        $A.login(function(){ $JS.pullToRefreshTrigger(); });
                        return;
                    }
                    if (res.ret === 1) {
                        $JS.payOK();
                    }else{
                        $A.alert(res.msg, '温馨提示');
                    }
                }
            });
        },
        /**
         * 芝麻信用认证
         */
        zhimaAuthenticate: function() {
            $A.ajax({
                url: 'https://api.gengdian.net/v2/credit/zhima/authenticate',
                data: {
                    cert_type: $A.$("#apply-selectpay-zhima-popup").find("#zhima_cert_type").val(),
                    cert_no: $A.$("#apply-selectpay-zhima-popup").find("#zhima_cert_no").val(),
                    realname: $A.$("#apply-selectpay-zhima-popup").find("#zhima_realname").val()
                },
                dataType: 'json',
                timeout: 10000,
                beforeSend: true,
                complete: true,
                error: true,
                success: function(res) {
                    if (res.ret === -1) {
                        //未登录事件
                        $A.toast(res.msg);
                        $A.login(function(){ $JS.pullToRefreshTrigger(); });
                        return;
                    }
                    if (res.ret === 1) {
                        $A.alert('恭喜您认证成功，点击确定立即借用。', '认证成功', function() {
                            $A.routerBack({popup:'#apply-selectpay-zhima-popup'});
                            $JS.borrow_zhima();
                        });
                    }else{
                        $A.alert(res.msg, '温馨提示');
                    }
                }
            });
        },
        /**
         * 点击白名单信用
         */
        white: function() {
            $A.ajax({
                url: 'https://api.gengdian.net/v2/credit/white/admittance',
                dataType: 'json',
                timeout: 10000,
                beforeSend: true,
                complete: true,
                error: true,
                success: function(res) {
                    if (res.ret === -1) {
                        //未登录事件
                        $A.toast(res.msg);
                        $A.login(function(){ $JS.pullToRefreshTrigger(); });
                        return;
                    }
                    if (res.ret === -2) {
                        //未认证评分事件
                        $A.routerLoad({popup: '#apply-selectpay-white-popup'});
                        return;
                    }
                    if (res.ret === 1) {
                        $JS.borrow_white();
                    }else{
                        api.confirm({
                            title: '白名单信用',
                            msg: res.msg,
                            buttons: ['重新认证', '关闭提示']
                        }, function(ret, err) {
                            if (ret.buttonIndex == 1) {
                                $A.routerLoad({popup: '#apply-selectpay-white-popup'});
                            }
                        });
                    }
                }
            });
        },
        /**
         * 使用白名单借用
         */
        borrow_white: function() {
            $A.ajax({
                url: 'https://api.gengdian.net/v2/payment/borrow_white',
                data: {
                    sn: '{#$cdb['sn']#}'       //设配编号
                },
                dataType: 'json',
                timeout: 10000,
                beforeSend: true,
                complete: true,
                error: true,
                success: function(res) {
                    if (res.ret === -1) {
                        //未登录事件
                        $A.toast(res.msg);
                        $A.login(function(){ $JS.pullToRefreshTrigger(); });
                        return;
                    }
                    if (res.ret === 1) {
                        $JS.payOK();
                    }else{
                        $A.alert(res.msg, '温馨提示');
                    }
                }
            });
        },
        /**
         * 白名单信用认证
         */
        whiteAuthenticate: function() {
            $A.ajax({
                url: 'https://api.gengdian.net/v2/credit/white/authenticate',
                data: {
                    cert_type: $A.$("#apply-selectpay-white-popup").find("#white_cert_type").val(),
                    cert_no: $A.$("#apply-selectpay-white-popup").find("#white_cert_no").val()
                },
                dataType: 'json',
                timeout: 10000,
                beforeSend: true,
                complete: true,
                error: true,
                success: function(res) {
                    if (res.ret === -1) {
                        //未登录事件
                        $A.toast(res.msg);
                        $A.login(function(){ $JS.pullToRefreshTrigger(); });
                        return;
                    }
                    if (res.ret === 1) {
                        $A.alert('恭喜您认证成功，点击确定立即借用。', '认证成功', function() {
                            $A.routerBack({popup:'#apply-selectpay-white-popup'});
                            $JS.borrow_white();
                        });
                    }else{
                        $A.alert(res.msg, '温馨提示');
                    }
                }
            });
        },
        /**
         * 已付押金直接借用
         */
        borrow: function() {
            $A.ajax({
                url: 'https://api.gengdian.net/v2/payment/borrow_deposit',
                data: {
                    sn: '{#$cdb['sn']#}'       //设配编号
                },
                dataType: 'json',
                timeout: 10000,
                beforeSend: true,
                complete: true,
                error: true,
                success: function(res) {
                    if (res.ret === -1) {
                        //未登录事件
                        $A.toast(res.msg);
                        $A.login(function(){ $JS.pullToRefreshTrigger(); });
                        return;
                    }
                    if (res.ret === 1) {
                        $JS.payOK();
                    }else{
                        $A.alert(res.msg, '温馨提示');
                    }
                }
            });
        },
        /**
         * 选择支付借用
         * @param type
         */
        pay: function(type) {
            var __payCall = function(type) {
                $A.ajax({
                    url: 'https://api.gengdian.net/v2/payment/build',
                    data: {
                        sn: '{#$cdb['sn']#}',       //设配编号
                        payid: '102'
                    },
                    dataType: 'json',
                    timeout: 10000,
                    beforeSend: true,
                    complete: true,
                    error: true,
                    success: function(res) {
                        if (res.ret === -1) {
                            //未登录事件
                            $A.toast(res.msg);
                            $A.login(function(){ $JS.pullToRefreshTrigger(); });
                            return;
                        }
                        if (res.ret !== 1) {
                            //统一下单失败
                            $A.alert(res.msg, '提交失败');
                            return;
                        }
                        //统一下单成功，发起支付
                        $JS.payid = res.data.payid;
                        $A.ajax({
                            url: 'https://api.gengdian.net/v2/payment/' + type,
                            data: {
                                'payid': $JS.payid
                            },
                            dataType: 'json',
                            timeout: 10000,
                            beforeSend: true,
                            complete: true,
                            error: true,
                            success: function (res) {
                                if (res.ret === -1) {
                                    //未登录事件
                                    $A.toast(res.msg);
                                    $A.login(function(){ $JS.pullToRefreshTrigger(); });
                                    return;
                                }
                                if (res.ret !== 1) {
                                    //发起支付失败
                                    $A.alert(res.msg, '发起支付失败');
                                    return;
                                }
                                var data = res.data;
                                //
                                if (type === 'alipay') {
                                    //支付宝支付
                                    var aliPayPlus = api.require('aliPayPlus');
                                    aliPayPlus.payOrder({
                                        orderInfo: data.orderInfo
                                    }, function(res, err) {
                                        if (parseInt(res.code) === 9000) {
                                            api.toast({msg:"支付成功！", location:'bottom'});
                                            $JS.payOK();
                                        }else{
                                            api.toast({msg:"支付失败：" + res.code +" "+ (res.statusMessage?res.statusMessage:''), location:'bottom'});
                                        }
                                    });
                                }else if (type === 'wxpay') {
                                    //微信支付
                                    var wxPay = api.require('wxPay');
                                    wxPay.payOrder({
                                        apiKey: data.appid,
                                        orderId: data.prepayid,
                                        mchId: data.partnerid,
                                        nonceStr: data.noncestr,
                                        timeStamp: data.timestamp,
                                        package: data.package,
                                        sign: data.sign
                                    }, function(res, err) {
                                        if (res.status) {
                                            api.toast({msg:"支付成功！", location:'bottom'});
                                            $JS.payOK();
                                        } else {
                                            if (err.code === -1) err.code = '系统维护，请选择其他支付方式';
                                            if (err.code === -2) err.code = '用户取消';
                                            api.toast({msg:"支付失败：" + err.code + " " + (err.msg || ''), location:'bottom'});
                                        }
                                    });
                                }else{
                                    //其他支付
                                    $A.alert('此支付方式正在维护中...', '发起支付失败');
                                }
                            }
                        });
                    }
                });
            };
            $A.apiReady(function(){
                __payCall(type);
            }, function(){
                $A.toast('请在APP内使用支付功能！');
            });
        },
        /**
         * 借用成功弹出
         */
        payOK: function() {
            $A.$theme("green");
            $A.$changeTheme("#296931");
            $A.routerLoad({popup: '#apply-selectpay-payok-popup', backRun: function(){ $JS.payOKD(); }});
        },
        /**
         * 关闭借用成功提示
         */
        payOKD: function() {
            $A.$theme();
            $A.$changeTheme();
            $A.routerBack(-1);
        },
        /**
         * 定时获取支付成功
         */
        monitor: function() {
            var self = this;
            $A.ajax({
                url: 'https://api.gengdian.net/v2/other/sn_pay_status',
                data: {
                    sn: '{#$cdb['sn']#}',                   //设配编号
                    userid: '{#$_A['user']['id']#}'         //会员ID号
                },
                dataType: 'json',
                timeout: 5000,
                success: function(res) {
                    if (res.ret === 1) {
                        $JS.payOK();
                    }else{
                        setTimeout(function(){
                            if (self.$random === $JS.$random) $JS.monitor();
                        }, 3000);
                    }
                },
                error: function(){
                    setTimeout(function(){
                        if (self.$random === $JS.$random) $JS.monitor();
                    }, 3000);
                }
            });

        }
    };
</script>