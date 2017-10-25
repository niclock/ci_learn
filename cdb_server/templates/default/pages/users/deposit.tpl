{#*我的押金*#}

{#user_check()#}

<div class="users_deposit">
    <div id="listsBox" class="list-block media-list"></div>
</div>
<div id="subnavbar_temp" style="display:none;">
    <div class="subnavbar users_deposit_subnavbar">
        <div class="buttons-row">
            <a href="#" class="button active" data-index="0" data-type="all" onclick="$JS.lists(this)">全部</a>
            <a href="#" class="button" data-index="1" data-type="使用中" onclick="$JS.lists(this)">使用中</a>
            <a href="#" class="button" data-index="2" data-type="可退款" onclick="$JS.lists(this)">可退款</a>
            <a href="#" class="button" data-index="3" data-type="退款中" onclick="$JS.lists(this)">退款中</a>
            <a href="#" class="button" data-index="4" data-type="已退款" onclick="$JS.lists(this)">已退款</a>
            <span></span>
        </div>
    </div>
</div>
<style>
    .users_deposit .list-block{margin-top:-1px}
    .users_deposit .list-block ul.no:before,.users_deposit .list-block ul.no:after{background-color:transparent}
    .users_deposit .list-block ul.no li{padding:50px 0;text-align:center}
    .users_deposit .item-title-row{margin:5px 0 8px}
    .users_deposit .item-subtitle em{color:#666}
    .users_deposit .item-text{margin-top:15px}
    .users_deposit_subnavbar{margin-top:-1px;padding:0}
    .users_deposit_subnavbar .buttons-row{height:100%;position:relative}
    .users_deposit_subnavbar .buttons-row .button{margin-left:0;height:48px;line-height:48px;border-radius:inherit}
    .users_deposit_subnavbar .buttons-row span{position:absolute;left:0;bottom:0;height:2px;width:20%;background:rgba(255,255,255,.5);-webkit-transition-duration:.3s;transition-duration:.3s}
    .users_deposit_last_tis{display:block;width:100%;text-align:center;margin:10px auto;}
    .users_deposit_last_tis img{width:100%;height:auto;}
</style>
<script>
    $JS = {
        /**
         * 页面创建完毕
         */
        created: function() {
            if ($JS.$el.find(".navbar .subnavbar").length === 0) {
                $JS.$el.find(".navbar .subnavbar").remove();
                $JS.$el.find(".navbar").append($JS.$el.find("#subnavbar_temp").html());
                $JS.$el.find(".page-content").addClass("with-subnavbar");
                setTimeout(function(){ $JS.pullToRefreshTrigger(); }, 200);
            }
            $JS.$el.find(".navbar .right").html('<a href="#" onclick="$JS.pullToRefreshTrigger();" class="link"><i class="icon material-icons">refresh</i></a><a href="javascript:void(0)" onclick="$JS.explain();" class="link" style="font-size:16px;">押金说明</a>');
        },
        /**
         * 页面被重新激活
         */
        activated: function() {
            //刷新所有列表
            $JS.$el.find("#listsBox").find("ul").remove();
            $JS.pullToRefreshTrigger();
        },
        /**
         * 押金说明
         */
        explain: function() {
            $A.routerPopup({title:'押金说明', url: 'pages/about/deposit_explain/'});
        },
        /**
         * 获取类型
         */
        dataType: function(datatype) {
            if (datatype === '可退款') {
                datatype = '1';
            }else if (datatype === '退款中') {
                datatype = '2';
            }else if (datatype === '已退款') {
                datatype = '3';
            }else if (datatype === '使用中') {
                datatype = '4';
            }else {
                datatype = '0';
            }
            return datatype;
        },
        /**
         * 加载列表
         * @param obj
         */
        lists: function(obj) {
            var tthis = $A.$(obj);
            tthis.parent().find("span").css('left', (parseInt(tthis.attr("data-index")) * 20) + '%');
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
         * 下拉刷新事件
         */
        refresh: function() {
            var active = $JS.$el.find(".navbar .subnavbar .active");
            var datatype = $JS.dataType(active.attr("data-type"));
            var listsBox = $JS.$el.find("#listsBox");
            //
            listsBox.find("ul[data-type='" + datatype + "']").remove();
            listsBox.find("ul").hide();
            //
            $A.ajax({
                url: 'https://api.gengdian.net/v2/users/deposit_lists',
                data: {
                    type: datatype
                },
                dataType: 'json',
                timeout: 10000,
                beforeSend: function() { },
                complete: function(){ setTimeout(function(){ $JS.pullToRefreshDone() }, 300) },
                error: true,
                success: function(res) {
                    if (res.ret === 1) {
                        var lists = res.data.lists, intemp = '', statusbtn = '';
                        for (var i = 0; i < lists.length; i++) {
                            var item = lists[i];
                            if (item['status'] === '使用中' && item['waitorder'] > 0) {
                                statusbtn = '<div onclick="$JS.apply(this, \'' + item['payid'] + '\');" class="button button-fill" data-waitorder="' + item['waitorder'] + '">押金退款</div>';
                            }else if (item['status'] == '已付款') {
                                statusbtn = '<div onclick="$JS.apply(this, \'' + item['payid'] + '\');" class="button button-fill" data-waitorder="0">押金退款</div>';
                            }else{
                                statusbtn = '<div onclick="$JS.apply(this, \'' + item['payid'] + '\');" class="button button-fill button-disabled">' + item['status'] + '</div>';
                            }
                            intemp += '<li class="item-content">' +
                                '<div class="item-inner">' +
                                '<div class="item-title-row">' +
                                '<div class="item-title">金额: ' + item['money'] + '元</div>' +
                                '<div class="item-after">' + $JS.dateYear(item['indate']) + '</div>' +
                                '</div>' +
                                '<div class="item-subtitle"><em>订单ID:</em> ' + item['payid'] + '</div>' +
                                '<div class="item-subtitle"><em>支付方式:</em> ' + item['payfrom'] + '</div>' +
                                '<div class="item-subtitle"><em>使用设备:</em> ' + item['sn'] + '</div>' +
                                (item['status'] == '已退款' ? '<div class="item-subtitle"><em>退款时间:</em> ' + $JS.dateYear(item['retdate']) + '</div>' : '') +
                                '<div class="item-text">' + statusbtn + '</div>' +
                                '</div>' +
                                '</li>';
                        }
                        if (intemp === '') {
                            intemp = '<ul data-type="' + datatype + '" class="no"><li>没有记录</li></ul>';
                        }else{
                            intemp = '<ul data-type="' + datatype + '">' + intemp + '</ul>';
                        }
                        listsBox.append(intemp);
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
         * 点击按钮
         * @param obj
         * @param payid
         */
        apply: function(obj, payid) {
            var tthis = $A.$(obj);
            if (tthis.text() === "已退款") {
                $A.alert("若订单显示“已退款”，表示押金已经从G电返回原支付方。", "已退款");
                return;
            }
            if (tthis.text() === "退款中") {
                $A.alert("退款申请已受理，将于3个工作日内完成。", "退款中");
                return;
            }
            if (tthis.text() === "使用中") {
                $A.alert("若订单显示“使用中”，表示归还使用设备后可申请押金退款。", "使用中");
                return;
            }
            if (tthis.text() !== "押金退款") return;
            if ($A.runNum(tthis.attr("data-waitorder")) > 0) {
                $A.confirm("<span class='users_deposit_last_tis'><img src='{#$TEM_PATH#}assets/images/back_step.jpg'></span>您还有订单未付款，确定付款后即可申请押金退款。", "押金退款", function(){
                    $A.ajax({
                        url: 'https://api.gengdian.net/v2/users/giveback',
                        data: {
                            act: 'mark',
                            orderid: tthis.attr("data-waitorder")      //订单ID
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
                });
                return;
            }
            $A.confirm("<span class='users_deposit_last_tis'><img src='{#$TEM_PATH#}assets/images/back_step_end.jpg'></span>申请成功后，押金将3个工作日内原路退回支付账户？", "押金退款", function(){
                $A.ajax({
                    url: 'https://api.gengdian.net/v2/payment/refund',
                    data: {
                        payid: payid
                    },
                    dataType: 'json',
                    timeout: 10000,
                    beforeSend: true,
                    complete: true,
                    error: true,
                    success: function(res) {
                        if (res.ret === 1) {
                            tthis.addClass('button-disabled');
                            tthis.text(res.msg);
                        }else{
                            $A.alert(res.msg, '提醒', function(){
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
    };
</script>