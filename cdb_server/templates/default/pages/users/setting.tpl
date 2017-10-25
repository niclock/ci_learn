{#*用户设置*#}

{#user_check()#}

<div class="users_setting">
    <div class="list-block">
        <ul>
            <li onclick="$A.routerPopup({title:'账号资料', url: 'pages/users/personal/'});">
                <a href="#" class="item-link item-content">
                    <div class="item-inner">
                        <div class="item-title">账号资料</div>
                    </div>
                </a>
            </li>
        </ul>
    </div>
    <div class="list-block">
        <ul>
            <li onclick="$A.routerPopup({title:'关于我们', url: 'pages/about/index/'});">
                <a href="#" class="item-link item-content">
                    <div class="item-inner">
                        <div class="item-title">关于我们</div>
                    </div>
                </a>
            </li>
            <li onclick="$A.routerPopup({title:'用户协议', url: 'pages/about/server/'});">
                <a href="#" class="item-link item-content">
                    <div class="item-inner">
                        <div class="item-title">用户协议</div>
                    </div>
                </a>
            </li>
            <li onclick="$A.routerPopup({title:'押金说明', url: 'pages/about/deposit_explain/'});">
                <a href="#" class="item-link item-content">
                    <div class="item-inner">
                        <div class="item-title">押金说明</div>
                    </div>
                </a>
            </li>
            <li onclick="$A.routerPopup({title:'充值协议', url: 'pages/about/recharge_agreement/'});">
                <a href="#" class="item-link item-content">
                    <div class="item-inner">
                        <div class="item-title">充值协议</div>
                    </div>
                </a>
            </li>
        </ul>
    </div>

    <div id="versionBox" style="display:none;" class="list-block">
        <ul>
            <li>
                <a href="#" onclick="$JS.version();" class="item-link item-content">
                    <div class="item-inner">
                        <div class="item-title">当前版本</div>
                        <div class="item-after" id="version"></div>
                    </div>
                </a>
            </li>
        </ul>
    </div>
</div>


<div class="content-block">
    <a href="#" id="uswitch" class="button button-big button-fill" onclick="$JS.uswitch();" style="margin-bottom:15px;display:none;">切换账号</a>
    <a href="#" class="button button-big button-fill" onclick="$JS.out();">退出登录</a>
</div>

<!--suppress CssUnusedSymbol -->
<style>
    .users_setting .list-block li{background-color:#ffffff;}
    .switch_dealer{display:inline-block;background:#4cd964;padding:0 5px;font-size:12px;color:#ffffff;height:20px;line-height:20px;margin-top:-2px;margin-left:5px;vertical-align:middle;border-radius:3px;}
    .switch_giconcheck{float:right;color:#555;font-size:22px;}
</style>

<script>
    $JS = {
        userList: [],
        created: function() {
            $A.apiReady(function(){
                if (api.systemType === 'android') {
                    $JS.$el.find("#version").text(api.appVersion + " (" + $A.version + ")");
                    $JS.$el.find("#versionBox").show();
                }
            }, null, true);
            //
            $A.ajax({
                url: 'https://api.gengdian.net/v2/users/ally',
                dataType: 'json',
                timeout: 10000,
                beforeSend: true,
                complete: true,
                error: true,
                success: function(res) {
                    if (res.ret === 1) {
                        if (res.data.length > 1) {
                            $JS.$el.find("#uswitch").show();
                            $JS.userList = res.data;
                        }
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
         * 更新版本
         */
        version: function() {
           $A.toast("当前已经是最新版本！");
        },
        /**
         * 切换账号
         */
        uswitch: function() {
            var buttons = [];
            buttons.push({
                text: '切换账号',
                label: true
            });
            for (var i = 0; i < $JS.userList.length; i++) {
                var item = $JS.userList[i];
                buttons.push({
                    text: (item['id']==$A.user.id?'<i class="Gicons gicon-check switch_giconcheck"></i>':'') + item['username'] + ' (ID:' + item['id'] + ')' + (item['isdealer']?'<span class="switch_dealer">商家</span>':''),
                    userid: item['id']==$A.user.id?0:item['id']
                });
            }
            $A.actions(buttons, function(index){
                if (typeof buttons[index] !== 'undefined' && buttons[index]['userid']) {
                    var userid = buttons[index]['userid'];
                    if ($A.runNum(userid) === 0) return;
                    $A.ajax({
                        url: 'https://api.gengdian.net/v2/users/toggle',
                        data: {
                            userid: userid
                        },
                        dataType: 'json',
                        timeout: 10000,
                        beforeSend: true,
                        complete: true,
                        error: true,
                        success: function(res) {
                            if (res.ret === 1) {
                                $A.toast(res.msg);
                                $A.user = res.data;
                                $A.storage('userInfo', $A.user);
                                $A.$changeTheme();
                                $A.$theme();
                                $A.outAfter();
                                $A.loginAfter();
                                $JS.pullToRefreshTrigger();
                            }else{
                                $A.alert(res.msg, '提醒', function(){
                                    if (res.ret === -1) {
                                        $A.login(function(){ $JS.pullToRefreshTrigger(); });
                                    }
                                });
                            }
                        }
                    });
                }
            });
        },
        /**
         * 退出
         */
        out: function() {
            $A.confirm('确定要退出吗?', '提示',
                function () {
                    $A.out(function(){
                        $A.routerBack({name: 'users'});
                    });
                }
            );
        }
    };
</script>