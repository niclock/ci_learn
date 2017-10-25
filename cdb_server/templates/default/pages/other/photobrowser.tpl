<!DOCTYPE html>
<html>
<head>
    <title>查看图片</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width,user-scalable=no,minimum-scale=1,maximum-scale=1">
    <meta name="format-detection" content="telephone=no" />
    <meta http-equiv="Cache-Control" content="no-siteapp" />
    <style type="text/css">
        html,body{margin:0;padding:0}
        body{font-family:"Microsoft YaHei",SimHei,SimSun,sans-serif;background:transparent;}
        header{position:absolute;left:0;top:50%;margin-top:-25px;width:100%;height:50px;line-height:50px;color:#ffffff;background:transparent;display:-webkit-box;display:-webkit-flex;display:flex;transition:all 200ms;-moz-transition:all 200ms;-webkit-transition:all 200ms;-o-transition:all 200ms;}
        #back{min-width:50px;width:10%;height:50px;background-image:url("data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAMgAAADIBAMAAABfdrOtAAAAA3NCSVQICAjb4U/gAAAALVBMVEX///////////////////////////////////////////////////////////+g0jAFAAAAD3RSTlMAESIzRFVmd4iZu8zd7v9ufV8LAAAACXBIWXMAAAsSAAALEgHS3X78AAAAHHRFWHRTb2Z0d2FyZQBBZG9iZSBGaXJld29ya3MgQ1M26LyyjAAAAX9JREFUeJzt27FNA0EURdEBAyIkNkKiBAJSJJdACc6duAQogBYoAYkGkGiABEFIgoQA278GdrXYM2S84P0A7m3g6Xi9yWqmFCKi/9pOwsYslnP3xjgiFgfeja27biRuvSOH/YaZMkDMlAES8W7cWEMijL/XGhIxsW1USFzYRiokpq6NBhInrpEG8unaaCGvrpEGYnskLeTNtAFECYgSECEgSkCEgCgBEQKiBEQIiFIGZJQBOcuAvAD5fdmQJ9NGC1m5vnC0kEfTBhAlIEpAhIAoARECogRECIgSEKEUyFECpFwnQLYzILsJkLJfR6a2kb0MScozKTcZlIwXPueNhyIGRQyKFhQxKFpQxKBoQRGDogVFDIoWFDEoWlDEoGhBEYOiBUUMihYUMShaf5Ty7BpJOa2ac+72B+XcNZL+B7Pd+y2jh7pybFtpTtrbHkrOrfKU+/E5N/03lA/jxoZy7xz5phhPH/QNFN8LP9RTFl5IR7mK1aV5o+t04t8gIqp9Abt1E3Psi6nMAAAAAElFTkSuQmCC");background-repeat:no-repeat;background-size:22px 22px;background-position:center;}
        #title{-webkit-box-flex:1;-webkit-flex:1;flex:1;font-size:18px;text-align:center;}
        #null{min-width:50px;width:10%;height:50px;}
    </style>
</head>

<body>
    <header id="header">
        <div id="back"></div>
        <div id="title"></div>
        <div id="null"></div>
    </header>
</body>

<script type="text/javascript">
    function setIndex(index, total) {
        var title = document.getElementById("title");
        title.innerText = index + '/' + total;
    }
    function toggleHeader() {
        var dom = document.getElementById("header");
        if (window.__toggleHeader === true) {
            window.__toggleHeader = false;
            dom.style.webkitTransform = dom.style.transform = 'translate3d(0, 0, 0)';
        }else{
            window.__toggleHeader = true;
            dom.style.webkitTransform = dom.style.transform = 'translate3d(0, -200%, 0)';
        }
    }
    function callclosed() {
        api.execScript({name:'root', script:'if (typeof $main_box == "object"){ $main_box.callback(); }'});
    }
    apiready = function () {
        var pageParam = api.pageParam;
        if (pageParam.total) {
            setIndex(pageParam.activeIndex, pageParam.total);
        }
        document.getElementById("back").addEventListener('touchend', function(){
            callclosed();
        });
    };
</script>
</html>