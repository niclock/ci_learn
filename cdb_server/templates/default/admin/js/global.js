/**
 +----------------------------------------------------------
 * 下拉菜单
 +----------------------------------------------------------
 */
$(function() {
    $('.M').hover(function() {
        $(this).addClass('active');
    },
    function() {
        $(this).removeClass('active');
    });
    //
    $("table.tableBasic").find("tr").mouseover(function(){
        $(this).css("background-color","#f4f4f4");
    }).mouseout(function(){
        $(this).css("background-color", "transparent");
    })
});

/**
 +----------------------------------------------------------
 * 刷新验证码
 +----------------------------------------------------------
 */
function refreshimage() {
    var cap = document.getElementById('vcode');
    cap.src = cap.src + '?';
}

/**
 +----------------------------------------------------------
 * 无组件刷新局部内容
 +----------------------------------------------------------
 */
function dou_callback(page, name, value, target) {
    $.ajax({
        type: 'GET',
        url: page,
        data: name + '=' + value,
        dataType: "html",
        success: function(html) {
            $('#' + target).html(html);
        }
    });
}

/**
 +----------------------------------------------------------
 * 表单全选
 +----------------------------------------------------------
 */
function selectcheckbox(form) {
    for (var i = 0; i < form.elements.length; i++) {
        var e = form.elements[i];
        if (e.name != 'chkall' && e.disabled != true) e.checked = form.chkall.checked;
    }
}

/**
 +----------------------------------------------------------
 * 显示服务端扩展列表
 +----------------------------------------------------------
 */
function get_cloud_list(unique_id, get, localsite) {
    $.ajax({
        type: 'GET',
        url: 'http://cloud.douco.com/extend&rec=client',
        data: {'unique_id':unique_id, 'get':get, 'localsite':localsite},
        dataType: 'jsonp',
        jsonp: 'jsoncallback',
        success: function(cloud) {
            $('.selector').html(cloud.selector)
            $('.cloudList').html(cloud.html)
            $('.pager').html(cloud.pager)
        }
    });
}

/**
 +----------------------------------------------------------
 * 写入可更新数量
 +----------------------------------------------------------
 */
function cloud_update_number(localsite) {
    $.ajax({
        type: 'GET',
        url: 'http://cloud.douco.com/extend&rec=cloud_update_number',
        data: {'localsite':localsite},
        dataType: 'jsonp',
        jsonp: 'jsoncallback',
        success: function(cloud) {
            change_update_number(cloud.update, cloud.patch, cloud.module, cloud.plugin, cloud.theme, cloud.mobile)
        }
    });
}

/**
 +----------------------------------------------------------
 * 修改update_number值
 +----------------------------------------------------------
 */
function change_update_number(update, patch, module, plugin, theme, mobile) {
    $.ajax({
        type: 'POST',
        url: 'cloud.php?rec=update_number',
        data: {'update':update, 'patch':patch, 'module':module, 'plugin':plugin, 'theme':theme}
    });
}

/**
 +----------------------------------------------------------
 * 弹出窗口
 +----------------------------------------------------------
 */
function douFrame(name, frame, url ) {
    $.ajax({
        type: 'POST',
        url: url,
        data: {'name':name, 'frame':frame},
        dataType: 'html',
        success: function(html) {
            $(document.body).append(html);
        }
    });
}

/**
 +----------------------------------------------------------
 * 显示和隐藏
 +----------------------------------------------------------
 */
function douDisplay(target, action) {
    var traget = document.getElementById(target);
    if (action == 'show') {
        traget.style.display = 'block';
    } else {
        traget.style.display = 'none';
    }
}

/**
 +----------------------------------------------------------
 * 清空对象内HTML
 +----------------------------------------------------------
 */
function douRemove(target) {
    var obj = document.getElementById(target);
    obj.parentNode.removeChild(obj);
}

/**
 +----------------------------------------------------------
 * 无刷新自定义导航名称
 +----------------------------------------------------------
 */
function change(id, choose) {
    document.getElementById(id).value = choose.options[choose.selectedIndex].title;
}

function runNum(str, fixed) {
    var _s = Number(str);
    if (_s+"" == "NaN") {
        _s = 0;
    }
    if (/^[0-9]*[1-9][0-9]*$/.test(fixed)) {
        _s = _s.toFixed(fixed);
        var rs = _s.indexOf('.');
        if (rs < 0) {
            _s+= ".";
            for (var i=0;i<fixed;i++) {
                _s+= "0";
            }
        }
    }
    return _s;
}

