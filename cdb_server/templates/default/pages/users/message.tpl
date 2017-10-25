{#*我的信息*#}

{#user_check()#}

<div class="users_message">
    <div id="listsBox" class="list-block media-list"></div>
</div>
<div id="subnavbar_temp" style="display:none;">
    <div class="subnavbar users_message_subnavbar">
        <div class="buttons-row">
            <a href="#" class="button active" data-index="0" data-type="all" onclick="$JS.lists(this)">全部</a>
            <a href="#" class="button" data-index="1" data-type="未阅读" onclick="$JS.lists(this)">未阅读</a>
            <a href="#" class="button" data-index="2" data-type="已阅读" onclick="$JS.lists(this)">已阅读</a>
            <span></span>
        </div>
    </div>
</div>
<!--suppress CssUnusedSymbol -->
<style>
    .users_message .list-block{margin-top:-1px}
    .users_message .list-block ul.no:before,.users_message .list-block ul.no:after{background-color:transparent}
    .users_message .list-block ul.no li{padding:50px 0;text-align:center}
    .users_message .item-title-row{margin:5px 0 8px}
    .users_message .item-title em{display:none;vertical-align:top;margin-top:7px;margin-right:5px;border-radius:50%;width:8px;height:8px;background-color:#ff5722}
    .users_message .item-subtitle{display:none}
    .users_message .item-text{margin-top: 15px;height: auto;max-height: inherit;display: block;-webkit-line-clamp: inherit;text-overflow: inherit;-webkit-box-orient: inherit;}
    .users_message .list-block li.noview .item-title em{display:inline-block}
    .users_message .list-block li.noview .item-subtitle{display:block}
    .users_message .list-block li.noview .item-text{display:none}
    .users_message_subnavbar{margin-top:-1px;padding:0}
    .users_message_subnavbar .buttons-row{height:100%;position:relative}
    .users_message_subnavbar .buttons-row .button{margin-left:0;height:48px;line-height:48px;border-radius:inherit}
    .users_message_subnavbar .buttons-row span{position:absolute;left:0;bottom:0;height:2px;width:33.33%;background:rgba(255,255,255,.5);-webkit-transition-duration:.3s;transition-duration:.3s}
</style>

<style>
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
        },
        /**
         * 获取类型
         */
        dataType: function(datatype) {
            if (datatype === '已阅读') {
                datatype = '1';
            }else if (datatype === '未阅读') {
                datatype = '2';
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
            tthis.parent().find("span").css('left', (parseInt(tthis.attr("data-index")) * 33.33) + '%');
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
                url: 'https://api.gengdian.net/v2/users/message_lists',
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
                        var lists = res.data.lists, intemp = '';
                        for (var i = 0; i < lists.length; i++) {
                            var item = lists[i];
                            intemp += '<li class="item-content' + (item['viewdate'] ? '' : ' noview') + '" data-id="' + item['id'] + '" onclick="$JS.view(this);"> ' +
                                '<div class="item-inner"> ' +
                                '<div class="item-title-row"> ' +
                                '<div class="item-title">' + (item['viewdate'] ? '' : '<em></em>') + '' + item['title'] + '</div> ' +
                                '<div class="item-after">' + $JS.dateYear(item['indate']) + '</div> ' +
                                '</div> ' +
                                '<div class="item-subtitle">' + item['subtitle'] + '</div> ' +
                                '<div class="item-text">' + item['content'] + '</div> ' +
                                '</div> ' +
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
         * 点击查看
         */
        view: function(obj){
            var tthis = $A.$(obj);
            if (tthis.hasClass("noview")) {
                tthis.removeClass("noview");
                tthis.find(".item-subtitle").hide();
                tthis.find(".item-title em").hide();
                tthis.find(".item-text").show();
                //
                $A.ajax({
                    url: 'https://api.gengdian.net/v2/push/message_read',
                    data: {
                        id: tthis.attr("data-id")
                    },
                    dataType: 'json',
                    timeout: 5000
                });
            }

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