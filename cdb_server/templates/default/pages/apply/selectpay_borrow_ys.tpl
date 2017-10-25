{#*用户借用设备-雨伞*#}


{#$setting = setting('pay')#}
<div class="page-selectpay-box">
    <div class="page-success-box">
        <p>借用设备：<em>{#$cdb['title']#}</em></p>
        <p id="sn">设备编码：<em>{#$cdb['sn']#}</em></p>
        <p>借用押金：<em><del>29元</del> <font color="#f00">0元</font></em></p>
        <p>借出门店：<em>{#$cdb['userinfo']['username']#}</em></p>
        <p>门店编号：<em>88{#zerofill($cdb['userinfo']['id'], 8)#}</em></p>
    </div>
    <div class="content-block" id="payList">
        <a href="#" onclick="$JS.free();" class="button-fill button-big button color-green">三免借用（免押金+免租金+免信用）</a>
        <div class="pay-help-tis">
            如需帮助，请拨打客服电话 {#settingfind('system', 'tel_num')#}
        </div>
        <p class="buttons-row button-explain">
            <a href="#" onclick="$JS.explain();" class="button-big button">押金说明</a>
        </p>
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
                                            <div class="item-title">每天</div>
                                            <div class="item-after"><del>1元</del> <font color="#f00">0元</font></div>
                                        </div>
                                    </div>
                                </li>
                            </ul>
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
                            <p>借用押金：<em><del>29元</del> <font color="#f00">0元</font></em></p>
                            <p>借出门店：<em>{#$cdb['userinfo']['username']#}</em></p>
                            <p>门店编号：<em>88{#zerofill($cdb['userinfo']['id'], 8)#}</em></p>
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
    .page-selectpay-box .pay-help-tis {text-align:center;padding:12px 0;font-size:14px;line-height:24px;}
    .page-selectpay-box .button {margin-bottom:15px;}
    .page-standard-box .list-block {margin-top:0;}
    .page-standard-box .list-block .item-after {color:#212121;font-size:16px;}
    .page-explain-box p {padding:8px 0;margin:0;}
    .page-success-box {margin:20px;padding:20px;border-radius:8px;font-size:16px;background-color:#e4e4e4;}
    .page-success-box p {padding:6px 0;margin:0;color:#666;}
    .page-success-box p em {display:block;float:right;text-align:right;color:#333;}
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
                window.__apply_explain_popup = true;
                $JS.explain();
            }
            $JS.$el.find(".navbar .right").html('<a href="javascript:void(0)" onclick="$JS.standard();" class="link" style="font-size:16px;">收费标准&nbsp;</a>');
            $JS.monitor();
        },
        destroy: function() {
            window.__apply_explain_popup = false;
        },
        /**
         * 查看押金说明
         */
        explain: function() {
            $A.alert('<div class="page-explain-box">' +
                '<p>押金：<del>29元</del>，三免期<font color="#f00">0元</font>，<br/>请在使用后归还至G家网点。</p>' +
                '<p>租金：<del>1元/天</del>，三免期<font color="#f00">0元</font>。</p>' +
                '<p>三免期无需信用抵押。</p>' +
                '</div>', '押金说明（雨伞）');
        },
        /**
         * 查看收费标准
         */
        standard: function() {
            $A.routerLoad({popup: '#apply-selectpay-standard-popup'});
        },
        /**
         * 已付押金直接借用
         */
        free: function() {
            $A.ajax({
                url: 'https://api.gengdian.net/v2/payment/borrow_ys',
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