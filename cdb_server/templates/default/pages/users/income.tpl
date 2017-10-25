{#*我的收益*#}

<div class="users_income">
    <div class="income-head">
        <div class="income-tit">可提现（元）</div>
        <div class="income-text"><span id="income">...</span><button onclick="$JS.toCash();">收益提现<i class="icon material-icons">play_circle_outline</i></button></div>
        <div class="income-out">累计提现: <span id="income_out">...</span></div>
    </div>
    <div id="listsBox" class="list-block media-list"></div>
</div>
<style>
    .income-head{color:#fff;padding:10px 25px;font-size:18px;}
    .income-head .income-text{font-size:50px;color:#fff;padding-top:15px;border-bottom:1px solid #ffffff;position:relative;}
    .income-head .income-text button{font-size:20px;position:absolute;bottom:7px;right:0;color:#ffffff;border:0;padding-right:0;background-color:transparent;}
    .income-head .income-text button i{vertical-align:bottom;padding-bottom:2px;padding-left:3px;}
    .income-head .income-out{font-size:18px;color:#fff;padding-top:10px;padding-bottom:10px;}
    .users_income .list-block{margin-top:-1px}
    .users_income .list-block ul.no:before,.users_income .list-block ul.no:after{background-color:transparent}
    .users_income .list-block ul.no li{padding:50px 0;text-align:center}
    .users_income .item-title-row{margin:5px 0 8px}
    .users_income .item-subtitle em{color:#666}
    .users_income .item-text{margin-top:15px}
</style>
<script>
    $JS = {
        /**
         * 当前页、是否有下一页
         */
        nowPage: 0, nextPage: false,
        /**
         * 创建完毕执行
         */
        created: function() {
            $JS.$el.find(".navbar").eq(0).css("box-shadow", "none");
            $JS.$el.find(".income-head").addClass("bg-" + $A.$theme());
            //
            setTimeout(function(){ $JS.pullToRefreshTrigger(); }, 200);
            $JS.$el.find(".navbar .right").html('<a href="#" onclick="$JS.pullToRefreshTrigger();" class="link"><i class="icon material-icons">refresh</i></a><a href="#" onclick="$JS.filter();" class="link"><i class="icon material-icons">format_list_bulleted</i><span style="font-size:16px;padding-top:1px;">筛选</span></a>');
        },
        /**
         * 下拉刷新
         */
        refresh: function(isNext) {
            var listsBox = $JS.$el.find("#listsBox");
            if (isNext === true) {
                $JS.nowPage++
            }else{
                $JS.$el.find(".page-content").scrollTop(0);
                listsBox.html("");
                $JS.nowPage = 1;
            }
            //
            $A.ajax({
                url: 'https://api.gengdian.net/v2/users/income_lists',
                data: {
                    page: $JS.nowPage
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
                                '<div class="item-title">收入：' + (item['setup'] < 0 ? '-' : (item['setup'] > 0 ? '+' : '')) + ' ' + item['setup'] + '</div>' +
                                '<div class="item-after">' + $JS.dateYear(item['indate']) + '</div>' +
                                '</div>' +
                                '<div class="item-subtitle">' + item['title'] + '</div>';
                            if (item['masterid'] > 0) {
                                intemp += '<div class="item-subtitle">操作会员: ' + ['mastername'] + '</div>';
                            }
                            intemp += '</div></li>';
                        }
                        if (isNext === true) {
                            listsBox.find("ul").append(intemp);
                        }else{
                            if (intemp === '') {
                                intemp = '<ul class="no"><li>没有记录</li></ul>';
                            }else{
                                intemp = '<ul>' + intemp + '</ul>';
                            }
                            listsBox.html(intemp);
                        }
                        $JS.$el.find("#income").text(res.data.user_income);
                        $JS.$el.find("#income_out").text(res.data.user_income_out);
                        $JS.nextPage = res.data.hasMorePages;
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
            if ($JS.nextPage === true) {
                $JS.nextPage = false;
                $JS.refresh(true);
            }
            $JS.infiniteDone();
        },
        /**
         * 点击提现
         */
        toCash: function() {
            $A.toast("提现功能正在升级中，升级过程不影响收益<br/>如有疑问请致电G电客服：{#settingfind('system', 'tel_num')#}");
        },
        /**
         * 筛选
         */
        filter: function() {
            $A.toast("筛选功能正在升级中，升级过程不影响收益<br/>如有疑问请致电G电客服：{#settingfind('system', 'tel_num')#}");
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