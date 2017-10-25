jQuery.expressUllist = function(vobj, iobj, isfixed) {
    var _expressItem=[{"id":1,"code":"aae","name":"aae全球专递"},{"id":2,"code":"anjie","name":"安捷快递"},{"id":3,"code":"anxindakuaixi","name":"安信达快递"},{"id":4,"code":"biaojikuaidi","name":"彪记快递"},{"id":5,"code":"bht","name":"bht"},{"id":6,"code":"baifudongfang","name":"百福东方国际物流"},{"id":7,"code":"coe","name":"中国东方（COE）"},{"id":8,"code":"changyuwuliu","name":"长宇物流"},{"id":9,"code":"datianwuliu","name":"大田物流"},{"id":10,"code":"debangwuliu","name":"德邦物流"},{"id":11,"code":"dhl","name":"dhl"},{"id":12,"code":"dpex","name":"dpex"},{"id":13,"code":"dsukuaidi","name":"d速快递"},{"id":14,"code":"disifang","name":"递四方"},{"id":15,"code":"ems","name":"ems快递"},{"id":16,"code":"fedex","name":"fedex（国外）"},{"id":17,"code":"feikangda","name":"飞康达物流"},{"id":18,"code":"fenghuangkuaidi","name":"凤凰快递"},{"id":19,"code":"feikuaida","name":"飞快达"},{"id":20,"code":"guotongkuaidi","name":"国通快递"},{"id":21,"code":"ganzhongnengda","name":"港中能达物流"},{"id":22,"code":"guangdongyouzhengwuliu","name":"广东邮政物流"},{"id":23,"code":"gongsuda","name":"共速达"},{"id":24,"code":"huitongkuaidi","name":"汇通快运"},{"id":25,"code":"hengluwuliu","name":"恒路物流"},{"id":26,"code":"huaxialongwuliu","name":"华夏龙物流"},{"id":27,"code":"haihongwangsong","name":"海红"},{"id":28,"code":"haiwaihuanqiu","name":"海外环球"},{"id":29,"code":"jiayiwuliu","name":"佳怡物流"},{"id":30,"code":"jinguangsudikuaijian","name":"京广速递"},{"id":31,"code":"jixianda","name":"急先达"},{"id":32,"code":"jjwl","name":"佳吉物流"},{"id":33,"code":"jymwl","name":"加运美物流"},{"id":34,"code":"jindawuliu","name":"金大物流"},{"id":35,"code":"jialidatong","name":"嘉里大通"},{"id":36,"code":"jykd","name":"晋越快递"},{"id":37,"code":"kuaijiesudi","name":"快捷速递"},{"id":38,"code":"lianb","name":"联邦快递（国内）"},{"id":39,"code":"lianhaowuliu","name":"联昊通物流"},{"id":40,"code":"longbanwuliu","name":"龙邦物流"},{"id":41,"code":"lijisong","name":"立即送"},{"id":42,"code":"lejiedi","name":"乐捷递"},{"id":43,"code":"minghangkuaidi","name":"民航快递"},{"id":44,"code":"meiguokuaidi","name":"美国快递"},{"id":45,"code":"menduimen","name":"门对门"},{"id":46,"code":"ocs","name":"OCS"},{"id":47,"code":"peisihuoyunkuaidi","name":"配思货运"},{"id":48,"code":"quanchenkuaidi","name":"全晨快递"},{"id":49,"code":"quanfengkuaidi","name":"全峰快递"},{"id":50,"code":"quanjitong","name":"全际通物流"},{"id":51,"code":"quanritongkuaidi","name":"全日通快递"},{"id":52,"code":"quanyikuaidi","name":"全一快递"},{"id":53,"code":"rufengda","name":"如风达"},{"id":54,"code":"santaisudi","name":"三态速递"},{"id":55,"code":"shenghuiwuliu","name":"盛辉物流"},{"id":56,"code":"shentong","name":"申通"},{"id":57,"code":"shunfeng","name":"顺丰"},{"id":58,"code":"sue","name":"速尔物流"},{"id":59,"code":"shengfeng","name":"盛丰物流"},{"id":60,"code":"saiaodi","name":"赛澳递"},{"id":61,"code":"tiandihuayu","name":"天地华宇"},{"id":62,"code":"tiantian","name":"天天快递"},{"id":63,"code":"tnt","name":"tnt"},{"id":64,"code":"ups","name":"ups"},{"id":65,"code":"wanjiawuliu","name":"万家物流"},{"id":66,"code":"wenjiesudi","name":"文捷航空速递"},{"id":67,"code":"wuyuan","name":"伍圆"},{"id":68,"code":"wxwl","name":"万象物流"},{"id":69,"code":"xinbangwuliu","name":"新邦物流"},{"id":70,"code":"xinfengwuliu","name":"信丰物流"},{"id":71,"code":"yafengsudi","name":"亚风速递"},{"id":72,"code":"yibangwuliu","name":"一邦速递"},{"id":73,"code":"youshuwuliu","name":"优速物流"},{"id":74,"code":"youzhengguonei","name":"邮政包裹挂号信"},{"id":75,"code":"youzhengguoji","name":"邮政国际包裹挂号信"},{"id":76,"code":"yuanchengwuliu","name":"远成物流"},{"id":77,"code":"yuantong","name":"圆通速递"},{"id":78,"code":"yuanweifeng","name":"源伟丰快递"},{"id":79,"code":"yuanzhijiecheng","name":"元智捷诚快递"},{"id":80,"code":"yunda","name":"韵达快运"},{"id":81,"code":"yuntongkuaidi","name":"运通快递"},{"id":82,"code":"yuefengwuliu","name":"越丰物流"},{"id":83,"code":"yad","name":"源安达"},{"id":84,"code":"yinjiesudi","name":"银捷速递"},{"id":85,"code":"zhaijisong","name":"宅急送"},{"id":86,"code":"zhongtiekuaiyun","name":"中铁快运"},{"id":87,"code":"zhongtong","name":"中通速递"},{"id":88,"code":"zhongyouwuliu","name":"中邮物流"},{"id":89,"code":"zhongxinda","name":"忠信达"},{"id":90,"code":"zhimakaimen","name":"芝麻开门"}];
    //
    vobj.css("position","re");
    var _t = vobj.offset().top;     		//控件的定位点高
    var _h = vobj.outerHeight();  		    //控件本身的高
    var _w = vobj.outerWidth();  		    //控件本身的宽
    var _l = vobj.offset().left;    		//控件的定位点宽
    //
    var ljson = eval(_expressItem);
    var _html = "<ul>";
    for(var i=0; i<ljson.length; i++) { _html+= '<li data-id="'+ljson[i].id+'" data-code="'+ljson[i].code+'">'+ljson[i].name+'</li>'; }
    _html+= '</ul>';
    $("#__jQuery-express").remove();
    var $intemp = $('<div id="__jQuery-express" style="display:none;">' + _html + '</span>');
    var $csstemp = {
        top:_t+_h,
        left:_l,
        width:_w,
        position:'absolute',
        'background-color': '#ffffff',
        'z-index': '123456789'
    };
    if (isfixed === true) {
        $csstemp.top-= $(window).scrollTop();
        $csstemp.position = 'fixed';
    }
    $intemp.css($csstemp);
    $intemp.find("ul").css({
        border: '1px solid #cccccc',
        'max-height': '220px',
        'overflow': 'auto'
    });
    $intemp.find("li").css({
        'padding': '4px 6px',
        'border-bottom': '1px dashed #cccccc'
    });
    $(document.body).append($intemp);
    vobj.attr("data-expressval", vobj.val());
    vobj.click(function(){
        $intemp.show();
        var $c = {
            top:vobj.offset().top+vobj.outerHeight(),
            left:vobj.offset().left
        };
        if (isfixed === true) {
            $c.top-= $(window).scrollTop();
        }
        $intemp.css($c);
    }).focus(function(){
        $intemp.show();
        var $c = {
            top:vobj.offset().top+vobj.outerHeight(),
            left:vobj.offset().left
        };
        if (isfixed === true) {
            $c.top-= $(window).scrollTop();
        }
        $intemp.css($c);
    }).blur(function(){
        var curVal = vobj.val();
        if (curVal && vobj.attr("data-expressval")) {
            $intemp.find("li").each(function(){
                var textValue = $(this).text();
                var textCode = $(this).attr("data-code");
                if (textValue.indexOf(curVal) != -1 || textCode.indexOf(curVal) != -1) {
                    vobj.val($(this).text());
                    iobj.val($(this).attr('data-code'));
                    return false;
                }
            });
        }
        $intemp.hide();
    }).keyup(function(){
        if (iobj){
            iobj.val("");
            var curVal = vobj.val();
            $intemp.find("li").each(function(){
                var textValue = $(this).text();
                var textCode = $(this).attr("data-code");
                if (textValue.indexOf(curVal) != -1 || textCode.indexOf(curVal) != -1) {
                    $(this).show();
                }else{
                    $(this).hide();
                }
                if (textValue == curVal) {
                    iobj.val($(this).attr('data-code'));
                }
            });
            $intemp.show();
        }
    });
    $intemp.find("li").mousedown(function(){
        vobj.val($(this).text());
        if (iobj) iobj.val($(this).attr('data-code'));
    });
};