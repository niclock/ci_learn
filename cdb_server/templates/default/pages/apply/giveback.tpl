{#*用户归还设备*#}

{#$wherarr = array()#}
{#$wherarr['ret'] = 1#}
{#$wherarr['userid'] = $_A['user']['id']#}
{#$orderinfo = db_getone(table('order'), $wherarr, '`indate` DESC,`id` DESC')#}
{#$myordersale = my_order_sale($orderinfo)#}

{#if $orderinfo['ret'] == 0#}
    {#page_tis('无需归还或已经归还！')#}
{#/if#}

{#$cdb = cdb_info($orderinfo['sn'])#}
{#if intval($cdb['id']) == 0#}
    {#page_tis($cdb)#}
{#/if#}


{#if $cdb['type'] == '雨伞'#}

    {#*归还雨伞*#}
    {#tpl('apply/giveback_ys', ['cdb'=>$cdb, 'orderinfo'=>$orderinfo, 'myordersale'=>$myordersale])#}

{#else#}

    {#*归还充电宝*#}
    {#tpl('apply/giveback_cdb', ['cdb'=>$cdb, 'orderinfo'=>$orderinfo, 'myordersale'=>$myordersale])#}

{#/if#}