jQuery(function($) {
    'use strict';

    // -------------------------------------------------------------
    // Banner
    // -------------------------------------------------------------
    var iCur = 1, total = 5, duration = 0.6, delay = 0.15;
    var iDir = -1; // direction: -1 = go to right, 1 = go to left
    var obj = $('.banner').eq(iCur - 1);
    var box = $('.bannerHolder');
    var stopLeft = 6; // 6%

    function tweenUpdate() {
        var outTL = new TimelineLite({
            onComplete : moveIn
        });
        outTL.to(obj.children('h1'), duration, {
            left : (iDir * 100) + '%',
            opacity : 0,
            ease : Back.easeIn
        }).to(obj.children('p'), duration, {
            left : (iDir * 100) + '%',
            opacity : 0,
            ease : Back.easeIn
        }, delay).to(obj.children('img'), duration, {
            right : -iDir * 100 + '%',
            opacity : 0,
            ease : Back.easeIn
        }, 2 * delay).to(box, duration, {
            backgroundPosition : '+=' + (-iDir) + '%'
        }, delay)
        function moveIn() {
            obj = $('.banner').eq(iCur - 1);
            var inTL = new TimelineLite();
            inTL.fromTo(obj.children('h1'), duration, {
                left : (-iDir * 100) + '%',
                opacity : 0
            }, {
                left : stopLeft + '%',
                opacity : 1,
                ease : Back.easeOut
            }).fromTo(obj.children('p'), duration, {
                left : (-iDir * 100) + '%',
                opacity : 0
            }, {
                left : stopLeft + '%',
                opacity : 1,
                ease : Back.easeOut
            }, delay).fromTo(obj.children('img'), duration, {
                right : iDir * 100 + '%',
                opacity : 0
            }, {
                right : 0 + '%',
                opacity : 1,
                ease : Back.easeOut
            }, 2 * delay)
        }
        $('.BannerNav li a').removeClass('active');
        $('.BannerNav li a').eq(iCur - 1).addClass('active');
    }
    $('.BannerNav li a').eq(iCur - 1).addClass('active');
    $('.BannerNav li a').click(function() {

        var nextOne = $('.BannerNav li a').index(this) + 1;
        if (nextOne != iCur) {
            if (nextOne < iCur) {
                iDir = 1;

            } else {
                iDir = -1;
            }
            iCur = nextOne;
            tweenUpdate();
        }
        return false;
    })
    /*
     * var myBannerAuto = setInterval(function(){iCur = iCur % total + 1; iDir =
     * -1;tweenUpdate();},5000)
     */
    $('#goNext,#goPrev').click(function() {
        if (this.id == 'goNext') {
            iCur = iCur % total + 1;
            iDir = -1;
            /* clearInterval(myBannerAuto); */
        } else {
            iCur--;
            iCur = iCur == 0 ? total : iCur;
            iDir = 1;
            /* clearInterval(myBannerAuto); */
        }
        tweenUpdate();
        /*
         * myBannerAuto = setInterval(function(){iCur = iCur % total + 1; iDir =
         * -1;tweenUpdate();},5000);
         */
        return false;
    })

})