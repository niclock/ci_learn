window.wxShare = function(wxJssdk, shareData, callback) {
    if (typeof wxJssdk === "undefined") {
        if (typeof callback === 'function') callback(false);
        return;
    }
    if (typeof shareData === "undefined") {
        if (typeof callback === 'function') callback(false);
        return;
    }
    var ua = window.navigator.userAgent.toLowerCase();
    if(ua.match(/MicroMessenger/i) !== 'micromessenger'){
        if (typeof callback === 'function') callback(false);
        return;
    }
    //
    if (window.__wx_share_load_js !== true) {
        window.__wx_share_load_js = true;
        //
        var script = document.createElement("script");
        script.type = "text/javascript";
        script.src = "http://res.wx.qq.com/open/js/jweixin-1.0.0.js";
        document.body.appendChild(script);
    }
    if (typeof wx === "undefined") {
        setTimeout(function(){ wxShare(wxJssdk, shareData, callback); }, 100);
        return;
    }
    // 是否启用调试
    wxJssdk.debug = false;
    //
    wxJssdk.jsApiList = [
        'checkJsApi',
        'onMenuShareTimeline',
        'onMenuShareAppMessage',
        'onMenuShareQQ',
        'onMenuShareWeibo'
    ];
    wx.config(wxJssdk);
    wx.ready(function() {
        wx.onMenuShareAppMessage(shareData);
        wx.onMenuShareTimeline(shareData);
        wx.onMenuShareQQ(shareData);
        wx.onMenuShareWeibo(shareData);
        if (typeof callback === 'function') callback(true);
    });
};