<!DOCTYPE html>
<html>

<head>
    <meta charset="utf-8">
    <meta name="renderer" content="webkit">
    <meta http-equiv="X-UA-Compatible" content="IE=Edge,chrome=1">
    <title>为什么会这样-{#if $system['title']#}{#$system['title']#}{#else#}{#$_A['BASE_NAME']#}{#/if#}</title>
    <link rel="stylesheet" type="text/css" href="{#$TEM_PATH#}assets/css/public.css" />
    <link rel="stylesheet" type="text/css" href="{#$TEM_PATH#}assets/css/shopping.css" />
</head>

<body>

<div class="wrapper">
    <div class="notFound-box">
        <p>暂时无法支持您访问的页面</p>
        <a href="{#url()#}" class="buy-button">返回首页</a>
    </div>
</div>

</body>
</html>