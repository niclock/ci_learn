{#*商家认领设备*#}

{#$setting = setting('system')#}
<div class="content-block">
    <div class="page-giveback-box">
        <p>认领设备：<em>{#$cdb['title']#}</em></p>
        <p>设备编码：<em>{#$cdb['sn']#}</em></p>
    </div>
    <div class="page-giveback-tis">
        {#if $setting['claim_pass']#}
            正确核对<span class="color-red"> 设备编号 </span>后输入<span class="color-red"> 认领密码 </span>认领
        {#else#}
            正确核对<span class="color-red"> 设备编号 </span>后确定认领
        {#/if#}
    </div>
    {#if $setting['claim_pass']#}
        <div class="list-block">
            <ul>
                <li>
                    <div class="item-content">
                        <div class="item-inner">
                            <div class="item-input">
                                <input id="claimpass" type="password" placeholder="请输入认领密码">
                            </div>
                        </div>
                    </div>
                </li>
            </ul>
        </div>
    {#/if#}
</div>
<div class="content-block page-giveback-btn">
    <a href="#" onclick="$JS.claim();" class="button-fill button-big button">已核对，确定认领</a>
</div>

<style>
    .page-giveback-box{margin:5px;padding:20px;border-radius:8px;font-size:16px;background-color:#e4e4e4;}
    .page-giveback-box p{padding:5px 0;margin:0;color:#666;}
    .page-giveback-box p em{display:block;float:right;text-align:right;color:#333;}
    .page-giveback-btn a{margin-bottom:15px;}
    .page-giveback-tis{margin-top:22px;margin-bottom:-10px;text-align:center;}
</style>

<script>
    $JS = {
        title: '认领设备',
        claim: function() {
            $A.confirm('确定编号：<span class="color-red"> {#$cdb['sn']#} </span>', '确定认领', function(){
                $A.ajax({
                    url: 'https://api.gengdian.net/v2/users/claim',
                    data: {
                        sn: '{#$cdb['sn']#}',                          //设配编号
                        claimpass: $JS.$el.find("#claimpass").val()    //认领密码
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
                        $A.alert(res.msg, '温馨提示', function(){
                            if (res.ret === 1) {
                                $A.routerBack(-1);
                            }
                        });
                    }
                });
            });
        }
    }
</script>