function _comment_tao(storeid) {
    art.dialog({
        title: '采集天猫评论',
        fixed: true,
        lock: true,
        content: '淘宝/天猫宝贝地址:<br/>' +
        '<input id="taobaourl" ' +
        'style="width:480px;padding:3px 5px;border:1px solid #cccccc;" placeholder="请输入淘宝/天猫宝贝地址" value="'+$("#gathering_url").val()+'">' +
        '<div style="margin-top:12px;vertical-align:top;">文字替换: (一行对应一行)<br/>' +
        '<textarea style="border:1px solid #cccccc;width:222px;height:120px;padding:3px 5px;" id="taoreplace1">'+$("#gathering_taoreplace1").text()+'</textarea>替换' +
        '<textarea style="border:1px solid #cccccc;width:222px;height:120px;padding:3px 5px;" id="taoreplace2">'+$("#gathering_taoreplace2").text()+'</textarea>' +
        '</div>' +
        '<div style="margin-top:12px;text-align:left;">采集页数: ' +
        '<input id="taobaostart" style="width:50px;border:1px solid #cccccc;padding:3px 5px;" placeholder="开始" value="'+$("#gathering_start").val()+'"> 至 ' +
        '<input id="taobaopage" style="width:50px;border:1px solid #cccccc;padding:3px 5px;" placeholder="结束" value="'+$("#gathering_page").val()+'">' +
        '<label style="margin-top:5px;display:block;float:right;"><input type="checkbox" id="taobaore" value="1" style="margin-top:-2px;"> 更新已存在的评论</label>' +
        '</div>',
        button: [{
            name: '采集',
            focus: true,
            callback: function () {
                var _url = $.trim($("#taobaourl").val());
                var _start = $.trim($("#taobaostart").val());
                var _page = $.trim($("#taobaopage").val());
                var _place1 = $("#taoreplace1").val();
                var _place2 = $("#taoreplace2").val();
                if (_url == "") {
                    alert("请输入地址！"); return false;
                }else if (_page == "") {
                    alert("请输入最大采集页数！"); return false;
                }else{
                    $.alert("正在采集中...", 0, 1);
                    $("#gathering_url").val(_url);
                    $("#gathering_start").val(_start);
                    $("#gathering_page").val(_page);
                    $("#gathering_taoreplace1").text(_place1);
                    $("#gathering_taoreplace2").text(_place2);

                    $.ajax({
                        type: 'POST',
                        url: HOST + "admin/store_comment_taobao/?id="+storeid,
                        data: {
                            act: 'save',
                            taopage: _page,
                            taourl: _url,
                            page: _start,
                            taoreplace1: _place1,
                            taoreplace2: _place2
                        },
                        dataType: "text",
                        success: function(text) {
                            window.location.href = HOST + "admin/store_comment_taobao/?id="+storeid+"&taopage="+_page+
                                "&taourl="+encodeURIComponent(_url)+"&page="+_start+"&savepage=1&taobaore="+($("#taobaore").is(":checked")?1:0);
                        }
                    });
                }
                return false;
            }
        },{
            name: '关闭',
            callback: function () {
                return true;
            }
        }]
    });
}

/**
 * 评价
 */
function _comment(storeid) {
    $.alert("正在加载...", 0, 1);
    $.ajax({
        type: "GET",
        url: HOST + "admin/comment/",
        data: {
            id: storeid
        },
        dataType: "json",
        success: function (data) {
            if (data != null && data.success != null && data.success){
                $.alert(0);
                art.dialog({
                    title: '评价宝贝',
                    fixed: true,
                    lock: true,
                    content: data.message,
                    button: [{
                        name: '发表',
                        focus: true,
                        callback: function () {
                            $.alert("正在发表...", 0, 1);
                            $('#comment_form').unbind("submit").submit(function() {
                                $(this).ajaxSubmit({
                                    dataType : 'json',
                                    success : function (subdata) {
                                        $.alert(0);
                                        if (subdata != null && subdata.success != null && subdata.success){
                                            window.location.reload();
                                        }else{
                                            $.alert(subdata.message);
                                        }
                                    },
                                    error : function () {
                                        $.alert(0);
                                        alert("发表错误！");
                                    }
                                });
                                return false;
                            }).submit();
                            return false;
                        }
                    },{
                        name: '关闭',
                        callback: function () {
                            return true;
                        }
                    }]
                });
            }else{
                $.alert(data.message);
            }
        },
        error: function (data) {
            $.alertk("系统繁忙，请稍后再试！");
        }
    });
}


