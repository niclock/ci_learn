{#*核销卡券*#}

{#$sale = user_sale_info(substr($_GPC['sn'], 2))#}
{#if !$sale#}
    {#page_tis('核销兑换', '提醒：兑换编码不正确或不在可使用状态！')#}
{#/if#}
{#if !in_array($_A['user']['id'], $sale['cancel_ids'])#}
    {#page_tis('核销兑换', '提醒：身份权限不足！')#}
{#/if#}
<div class="content-block">
    <div class="page-giveback-box">
        <p>兑换编码：<em>{#four_format($sale['exchangesn'])#}</em></p>
        <p>兑换名称：<em>{#$sale['title']#}</em></p>
        <p>兑换会员：<em>{#$sale['userinfo']['username']#}</em></p>
        <p>手机号码：<em>{#card_format($sale['userinfo']['userphone'])#}</em></p>
        <p>优惠方式：<em>{#$sale['sale_mode']#}</em></p>
        <p>有效期限：<em>{#date("Y-m-d H:i:s", $sale['enddate'])#}</em></p>
    </div>
</div>
<div class="content-block page-giveback-btn">
    <a href="#" onclick="$JS.use();" class="button-fill button-big button">确定兑换</a>
</div>
<script>
    $JS = {
        title: '核销兑换',
        use: function() {
            $A.confirm('确定编码：<span class="color-red"> {#four_format($sale['exchangesn'])#} </span>', '确定兑换', function(){
                $A.ajax({
                    url: 'https://api.gengdian.net/v2/users/used_sale',
                    data: {
                        idB: '{#$sale['idB']#}'       //会员优惠券ID
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