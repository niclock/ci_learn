{#*我的优惠券*#}

{#user_check()#}

<div class="users_sale">
    <div id="listsBox" class="list-block media-list"></div>
</div>
<div id="subnavbar_temp" style="display:none;">
    <div class="subnavbar users_sale_subnavbar">
        <div class="buttons-row">
            <a href="#" class="button active" data-index="0" data-type="可使用" onclick="$JS.lists(this)">可使用</a>
            <a href="#" class="button" data-index="1" data-type="已使用" onclick="$JS.lists(this)">已使用</a>
            <a href="#" class="button" data-index="2" data-type="已过期" onclick="$JS.lists(this)">已过期</a>
            <a href="#" class="button" data-index="3" data-type="全部" onclick="$JS.lists(this)">全部</a>
            <span></span>
        </div>
    </div>
</div>

<!-- 兑换码领券 Popup -->
<div class="popup popup-up" id="users-sale-sn-popup">
    <div class="view navbar-fixed">
        <div class="pages">
            <div class="page">
                <div class="navbar">
                    <div class="navbar-inner">
                        <div class="left">
                            <a href="javascript:void(0)" onclick="$A.routerBack({popup:'#users-sale-sn-popup'})" class="link"><i class="icon material-icons">close</i></a>
                        </div>
                        <div class="center">兑换码领券</div>
                    </div>
                </div>
                <div class="page-content">
                    <form class="list-block">
                        <ul>
                            <li>
                                <div class="item-content">
                                    <div class="item-inner">
                                        <div class="item-input">
                                            <input type="text" placeholder="请输入兑换码" id="users_sale_sn">
                                        </div>
                                    </div>
                                </div>
                            </li>
                        </ul>
                    </form>
                    <div class="content-block">
                        <a href="#" onclick="$JS.submitsn()" class="button-fill button-big button" style="margin-bottom:18px;">确&nbsp;&nbsp;定</a>
                        <a href="#" onclick="$A.routerBack({popup:'#users-sale-sn-popup'})" class="button-big button">返&nbsp;&nbsp;回</a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<!--suppress CssUnusedSymbol -->
<style>
    .users_sale .list-block{margin-top:-1px}
    .users_sale .list-block ul.no:before,.users_sale .list-block ul.no:after{background-color:transparent}
    .users_sale .list-block ul.no li{padding:50px 0;text-align:center}
    .users_sale .item-title-row{margin:5px 0 8px}
    .users_sale .item-subtitle em{color:#666}
    .users_sale .item-text{margin-top:15px}
    .users_sale_subnavbar{margin-top:-1px;padding:0}
    .users_sale_subnavbar .buttons-row{height:100%;position:relative}
    .users_sale_subnavbar .buttons-row .button{margin-left:0;height:48px;line-height:48px;border-radius:inherit}
    .users_sale_subnavbar .buttons-row span{position:absolute;left:0;bottom:0;height:2px;width:25%;background:rgba(255,255,255,.5);-webkit-transition-duration:.3s;transition-duration:.3s}
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
                $JS.$el.find(".navbar").eq(0).append($JS.$el.find("#subnavbar_temp").html());
                $JS.$el.find(".page-content").eq(0).addClass("with-subnavbar");
                setTimeout(function(){ $JS.pullToRefreshTrigger(); }, 200);
            }
            $JS.$el.find(".navbar .right").html('<a href="#" onclick="$JS.pullToRefreshTrigger();" class="link"><i class="icon material-icons">refresh</i></a><a href="javascript:void(0)" onclick="$JS.sn();" class="link" style="font-size:16px;">兑换码领券</a>');
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
         * 获取类型
         */
        dataType: function(datatype) {
            if (datatype === '可使用') {
                datatype = '1';
            }else if (datatype === '已使用') {
                datatype = '2';
            }else if (datatype === '已过期') {
                datatype = '3';
            }else{
                datatype = '0';
            }
            return datatype;
        },
        /**
         * 切换列表
         * @param obj
         */
        lists: function(obj) {
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
                url: 'https://api.gengdian.net/v2/users/sale_lists',
                data: {
                    act: datatype,
                    page: $JS.nowPage[datatype]
                },
                dataType: 'json',
                timeout: 10000,
                beforeSend: function() { },
                complete: function(){ setTimeout(function(){ $JS.pullToRefreshDone() }, 300) },
                error: true,
                success: function(res) {
                    if (res.ret === 1) {
                        var lists = res.data, intemp = '';
                        for (var i = 0; i < lists.length; i++) {
                            var item = lists[i];
                            intemp += '<li class="item-content' + (item['viewdate'] ? '' : ' noview') + '" data-id="' + item['id'] + '">' +
                                '<div class="item-inner">' +
                                '<div class="item-title-row">' +
                                '<div class="item-title">' + item['title'] + '</div>' +
                                '<div class="item-after">' + $JS.dateYear(item['indate']) + '</div>' +
                                '</div>' +
                                '<div class="item-subtitle">优惠方式：' + item['TEXT'] + '</div>' +
                                '<div class="item-subtitle">使用条件：' + item['limit_exp'] + '</div>' +
                                (item['sale_type'] == "C" ? '<div class="item-subtitle">兑换编码：' + item['EXCHANGESN_FORMAT'] + '</div>' : '') +
                                '<div class="item-subtitle">有效期限：' + $JS.dateYear(item['enddate']) + (item['status_cn'] == '可使用' && item['enddate'] - Math.round(new Date().getTime() / 1000) < 259200 ? '<span class="badge bg-orange">即将过期</span>' : '') + '</div>' +
                                '<div class="item-text"><div data-saletype="' + item['sale_type'] + '" data-exchangesn="' + item['EXCHANGESN'] + '" data-title="' + item['use_exp'] + '" onclick="$JS.apply(this);" class="button button-fill ' + (item['status_cn'] != '可使用' ? 'button-disabled' : '') + '">' + item['status_cn'] + '</div></div>' +
                                '</div>' +
                                '</li>';
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
                        $JS.nextPage[datatype] = false;
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
        apply: function(obj) {
            var tthis = $A.$(obj);
            if (tthis.text() === "可使用") {
                var message = tthis.attr("data-title")?tthis.attr("data-title"):"请在归还设备时使用。";
                if (tthis.attr("data-saletype") === "C" && tthis.attr("data-exchangesn")) {
                    message = '<img style="width:150px;height:150px;display:block;margin:5px auto;" src="https://api.gengdian.net/v2/other/iqrcode?sn=' + tthis.attr("data-exchangesn") + '&size=300">' + tthis.attr("data-title");
                }
                $A.alert(message, "可使用");
            }
        },
        /**
         * 兑换码领券
         */
        sn: function() {
            $A.routerLoad({popup: '#users-sale-sn-popup'});
        },
        /**
         * 提交兑换
         */
        submitsn: function() {
            var obj = $A.$("#users_sale_sn");
            if (obj.val().length < 5) {
                $A.toast('请输入正确的兑换码');
                obj.focus();
                return;
            }
            //
            $A.ajax({
                url: 'https://api.gengdian.net/v2/users/checksale',
                data: {
                    sn: obj.val()
                },
                dataType: 'json',
                timeout: 10000,
                beforeSend: true,
                complete: true,
                error: true,
                success: function(res) {
                    if (res.ret === 1) {
                        $A.$("#users_sale_sn").val("");
                        $A.toast(res.msg);
                        $A.routerBack({popup:'#users-sale-sn-popup'});
                        $JS.pullToRefreshTrigger();
                        $push.getMessage();
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