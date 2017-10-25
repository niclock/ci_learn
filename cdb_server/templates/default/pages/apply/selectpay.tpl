{#if leftexists($_GPC['sn'], '18')#}

    {#*核销卡券*#}
    {#tpl('apply/selectpay_sale')#}

{#elseif leftexists($_GPC['sn'], '88')#}

    {#*商家二维码*#}
    {#tpl('apply/selectpay_users')#}

{#else#}

    {#$cdb = cdb_info($_GPC['sn'])#}
    {#if intval($cdb['id']) == 0#}{#page_tis('温馨提示', '提醒：'|cat:$cdb)#}{#/if#}
    {#if $cdb['status'] == '禁用'#}{#page_tis('温馨提示', '提醒：此设备不存在或者已经被禁用！')#}{#/if#}

    {#if $_A['user']['isdealer']#}

        {#if $cdb['status'] == '启用' && $cdb['userid'] == 0#}

            {#*商家认领设备*#}
            {#tpl('apply/selectpay_claim', ['cdb'=>$cdb])#}

        {#else#}

            {#*商家收回设备*#}
            {#tpl('apply/selectpay_takeback', ['cdb'=>$cdb])#}

        {#/if#}

    {#else#}

        {#*用户借用设备*#}
        {#if $cdb['userid'] == 0#}
            {#page_tis('温馨提示', '提醒：此设备尚未投入使用！')#}
        {#elseif $cdb['userid'] == $_A['user']['id']#}
            {#page_tis('温馨提示', '提醒：此设备正在被您借用！')#}
        {#elseif $cdb['status'] != '启用'#}
            {#page_tis('温馨提示', '提醒：此设备正在被借用！')#}
        {#/if#}

        {#if $cdb['type'] == '充电宝'#}
            {#tpl('apply/selectpay_borrow_cdb', ['cdb'=>$cdb])#}
        {#elseif $cdb['type'] == '雨伞'#}
            {#tpl('apply/selectpay_borrow_ys', ['cdb'=>$cdb])#}
        {#else#}
            {#page_tis('温馨提示', '提醒：未知的设备')#}
        {#/if#}

    {#/if#}

{#/if#}



