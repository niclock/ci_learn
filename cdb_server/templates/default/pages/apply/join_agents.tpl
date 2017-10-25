{#*代理商合作*#}

{#user_check()#}


<div class="users_joindealer">
    <div class="content-block-title">代理商合作</div>
    <form class="list-block inputs-list">
        <ul>
            <li>
                <div class="item-content">
                    <div class="item-inner">
                        <div class="item-title label">姓名<span class="color-red">*</span></div>
                        <div class="item-input">
                            <input type="text" id="fullname" placeholder="" value=""/>
                        </div>
                    </div>
                </div>
            </li>
            <li>
                <div class="item-content">
                    <div class="item-inner">
                        <div class="item-title label">联系电话<span class="color-red">*</span></div>
                        <div class="item-input">
                            <input type="tel" id="userphone" placeholder="" value=""/>
                        </div>
                    </div>
                </div>
            </li>
            <li>
                <div class="item-content">
                    <div class="item-inner">
                        <div class="item-title label">微信号<span class="color-red">*</span></div>
                        <div class="item-input">
                            <input type="text" id="weixin" placeholder="" value=""/>
                        </div>
                    </div>
                </div>
            </li>
            <li>
                <div class="item-content">
                    <div class="item-inner">
                        <div class="item-title label">城市/区域<span class="color-red">*</span></div>
                        <div class="item-input">
                            <input type="text" id="area" placeholder="" value=""/>
                        </div>
                    </div>
                </div>
            </li>
            <li>
                <div class="item-content">
                    <div class="item-inner">
                        <div class="item-title label">资源优势<span class="color-red">*</span></div>
                        <div class="item-input">
                            <input type="text" id="advantage" placeholder="" value=""/>
                        </div>
                    </div>
                </div>
            </li>
        </ul>
        <div class="joinbutton">
            <a href="#" class="button button-fill button-big" onclick="$JS.submit()">提交申请</a>
        </div>
    </form>
</div>



<style>
    .users_joindealer .content-block-title { color:#333333;text-align:center;font-size:16px;margin-bottom:20px; }
    .users_joindealer .joinbutton { margin: 20px 16px; }
    .users_joindealer .item-title span.color-red {font-size:20px;display:inline-block;height:20px;margin-top:-3px;margin-left:3px;vertical-align:top;}
</style>
<script>
    $JS = {
        refresh: false,
        /**
         * 提交
         */
        submit: function() {
            var fullname = $JS.$el.find('#fullname').val(),
                userphone = $JS.$el.find('#userphone').val(),
                weixin = $JS.$el.find('#weixin').val(),
                area = $JS.$el.find('#area').val(),
                advantage = $JS.$el.find('#advantage').val();
            //
            if (fullname === '') {
                $A.toast('请输入姓名！'); return;
            }
            if (userphone === '') {
                $A.toast('请输入联系电话！'); return;
            }
            if (weixin === '') {
                $A.toast('请输入微信号码！'); return;
            }
            if (area === '') {
                $A.toast('请输入城市区域！'); return;
            }
            if (advantage === '') {
                $A.toast('请输入资源优质！'); return;
            }
            $A.ajax({
                url: 'https://api.gengdian.net/v2/other/user_joinagents',
                data: {
                    fullname: fullname,
                    userphone: userphone,
                    weixin: weixin,
                    area: area,
                    advantage: advantage
                },
                dataType: 'json',
                timeout: 10000,
                beforeSend: true,
                complete: true,
                error: true,
                success: function(res) {
                    if (res.ret === -1) {
                        //未登录
                        $A.toast(res.msg);
                        $A.login();
                        return;
                    }
                    if (res.ret === 1) {
                        $A.alert(res.msg, '提交成功', function(){
                            $A.routerBack({popup: "#" + $JS.$id});
                        });
                        return;
                    }
                    $A.alert(res.msg, '提交失败');
                }
            });
        }
    };
</script>