{#*选择相片*#}

<div class="other_mediascanner">
    <div id="lists"></div>
    <div id="ulTemp">
        <ul>
            <li class="camera" onclick="$JS.camera()">
                <div></div>
                <div class="cameraicon"></div>
            </li>
            <li id="progress">
                <span class="table">
                    <span class="table-cell">
                        <span class="preloader">
                            <span class="preloader-inner">
                                <span class="preloader-inner-gap"></span>
                                <span class="preloader-inner-left"><span class="preloader-inner-half-circle"></span></span>
                                <span class="preloader-inner-right"><span class="preloader-inner-half-circle"></span></span>
                            </span>
                        </span>
                    </span>
                </span>
            </li>
        </ul>
    </div>
</div>

<style>
    .other_mediascanner #lists ul li{float:left;width:33.33%;height:80px;text-align:center;position:relative;}
    .other_mediascanner #lists ul li div{position:absolute;top:0;right:3px;bottom:3px;left:0;background-color:rgba(255,87,34,0.05);background-repeat:no-repeat;background-position:center;background-size:cover;}
    .other_mediascanner #lists ul li div:before{position:absolute;content:"0";text-indent:9999px;overflow:hidden;left:0;top:0;width:100%;height:100%;background-color:rgba(0,0,0,0.2);}
    .other_mediascanner #lists ul li.active div:before{background-color:rgba(0,0,0,0.5);}
    .other_mediascanner #lists ul li.camera div:before{display:none;}
    .other_mediascanner #lists ul li #check_box{display:none;color:#65ec6a;}
    .other_mediascanner #lists ul li #check_box_outline_blank{display:block;}
    .other_mediascanner #lists ul li.active #check_box{display:block;}
    .other_mediascanner #lists ul li.active #check_box_outline_blank{display:none;}
    .other_mediascanner #lists ul li i{position:absolute;right:12px;top:10px;color:#ffffff;}
    .other_mediascanner #lists ul li .cameraicon{position:absolute;top:25%;left:25%;right:25%;bottom:25%;background:url({#$TEM_PATH#}assets/images/camera.png) no-repeat center;background-size:cover;}
    .other_mediascanner #lists ul li#progress{display:none;}
    .other_mediascanner #lists ul li .table{display:table;width:100%;height:100%;}
    .other_mediascanner #lists ul li .table-cell{display:table-cell;vertical-align:middle;}
    .other_mediascanner #ulTemp{display:none;}
</style>
<script>
    $JS = {
        //cache_time: 60*60*24,     //页面缓存时长
        created: function() {
            $JS.$el.find(".navbar .right").html('<a href="#" onclick="$JS.decide();" class="link"><div id="decideLabel" class="button button-fill color-green" style="height:30px;line-height:30px;min-width:54px;">确定</div></a>');
            //
            $JS.ulWidth = ($A.$(window).width() + 3) + 'px';
            $JS.liHeight = ($A.$(window).width() / 3) + 'px';
            $JS.$el.find("#lists").html($JS.$el.find("#ulTemp").html());
            $JS.$el.find("#lists ul").css({width: $JS.ulWidth});
            $JS.$el.find("#lists li").css({height: $JS.liHeight});
            //
            $JS.loadImages();
        },
        infinite: function() {
            $JS.loadImages(true, function() {
                $JS.infiniteDone();
            });
        },
        camera: function() {
            api.getPicture({
                sourceType: 'camera',
                encodingType: 'jpg',
                mediaValue: 'pic',
                destinationType: 'url',
                allowEdit: false,
                quality: 89,
                targetWidth: 2048,
                targetHeight: 2048,
                saveToPhotoAlbum: false
            }, function(ret, err) {
                if (ret && ret.data) {
                    var data = [{path: ret.data, thumbPath: ret.data}];
                    $JS.decide(data);
                }
            });
        },
        decide: function(data) {
            var array = [];
            if (typeof data === 'object' && data.length > 0) {
                array = data;
            }else{
                $JS.$el.find("#lists li.active").each(function(){
                    array.push(JSON.parse($A.$(this).find("#data-json").text()));
                });
            }
            $A.routerBack(-1);
            if (array.length > 0 && typeof $A.__mediaScannerCallback === 'function') {
                $A.__mediaScannerCallback(array?array:false);
            }
        },
        loadImages: function(isFetch, callback) {
            var UIMediaScanner;
            if (typeof api === 'undefined') {
                $A.toast("当前设备不支持功能！");
                return;
            }
            if ($JS.progress === true) return;
            $JS.progress = true;
            $JS.$el.find("#lists #progress").show();
            UIMediaScanner = api.require('UIMediaScanner');
            if (isFetch) {
                UIMediaScanner.fetch(function(ret, err) {
                    $JS.$el.find("#lists #progress").hide();
                    if (ret.list.length > 0) {
                        $JS.loadImagePlus(ret.list);
                        $JS.progress = false;
                        if (typeof callback === 'function') callback();
                    }
                });
                return;
            }
            UIMediaScanner.scan({
                type: 'picture',
                count: 50,
                sort: {
                    key: 'time',
                    order: 'desc'
                },
                thumbnail: {
                    w: 200,
                    h: 200
                }
            }, function(ret) {
                $JS.$el.find("#lists #progress").hide();
                if (ret.list.length > 0) {
                    $JS.loadImagePlus(ret.list);
                    $JS.progress = false;
                    if (typeof callback === 'function') callback();
                }
            });
        },
        loadImagePlus: function(list) {
            for (var i = 0; i < list.length; i++) {
                var intemp = $A.$('<li style="height:' + $JS.liHeight + '">' +
                    '<div style="background-image:url(' + list[i].thumbPath + ')"></div>' +
                    '<div id="data-json" style="display:none">' + JSON.stringify(list[i]) + '</div>' +
                    '<i class="icon material-icons" id="check_box">check_box</i>' +
                    '<i class="icon material-icons" id="check_box_outline_blank">check_box_outline_blank</i>' +
                    '</li>');
                intemp.click(function(){
                    var length = $JS.$el.find("#lists li.active").length;
                    if (!$A.$(this).hasClass("active")) {
                        if (length >= $JS.$data.num) {
                            $A.toast("你最多只能选择" + $JS.$data.num + "张图片");
                            return;
                        }
                        length++;
                    }else{
                        length--;
                    }
                    $A.$(this).toggleClass("active");
                    if (length > 0) {
                        $JS.$el.find("#decideLabel").html("确定(" + length + ")");
                        if ($JS.$data.num === 1) $JS.decide(); //只选择1张的自动确认
                    }else{
                        $JS.$el.find("#decideLabel").html("确定");
                    }
                });
                intemp.insertBefore($JS.$el.find("#lists #progress"));
            }
        }
    };
</script>