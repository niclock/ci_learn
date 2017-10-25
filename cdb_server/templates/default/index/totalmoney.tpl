{#*测试租金*#}

<!DOCTYPE html>
{#_head_html()#}
<head>
    <title>押金计算</title>
    <meta http-equiv="content-type" content="text/html; charset=utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=Edge,chrome=1" />
    <meta name="renderer" content="webkit">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, minimum-scale=1, user-scalable=no">
    <meta name="format-detection" content="telephone=no" />
    <meta name="apple-mobile-web-app-capable" content="yes">
    <meta name="apple-mobile-web-app-status-bar-style" content="black">
    <link rel="stylesheet" type="text/css" href="{#$CSS_PATH#}default.css"/>
    <style>
        .main {
            margin: 20px;
            font-size: 14px;
            text-align: center;
        }
        .main h2{
            font-weight: 600;
            font-size: 20px;
            padding: 0;
            margin: 0 0 12px;
        }
        .inpMain {
            width: 177px;
            text-align: center;
            height: 22px;
            margin-bottom: 10px;
            outline: none;
        }
        button {
            width: 100px;
            height: 30px;
            border: 0;
            line-height: 30px;
            color: #ffffff;
            background-color: #57a2b9;
            margin-top: 8px;
            outline: none;
        }
        #load {
            margin-top: 15px;
            color: #e48f00;
        }
    </style>
    <script type="text/javascript" src="{#$JS_PATH#}jquery.min.js"></script>
    <script type="text/javascript" src="{#$JS_PATH#}jquery.alert.js"></script>
    <script type="text/javascript" src="{#$JS_PATH#}My97DatePicker/WdatePicker.js"></script>
</head>
<body>

<div class="main">
    <h2>押金计算</h2>

    <div class="filterlr">
        <div class="filterl">
            <div>起租时间</div>
            <input id="stime" name="stime" value="" readonly="readonly" onfocus="WdatePicker({maxDate:'#F{$dp.$D(\'etime\')}',dateFmt:'yyyy-MM-dd HH:mm:ss'})" class="inpMain">
        </div>
        <div class="filterr">
            <div>归还时间</div>
            <input id="etime" name="etime" value="" readonly="readonly" onfocus="WdatePicker({minDate:'#F{$dp.$D(\'stime\')}',dateFmt:'yyyy-MM-dd HH:mm:ss'})" class="inpMain">
        </div>
    </div>
    <button id="saveform">确定</button>

    <div id="load"></div>

</div>


<script type="text/javascript">
    $(function(){
        $("input.inpMain").click(function(){
            $(this).focus();
        });
        $('#saveform').click(function() {
            var load = $("#load");
            load.html("计算中...");
            $.ajax({
                url: '{#get_link('act|stime|etime')#}',
                data: {
                    act: 'submit',
                    stime: $("#stime").val(),
                    etime: $("#etime").val()
                },
                type: 'POST',
                dataType: 'json',
                success: function(response) {
                    load.html(response.message);
                },
                error: function() {
                    load.html("计算失败：网络繁忙，请稍后再试");
                }
            });
        });
    });
</script>
</body>
</html>