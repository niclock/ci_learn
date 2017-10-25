<!DOCTYPE HTML>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
    <meta name="viewport" content="width=device-width, minimum-scale=1.0, maximum-scale=2.0" />
    {#if $gotourl#}
        <meta http-equiv="refresh" content="{#$gototime#};URL={#$gotourl#} "/>
    {#/if#}
    <title>{#$title#}</title>
    <link type="text/css" rel="stylesheet" href="{#$CSS_PATH#}warning.css" />
    {#if $_GPC['__browser_from']=='app'#}
        <style type="text/css">
            .war-nav {
                display: none;
            }
            .footer {
                display: none;
            }
        </style>
    {#/if#}
    <script type="text/javascript" src="{#$JS_PATH#}jquery-1.11.0.js"></script>
    <script type="text/javascript">
        function winload() {
            var isback = false;
            if (document.referrer != '' && document.referrer != document.URL) {
                isback = true;
                $("#war-back").show();
            }
            //
            var war_l = $("#war-l");
            var datalink = war_l.html();
            var arr = datalink.match(/<a.*?href=[\'|\"]([^\"]*?)[\'|\"]>([^\"]*?)<\/a>/ig);
            var links = '';
            for(var i=0;i<arr.length;i++){
                var _link = arr[i] + "";
                if (isback == true || _link.indexOf("history.go(-1)") === -1){
                    links += arr[i];
                }
            }
            if (links) war_l.html(links).show();
        }
        function gototime(){
            var docgototime = document.getElementById("gototime").innerHTML;
            var re = new RegExp("^[0-9]+$");
            if (docgototime.search(re) != - 1) {
                if (docgototime > 1){
                    document.getElementById("gototime").innerHTML = docgototime-1;
                    setTimeout("gototime()",1000);
                }else if (docgototime == 1){
                    document.getElementById("gototime_a").innerHTML = "自动加载中，请稍等片刻...";
                }
            }
        }
    </script>
</head>
<body onload="winload();">
<div class="bodymain">

    <div class="war-nav">
        <div id="war-back" class="left" onclick="javascript:history.go(-1);"></div>
        <div id="war-title" class="center">{#$title#}</div>
        <div id="war-home" class="right" onclick="window.location='{#$smarty.const.BASE_URI#}'"></div>
    </div>

    <div class="warcon">
        <div class="warbox">
            <div class="war-t">{#$body#}</div>
            {#$datalink = str_replace('<br/>','',$datalink)#}
            <div class="war-l" id="war-l">{#$datalink#}</div>
            {#if $gotourl#}
                <div class="war-g"><a href="{#$gotourl#}" title="点击手动跳转" id="gototime_a"><span id="gototime">{#$gototime#}</span>秒后自动转跳</a></div>
                <script type="text/javascript">
                    setTimeout("gototime()",1000);
                </script>
            {#/if#}
        </div>
    </div>

    <div class="footer">
        <div class="footbox">
            <p>{#$TIME|date_format:"%Y-%m-%d %H:%M"#}</p>
        </div>
    </div>

</div>
</body>
</html>