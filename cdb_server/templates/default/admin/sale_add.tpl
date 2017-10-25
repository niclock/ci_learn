<!DOCTYPE html>
{#_head_html()#}
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=Edge,chrome=1" />
    <title>管理中心 - {#$_A['BASE_NAME']#}</title>
    <link href="{#$NOW_PATH#}css/public.css" rel="stylesheet" type="text/css">
    <style type="text/css">
        #codebox { cursor: pointer; }
        .checkbox label { padding-right: 5px; }
        .checkbox label input { margin-top: -3px; margin-right: 2px; }
        .labelbox80 label { display: inline-block; min-width: 110px; }
        .labelbox110 label { display: inline-block; min-width: 110px; margin: 2px auto; }
        .labelbox110 input.inpMain { height: 16px; line-height: 16px; padding: 1px 5px; }
    </style>
    <script type="text/javascript" src="{#$JS_PATH#}jquery.min.js"></script>
    <script type="text/javascript" src="{#$JS_PATH#}jquery.alert.js"></script>
    <script type="text/javascript" src="{#$JS_PATH#}jquery.form.min.js"></script>
    <script type="text/javascript" src="{#$JS_PATH#}My97DatePicker/WdatePicker.js"></script>
    <script type="text/javascript" src="{#$NOW_PATH#}js/global.js"></script>
    <script type="text/javascript" src="{#$NOW_PATH#}js/jquery.tab.js"></script>
    <script type="text/javascript">
        $(function(){
            $(".mainBox").css('min-height', $(window).height() - 195);
        });
    </script>
</head>
<body>
<div id="dcWrap">

    {#tpl('_top')#}
    <!-- dcHead 结束 -->
    {#tpl('_left', 'sale')#}

    <div id="dcMain">
        <!-- 当前位置 -->
        <div id="urHere">管理中心<b>&gt;</b><strong>{#sale_name()#}列表</strong> <b>&gt;</b><strong>{#$subtitle#}{#sale_name()#}</strong></div>
        <div id="index" class="mainBox" style="padding-top:18px;height:auto!important;min-height:550px;">

            <script type="text/javascript">
                $(function(){
                    var idTabs = $(".idTabs");
                    idTabs.idTabs();
                    idTabs.find(".tab li a[href='"+getcookie('__:idTabs:{#$_A['segments'][2]#}')+"']").click();
                    idTabs.find(".tab li a").click(function(){var href = $(this).attr("href"); if (href.substring(0,1) == "#"){ addCookie("__:idTabs:{#$_A['segments'][2]#}", href); }});
                });
            </script>
            <div class="idTabs">
                <ul class="tab">
                    <li><a href="#main">基本信息</a></li>
                    <li><a href="#where">条件限制</a></li>
                    <li><a href="#auto">自动获得</a></li>
                    <li><a href="{#url('admin/sale')#}">返回列表</a></li>
                </ul>
                <div class="items">
                    <form action="{#get_url()#}" method="post" id="saveform">
                        <div id="main" class="tabbody">
                            <table width="100%" border="0" cellpadding="8" cellspacing="0" class="tableBasic">
                                <tr>
                                    <td width="90" align="right">{#sale_name()#}名称</td>
                                    <td>
                                        <input type="text" name="title" value="{#$sale['title']#}" size="60" class="inpMain" />
                                    </td>
                                </tr>
                                <tr>
                                    <td align="right">兑换码</td>
                                    <td>
                                        <input type="text" name="code" value="{#$sale['code']#}" size="60" class="inpMain" placeholder="留空自动生成" onkeyup="codekeyup(this)"/>
                                        <span class="cue">客户输入的兑换码得到{#sale_name()#}</span>
                                        <div class="cue" id="cuecode" style="margin:5px 2px 0;{#if !$sale['code']#}display:none;{#/if#}">
                                            领取方式：打开APP >> 左上角菜单 >> 我的优惠 >> 使用兑换码领取
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td align="right">类型①<br/>抵租用现金</td>
                                    <td>
                                        <table width="100%" border="0" cellpadding="8" cellspacing="0" class="tableBasic tableAuto">
                                            <tr>
                                                <td width="70" align="right">优惠方式</td>
                                                <td class="checkbox" style="line-height:30px;">
                                                    <label><input type="radio" name="sale_type" {#che($sale['sale_type'], 'T')#}>租用时长</label>
                                                    <label><input type="radio" name="sale_type" {#che($sale['sale_type'], 'P')#}>百分比</label>
                                                    <label><input type="radio" name="sale_type" {#che($sale['sale_type'], 'F')#}>固定金额</label>，
                                                    <input type="text" name="sale" value="{#floatval($sale['sale'])#}" size="8" class="inpMain" />
                                                    <span class="cue">小时、百分比、固定金额</span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td align="right">满足可用</td>
                                                <td>
                                                    <input type="text" name="min" value="{#$sale['min']|intval#}" size="8" class="inpMain" /> 元，
                                                    <span class="cue">订单满此价格时可使用，填写0不限制</span>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                                <tr>
                                    <td align="right">类型②<br/>核销兑奖</td>
                                    <td>
                                        <table width="100%" border="0" cellpadding="8" cellspacing="0" class="tableBasic tableAuto">
                                            <tr>
                                                <td width="70" align="right">优惠方式</td>
                                                <td class="checkbox" style="line-height:30px;">
                                                    <label><input type="radio" name="sale_type" {#che($sale['sale_type'], 'C')#}>核销兑换</label>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td align="right">优惠方式说明</td>
                                                <td>
                                                    <input type="text" name="sale_mode" value="{#$sale['sale_mode']#}" size="50" class="inpMain" placeholder="例如：兑换价值x元xxx">
                                                </td>
                                            </tr>
                                            <tr>
                                                <td align="right">核销会员ID</td>
                                                <td>
                                                    <input type="text" name="cancel_ids" value="{#trim($sale['cancel_ids'], ',')#}" size="50" class="inpMain">
                                                    <span class="cue">多个用半角逗号隔开</span>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                                <tr>
                                    <td align="right">使用条件</td>
                                    <td>
                                        <input type="text" name="limit_exp" value="{#$sale['limit_exp']#}" size="60" class="inpMain" placeholder="例如：全平台通用"/>
                                    </td>
                                </tr>
                                <tr>
                                    <td align="right">可使用说明</td>
                                    <td>
                                        <input type="text" name="use_exp" value="{#$sale['use_exp']#}" size="60" class="inpMain" placeholder="例如：请在归还设备时使用"/>
                                    </td>
                                </tr>

                                <tr>
                                    <td align="right">数量</td>
                                    <td>
                                        总：<input type="text" name="numall" value="{#$numall|intval#}" size="8" class="inpMain" />　
                                        剩余：<input type="text" name="num" value="{#$num|intval#}" size="8" class="inpMain" />
                                    </td>
                                </tr>
                                <tr>
                                    <td align="right">状态</td>
                                    <td class="checkbox">
                                        <label><input type="radio" name="status"{#che($sale['status'], '启用')#}{#if !$sale#} checked{#/if#}>启用</label>
                                        <label><input type="radio" name="status"{#che($sale['status'], '禁用')#}>禁用</label>
                                    </td>
                                </tr>
                            </table>
                        </div>
                        <div id="where" class="tabbody">
                            <table width="100%" border="0" cellpadding="8" cellspacing="0" class="tableBasic">
                                <tr>
                                    <td width="90" align="right">每人可领<br/>(获取条件)</td>
                                    <td>
                                        <table width="100%" border="0" cellpadding="8" cellspacing="0" class="tableBasic">
                                            <tr>
                                                <td align="right" width="30">数量</td>
                                                <td>
                                                    <input type="text" name="numcan" value="{#$numcan|intval#}" size="5" class="inpMain" /> 张
                                                </td>
                                            </tr>
                                            <tr>
                                                <td align="right">周期</td>
                                                <td class="checkbox">
                                                    <label><input type="radio" name="numcan_type"{#che($sale['numcan_type'], 'closed')#}>关闭</label>
                                                    <label><input type="radio" name="numcan_type"{#che($sale['numcan_type'], 'day')#}>每天</label>
                                                    <label><input type="radio" name="numcan_type"{#che($sale['numcan_type'], 'week')#}>星期</label>
                                                    <label><input type="radio" name="numcan_type"{#che($sale['numcan_type'], 'month')#}>每月</label>
                                                    <label><input type="radio" name="numcan_type"{#che($sale['numcan_type'], 'year')#}>每年</label>
                                                </td>
                                            </tr>
                                        </table>
                                        <div class="cue" style="margin-top:5px;">
                                            每位客户最多可领取{#sale_name()#}张数，周期为自然周期。
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td align="right">有效时间</td>
                                    <td>
                                        <table width="100%" border="0" cellpadding="8" cellspacing="0" class="tableBasic">
                                            <tr>
                                                <td align="right" class="checkbox" width="80">
                                                    <label><input type="radio" name="end_type"{#che($sale['end_type'], 'fixed')#}>固定时间</label>
                                                </td>
                                                <td>
                                                    <input type="text" name="startdate" value="{#date("Y-m-d", $startdate)#}" size="12" class="inpMain"  id="d4321" onFocus="WdatePicker({maxDate:'#F{$dp.$D(\'d4322\',{d:-1});}'})"/> 至
                                                    <input type="text" name="enddate" value="{#date("Y-m-d", $enddate)#}" size="12" class="inpMain"  id="d4322" onFocus="WdatePicker({minDate:'#F{$dp.$D(\'d4321\',{d:1});}'})"/>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td align="right" class="checkbox">
                                                    <label><input type="radio" name="end_type"{#che($sale['end_type'], 'day')#}>领后天数</label>
                                                </td>
                                                <td>
                                                    <input type="text" name="end_day" value="{#$sale['end_day']|intval#}" size="5" class="inpMain" /> 天过期 （1天=24小时）
                                                </td>
                                            </tr>
                                            <tr>
                                                <td align="right" class="checkbox">
                                                    <label><input type="radio" name="end_type"{#che($sale['end_type'], 'each')#}>领后过期</label>
                                                </td>
                                                <td class="checkbox">
                                                    <label><input type="radio" name="end_each"{#che($sale['end_each'], 'day')#}>当天</label>
                                                    <label><input type="radio" name="end_each"{#che($sale['end_each'], 'week')#}>本周</label>
                                                    <label><input type="radio" name="end_each"{#che($sale['end_each'], 'month')#}>本月</label>
                                                    <label><input type="radio" name="end_each"{#che($sale['end_each'], 'year')#}>本年</label>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                            </table>
                        </div>
                        <div id="auto" class="tabbody">
                            <table width="100%" border="0" cellpadding="8" cellspacing="0" class="tableBasic">
                                <tr>
                                    <td width="90" align="right">自动获得</td>
                                    <td class="checkbox labelbox110">
                                        <label><input type="checkbox" name="autoget[]"{#ches($sale['autoget'], 'reg')#}>首次登陆(新注册)</label>
                                        <label><input type="checkbox" name="autoget[]"{#ches($sale['autoget'], 'login')#}>每次登录</label><br/>
                                        <label><input type="checkbox" name="autoget[]"{#ches($sale['autoget'], 'first_pay')#}>首次支付押金</label>
                                        <label><input type="checkbox" name="autoget[]"{#ches($sale['autoget'], 'every_pay')#}>每次支付押金</label><br/>
                                        <label><input type="checkbox" name="autoget[]"{#ches($sale['autoget'], 'first_complete')#}>首次完成交易</label>
                                        <label><input type="checkbox" name="autoget[]"{#ches($sale['autoget'], 'every_complete')#}>每次完成交易</label><br/>
                                        <label><input type="checkbox" name="autoget[]"{#ches($sale['autoget'], 'first_invite')#}>首次成功邀请</label>
                                        <label><input type="checkbox" name="autoget[]"{#ches($sale['autoget'], 'every_invite')#}>每次成功邀请</label>
                                        <div class="cue" style="margin-top:5px;">
                                            *以上所有 <u>每次</u> 均不包含首次；<br/>
                                            *完成事件自动获得 <u>选多个则每个事件都会获得，可设置“每人可领”项来限制；</u><br/>
                                            *不选择可通过{#sale_name()#}兑换码获得。<br/>
                                            *状态为[禁用/过期/可领取为0/剩余0]的不参与此方案。
                                        </div>
                                        <div>
                                            自动获得：<input type="text" name="autoget_num" value="{#intval($sale['autoget_num'])#}" placeholder="留空默认0，填0不赠送" class="inpMain" size="5"> 张
                                        </div>
                                    </td>
                                </tr>
                            </table>
                        </div>
                        <table width="100%" border="0" cellpadding="8" cellspacing="0" class="tableBasic">
                            <tr>
                                <td width="90" align="right"></td>
                                <td>
                                    <input class="btn" type="submit" value="提交{#$subtitle#}" />
                                    <input type="hidden" name="submit" value="1">
                                </td>
                            </tr>
                        </table>
                    </form>
                </div>
            </div>
        </div>
    </div>
    <div class="clear"></div>
    {#tpl('_foot')#}
    <!-- dcFooter 结束 -->
    <div class="clear"></div>
</div>
<div class="translucentbackground" style="display:none" onclick="_hidetranbg(this);"></div>
<script type="text/javascript">
    function codekeyup(obj) {
        var tthis = $(obj);
        if (tthis.val()) {
            $('#code').text(tthis.val());
            $('#cuecode').show();
        }else{
            $('#cuecode').hide();
        }
    }
    $(function(){
        //保存数据事件
        $('#saveform').submit(function() {
            //
            $.alert('正在保存...', 0);
            $(this).ajaxSubmit({
                dataType : 'json',
                success : function (data) {
                    if (data != null && data.success != null && data.success) {
                        $.alert(data.message);
                        setTimeout(function(){
                            window.location.href = '{#url('admin/sale_add')#}?id=' + data.id;
                        }, 500);
                    } else {
                        $.alertk(data.message);
                    }
                },
                error : function () {
                    $.alertk("保存失败！");
                }
            });
            return false;
        });
        //
        $("#codebox").mouseup(function(){
            var text = $(this),
                range,
                selection;
            if(!text.length) return;
            text = text[0];
            if (document.body.createTextRange) {
                range = document.body.createTextRange();
                range.moveToElementText(text);
                range.select();
            } else if (window.getSelection) {
                selection = window.getSelection();
                range = document.createRange();
                range.selectNodeContents(text);
                selection.removeAllRanges();
                selection.addRange(range);
            }
        });
    });
</script>
</body>
</html>