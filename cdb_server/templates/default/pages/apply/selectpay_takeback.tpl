{#*商家收回设备*#}

{#$orderinfo = db_getone(table('order'), ['sn'=>$cdb['sn'], 'userid'=>$cdb['userid']], '`indate` DESC,`id` DESC')#}

{#if $cdb['userid'] == $_A['user']['id']#}
    {#page_tis('收回设备', '提醒：此设备已收回！')#}
{#/if#}
{#if $cdb['status'] != '使用中'#}
    {#page_tis('收回设备', '提醒：此设备不在使用状态无法收回！')#}
{#/if#}

<div class="content-block">
    <div class="page-giveback-box">

        <p>借用会员：<em>{#$cdb['userinfo']['username']#}</em></p>
        <p>借用设备：<em>{#$cdb['title']#}</em></p>
        <p class="color-red">设备编码：<em>{#$cdb['sn']#}</em></p>
        <p>借用日期：<em>{#date('Y-m-d H:i', $orderinfo['indate'])#}</em></p>

        <p>归还门店：<em>{#$_A['user']['username']#}</em></p>

        {#if $cdb['type'] == '雨伞'#}
            <p>借用押金：<em>免押金</em></p>
        {#else#}
            <p>借用押金：<em>{#$smarty.const.DEPOSIT#}元</em></p>
        {#/if#}

        <p>借用时长：<em>{#cdb_time_diff($orderinfo['indate'], SYS_TIME)#}</em></p>

        {#*<p>借用金额：<em>{#cdb_totalMoney($orderinfo['indate'], 0, 0, $cdb['type'])#}元</em></p>*#}

    </div>
    <div class="page-giveback-tis">请正确核对<span class="color-red"> 设备编号 </span>后确定收回</div>
</div>
<div class="content-block page-giveback-btn">
    <a href="#" onclick="$JS.giveBack();" class="button-fill button-big button">已核对，确定收回</a>
</div>

<style>
    .page-giveback-box{margin:5px;padding:20px;border-radius:8px;font-size:16px;background-color:#e4e4e4;}
    .page-giveback-box p{padding:5px 0;margin:0;color:#666;}
    .page-giveback-box p em{display:block;float:right;text-align:right;color:#333;}
    .page-giveback-box p.color-red {color: #ff5330;}
    .page-giveback-box p.color-red em {color:#ff0000;font-weight:600}
    .page-giveback-btn a{margin-bottom:15px;}
    .page-giveback-tis{margin-top:22px;margin-bottom:-10px;text-align:center;}
</style>

<script>
    $JS = {
        title: '收回设备',
        created: function() {
            $JS.$el.find(".navbar .right").html('<a href="#" onclick="$JS.pullToRefreshTrigger();" class="link"><i class="icon material-icons">refresh</i></a>');
        },
        giveBack: function() {
            $A.ajax({
                url: 'https://api.gengdian.net/v2/users/giveback',
                data: {
                    act: 'apply',
                    sn: '{#$cdb['sn']#}'       //设配编号
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
        }
    }
</script>