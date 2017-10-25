{#*商家详情*#}

<div class="selectpay_users">
    <div class="swiper-container">
        <div class="swiper-wrapper" id="swiper-item" onclick="$JS.image(this);"></div>
        <div class="swiper-pagination color-white" style="display:none"></div>
    </div>
    <div class="userimg" id="userimg"></div>
    <div class="username" id="username"></div>
    <div class="usercode" id="usercode"></div>
    <div class="content-block">
        <ul class="item clearfix">
            <li onclick="$JS.openCdb()">
                <img src="{#$TEM_PATH#}assets/images/cdb.png">
                <span>剩余<em id="num_cdb"></em>个</span>
            </li>
            <li onclick="$JS.openYs()">
                <img src="{#$TEM_PATH#}assets/images/ys.png">
                <span>剩余<em id="num_ys"></em>把</span>
            </li>
        </ul>
    </div>
    <ul class="infoitem clearfix">
        <li class="address" id="address" style="display:none" onclick="$JS.address()"></li>
    </ul>
</div>
<!-- 借用成功 Popup -->
<div class="popup popup-up" id="apply-selectpay-ysok-popup">
    <div class="view navbar-fixed">
        <div class="pages">
            <div class="page theme-green">
                <div class="navbar">
                    <div class="navbar-inner">
                        <div class="left">
                            <a href="javascript:void(0)" onclick="$A.routerBack({popup: '#apply-selectpay-ysok-popup'});" class="link"><i class="icon material-icons">close</i></a>
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
                            <p>借用设备：<em id="cdb_title"></em></p>
                            <p>借用押金：<em><del>29元</del> <font color="#f00">0元</font></em></p>
                            <p>借出门店：<em id="cdb_username"></em></p>
                            <p>门店编号：<em id="cdb_usercode"></em></p>
                        </div>
                    </div>
                    <div class="content-block">
                        <a href="#" onclick="$A.routerBack({popup: '#apply-selectpay-ysok-popup'});" class="button button-fill button-big">确&nbsp;&nbsp;定</a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<!--suppress CssUnusedSymbol -->
<style>
    .selectpay_users .swiper-container{height:180px;width:100%;background:#ff5722;}
    .selectpay_users .swiper-container .swiper-slide{position:relative;}
    .selectpay_users .swiper-container .swiper-slide .swiper-img{width:100%;height:100%;background-size:cover;background-position:center;background-repeat:no-repeat;}
    .selectpay_users .userimg{width:80px;height:80px;overflow:hidden;border-radius:100%;margin:-40px auto;position:relative;z-index:2;background-color:#e4e4e4;border:2px solid #ff5722;}
    .selectpay_users .userimg img{width:100%;height:100%;}
    .selectpay_users .username{text-align:center;margin-top:55px;padding:0 20px;font-size:18px;}
    .selectpay_users .usercode{text-align:center;margin-top:3px;margin-bottom:-5px;font-size:14px;color:#ff5722;}
    .selectpay_users .item li{display:block;float:left;width:50%;-webkit-box-sizing:border-box;-moz-box-sizing:border-box;box-sizing:border-box;}
    .selectpay_users .item li img{width:38%;display:block;margin:10px auto;}
    .selectpay_users .item li span{display:block;text-align:center;font-size:16px;}
    .selectpay_users .item li span.sub{font-size:12px;color:#ff5722;}
    .selectpay_users .infoitem{margin-top:30px;font-size:14px;}
    .selectpay_users .infoitem li{position:relative;height:auto;line-height:22px;padding:13px 40px 13px 50px;border-top:1px solid #e8e8e8;}
    .selectpay_users .infoitem li:before,.selectpay_users .infoitem li:after{position:absolute;top:0;left:16px;width:22px;height:100%;content:"0";text-indent:9999px;overflow:hidden;background-position:center;background-size:contain;background-repeat:no-repeat;background-image:url("data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAADAAAAAwCAMAAABg3Am1AAAAPFBMVEUAAADPz8/Pz8/Nzc3Nzc3Nzc3MzMzPz8/Pz8/MzMzNzc3Nzc3Nzc3MzMzNzc3Nzc3MzMzNzc3Nzc3Nzc1AV71cAAAAE3RSTlMAQBCAwN+wMCDw0GDgz5+QUO9w6hFZZwAAARhJREFUSMfV09uygjAMBdDQe0Eumv//1zOjxsLslHDGJ9djoLCTtvQbsg8hxhB8pgucj/wRvSPDdOeD+3T++YXB4k7en1kx91fMrJqpY5cnpBR2qUg1yPPq3WteVSoDaWScY5FKGWW86kD55bbr0d3eRW24qf0eYyYCTto9liWU6yZ6HMuPd3mDBb4l0jL57xcEWGB0vZz3sHYjzfrx8urBwExbq4IqV6a0WpHrVM/OasxSypFbCyDzx1qen19bJZMicBNDiNyE3n1A2DL+AiXSFe4o1OEZaJsGF0zAFUSb0TFKRsdGKAyEBgxkWGFClpF3RrKV2t6vsGXGbDe6xEMDlgQ7YHDjs2FHl+XKXDP9Q4ZbaZkm+hl/+6kxPPty/kwAAAAASUVORK5CYII=");}
    .selectpay_users .infoitem li:after{top:0;left:auto;right:16px;width:18px;height:100%;background-image:url("data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAADAAAAAwCAYAAABXAvmHAAABSklEQVRoQ9XazW3DMAyGYcqTZAXDHiAjZIO2k7SbxJkg2SALSFAXslywyAD64UcyPulAw+8D+yLBgSqvnPOplJKJ6LEsy1flbfCxUPuEnPO5lPJ8zW9eENUADo8xbiGED0+IJoBHRDPAG6IL4AnRDfCCGAJ4QAwDrBEiAEuEGMAKIQqwQIgDtBEQgCYCBtBCQAEaCDgAjVABIBFqABRCFYBAqAOkESYASYQZQAphCmBESumHiL55PU3TPM/zb+1JCc95AHA8I94PkFK6EtEnxx/HcVvX9X/dcpm9AYl4s09IKt4EIBmvDpCOVwUg4tUAqHgVADIeDkDHQwEa8TCAVjwEoBkvDtCOFwVYxIsBrOJFAJbxwwDr+CGAh/hugJf4LoCn+GaAt/gmQIzxEkK4j2zAWzbrtbPVm3r+3Wbfdz6zefScHtQGtc79ATaqO0AC7vF1AAAAAElFTkSuQmCC");}
    .selectpay_users .infoitem li:last-child{border-bottom:1px solid #e8e8e8;}
    /** */
    .page-explain-box p {padding:8px 0;margin:0;}
    .page-success-box {margin:20px;padding:20px;border-radius:8px;font-size:16px;background-color:#e4e4e4;}
    .page-success-box p {padding:6px 0;margin:0;color:#666;}
    .page-success-box p em {display:block;float:right;text-align:right;color:#333;}
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
        title: '详情',
        mySwiper: null,
        userInfo: {},
        isScan: "{#$_GPC['isscan']#}",

        myLon: 0,
        myLat: 0,

        created: function() {
            window.sessionStorage['__giveBack__'] = 'open';
            //
            $JS.$el.find(".navbar").css({'box-shadow':'none'});
            //
            $A.location(function (lon, lat) {
                if (lon !== false) {
                    $JS.myLon = lon;
                    $JS.myLat = lat;
                }
            });
            $JS.activated();
        },
        beforeDestroy: function() {
            window.sessionStorage['__giveBack__'] = 'close';
        },
        activated: function() {
            $A.ajax({
                url: 'https://api.gengdian.net/v2/users/dealer',
                data: {
                    id: '{#intval(substr($_GPC['sn'],2))#}'       //商家会员ID
                },
                dataType: 'json',
                timeout: 10000,
                beforeSend: true,
                complete: true,
                error: true,
                success: function(res) {
                    if (res.ret === 1) {
                        var data = res.data;
                        //
                        if (data.albums.length > 0) {
                            var temp = '';
                            $A.$.each(data.albums, function (index, item) {
                                temp+= '<div class="swiper-slide" data-img="'+item+'"><div class="swiper-img" style="background-image:url('+item+')"></div></div>';
                            });
                            $JS.$el.find("#swiper-item").html(temp);
                            $JS.mySwiper = new Swiper('.swiper-container', {
                                pagination: '.swiper-pagination',
                                autoplay : 6000
                            });
                        }
                        if (data.istest) {
                            $A.alert("此G家正在申办中...", '温馨提示', function(){
                                $A.routerBack(-1);
                            });
                            return;
                        }
                        //
                        $JS.userInfo = data;
                        $JS.$el.find("#userimg").html('<img src="' + data.userimg + '">');
                        $JS.$el.find("#username").text(data.username);
                        $JS.$el.find("#usercode").text(data.usercode);
                        $JS.$el.find("#address").text(data.address).show();
                        $JS.$el.find("#num_cdb").text(data.num_cdb);
                        $JS.$el.find("#num_ys").text(data.num_ys);
                        //
                        if ("{#$_GPC['isscan']#}" == "yes" && $A.storage("isscanRand") != "{#$_GPC['randstr']#}") {
                            $A.storage("isscanRand", "{#$_GPC['randstr']#}");
                            $JS.selectYs("borrow", true);
                        }
                        //
                    }else{
                        $A.alert(res.msg, '温馨提示', function(){
                            $A.routerBack(-1);
                        });
                    }
                }
            });
        },
        image: function(obj) {
            var objs = $A.$(obj).find("div.swiper-slide");
            if (objs.length > 0) {
                var imgs = [], index = 0;
                objs.each(function(i, item) {
                    imgs.push($A.$(item).attr("data-img"));
                    if ($A.$(item).hasClass("swiper-slide-active")) index = i;
                });
                $A.album(imgs, index);
            }
        },
        address: function() {
            var userInfo = $JS.userInfo;
            if ($JS.myLon !== 0) {
                $A.routerBack({name: 'main'});
                if (!($A.bMap.lastData.id > 0 && $A.bMap.lastData.id === userInfo.id)) {
                    $A.bMap.obj.removeAnnotations({ids: [userInfo.id]});
                    $A.bMap.addShow(userInfo);
                    $A.bMap.showInfo(userInfo, {lon: $JS.myLon, lat: $JS.myLat});
                }
            }
        },
        openCdb: function() {
            api.actionSheet({
                title: '充电宝',
                cancelTitle: '取消',
                buttons: ['借用', '归还']
            }, function(ret, err) {
                if (ret.buttonIndex === 1) {
                    $JS.openCdbScan();
                }else if (ret.buttonIndex == 2) {
                    api.confirm({
                        title: "归还方式",
                        msg: "请将充电宝送至【服务网点（G家）】，\r\nG家店员扫码，即完成归还。\r\n\r\n客服：" + $A.callTel(true),
                        buttons: ['联系客服', '取消']
                    }, function(ret, err) {
                        if (ret.buttonIndex === 1) {
                            $A.callTel();
                        }
                    });
                }
            });

        },
        openCdbScan: function() {
            $A.winScan({
                pageParam: {
                    bottomText: '请扫描【充电宝】上的二维码'
                },
                callback: function(content) {
                    var matcht = content.match(/http+s?:\/\/+[s.|ss.|api.|api2.]+gengdian.net\/cdb\/(.*?)\//i);
                    if (matcht && matcht[1] && matcht[1].length >= 10 && $A.leftexists(matcht[1], "0")) {
                        $A.ajax({
                            url: 'https://api.gengdian.net/v2/other/cdbinfo',
                            data: {
                                sn: matcht[1]       //设备编号
                            },
                            dataType: 'json',
                            timeout: 10000,
                            beforeSend: true,
                            complete: true,
                            error: true,
                            success: function(res) {
                                if (res.ret === 1) {
                                    if (res.data.type === '充电宝') {
                                        $A.routerPopup({title: '选择支付', url: 'pages/apply/selectpay/', data: {sn: matcht[1]}});
                                    }else{
                                        $A.alert("您扫描的二维码不正确，<br/>请扫描【充电宝】上的二维码。", "亲：", function() {
                                            $JS.openCdbScan();
                                        });
                                    }
                                }else{
                                    $A.alert(res.msg, "亲：", function() {
                                        $JS.openCdbScan();
                                    });
                                }
                            }
                        });
                    } else {
                        $A.alert("您扫描的二维码不正确，<br/>请扫描【充电宝】上的二维码。", "亲：", function() {
                            $JS.openCdbScan();
                        });
                    }
                }
            });
        },
        openYs: function() {
            api.actionSheet({
                title: '三免雨伞',
                cancelTitle: '取消',
                buttons: ['借用', '归还']
            }, function (ret, err) {
                if (ret.buttonIndex === 1) {
                    $JS.selectYs('borrow');
                }else if (ret.buttonIndex == 2) {
                    $JS.selectYs('giveback');
                }
            });
        },
        openYsScan: function(callback, type) {
            $A.winScan({
                pageParam: {
                    bottomText: type=='borrow'?"请扫描【店内雨伞架上】的二维码":"<div style='padding:0 20px;font-size:14px;'>请将雨伞送至【服务网点（G家）】，<br/>扫描【店内雨伞架上】的二维码，即完成归还。<div style='padding-top:10px;'>如何查找G家？<br/>通过【G电微信公用号】或【G电APP】的地图，<br/>即可找到G家。</div></div>"
                },
                callback: function(content) {
                    var matcht = content.match(/http+s?:\/\/+[s.|ss.|api.|api2.]+gengdian.net\/users\/(.*?)\//i);
                    if (matcht && matcht[1] && matcht[1] == $JS.$el.find("#usercode").text()) {
                        if (typeof callback === 'function') callback();
                    } else {
                        $A.alert("您扫描的二维码不正确，<br/>请扫描【店内雨伞架上】上的二维码。", "亲：", function() {
                            $JS.openYsScan(callback, type);
                        });
                    }
                }
            });
        },
        selectYs: function(type, skip) {
            $JS.$el.find(".selectYs").removeClass('active');
            var $callback = null;
            if (type == 'borrow') {
                $callback = function() {
                    $A.confirm('<div class="page-explain-box">' +
                        '<p>押金：<del>29元</del>，三免期<font color="#f00">0元</font>，<br/>请在使用后归还至G家网点。</p>' +
                        '<p>租金：<del>1元/天</del>，三免期<font color="#f00">0元</font>。</p>' +
                        '<p>三免期无需信用抵押。</p>' +
                        '</div>', '押金说明（借伞）', function () {
                        $A.ajax({
                            url: 'https://api.gengdian.net/v2/payment/borrow_ys',
                            data: {
                                userid: '{#intval(substr($_GPC['sn'],2))#}'       //商家会员ID
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
                                    $JS.$el.find("#cdb_title").text(res.data.title);
                                    $JS.$el.find("#cdb_username").text(res.data.username);
                                    $JS.$el.find("#cdb_usercode").text(res.data.usercode);
                                    $JS.payOK();
                                }else{
                                    $A.alert(res.msg, '温馨提示');
                                }
                            }
                        });
                    });
                };
            }else if (type == 'giveback') {
                $callback = function() {
                    $A.ajax({
                        url: 'https://api.gengdian.net/v2/payment/giveback_ys',
                        data: {
                            userid: '{#intval(substr($_GPC['sn'],2))#}'       //商家会员ID
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
                                $A.giveBack(true);
                            }else{
                                $A.alert(res.msg, '温馨提示');
                            }
                        }
                    });
                };
            }
            if (skip === true) {
                $callback();
            }else{
                $JS.openYsScan(function() { $callback() }, type);
            }
        },
        /**
         * 借用成功弹出
         */
        payOK: function() {
            $A.$theme("green");
            $A.$changeTheme("#296931");
            $A.routerLoad({popup: '#apply-selectpay-ysok-popup', backRun: function(){ $JS.payOKD(); }});
        },
        /**
         * 关闭借用成功提示
         */
        payOKD: function() {
            $A.$theme();
            $A.$changeTheme();
        }
    }
</script>