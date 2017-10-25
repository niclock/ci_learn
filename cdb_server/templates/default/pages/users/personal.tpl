{#*个人信息*#}

{#user_check()#}

<div class="users_personal">
    <div class="list-block">
        <ul>
            <li onclick="$JS.userimg()">
                <a href="#" class="item-link item-content">
                    <div class="item-inner">
                        <div class="item-title">头像</div>
                        <div class="item-after userimg"></div>
                    </div>
                </a>
            </li>
            <li onclick="$JS.username()">
                <a href="#" class="item-link item-content">
                    <div class="item-inner">
                        <div class="item-title">昵称</div>
                        <div class="item-after username"></div>
                    </div>
                </a>
            </li>
            <li onclick="$JS.userphone()">
                <a href="#" class="item-link item-content">
                    <div class="item-inner">
                        <div class="item-title">手机号码</div>
                        <div class="item-after userphone"></div>
                    </div>
                </a>
            </li>
        </ul>
    </div>
    <div class="list-block">
        <ul>
            <li onclick="$JS.zhima()">
                <a href="#" class="item-link item-content">
                    <div class="item-inner">
                        <div class="item-title">芝麻信用</div>
                        <div class="item-after" id="zhima_text"></div>
                    </div>
                </a>
            </li>
        </ul>
    </div>
</div>

<!-- 芝麻信用 Popup -->
<div class="popup popup-up" id="pages-users-personal-zhima">
    <div class="view navbar-fixed">
        <div class="pages">
            <div class="page">
                <div class="navbar">
                    <div class="navbar-inner">
                        <div class="left">
                            <a href="javascript:void(0)" onclick="$A.routerBack({popup:'#pages-users-personal-zhima'})" class="link"><i class="icon material-icons">close</i></a>
                        </div>
                        <div class="center">芝麻信用认证</div>
                    </div>
                </div>
                <div class="page-content page-zhima-box">
                    <form class="list-block">
                        <img src="{#$TEM_PATH#}assets/images/zhima_logo.png" class="zhima-logo">
                        <ul>
                            <li>
                                <div class="item-content">
                                    <div class="item-inner">
                                        <div class="item-title label">证件类型</div>
                                        <div class="item-input">
                                            <select id="zhima_cert_type">
                                                <option value="IDENTITY_CARD">身份证</option>
                                                <option value="PASSPORT">护照</option>
                                            </select>
                                        </div>
                                    </div>
                                </div>
                            </li>
                            <li>
                                <div class="item-content">
                                    <div class="item-inner">
                                        <div class="item-title label">证件号码</div>
                                        <div class="item-input">
                                            <input type="text" placeholder="请输入证件号码" id="zhima_cert_no">
                                        </div>
                                    </div>
                                </div>
                            </li>
                            <li>
                                <div class="item-content">
                                    <div class="item-inner">
                                        <div class="item-title label">真实姓名</div>
                                        <div class="item-input">
                                            <input type="text" placeholder="请输入真是姓名" id="zhima_realname">
                                        </div>
                                    </div>
                                </div>
                            </li>
                        </ul>
                        <div class="content-block-title">芝麻信用 <u>≥590分</u> 可享免押金借用</div>
                    </form>
                    <div class="content-block">
                        <a href="#" onclick="$JS.zhimaAuthenticate()" class="button-fill button-big button">提&nbsp;交</a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- 修改用户名 Popup -->
<div class="popup popup-up" id="pages-users-personal-username">
    <div class="view navbar-fixed">
        <div class="pages">
            <div class="page">
                <div class="navbar">
                    <div class="navbar-inner">
                        <div class="left">
                            <a href="javascript:void(0)" onclick="$A.routerBack({popup:'#pages-users-personal-username'})" class="link"><i class="icon material-icons">close</i></a>
                        </div>
                        <div class="center">昵称</div>
                    </div>
                </div>
                <div class="page-content page-standard-box">
                    <form class="list-block">
                        <ul>
                            <li>
                                <div class="item-content">
                                    <div class="item-inner">
                                        <div class="item-input item-input-field">
                                            <input type="text" id="usernameedit" placeholder="请输入昵称">
                                        </div>
                                    </div>
                                </div>
                            </li>
                        </ul>
                    </form>
                    <div class="content-block">
                        <a href="#" onclick="$JS.username(true)" class="button-fill button-big button">保&nbsp;&nbsp;存</a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- 修改手机号码 Popup -->
<div class="popup popup-up" id="pages-users-personal-userphone">
    <div class="view navbar-fixed">
        <div class="pages">
            <div class="page">
                <div class="navbar">
                    <div class="navbar-inner">
                        <div class="left">
                            <a href="javascript:void(0)" onclick="$A.routerBack({popup:'#pages-users-personal-userphone'})" class="link"><i class="icon material-icons">close</i></a>
                        </div>
                        <div class="center">手机号码</div>
                    </div>
                </div>
                <div class="page-content page-standard-box">
                    <form class="list-block" style="margin-top:25px;">
                        <div class="content-block-title">验证旧手机号码</div>
                        <div class="content-block-subtitle" onclick="$JS.lose();">手机号码已丢失？</div>
                        <ul id="oldphone">
                            <li>
                                <div class="item-content">
                                    <div class="item-inner">
                                        <div class="item-title label">旧手机号码</div>
                                        <div class="item-input item-input-field">
                                            <input type="tel" class="phoneval" disabled="disabled">
                                        </div>
                                    </div>
                                </div>
                            </li>
                            <li>
                                <div class="item-content">
                                    <div class="item-inner">
                                        <div class="item-title label">验证码</div>
                                        <div class="item-input item-input-field">
                                            <input type="tel" class="codeval" id="oldcode">
                                            <a href="#" onclick="$JS.getSms()" class="getCode button button-fill">获取验证码</a>
                                        </div>
                                    </div>
                                </div>
                            </li>
                        </ul>
                        <div class="content-block-title">新的手机号码</div>
                        <ul id="newphone">
                            <li>
                                <div class="item-content">
                                    <div class="item-inner">
                                        <div class="item-title label">新的手机号码</div>
                                        <div class="item-input item-input-field">
                                            <input type="tel" class="phoneval" id="newuserphone">
                                        </div>
                                    </div>
                                </div>
                            </li>
                            <li>
                                <div class="item-content">
                                    <div class="item-inner">
                                        <div class="item-title label">验证码</div>
                                        <div class="item-input item-input-field">
                                            <input type="tel" class="codeval" id="newcode">
                                            <a href="#" onclick="$JS.getSms(true)" class="getCode button button-fill">获取验证码</a>
                                        </div>
                                    </div>
                                </div>
                            </li>
                        </ul>
                    </form>
                    <div class="content-block">
                        <a href="#" onclick="$JS.userphone(true)" class="button-fill button-big button">保&nbsp;&nbsp;存</a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<style>
    .page-zhima-box .zhima-logo {width:50%;max-width:500px;display:block;margin:0 auto 30px;}
    .page-zhima-box .content-block-title {text-align:right}
    .users_personal .list-block li{background-color:#ffffff;}
    .users_personal .list-block .userimg{max-height:inherit;}
    .users_personal .list-block .userimg img{width:72px;height:72px;margin:5px 0;border-radius:50%;}
    #pages-users-personal-userphone .content-block-title{text-align:center;color:#333;font-size:18px;}
    #pages-users-personal-userphone .content-block-subtitle{text-align:center;color:#99691b;margin-top:-10px;margin-bottom:10px;font-size:14px;}
    #pages-users-personal-userphone .getCode{position:absolute;top:0;right:0;height:30px;line-height:30px;}
</style>
<script>
    $JS = {
        /**
         * 页面创建完毕执行
         */
        created: function() {
            $A.ajax({
                url: 'https://api.gengdian.net/v2/users/otherinfo',
                data: {
                    act: 'userinfo'
                },
                dataType: 'json',
                beforeSend: true,
                complete: true,
                error: function() {
                    $A.alert("数据加载失败...", '提醒', function(){
                        $A.routerBack(-1);
                    });
                },
                success: function(res) {
                    if (res.ret === 1) {
                        $A.user = res.data.userinfo;
                        $JS.$el.find(".userimg").html('<img src="' + $A.user.userimg + '">');
                        $JS.$el.find(".username").text($A.user.username);
                        $JS.$el.find(".userphone").text($JS.phoneFormat($A.user.userphone) + ($A.isPhone_sub($A.user.userphone)?' (特殊)':''));
                    }else {
                        $A.alert(res.msg, '提醒', function(){
                            $A.routerBack(-1);
                        });
                    }
                }
            });
            //
            $A.ajax({
                url: 'https://api.gengdian.net/v2/credit/zhima/admittance',
                dataType: 'json',
                timeout: 10000,
                success: function(res) {
                    if (res.ret === -2) {
                        $JS.$el.find("#zhima_text").text("未认证");
                    }else if (res.ret === 1) {
                        $JS.$el.find("#zhima_text").text("已认证");
                    }else{
                        $JS.$el.find("#zhima_text").text("未通过认证");
                    }
                }
            });
        },
        /**
         * 点击芝麻信用
         */
        zhima: function() {
            var text = $JS.$el.find("#zhima_text").text();
            if (text != '未认证') {
                api.confirm({
                    title: '芝麻信用',
                    msg: "您的芝麻信用【" + text + "】，是否重新认证？",
                    buttons: ['重新认证', '关闭提示']
                }, function(ret, err) {
                    if (ret.buttonIndex == 1) {
                        $A.routerLoad({popup: '#pages-users-personal-zhima'});
                    }
                });
            }else{
                $A.routerLoad({popup: '#pages-users-personal-zhima'});
            }
        },
        /**
         * 芝麻信用认证
         */
        zhimaAuthenticate: function() {
            $A.ajax({
                url: 'https://api.gengdian.net/v2/credit/zhima/authenticate',
                data: {
                    cert_type: $A.$("#pages-users-personal-zhima").find("#zhima_cert_type").val(),
                    cert_no: $A.$("#pages-users-personal-zhima").find("#zhima_cert_no").val(),
                    realname: $A.$("#pages-users-personal-zhima").find("#zhima_realname").val()
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
                        $A.alert('恭喜您认证成功。', '认证成功', function() {
                            $JS.$el.find("#zhima_text").text("已认证");
                            $A.routerBack({popup:'#pages-users-personal-zhima'});
                        });
                    }else{
                        $A.alert(res.msg, '温馨提示');
                    }
                }
            });
        },
        /**
         * 手机号码丢失
         */
        lose: function() {

        },
        /**
         * 设置头像
         */
        userimg: function() {
            $A.mediaScanner({
                num: 1,
                callback: function(res) {
                    if (res) {
                        var imageClip = function(path) {
                            $A.imageClip({
                                title: '设置头像',
                                srcPath: path,
                                style: {
                                    clip: {
                                        w: api.winWidth / 1.8,
                                        h: api.winWidth / 1.8,
                                        borderColor: '#ff5722',
                                        borderWidth: 1,
                                        appearance: 'rectangle'
                                    }
                                },
                                quality: 0.8,
                                mode: 'image',
                                success: function(ret) {
                                    $A.showIndicator();
                                    api.ajax({
                                        url: 'https://api.gengdian.net/v2/users/edit/avatar',
                                        data: {
                                            values: {
                                                '__browser_sn': $A.sn()
                                            },
                                            files: {
                                                image: ret.destPath
                                            }
                                        },
                                        method: "post",
                                        dataType: "json",
                                        timeout: 30
                                    }, function(res) {
                                        $A.hideIndicator();
                                        if (ret) {
                                            if (res.ret === 1) {
                                                $A.toast("修改成功");
                                                $A.user.userimg = res.data.url;
                                                $A.storage('userInfo', $A.user);
                                                $JS.$el.find(".userimg img").attr("src", $A.user.userimg);
                                            }else{
                                                $A.toast(res.msg);
                                            }
                                        } else {
                                            $A.toast("网络繁忙，请稍后再试！");
                                        }
                                    });
                                },
                                error: function() {
                                    $A.toast("设置头像失败！");
                                }
                            });
                        };
                        if ($A.leftexists(res[0].path, "/")) {
                            imageClip(res[0].path);
                        }else{
                            var UIMediaScanner = api.require('UIMediaScanner');
                            UIMediaScanner.transPath({
                                path: res[0].path
                            }, function(ret, err) {
                                if (ret) {
                                    imageClip(ret.path);
                                } else {
                                    $A.toast("设置头像失败！-1");
                                }
                            });
                        }
                    }
                }
            });
        },
        /**
         * 修改昵称
         * @param action
         */
        username: function(action) {
            var obj = $A.$("#pages-users-personal-username");
            if (action === true) {
                var username = obj.find("input#usernameedit").val();
                if (username === '') {
                    $A.toast("请输入有效的昵称！"); return;
                }
                $A.ajax({
                    url: 'https://api.gengdian.net/v2/users/edit/username',
                    dataType: 'json',
                    data: {
                        username: username
                    },
                    beforeSend: true,
                    complete: true,
                    error: true,
                    timeout: 60000,
                    success: function(res) {
                        if (res.ret === 1) {
                            $A.toast("修改成功");
                            $A.user.username = username;
                            $A.storage('userInfo', $A.user);
                            $JS.$el.find(".username").text($A.user.username);
                            $A.routerBack({popup:'#pages-users-personal-username'});
                        }else{
                            $A.toast(res.msg);
                        }
                    }
                });
            }else{
                obj.find("input#usernameedit").val($A.user.username);
                $A.routerLoad({popup: '#pages-users-personal-username'});
            }
        },
        /**
         * 修改手机号码
         * @param action
         */
        userphone: function(action) {
            if ($A.isPhone_sub($A.user.userphone)) {
                $A.toast("特殊号码请联系G电客服修改！");
                return;
            }
            var obj = $A.$("#pages-users-personal-userphone");
            if (action === true) {
                $A.ajax({
                    url: 'https://api.gengdian.net/v2/users/edit/userphone',
                    dataType: 'json',
                    data: {
                        oldcode: obj.find("#oldcode").val(),
                        newuserphone: obj.find("#newuserphone").val(),
                        newcode: obj.find("#newcode").val()
                    },
                    beforeSend: true,
                    complete: true,
                    error: true,
                    timeout: 60000,
                    success: function(res) {
                        if (res.ret === 1) {
                            $A.toast("修改成功");
                            $A.user.userphone = res.data.userphone;
                            $A.storage('userInfo', $A.user);
                            $JS.$el.find(".userphone").text($JS.phoneFormat($A.user.userphone));
                            $A.routerBack({popup:'#pages-users-personal-userphone'});
                        }else{
                            $A.toast(res.msg);
                        }
                    }
                });
            }else{
                obj.find(".codeval").val("");
                obj.find(".phoneval").val("");
                obj.find("#oldphone .phoneval").val($JS.phoneFormat($A.user.userphone));
                $A.routerLoad({popup: '#pages-users-personal-userphone'});
            }
        },
        /**
         * 获取短信验证码
         * @param action
         */
        getSms: function(action) {
            var obj = $A.$("#pages-users-personal-userphone").find("#oldphone");
            if (action === true) {
                obj = $A.$("#pages-users-personal-userphone").find("#newphone");
            }
            var codeObj = obj.find("a.getCode");
            if (codeObj.text() !== '获取验证码') return;
            var phone = $A.user.userphone;
            if (action === true) {
                phone = obj.find(".phoneval").val();
            }
            if (!$A.isPhone(phone)) {
                $A.toast("请输入正确的手机号码！");
                obj.find(".phoneval").focus();
                return;
            }
            $A.ajax({
                url: 'https://api.gengdian.net/v2/users/sms',
                data: {
                    userphone: phone
                },
                dataType: 'json',
                beforeSend: true,
                complete: true,
                error: true,
                success: function(res) {
                    if (res.msg === 1) {
                        var second = 60;
                        codeObj.text(second + '秒后重试');
                        var codeInter = setInterval(function(){
                            second--;
                            if (second <= 0) {
                                codeObj.text('获取验证码');
                                clearInterval(codeInter);
                            }else{
                                codeObj.text(second + '秒后重试');
                            }
                        }, 1000);
                        $A.toast("【手机尾号: " + res.data.last4 + "】<br/>" + res.msg, 8000);
                    }else{
                        $A.toast(res.msg);
                    }
                }
            });
        },
        /**
         * 加密手机号码
         * @param phone
         * @returns {*}
         */
        phoneFormat: function(phone) {
            if (!$A.isPhone(phone)) return phone;
            return phone.substr(0, 3) + "****" + phone.substr(-4)
        }
    };
</script>