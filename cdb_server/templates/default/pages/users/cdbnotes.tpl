{#*我的设备*#}

{#user_check()#}

<div class="users_cdbnotes">
    <div id="listsBox" class="list-block media-list"></div>

</div>
<div id="subnavbar_temp" style="display:none;">
    <div class="subnavbar users_cdbnotes_subnavbar">
        <div class="buttons-row">
            <a href="#" class="button active" data-index="0" data-type="我的设备" onclick="$JS.lists(this)">我的设备</a>
            <a href="#" class="button" data-index="1" data-type="设备记录" onclick="$JS.lists(this)">设备记录</a>
            <span></span>
        </div>
    </div>
</div>
<style>
    .users_cdbnotes .list-block{margin-top:-1px}
    .users_cdbnotes .list-block ul.no:before,.users_cdbnotes .list-block ul.no:after{background-color:transparent}
    .users_cdbnotes .list-block ul.no li{padding:50px 0;text-align:center}
    .users_cdbnotes .item-title-row{margin:5px 0 8px}
    .users_cdbnotes .item-subtitle em{color:#666}
    .users_cdbnotes .item-text{margin-top:15px}
    .users_cdbnotes_subnavbar{margin-top:-1px;padding:0}
    .users_cdbnotes_subnavbar .buttons-row{height:100%;position:relative}
    .users_cdbnotes_subnavbar .buttons-row .button{margin-left:0;height:48px;line-height:48px;border-radius:inherit}
    .users_cdbnotes_subnavbar .buttons-row span{position:absolute;left:0;bottom:0;height:2px;width:50%;background:rgba(255,255,255,.5);-webkit-transition-duration:.3s;transition-duration:.3s}
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
                setTimeout(function(){ $JS.pullToRefreshTrigger(); }, 200);
            }
            $JS.$el.find(".navbar .right").html('<a href="#" onclick="$JS.pullToRefreshTrigger();" class="link"><i class="icon material-icons">refresh</i></a>');
        },
        /**
         * 获取类型
         */
        dataType: function(datatype) {
            if (datatype === '设备记录') {
                datatype = 'notes';
            }else{
                datatype = 'lists';
            }
            return datatype;
        },
        /**
         * 切换列表
         * @param obj
         */
        lists: function(obj) {
            var tthis = $A.$(obj);
            tthis.parent().find("span").css('left', (parseInt(tthis.attr("data-index")) * 50) + '%');
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
                url: 'https://api.gengdian.net/v2/users/cdbnotes_lists',
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
                            if (datatype === 'notes') {
                                intemp+= '<li class="item-content">' +
                                    '<div class="item-inner">' +
                                    '<div class="item-title-row">' +
                                    '<div class="item-title">' + (item['type']=='in'?'收录':'借出') + '设备：' + item['sn'] + '</div>' +
                                    '<div class="item-after">' + $JS.dateYear(item['indate']) + '</div>' +
                                    '</div>' +
                                    '</div>' +
                                    '</li>';
                            }else{
                                intemp+= '<li class="item-content">' +
                                    '<div class="item-inner">' +
                                    '<div class="item-title-row">' +
                                    '<div class="item-title">设备编号：' + item['sn'] + '</div>' +
                                    '<div class="item-after">' + $JS.dateYear(item['update']) + '</div>' +
                                    '</div>' +
                                    '</div>' +
                                    '</li>';
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