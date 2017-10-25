{#*页面模板*#}

<div class="template">

</div>

<style>

</style>
<script>
    $JS = {
        var $el,                        //object    页面对象
        var $id,                        //string    页面ID
        var $data,                      //json      页面传递参数
        var pullToRefreshTrigger,       //function  触发下拉刷新
        var pullToRefreshDone,          //function  重置下拉刷新
        var infiniteDone,               //function  重置滚动到底部

        cache_time: 10,                 //int       页面缓存时长（秒）
        title: '',                      //string    页面名称
        beforeCreate: function() {},    //function  页面创建之前执行
        created: function() { },        //function  页面创建完毕执行
        opened: function() { },         //function  页面打开动画时
        closed: function() { },         //function  页面结束动画后
        beforeDestroy: function() { },  //function  页面销毁之前
        destroy: function() { },        //function  页面销毁之后
        activated: function() { }       //function  页面被激活（从别的页面回到这个页面）
        deactivated: function() { }     //function  取消激活页面（离开这个页面）
        refresh: function() { },        //[false取消下拉刷新功能 | function下拉刷新时执行的函数 | 不设置此函数则自动刷新内容]
        infinite: function() { }        //[function页面滚动到底部执行 | 不设置不启用]
    };
    //$A.routerBack(-1); 返回上一页
</script>