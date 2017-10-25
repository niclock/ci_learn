{#*商务合作*#}

{#user_check()#}

<div class="apply_join">
    <div class="list-block">
        <ul>
            <li onclick="$A.routerPopup({title:'城市代理申请', url: 'pages/apply/join_agents/'});">
                <a href="#" class="item-link item-content">
                    <div class="item-inner">
                        <div class="item-title">城市代理申请</div>
                    </div>
                </a>
            </li>
        </ul>
    </div>
    <div class="list-block">
        <ul>
            <li onclick="$A.routerPopup({title:'G家合作', url: 'pages/apply/join_gjia/'});">
                <a href="#" class="item-link item-content">
                    <div class="item-inner">
                        <div class="item-title">G家合作</div>
                    </div>
                </a>
            </li>
        </ul>
    </div>
</div>

<style>
    .apply_join .list-block li {
        background-color: #ffffff;
    }
</style>
<script>
    $JS = {
        title: '商务合作'
    };
</script>