{#*商家合作协议*#}

<div class="join_dealer_agreement">
    <img src="{#$NOW_PATH#}about/images/join_dealer_agreement_01.jpg" onclick="$JS.show(0);">
    <img src="{#$NOW_PATH#}about/images/join_dealer_agreement_02.jpg" onclick="$JS.show(1);">
</div>
<style>
    .join_dealer_agreement img {
        width: 100%;
        display: table;
    }
</style>
<script>
    $JS = {
        refresh: false,
        show: function(index) {
            $A.album([
                '{#$NOW_PATH#}about/images/join_dealer_agreement_01.jpg',
                '{#$NOW_PATH#}about/images/join_dealer_agreement_02.jpg'
            ], index);
        }
    };
</script>