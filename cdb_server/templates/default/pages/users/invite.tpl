{#*邀请好友*#}

{#user_check()#}

{#$share = setting('share')#}
<div class="users_invite">
    <div class="invite-head">
        <div class="invite-logo">
            <img src="{#$IMG_PATH#}logo.png">
        </div>
        <div class="invite-title" style="padding-bottom:30px;">邀请好友，一起共享电源</div>
        {#*<div class="invite-subtitle">邀请好友成功注册，您们都能获得相应免费{#sale_name()#}！</div>*#}
        {#*<div class="invite-rule" onclick="$A.routerLoad({popup: '#pages-users-invite-rule'});">详情查看《邀请好友规则》</div>*#}
    </div>
    <div class="invite-content">
        <div class="invite-tis">马上分享到</div>
        <div class="invite-btns clearfix">
            <div class="invite-btn" onclick="$JS.share('wx')">
                <div class="invite-wx" style="background-image:url({#$IMG_PATH#}wx.png)"></div>
                微信好友
            </div><div id="qq" class="invite-btn" onclick="$JS.share('qq')">
                <div class="invite-qq" style="background-image:url({#$IMG_PATH#}qq.png)"></div>
                QQ好友
            </div><div class="invite-btn" onclick="$JS.share('wxb')">
                <div class="invite-wxb" style="background-image:url({#$IMG_PATH#}wxb.png)"></div>
                朋友圈
            </div><div id="wb" class="invite-btn" onclick="$JS.share('wb')">
                <div class="invite-wb" style="background-image:url({#$IMG_PATH#}wb.png)"></div>
                新浪微博
            </div><div id="qqb" class="invite-btn" onclick="$JS.share('qqb')">
                <div class="invite-qqb" style="background-image:url({#$IMG_PATH#}qqb.png)"></div>
                QQ空间
            </div>
        </div>
    </div>
</div>

<!-- 邀请好友规则 Popup -->
<div class="popup popup-up" id="pages-users-invite-rule">
    <div class="view navbar-fixed">
        <div class="pages">
            <div class="page">
                <div class="navbar">
                    <div class="navbar-inner">
                        <div class="left">
                            <a href="javascript:void(0)" onclick="$A.routerBack({popup:'#pages-users-invite-rule'})" class="link"><i class="icon material-icons">close</i></a>
                        </div>
                        <div class="center">邀请好友规则</div>
                    </div>
                </div>
                <div class="page-content rule-content">
                    {#$share['rule']#}
                </div>
            </div>
        </div>
    </div>
</div>


<style>
    .invite-head{width:100%;text-align:center}
    .invite-logo{width:90px;height:90px;margin:0 auto;padding:42px 0 33px}
    .invite-logo img{width:100%;height:100%}
    .invite-title{font-size:17px;color:#fff;padding-bottom:5px}
    .invite-subtitle{font-size:14px;color:#fff;padding-bottom:10px}
    .invite-rule{font-size:14px;color:#fff;padding-bottom:30px;text-decoration:underline}
    .invite-content{padding-top:30px;text-align:center}
    .invite-tis{width:80%;height:50px;line-height:50px;margin:0 auto;border-bottom:1px solid #e8e8e8}
    .invite-btns{margin:20px 10px}
    .invite-btn{display:inline-block;width:20%}
    .invite-btn>div{width:100%;height:38px;margin:0 auto 12px;background-position:center;background-repeat:no-repeat;background-size:contain}
    .rule-content{padding:16px}
    .rule-content img{max-width:100%;max-height:100%}
</style>

<script>
    $JS = {
        created: function() {
            $JS.$el.find(".navbar").eq(0).css("box-shadow", "none");
            $JS.$el.find(".invite-head").addClass("bg-" + $A.$theme());
            //
            if ($A.version < 10510) {
                $JS.$el.find("#qq").hide();
                $JS.$el.find("#qqb").hide();
                $JS.$el.find("#wb").hide();
                $JS.$el.find("div.invite-btn").css("width", "30%");
            }else if ($A.version < 10516) {
                $JS.$el.find("#wb").hide();
                $JS.$el.find("div.invite-btn").css("width", "25%");
            }
            $A.apiReady(function(){
                api.download({
                    url: '{#fillurl($share['thumb'])#}',
                    report: true,
                    cache: true,
                    allowResume: true
                }, function(ret, err) {
                    if (ret.state === 1) {
                        $JS.share_thumb = ret.savePath;
                    }else{
                        $JS.share_thumb = false;
                    }
                });
            }, null, true);
        },
        share: function(type) {
            if (typeof api === 'undefined') {
                $A.toast("当前版本不支持此功能！");
                return;
            }
            switch (type) {
                case 'wx':
                    $JS.sharewx('session');
                    break;
                case 'wxb':
                    $JS.sharewx('timeline');
                    break;
                case 'qq':
                    $JS.shareqq('QFriend');
                    break;
                case 'qqb':
                    $JS.shareqq('QZone');
                    break;
                case 'wb':
                    $JS.sharewb();
                    break;
            }
        },
        sharewb: function() {
            if (typeof $JS.share_thumb === 'undefined') {
                $A.toast("分享组件正在加载，请3秒后重试...");
                return;
            }
            if ($JS.share_thumb === false) {
                $A.toast("分享组件加载失败，请稍后再试！");
                return;
            }
            var weibo = api.require('weibo');
            weibo.isInstalled(function(ret) {
                if (!ret.status) {
                    $A.toast("请先安装新浪微博客户端！");
                    return;
                }
                $A.showIndicator(2000);
                weibo.shareWebPage({
                    apiKey: '{#$share['wb_appkey']#}',
                    text: '{#$share['wb_desc']#}',
                    title: '{#$share['title']#}',
                    description: '{#$share['desc']#}',
                    thumb: $JS.share_thumb,
                    contentUrl: 'https://api.gengdian.net/#/invite?id={#$_A['user']['id']#}'
                }, function(ret, err) {
                    if (ret.status){
                        $JS.sharewb_err(0);
                    }else{
                        $JS.sharewb_err(err.code);
                    }
                });
            });
        },
        shareqq: function(stype) {
            var qq = api.require('QQPlus');
            qq.installed(function(ret, err) {
                if (!ret.status) {
                    $A.toast("请先安装QQ客户端！");
                    return;
                }
                $A.showIndicator(2000);
                qq.shareNews({
                    type:           stype,
                    url:            'https://api.gengdian.net/#/invite?id={#$_A['user']['id']#}',
                    title:          '{#$share['title']#}',
                    description:    '{#$share['desc']#}',
                    imgUrl:         '{#fillurl($share['thumb'])#}'
                },function(rel, err){
                    if (!rel.status && rel.msg) {
                        $A.toast(rel.msg);
                    }
                });
            });
        },
        sharewx: function(scene) {
            if (typeof $JS.share_thumb === 'undefined') {
                $A.toast("分享组件正在加载，请3秒后重试...");
                return;
            }
            if ($JS.share_thumb === false) {
                $A.toast("分享组件加载失败，请稍后再试！");
                return;
            }
            var wx = api.require('wx');
            wx.isInstalled(function(ret, err) {
                if (!ret.installed) {
                    $A.toast("请先安装微信客户端！");
                    return;
                }
                $A.showIndicator(2000);
                wx.shareWebpage({
                    scene:          scene,
                    thumb:          $JS.share_thumb,
                    contentUrl:     'https://api.gengdian.net/#/invite?id={#$_A['user']['id']#}',
                    apiKey:         '{#$share['wx_appid']#}',
                    title:          '{#$share['title']#}',
                    description:    '{#$share['desc']#}'
                }, function(ret, err){
                    if (ret.status){
                        $JS.sharewx_err(0);
                    }else{
                        $JS.sharewx_err(err.code);
                    }
                });
            });
        },
        sharewb_err: function(code) {
            var text = '分享失败';
            switch(code) {
                case 0:
                    text = '分享成功';
                    break;
                case 1:
                    text = '分享取消';
                    break;
                case 2:
                    text = '发送失败';
                    break;
                case 3:
                    text = '授权失败';
                    break;
                case 4:
                    text = '不支持的请求';
                    break;
            }
            $A.toast(text);
        },
        sharewx_err: function(code) {
            var text = '未知错误';
            switch(code) {
                case 0:
                    text = '分享成功';
                    break;
                case 2:
                    text = '分享取消';
                    break;
                case 3:
                    text = '发送失败';
                    break;
                case 4:
                    text = '授权拒绝';
                    break;
                case 5:
                    text = '微信服务器返回的不支持错误';
                    break;
                case 6:
                    text = '当前设备未安装微信客户端';
                    break;
                case 7:
                    text = '注册SDK失败';
                    break;
            }
            $A.toast(text);
        }
    };
</script>