function _comment_img(obj) {
    var tthis = $(obj).parent().find(".tl-file");
    var i = 0;
    tthis.find("input").each(function(){
        if ($(this).val() != "") { i++; }
    });
    if (i >= 5) {
        $.alert("最多只能添加5张图片。");
        return false;
    }
    i = 0;
    tthis.find("input").each(function(){
        if ($(this).val() == "") {
            if (i == 0) {
                $(this).click(); i = 1;
            }else{
                $(this).remove();
            }
        }
    });
    var m = Math.round(Math.random() * 10000);
    tthis.append('<input type="file" name="fiels_'+m+'" onchange="_comment_change(this);">');
}

function _comment_change(obj) {
    var filepath = $(obj).val();
    if (filepath == "") { return false; }
    var extStart = filepath.lastIndexOf(".");
    var ext = filepath.substring(extStart,filepath.length).toUpperCase();
    if (ext!=".BMP" && ext!=".PNG" && ext!=".GIF" && ext!=".JPG" && ext!=".JPEG"){
        alert("图片限于bmp,png,gif,jpeg,jpg格式"); $(obj).remove(); return false;
    }
    try {
        var file_size = obj.files[0].size;
        var size = file_size / 1024;
        if(size > 1024){
            alert("上传的图片大小不能超过1M！");
            $(obj).remove(); return false;
        }
    }catch(e){}

    var tthis = $(obj).parent().parent().find(".tl-img"), objUrl = '';
    var $intemp = $('<div class="ibx"><div><img></div><span>删除</span></div>');
    $intemp.find("span").click(function(){
        $(obj).val("").remove();
        $intemp.remove();
    });
    tthis.append($intemp);
    //
    if ($.browser.msie) {
        try {
            objUrl = getObjectURL(obj.files[0]);
            $intemp.find("img").attr("src", objUrl);
        }catch (e) {
            var oob = $intemp.find("img");
            var div = oob.parent("div")[0];
            obj.select();
            if (top != self) {
                window.parent.document.body.focus()
            }else {
                obj.blur()
            }
            var src = document.selection.createRange().text;
            document.selection.empty();
            oob.hide();
            oob.parent("div").css({
                'filter': 'progid:DXImageTransform.Microsoft.AlphaImageLoader(sizingMethod=scale)'
            });
            div.filters.item("DXImageTransform.Microsoft.AlphaImageLoader").src = src
        }
    }else{
        objUrl = getObjectURL(obj.files[0]);
        $intemp.find("img").attr("src", objUrl);
    }
}

function _comment_key(obj) {
    var tthis = $(obj);
    var val = $.trim(tthis.val());
    if (val) {
        tthis.prev("span").hide();
    }else{
        tthis.prev("span").show();
    }
}

function _comment_star(obj, i) {
    var tthis = $(obj).parent();
    tthis.attr("class", "star" + i);
    tthis.prev().val(i);
}

function getObjectURL(file) {
    var url = null ;
    if (window.createObjectURL!=undefined) { // basic
        url = window.createObjectURL(file) ;
    } else if (window.URL!=undefined) { // mozilla(firefox)
        url = window.URL.createObjectURL(file) ;
    } else if (window.webkitURL!=undefined) { // webkit or chrome
        url = window.webkitURL.createObjectURL(file) ;
    }
    return url ;
}

// 添加cookie
var addCookie = function(cookieName, cookieValue, cookieHours) {
    var str = cookieName + "=" + unescape(cookieValue);
    if (cookieHours > 0) {
        var date = new Date();
        var ms = cookieHours * 3600 * 1000;
        date.setTime(date.getTime() + ms);
        str += "; expires=" + date.toGMTString();
    }
    str += "; path=/";
    document.cookie = str;
};

function getcookie(cookiename){
    var cookiestring = document.cookie;
    var start = cookiestring.indexOf(cookiename + '=');
    if (start == -1)
        return   null;
    start += cookiename.length   +   1;
    var end = cookiestring.indexOf( "; ",   start);
    if (end == -1) return unescape(cookiestring.substring(start));
    return unescape(cookiestring.substring(start, end));
}

$(function(){
    $("select").each(function(){
        var val = $(this).attr("data-val");
        if (val && $(this).find("option[value='"+val+"']").length > 0) {
            $(this).val(val).change();
        }
    });
});