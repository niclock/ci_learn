{#*用户归还充电宝*#}

{#$giveusername = db_getone(table('users'), '`id`='|cat:intval($orderinfo['retuserid']), '', 'username')#}
{#$setting = setting('pay')#}
<div class="page-giveback-box">
    <div class="simple-box">
        <p>归还设备：<em>{#$cdb['title']#}</em></p>
        <p class="color-red">设备编号：<em>{#$cdb['sn']#}</em></p>
        <p class="color-red">归还门店：<em>{#$giveusername#}</em></p>
        <p>总费用/时长：<em>{#$orderinfo['retmoney']#}元/{#cdb_time_diff($orderinfo['indate'], $orderinfo['retdate'])#}</em></p>
        <div class="simple-mask" onclick="$JS.detail(this)">
            <div class="expand-button">查看详细信息</div>
            <i class="icon material-icons">expand_more</i>
        </div>
    </div>
    <div class="detail-box">
        <p>归还设备：<em>{#$cdb['title']#}</em></p>
        <p>设备编号：<em>{#$cdb['sn']#}</em></p>
        <p>借用日期：<em>{#date('Y-m-d H:i', $orderinfo['indate'])#}</em></p>

        <p>归还日期：<em>{#date("Y-m-d H:i", $orderinfo['retdate'])#}</em></p>
        <p>归还门店：<em>{#$giveusername#}</em></p>

        <p>借用押金：<em>{#$smarty.const.DEPOSIT#}元</em></p>
        <p>借用时长：<em>{#cdb_time_diff($orderinfo['indate'], $orderinfo['retdate'])#}</em></p>
        <p>借用租金：<em>{#$orderinfo['retmoney']#}元</em></p>
    </div>
    {#if $myordersale#}
        <div class="sale-list">
            <div class="list-block">
                <ul>
                    <li>
                        <a href="#" class="item-link smartSelect" onclick="$A.smartSelect(this);">
                            <select onchange="$JS.givebacksale();" id="giveback_sale" name="选择{#sale_name()#}" style="display:none">
                                <option value="0" data-saleMoney="0" >不使用{#sale_name()#}</option>
                                {#foreach $myordersale AS $key=>$item#}
                                    <option value="{#$item['idB']#}" data-saleMoney="{#$item['saleMoney']#}" {#if $key==0#}selected{#/if#}>
                                        {#if $item['sale_type'] == 'T'#}
                                            可抵{#forum_hour2day($item['sale'])#}
                                        {#elseif $item['sale_type'] == 'P'#}
                                        {#round(((100 - $item['sale']) / 10),1)#}折优惠
                                        {#elseif $item['sale_type'] == 'F'#}
                                            可抵{#$item['saleMoney']#}元现金
                                        {#/if#}
                                    </option>
                                {#/foreach#}
                            </select>
                            <div class="item-content">
                                <div class="item-inner">
                                    <div class="item-title color-deeporange">{#sale_name()#}</div>
                                    <div class="item-after">
                                        {#if $myordersale[0]['sale_type'] == 'T'#}
                                            可抵{#forum_hour2day($myordersale[0]['sale'])#}
                                        {#elseif $myordersale[0]['sale_type'] == 'P'#}
                                            {#round(((100 - $myordersale[0]['sale']) / 10),1)#}折优惠
                                        {#elseif $myordersale[0]['sale_type'] == 'F'#}
                                            可抵{#$myordersale[0]['saleMoney']#}元现金
                                        {#/if#}
                                    </div>
                                </div>
                            </div>
                        </a>
                    </li>
                </ul>
            </div>
        </div>
    {#/if#}
</div>
<div class="page-giveback-tis">
    请正确核对<span class="color-red"> 设备编号 </span>及<span class="color-red"> 归还门店 </span>？
</div>
<div class="content-block">
    <a href="#" onclick="$JS.submit()" class="button-fill button-big button">确定支付<span> (<span class="truemoney">{#$orderinfo['retmoney']#}</span>元)</span></a>
</div>

{#$piclist =getNewList('payad')#}
{#$picsinfo =$piclist['data']["lists"]#}

{#foreach $picsinfo AS $key=>$item#}
<div  class="page-img-box"> <img src="{#$item['picture']#}" ></div>

{#/foreach#}

<!-- 归还成功 Popup -->
<div class="popup popup-up" id="apply-giveback-payok-popup">
    <div class="view navbar-fixed">
        <div class="pages">
            <div class="page">
                <div class="navbar">
                    <div class="navbar-inner">
                        <div class="left">
                            <a href="javascript:void(0)" onclick="$A.routerBack({popup: '#apply-giveback-payok-popup'});" class="link"><i class="icon material-icons">close</i></a>
                        </div>
                        <div class="center">支付成功</div>
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
                    <div class="payok-text" style="">支付成功 &yen;<span class="truemoney">{#$orderinfo['retmoney']#}</span></div>
                    <div class="page-giveback-box">
                        <div class="simple-box">
                            <p>归还设备：<em>{#$cdb['title']#}</em></p>
                            <p class="color-red">设备编号：<em>{#$cdb['sn']#}</em></p>
                            <p class="color-red">归还门店：<em>{#$giveusername#}</em></p>
                            <p>总费用/时长：<em>{#$orderinfo['retmoney']#}元/{#cdb_time_diff($orderinfo['indate'], $orderinfo['retdate'])#}</em></p>
                            <div class="simple-mask" onclick="$JS.detail(this)">
                                <div class="expand-button">查看详细信息</div>
                                <i class="icon material-icons">expand_more</i>
                            </div>
                        </div>
                        <div class="detail-box">
                            <p>归还设备：<em>{#$cdb['title']#}</em></p>
                            <p>设备编号：<em>{#$cdb['sn']#}</em></p>
                            <p>借用日期：<em>{#date('Y-m-d H:i', $orderinfo['indate'])#}</em></p>

                            <p>归还日期：<em>{#date("Y-m-d H:i", $orderinfo['retdate'])#}</em></p>
                            <p>归还门店：<em>{#$giveusername#}</em></p>

                            <p>借用押金：<em>{#$smarty.const.DEPOSIT#}元</em></p>
                            <p>借用时长：<em>{#cdb_time_diff($orderinfo['indate'], $orderinfo['retdate'])#}</em></p>
                            <p>借用租金：<em>{#$orderinfo['retmoney']#}元</em></p>
                        </div>
                    </div>
                    <div class="content-block">
                        <a href="#" onclick="$A.routerBack({popup: '#apply-giveback-payok-popup'});" class="button button-fill button-big">确&nbsp;&nbsp;定</a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<!--suppress CssUnusedSymbol -->
<style>
    .page-giveback-box {margin:20px;padding:20px;border-radius:8px;font-size:16px;background-color:#e4e4e4;}
    .page-giveback-box p {padding:5px 0;margin:0;color:#666;}
    .page-giveback-box p em {display:block;float:right;text-align:right;color:#333;}
    .page-giveback-box p.color-red {color: #ff5330;}
    .page-giveback-box p.color-red em {color:#ff0000;font-weight:600}
    .page-giveback-box .simple-box {position:relative;padding-bottom:30px;}
    .page-giveback-box .simple-box .simple-mask {position:absolute;width:100%;height:50%;left:0;bottom:0;text-align:center;background-image:-webkit-linear-gradient(top,hsla(0,0%,89%,0),#e4e4e4);background-image:linear-gradient(180deg,hsla(0,0%,89%,0),#e4e4e4);}
    .page-giveback-box .simple-box .simple-mask .expand-button {position:absolute;width:100%;bottom:0;font-size:14px;left:0;}
    .page-giveback-box .simple-box .simple-mask i {position:absolute;width:100%;bottom:-18px;left:0;}
    .page-giveback-box .detail-box {display:none;}
    .page-giveback-tis {margin-top:22px;margin-bottom:-10px;text-align:center;}
    .page-img-box{padding-left:15px;position:absolute;width:90%;height:30%;}
    .page-img-box img{width:100%;height:100%;}
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
    /** 优惠券提醒 */
    .saleBigOrange{font-weight:700;color:#ff5722;font-size:22px;padding:0 3px}
    .saleMessage{font-size:14px;line-height:18px;color:#f0ad4e;padding-top:20px}
</style>
<script>
    $JS = {
        title: '订单结算',

        created: function() {
            window.sessionStorage['__giveBack__'] = 'open';
            //
            $JS.$el.find(".navbar .right").html('<a href="#" onclick="$JS.pullToRefreshTrigger();" class="link"><i class="icon material-icons">refresh</i></a>');
            $JS.monitor();
            $JS.givebacksale();
        },
        beforeDestroy: function() {
            //消除归还通知
            var popup = {popup: '#' + $JS.$id, skipBefore: true};
            $A.confirm("您确定要取消归还操作吗？", "操作提醒", function(){
                $A.ajax({
                    url: 'https://api.gengdian.net/v2/users/giveback',
                    data: {
                        act: 'clear',
                        sn: '{#$cdb['sn']#}'       //设配编号
                    },
                    dataType: 'json',
                    beforeSend: true,
                    complete: true,
                    error: true,
                    success: function(res) {
                        if (res.ret === 1) {
                            window.sessionStorage['__giveBack__'] = 'close';
                            $A.routerBack(popup);
                        }else{
                            $A.toast(res.msg);
                        }
                    }
                });
            });
            return true;
        },
        /**
         * 查看详情
         */
        detail: function(obj) {
            var el = $A.$(obj).parents(".simple-box");
            el.hide();
            el.next(".detail-box").show();
        },
        /**
         * 选中优惠券
         */
        givebacksale: function() {
            var tthis = $JS.$el.find("#giveback_sale");
            if (tthis.length === 0) return;
            //
            var select = tthis[0];
            var option = $A.$(select.options[select.selectedIndex]);
            var retmoney = $A.runNum('{#$orderinfo['retmoney']#}');                 //原价金额

            var test = $A.runNum(option.attr("data-saleMoney"));

            var valuemoney= $A.runNum('{#$myordersale[0]['idB']#}');
            var paymoney = retmoney - $A.runNum(option.attr("data-saleMoney"));

            var truemoney = Math.max(0, paymoney).toFixed(2);
            $JS.$el.find(".truemoney").text(truemoney);
            $JS.usaleid = option.val();
            $JS.saleMessage = "使用{#sale_name()#}抵扣:<span class='saleBigOrange'>" + test+ "</span>元<br/>" +
                "使用后应付金额:<span class='saleBigOrange'>" + truemoney + "</span>元" +
                "<div class='saleMessage'>提醒：{#sale_name()#}一次性使用，不可兑换现金，不设找零。</div>";
        },
        /**
         * 确定支付
         */
        submit: function() {
            var truemoney = $A.runNum($JS.$el.find(".truemoney").eq(0).text());
            if (truemoney < 0) {
                $A.toast('参数错误！'); return;
            }
            //
            var __payFree = function() {
                $A.ajax({
                    url: 'https://api.gengdian.net/v2/payment/free',
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
                            $A.alert(res.msg, '支付失败');
                            return;
                        }
                        api.toast({msg:"支付成功！", location:'bottom'});
                        $JS.payOK();
                    }
                });
            };
            var __payCall = function(type) {
                $A.ajax({
                    url: 'https://api.gengdian.net/v2/payment/build',
                    data: {
                        sn: '{#$cdb['sn']#}',                   //设配编号
                        orderid: '{#$orderinfo['id']#}',        //订单编号
                        usaleid: $JS.usaleid,                   //优惠券ID
                        money: truemoney,                       //支付金额（用于核对）

                        payid: '103'
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
                        if (type === 'free') {
                            //0元支付
                            __payFree();
                            return;
                        }
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
            //
            var __callBack = function() {
                if (truemoney === 0) {
                    __payCall('free');
                }else{
                    var buttons = [];
                    buttons.push({
                        text: '请选择支付方式',
                        label: true
                    });
                    {#if $setting['over']['open']#}
                    buttons.push({
                        text: '余额支付 (' + truemoney + '元)',
                        color: 'deeporange',
                        type: 'over'
                    });
                    {#/if#}
                    {#if $setting['alipay']['openapp']#}
                    buttons.push({
                        text: '支付宝 (' + truemoney + '元)',
                        color: 'blue',
                        type: 'alipay'
                    });
                    {#/if#}
                    {#if $setting['weixin']['openapp']#}
                    buttons.push({
                        text: '微信支付 (' + truemoney + '元)',
                        color: 'green',
                        type: 'wxpay'
                    });
                    {#/if#}
                    $A.actions(buttons, function(index){
                        if (typeof buttons[index] !== 'undefined' && buttons[index]['type']) {
                            var type = buttons[index]['type'];
                            __payCall(type);
                        }
                    });
                }
            };
            if ($JS.usaleid > 0) {
                $A.confirm($JS.saleMessage, '用券提醒', function() { __callBack(); });
            }else{
                __callBack();
            }
        },
        /**
         * 归还成功弹出
         */
        payOK: function() {
            $A.$theme("green");
            $A.$changeTheme("#296931");
            $A.routerLoad({popup: '#apply-giveback-payok-popup', backRun: function(){ $JS.payOKD(); }});
        },
        /**
         * 关闭归还成功提示
         */
        payOKD: function() {
            $A.$theme();
            $A.$changeTheme();
            $A.routerBack({popup: "#" + $JS.$id, skipBefore: true});
        },
        /**
         * 定时获取支付成功
         */
        monitor: function() {
            var self = this;
            $A.ajax({
                url: 'https://api.gengdian.net/v2/other/sn_give_status',
                data: {
                    sn: '{#$cdb['sn']#}',                               //设配编号
                    orderid: '{#$orderinfo['id']#}'                     //订单ID
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
    }
</script>