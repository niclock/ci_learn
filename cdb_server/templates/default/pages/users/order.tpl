{#*我的订单记录*#}

{#user_check()#}

<div class="users_order">
    <div id="listsBox" class="list-block media-list"></div>
</div>
<div id="subnavbar_temp" style="display:none;">
    <div class="subnavbar users_order_subnavbar">
        <div class="buttons-row">
            <a href="#" class="button active" data-index="0" data-type="使用中" onclick="$JS.lists(this)">使用中</a>
            <a href="#" class="button" data-index="1" data-type="待付款" onclick="$JS.lists(this)" id="await">待付款<i class="badge bg-green">0</i></a>
            <a href="#" class="button" data-index="2" data-type="已归还" onclick="$JS.lists(this)">已归还</a>
            <a href="#" class="button" data-index="3" data-type="all" onclick="$JS.lists(this)">全部</a>
            <span></span>
        </div>
    </div>
</div>
<style>
    .users_order .list-block{margin-top:-1px}
    .users_order .list-block ul.no:before,.users_order .list-block ul.no:after{background-color:transparent}
    .users_order .list-block ul.no li{padding:50px 0;text-align:center}
    .users_order .item-title-row{margin:5px 0 8px}
    .users_order .item-subtitle em{color:#666}
    .users_order .item-text{margin-top:15px}
    .users_order_subnavbar{margin-top:-1px;padding:0}
    .users_order_subnavbar .buttons-row{height:100%;position:relative}
    .users_order_subnavbar .buttons-row .button{margin-left:0;height:48px;line-height:48px;border-radius:inherit}
    .users_order_subnavbar .buttons-row span{position:absolute;left:0;bottom:0;height:2px;width:25%;background:rgba(255,255,255,.5);-webkit-transition-duration:.3s;transition-duration:.3s}
    .users_order_subnavbar i.badge{display:none;height:20px;line-height:20px;margin-top:-15px;}
</style>
<script>
    $JS = {
        /**
         * 当前页组、是否有下一页组
         */
        nowPage: {}, nextPage: {},
        /**
         * 创建完毕执行
         */
        created: function() {
            if ($JS.$el.find(".navbar .subnavbar").length === 0) {
                $JS.$el.find(".navbar .subnavbar").remove();
                $JS.$el.find(".navbar").append($JS.$el.find("#subnavbar_temp").html());
                $JS.$el.find(".page-content").addClass("with-subnavbar");
                //查询待付款数量
                $JS.await(function(num){
                    if (num > 0) {
                        $JS.$el.find("#await").click();
                    }else{
                        $JS.pullToRefreshTrigger();
                    }
                });
            }
            $JS.$el.find(".navbar .right").html('<a href="#" onclick="$JS.pullToRefreshTrigger();" class="link"><i class="icon material-icons">refresh</i></a>');
            if ($A.runNum($JS.$data.orderid) > 0) {
                $JS.giveBack($JS.$data.orderid);
            }
        },
        /**
         * 页面被重新激活
         */
        activated: function() {
            //查询待付款数量
            $JS.await();
            //刷新所有列表
            $JS.$el.find("#listsBox").find("ul").remove();
            $JS.pullToRefreshTrigger();
        },
        /**
         * 获取类型
         */
        dataType: function(datatype) {
            if (datatype === '使用中') {
                datatype = '1';
            }else if (datatype === '待付款') {
                datatype = '2';
            }else if (datatype === '已归还') {
                datatype = '3';
            }else{
                datatype = '0';
            }
            return datatype;
        },
        /**
         * 查询待付款数量
         */
        await: function(callback){
            var __callback = function(num) {
                if (typeof callback === 'function') callback(num);
            };
            $A.ajax({
                url: 'https://api.gengdian.net/v2/users/order_lists',
                data: {
                    act: 'await'
                },
                dataType: 'json',
                timeout: 10000,
                success: function(res) {
                    if (res.ret === 1) {
                        $JS.$el.find("#await .badge").text(res.data.await).css("display", "inline-block");
                        __callback(res.data.await);
                    }else{
                        $JS.$el.find("#await .badge").val(0).hide();
                        __callback(0);
                    }
                },
                error: function() {
                    __callback(0);
                }
            });
        },
        /**
         * 切换列表
         * @param obj
         */
        lists: function(obj) {
            //
            var tthis = $A.$(obj);
            tthis.parent().find("span").css('left', (parseInt(tthis.attr("data-index")) * 25) + '%');
            tthis.parent().find(".active").removeClass("active");
            tthis.addClass("active");
            //
            var datatype = $JS.dataType(tthis.attr("data-type"));
            var listsBox = $JS.$el.find("#listsBox");
            var orderUl = listsBox.find("ul[data-type='" + datatype + "']");
            if (orderUl.length > 0) {
                listsBox.find("ul").hide();
                orderUl.show();
            }else{
                $JS.pullToRefreshTrigger();
            }
        },
        /**
         * 下拉刷新
         */
        refresh: function(isNext) {
            var active = $JS.$el.find(".navbar .subnavbar .active");
            var datatype = $JS.dataType(active.attr("data-type"));
            var listsBox = $JS.$el.find("#listsBox");
            //
            if (isNext === true) {
                $JS.nowPage[datatype]++
            }else{
                $JS.nowPage[datatype] = 1;
                //
                listsBox.find("ul[data-type='" + datatype + "']").remove();
                listsBox.find("ul").hide();
            }
            //
            $A.ajax({
                url: 'https://api.gengdian.net/v2/users/order_lists',
                data: {
                    type: datatype,
                    page: $JS.nowPage[datatype]
                },
                dataType: 'json',
                timeout: 10000,
                beforeSend: function() { },
                complete: function(){ setTimeout(function(){ $JS.pullToRefreshDone() }, 300) },
                error: true,
                success: function(res) {
                    if (res.ret === 1) {
                        var lists = res.data.lists, intemp = '';
                        for (var i = 0; i < lists.length; i++) {
                            var item = lists[i];
                            intemp += '<li class="item-content">' +
                                '<div class="item-inner">' +
                                '<div class="item-title-row">' +
                                '<div class="item-title">' + item['title'] + '</div>' +
                                '<div class="item-after">借用时间: ' + $JS.dateYear(item['indate']) + '</div>' +
                                '</div>' +
                                '<div class="item-subtitle">设备编码: ' + item['sn'] + '</div>';
                            if (item['retdate'] > 0) {
                                intemp += '<div class="item-subtitle">租用时长: ' + item['timeDiff'] + '</div>' +
                                    '<div class="item-subtitle">借用金额: ' + item['retmoney'] + '元</div>' +
                                    '<div class="item-subtitle">归还时间: ' + $JS.dateYear(item['retdate']) + '</div>';
                                if (item['ret'] > 0) {
                                    intemp += '<div class="item-text"><div onclick="$JS.giveBack(\'' + item['id'] + '\');" class="button button-fill" style="font-weight:700">已归还，待付款（' + item['retmoney'] + '元）</div></div>';
                                } else {
                                    intemp += '<div class="item-text"><div class="button button-fill button-disabled">已归还成功</div></div>';
                                }
                            } else {
                                if (item['cdb_type'] == '雨伞') {
                                    intemp += '<div class="item-subtitle">租用时长: ' + item['timeDiff'] + '</div>' +
                                        '<div class="item-subtitle">借用金额: <span style="color:#ff5722;"><b>' + item['totalMoney'] + '元</b>（三免期）</span></div>' +
                                        '<div class="item-text"><div onclick="$JS.givebackYs();" class="button button-fill">归还雨伞（' + item['totalMoney'] + '元）</div></div>';
                                } else {
                                    intemp += '<div class="item-subtitle">租用时长: ' + item['timeDiff'] + '</div>' +
                                        '<div class="item-subtitle">借用金额: ' + item['totalMoney'] + '元</div>' +
                                        '<div class="item-text"><div onclick="$A.alert(\'请将充电宝送至【服务网点（G家）】，<br/>G家店员扫码，即完成归还。<br/><br/>客服：{#settingfind('system', 'tel_num')#}\', \'归还方式\');" class="button button-fill">归还设备（' + item['totalMoney'] + '元）</div></div>';
                                }
                            }
                        }
                        if (isNext === true) {
                            listsBox.find("ul[data-type='" + datatype + "']").append(intemp);
                        }else{
                            if (intemp === '') {
                                intemp = '<ul data-type="' + datatype + '" class="no"><li>没有记录</li></ul>';
                            }else{
                                intemp = '<ul data-type="' + datatype + '">' + intemp + '</ul>';
                            }
                            listsBox.append(intemp);
                        }
                        $JS.nextPage[datatype] = res.data.hasMorePages;
                    }else{
                        $A.alert(res.msg, '提醒', function(){
                            if (res.ret === -1) {
                                $A.login(function(){ $JS.pullToRefreshTrigger(); });
                            }
                        });
                    }
                }
            });
        },
        /**
         * 无限加载
         */
        infinite: function() {
            var active = $JS.$el.find(".navbar .subnavbar .active");
            var datatype = $JS.dataType(active.attr("data-type"));
            if ($JS.nextPage[datatype] === true) {
                $JS.nextPage[datatype] = false;
                $JS.refresh(true);
            }
            $JS.infiniteDone();
        },
        /**
         * 归还设备
         * @param orderid
         */
        giveBack: function(orderid) {
            $A.ajax({
                url: 'https://api.gengdian.net/v2/users/giveback',
                data: {
                    act: 'mark',
                    orderid: orderid      //订单ID
                },
                dataType: 'json',
                beforeSend: true,
                complete: true,
                error: true,
                success: function(res) {
                    if (res.ret === 1) {
                        $A.giveBack(true);
                    }else{
                        $A.toast(res.msg);
                    }
                }
            });
        },
        /**
         * 打开归还雨伞二维码扫描
         */
        openYsScan: function(callback) {
            $A.winScan({
                pageParam: {
                    bottomText: "<div style='padding:0 20px;font-size:14px;'>请将雨伞送至【服务网点（G家）】，<br/>扫描【店内雨伞架上】的二维码，即完成归还。<div style='padding-top:10px;'>如何查找G家？<br/>通过【G电微信公用号】或【G电APP】的地图，<br/>即可找到G家。</div></div>"
                },
                callback: function(content) {
                    var matcht = content.match(/http+s?:\/\/+[s.|ss.|api.|api2.]+gengdian.net\/users\/(.*?)\//i);
                    if (matcht && matcht[1] && matcht[1].length >= 10) {
                        if (typeof callback === 'function') callback(parseInt(matcht[1].substring(2)));
                    } else {
                        $A.alert("您扫描的二维码不正确，<br/>请扫描【店内雨伞架上】上的二维码。", "亲：", function() {
                            $JS.openYsScan(callback);
                        });
                    }
                }
            });
        },
        /**
         * 归还雨伞
         */
        givebackYs: function() {
            $JS.openYsScan(function(userid) {
                $A.ajax({
                    url: 'https://api.gengdian.net/v2/payment/giveback_ys',
                    data: {
                        userid: userid       //商家会员ID
                    },
                    dataType: 'json',
                    timeout: 10000,
                    beforeSend: true,
                    complete: true,
                    error: true,
                    success: function(res) {
                        if (res.ret === 1) {
                            $A.giveBack(true);
                        }else{
                            $A.alert(res.msg, '温馨提示', function(){
                                if (res.ret === -1) {
                                    $A.login(function(){ $JS.pullToRefreshTrigger(); });
                                }
                            });
                        }
                    }
                });
            });
        },
        /**
         * 时间戳转时间（今年取消年份显示）
         */
        dateYear: function(date) {
            var zeroFill = function(str, length, after) {
                if (str.length >= length) {
                    return str;
                }
                var _str = '', _ret = '';
                for (var i = 0; i < length; i++) {
                    _str += '0';
                }
                if (after || typeof after === 'undefined') {
                    _ret = (_str + "" + str).substr(length * -1);
                } else {
                    _ret = (str + "" + _str).substr(0, length);
                }
                return _ret;
            };
            var formatDate = function(format, v) {
                if (format === '') {
                    format = 'Y-m-d H:i:s';
                }
                if (typeof v === 'undefined') {
                    v = new Date().getTime();
                }else if (/^(-)?\d{1,10}$/.test(v)) {
                    v = v * 1000;
                } else if (/^(-)?\d{1,13}$/.test(v)) {
                    v = v * 1000;
                } else if (/^(-)?\d{1,14}$/.test(v)) {
                    v = v * 100;
                } else if (/^(-)?\d{1,15}$/.test(v)) {
                    v = v * 10;
                } else if (/^(-)?\d{1,16}$/.test(v)) {
                    v = v * 1;
                } else {
                    return v;
                }
                var dateObj = new Date(v);
                if (parseInt(dateObj.getFullYear()) + "" === "NaN") { return v; }
                //
                format = format.replace(/Y/g, dateObj.getFullYear());
                format = format.replace(/m/g, zeroFill(dateObj.getMonth() + 1, 2));
                format = format.replace(/d/g, zeroFill(dateObj.getDate(), 2));
                format = format.replace(/H/g, zeroFill(dateObj.getHours(), 2));
                format = format.replace(/i/g, zeroFill(dateObj.getMinutes(), 2));
                format = format.replace(/s/g, zeroFill(dateObj.getSeconds(), 2));
                return format;
            };
            if (formatDate("Y") === formatDate("Y", date)) {
                return formatDate("m-d H:i:s", date);
            }else{
                return formatDate("Y-m-d H:i:s", date);
            }
        }
    }
</script>