{#*G家协议*#}

{#user_check()#}

{#$setting = setting('pay')#}
<div class="users_joincontract">
    <div class="content-block-title">G家协议（电子签约）</div>
    <form class="list-block inputs-list">
        <ul>
            <li>
                <div class="item-content">
                    <div class="item-inner">
                        <div class="item-title label">邀请码：<span class="color-red">*</span></div>
                        <div class="item-input">
                            <input type="text" id="invite" placeholder="" value=""/>
                        </div>
                    </div>
                </div>
            </li>
            <li>
                <div class="item-content">
                    <div class="item-inner">
                        <div class="item-title label">公司名称（或门店名称）：<span class="color-red">*</span></div>
                        <div class="item-input">
                            <input type="text" id="company" placeholder="" value=""/>
                        </div>
                    </div>
                </div>
            </li>
            <li>
                <div class="item-content">
                    <div class="item-inner">
                        <div class="item-title label">联系人：<span class="color-red">*</span></div>
                        <div class="item-input">
                            <input type="text" id="linkname" placeholder="" value=""/>
                        </div>
                    </div>
                </div>
            </li>
            <li>
                <div class="item-content">
                    <div class="item-inner">
                        <div class="item-title label">联系电话：<span class="color-red">*</span></div>
                        <div class="item-input">
                            <input type="text" id="linkphone" placeholder="" value=""/>
                        </div>
                    </div>
                </div>
            </li>
            <li>
                <div class="item-content">
                    <div class="item-inner">
                        <div class="item-title label">营业场所（地址）：<span class="color-red">*</span></div>
                        <div class="item-input">
                            <input type="text" id="site" placeholder="" value=""/>
                        </div>
                    </div>
                </div>
            </li>
            <li>
                <div class="item-content">
                    <div class="item-inner">
                        <div class="item-title label">选择套餐：<span class="color-red">*</span></div>
                        <div class="item-input">
                            <select id="setmeal">
                                <option> </option>
                                <option value="1">套餐一（0元）</option>
                                <option value="2">套餐二（199元）</option>
                                <option value="3">套餐三（399元）</option>
                            </select>
                        </div>
                    </div>
                </div>
            </li>
            <li>
                <div class="item-content">
                    <div class="item-inner">
                        <div class="item-title label">充电宝数量：<span class="color-red">*</span></div>
                        <div class="item-input">
                            <input type="text" id="cdbnum" placeholder="" value=""/>
                        </div>
                    </div>
                </div>
            </li>
            <li>
                <div class="item-content">
                    <div class="item-inner">
                        <div class="item-title label">数据线数量：<span class="color-red">*</span></div>
                        <div class="item-input">
                            <input type="text" id="sjxnum" placeholder="" value=""/>
                        </div>
                    </div>
                </div>
            </li>
            <li>
                <div class="item-content">
                    <div class="item-inner">
                        <div class="item-title label">充电架数量：<span class="color-red">*</span></div>
                        <div class="item-input">
                            <input type="text" id="cdjnum" placeholder="" value=""/>
                        </div>
                    </div>
                </div>
            </li>
            <li>
                <div class="item-content">
                    <div class="item-inner">
                        <div class="item-title label">支付金额(元)：<span class="color-red">*</span></div>
                        <div class="item-input">
                            <input type="number" id="money" placeholder="请输入支付金额" value=""/>
                        </div>
                    </div>
                </div>
            </li>
        </ul>
        <div class="joinbutton">
            <a href="#" class="button button-fill button-big" onclick="$JS.submit()">提交申请</a>
        </div>
    </form>
</div>


<!-- 申请成功 Popup -->
<div class="popup popup-up" id="users-joincontract-payok-popup">
    <div class="view navbar-fixed">
        <div class="pages">
            <div class="page">
                <div class="navbar">
                    <div class="navbar-inner">
                        <div class="left">
                            <a href="javascript:void(0)" onclick="$A.routerBack({popup: '#users-joincontract-payok-popup'});" class="link"><i class="icon material-icons">close</i></a>
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
                    <div class="payok-text">支付成功 &yen;<span id="truemoney"></span></div>
                    <div class="payok-content">如有需求，请联系客服电话{#settingfind('system', 'tel_num')#}。</div>
                    <div class="content-block">
                        <a href="#" onclick="$A.routerBack({popup: '#users-joincontract-payok-popup'});" class="button button-fill button-big">确&nbsp;&nbsp;定</a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<style>
    .users_joincontract .content-block-title { color:#333333;text-align:center;font-size:16px;margin-bottom:20px; }
    .users_joincontract .joinbutton { margin: 20px 16px; }
    .users_joincontract .joinbutton .tis { margin-bottom: 12px; font-size: 14px; color: #aa6a25; }
    .users_joincontract .joinbutton .agreement { margin-top: 12px; font-size: 14px; color: #aaa; }
    .users_joincontract .item-title span.color-red {font-size:20px;display:inline-block;height:20px;margin-top:-3px;margin-left:3px;vertical-align:top;}
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
    .payok-content {text-align:center;color:#666666;margin:25px 20px 0;padding-bottom:5px;font-size:16px;}
    @keyframes payok-wrap-front-half{0%{transform:rotate( 0 );}99%{transform:rotate( 180deg );opacity:1;}100%{transform:rotate( 180deg );opacity:0;}}
    @keyframes payok-wrap-back-half{0%{transform:rotate( 0 );}99%{transform:rotate( 180deg );opacity:1;}100%{transform:rotate( 180deg );opacity:0;}}
    @keyframes payok-wrap-first{0%{left:0;}100%{left:100px;}}
    @-moz-keyframes payok-wrap-first{0%{left:0;}100%{left:100px;}}
    @-webkit-keyframes payok-wrap-first{0%{left:0;}100%{left:100px;}}
    @-o-keyframes payok-wrap-first{0%{left:0;}100%{left:100px;}}
</style>
<script>
    $JS = {
        payid: '',
        refresh: false,
        truemoney: '0.00',
        /**
         *
         */
        created: function() {
            $JS.monitor();
        },
        /**
         * 支付
         */
        submit: function() {
            var invite = $JS.$el.find('#invite').val(),
                company = $JS.$el.find('#company').val(),
                linkname = $JS.$el.find('#linkname').val(),
                linkphone = $JS.$el.find('#linkphone').val(),
                site = $JS.$el.find('#site').val(),
                setmeal = $A.runNum($JS.$el.find('#setmeal').val()),
                cdbnum = $A.runNum($JS.$el.find('#cdbnum').val()),
                sjxnum = $A.runNum($JS.$el.find('#sjxnum').val()),
                cdjnum = $A.runNum($JS.$el.find('#cdjnum').val()),
                money = $A.runNum($JS.$el.find('#money').val());
            //
            if (invite === '') { $A.toast('请输入邀请码！'); return; }
            if (company === '') { $A.toast('请输入公司名称（或门店名称）！'); return; }
            if (linkname === '') { $A.toast('请输入联系人昵称！'); return; }
            if (linkphone === '') { $A.toast('请输入联系电话！'); return; }
            if (site === '') { $A.toast('请输入营业场所！'); return; }
            if (setmeal === 0) { $A.toast('请选择套餐！'); return; }
            if (cdbnum === 0) { $A.toast('请输入充电宝数量！'); return; }
            if (sjxnum === 0) { $A.toast('请输入数据线数量！'); return; }
            if (cdjnum === 0) { $A.toast('请输入充电架数量！'); return; }
            if ($JS.$el.find('#money').val() === '') { $A.toast('请输入支付金额，无支付金额请填写0！'); return; }
            //
            $JS.truemoney = money;
            $JS.$el.find("#truemoney").text($JS.truemoney);
            //
            var __payCall = function(type, contractid) {
                $A.ajax({
                    url: 'https://api.gengdian.net/v2/payment/build',
                    data: {
                        payid: '105',
                        contractid: contractid
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
            //
            var __payType = function(contractid) {
                var buttons = [];
                buttons.push({
                    text: '请选择支付方式',
                    label: true
                });
                {#if $setting['over']['open']#}
                buttons.push({
                    text: '余额支付 (' + $JS.truemoney + '元)',
                    color: 'deeporange',
                    type: 'over'
                });
                {#/if#}
                {#if $setting['alipay']['openapp']#}
                buttons.push({
                    text: '支付宝 (' + $JS.truemoney + '元)',
                    color: 'blue',
                    type: 'alipay'
                });
                {#/if#}
                {#if $setting['weixin']['openapp']#}
                buttons.push({
                    text: '微信支付 (' + $JS.truemoney + '元)',
                    color: 'green',
                    type: 'wxpay'
                });
                {#/if#}
                $A.actions(buttons, function(index){
                    if (typeof buttons[index] !== 'undefined' && buttons[index]['type']) {
                        var type = buttons[index]['type'];
                        __payCall(type, contractid);
                    }
                });
            };
            //
            $A.ajax({
                url: 'https://api.gengdian.net/v2/other/contract',
                data: {
                    invite: invite,
                    company: company,
                    linkname: linkname,
                    linkphone: linkphone,
                    site: site,
                    money: $JS.truemoney,
                    setmeal: setmeal,
                    cdbnum: cdbnum,
                    sjxnum: sjxnum,
                    cdjnum: cdjnum
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
                        //提交失败
                        $A.alert(res.msg, '提交失败');
                        return;
                    }
                    if (res.data.status === '待付款') {
                        __payType(res.data.id);
                    }else if (res.data.status === '待审核') {
                        $A.confirm("您已成功提交申请，请等待审核。审核通过后可在此页面查看合同。", "提交成功", function(){
                            $A.routerBack(-1);
                        });
                    }
                }
            });
        },
        /**
         * 归还成功弹出
         */
        payOK: function() {
            $A.$theme("green");
            $A.$changeTheme("#296931");
            $A.routerLoad({popup: '#users-joincontract-payok-popup', backRun: function(){ $JS.payOKD(); }});
        },
        /**
         * 关闭归还成功提示
         */
        payOKD: function() {
            $A.$theme();
            $A.$changeTheme();
            $A.routerBack({popup: "#" + $JS.$id});
        },
        /**
         * 定时获取支付成功
         */
        monitor: function() {
            var self = this;
            if ($JS.payid === '') {
                setTimeout(function(){
                    if (self.$random === $JS.$random) $JS.monitor();
                }, 3000);
                return;
            }
            $A.ajax({
                url: 'https://api.gengdian.net/v2/other/pay_status',
                data: {
                    payid: $JS.payid
                },
                dataType: 'json',
                timeout: 5000,
                success: function(res) {
                    if (res.ret === 1 && res.data.status === 1) {
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