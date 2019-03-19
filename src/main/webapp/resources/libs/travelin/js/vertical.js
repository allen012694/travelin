jQuery(function($) {
    'use strict';

    // -------------------------------------------------------------
    // Place Details
    // -------------------------------------------------------------
    /*
     * (function getAreaDescription(itemIndex) { {
     */
    (function() {
        var $frame = $('#framedetails');
        var $wrap = $frame.parent();

        // Call Sly on frame
        $frame.sly({
            mouseDragging : 1,
            touchDragging : 1,
            releaseSwing : 1,
            speed : 300,
            easing : 'easeOutExpo',
            pagesBar : null,
            activatePageOn : 'click',
            scrollBar : $wrap.find('.scrollbar'),
            scrollBy : 100,
            dragHandle : 1,
            dynamicHandle : 1,
            clickBar : 1,

        // Buttons
        /*
         * forward : $wrap.find('.forward'), backward : $wrap.find('.backward'),
         * prevPage : $wrap.find('.prevPage'), nextPage :
         * $wrap.find('.nextPage')
         */
        });

        // To Start button
        /*
         * $wrap.find('.toStart').on('click', function() { var item =
         * $(this).data('item'); // Animate a particular item to the start of
         * the frame. // If no item is provided, the whole content will be //
         * animated. $frame.sly('toStart', item); });
         */
        // To Center button
        /*
         * $wrap.find('.toCenter').on('click', function() { var item =
         * $(this).data('item'); // Animate a particular item to the center of
         * the frame. // If no item is provided, the whole content will be //
         * animated. $frame.sly('toCenter', item); });
         */

        // To End button
        /*
         * $wrap.find('.toEnd').on('click', function() { var item =
         * $(this).data('item'); // Animate a particular item to the end of the
         * frame. // If no item is provided, the whole content will be //
         * animated. $frame.sly('toEnd', item);
         */

        /**/
        /*
         * }) }, })
         */
    }());

    // -------------------------------------------------------------
    // Places List
    // -------------------------------------------------------------

    $(document).ready(function() {
        getAllAreas();

    });

    function getAllAreas() {
        $
                .ajax({
                    type : "POST",
                    url : "/travelin/getAllCities",
                    success : function(result) {
                        (function() {
                            var $frame = $('#framelist');
                            var $slidee = $frame.children('ul').eq(0);
                            var $wrap = $frame.parent();

                            // Call Sly on frame
                            $frame.sly({
                                itemNav : 'centered',
                                smart : 1,
                                activateOn : 'click',
                                mouseDragging : 1,
                                touchDragging : 1,
                                releaseSwing : 1,
                                startAt : 1,
                                scrollBar : $wrap.find('.scrollbar'),
                                scrollBy : 1,
                                pagesBar : $wrap.find('.pages'),
                                activatePageOn : 'click',
                                speed : 300,
                                elasticBounds : 1,
                                easing : 'easeOutExpo',
                                dragHandle : 1,
                                dynamicHandle : 1,
                                clickBar : 1,

                                // Buttons
                                forward : $wrap.find('.forward'),
                                backward : $wrap.find('.backward'),
                                prev : $wrap.find('.prev'),
                                next : $wrap.find('.next'),
                                prevPage : $wrap.find('.prevPage'),
                                nextPage : $wrap.find('.nextPage')
                            });
                            $
                            // To Start button
                            $wrap.find('.toStart').on('click', function() {
                                var item = $(this).data('item');
                                // Animate a particular item to the start of the
                                // frame.
                                // If no item is provided, the whole content
                                // will be
                                // animated.
                                $frame.sly('toStart', item);
                            });

                            // To Center button
                            $wrap.find('.toCenter').on('click', function() {
                                var item = $(this).data('item');
                                // Animate a particular item to the center of
                                // the frame.
                                // If no item is provided, the whole content
                                // will be
                                // animated.
                                $frame.sly('toCenter', item);
                            });

                            // To End button
                            $wrap.find('.toEnd').on('click', function() {
                                var item = $(this).data('item');
                                // Animate a particular item to the end of the
                                // frame.
                                // If no item is provided, the whole content
                                // will be
                                // animated.
                                $frame.sly('toEnd', item);
                            });

                            // Add item
                            $wrap.find('.add').on('click', function() {

                            });
                            for (var i = 0; i < result.length; i++) {
                                $frame.sly('add', '<li data-id="' + result[i].id + '">' + result[i].name + '</li>');

                            }

                            // Remove item
                            $wrap.find('.remove').on('click', function() {
                                $frame.sly('remove', -1);
                            });
                            $frame
                                    .sly(
                                            "on",
                                            "active",
                                            function(e, itemIndex) {
                                                /* getAreaDescription(itemIndex); */
                                                var areaId = this.items[itemIndex].el.getAttribute("data-id");
                                                $
                                                        .ajax({
                                                            type : "POST",
                                                            url : "/travelin/getAreaDescription",
                                                            contentType : 'application/json',
                                                            data : JSON.stringify({
                                                                id : areaId
                                                            }),
                                                            success : function(result) {
                                                                var $framedetails = $('#framedetails');

                                                                $framedetails.sly('remove', '#detailsName');
                                                                $framedetails.sly('remove', '#detailsImg');
                                                                $framedetails.sly('remove', '#detailsDescription');
                                                                $framedetails.sly('remove', '#details_btn');

                                                                $framedetails.sly('add', '<div class="w3-row"><h1 id="detailsName">'
                                                                        + result.name + '</h1>'
                                                                        + '<button class="w3-btn" style="float:right;margin-top:-60px;" id="details_btn" data-id="'
                                                                                + result.id + '">Tìm Hiểu</button></div>');
                                                                $framedetails.sly('add',
                                                                        '<img id="detailsImg" src="<c:url value=/../../travelin/resources/images/areas/'
                                                                                + result.id + '.jpg">');
                                                                $framedetails.sly('add',
                                                                        '<div style="padding-bottom:20px" id="detailsDescription">'
                                                                                + result.description + '</div>');

                                                                $framedetails.sly('add',
                                                                        '<div class="mfp-hide" id="popup-details">'
                                                                                + '<div class="mfp-with-anim">'
                                                                                + '<div id="pie_btn"></div>' + '</div>'
                                                                                + '</div>');
                                                                Raphael.fn.pieChart = function(cx, cy, r, values,
                                                                        labels, urls, stroke) {
                                                                    var paper = this, rad = Math.PI / 180, chart = this
                                                                            .set();
                                                                    function sector(cx, cy, r, startAngle, endAngle,
                                                                            params) {

                                                                        var x1 = cx + r * Math.cos(-startAngle * rad), x2 = cx
                                                                                + r * Math.cos(-endAngle * rad), y1 = cy
                                                                                + r * Math.sin(-startAngle * rad), y2 = cy
                                                                                + r * Math.sin(-endAngle * rad);
                                                                        return paper.path(
                                                                                [ "M", cx, cy, "L", x1, y1, "A", r, r,
                                                                                        0,
                                                                                        +(endAngle - startAngle > 180),
                                                                                        0, x2, y2, "z" ]).attr(params);
                                                                    }
                                                                    var angle = 54, total = 0, start = 0, process = function(
                                                                            j) {
                                                                        var value = values[j], angleplus = 360 * value
                                                                                / total, popangle = angle
                                                                                + (angleplus / 2), color = Raphael.hsb(
                                                                                start, .75, 1), ms = 500, delta = 30, bcolor = Raphael
                                                                                .hsb(start, 1, 1), p = sector(cx, cy,
                                                                                r, angle, angle + angleplus, {
                                                                                    fill : "90-" + bcolor,
                                                                                    stroke : stroke,
                                                                                    "opacity" : 0,
                                                                                    "stroke-width" : 3,
                                                                                    "stroke-opacity" : 1,
                                                                                }), txt = paper.text(
                                                                                cx + (r + delta + 55)
                                                                                        * Math.cos(-popangle * rad),
                                                                                cy + (r + delta + 25)
                                                                                        * Math.sin(-popangle * rad),
                                                                                labels[j]).attr({
                                                                            fill : bcolor,
                                                                            stroke : "none",
                                                                            opacity : 0,
                                                                            "font-size" : 20
                                                                        });
                                                                        p.click(function() {
                                                                            window.location.href = urls[j];
                                                                        });
                                                                        p.mouseover(function() {
                                                                            this[0].style.cursor = "pointer";
                                                                            p.stop().animate({
                                                                                transform : "s1.1 1.1 " + cx + " " + cy
                                                                            }, ms, "elastic");
                                                                            txt.stop().animate({
                                                                                opacity : 1
                                                                            }, ms, "elastic");
                                                                        }).mouseout(function() {
                                                                            p.stop().animate({
                                                                                transform : ""
                                                                            }, ms, "elastic");
                                                                            txt.stop().animate({
                                                                                opacity : 0
                                                                            }, ms);
                                                                        });
                                                                        angle += angleplus;
                                                                        chart.push(p);
                                                                        chart.push(txt);
                                                                        start += .1;
                                                                    };
                                                                    for (var i = 0, ii = values.length; i < ii; i++) {
                                                                        total += values[i];
                                                                    }
                                                                    for (i = 0; i < ii; i++) {
                                                                        process(i);
                                                                    }
                                                                    return chart;
                                                                };

                                                                $('#details_btn')
                                                                        .click(
                                                                                function() {
                                                                                    var target = $(this);
                                                                                    $.magnificPopup.open({
                                                                                        items : {
                                                                                            src : $('#popup-details')
                                                                                                    .html(),
                                                                                            type : 'inline'
                                                                                        },
                                                                                        removalDelay : 300,
                                                                                        mainClass : 'mfp-zoom-in',

                                                                                        midClick : true

                                                                                    });
                                                                                    $(function(event) {
                                                                                        var values = [ 1, 1, 1, 1, 1 ], labels = [
                                                                                                "Ăn uống", "Sức khỏe",
                                                                                                "Mua sắm", "Giải trí",
                                                                                                "Du lịch" ];
                                                                                        var urls = [
                                                                                                "/travelin/places?group=1&aid="
                                                                                                        + target
                                                                                                                .attr("data-id"),
                                                                                                "/travelin/places?group=3&aid="
                                                                                                        + target
                                                                                                                .attr("data-id"),
                                                                                                "/travelin/places?group=5&aid="
                                                                                                        + target
                                                                                                                .attr("data-id"),
                                                                                                "/travelin/places?group=4&aid="
                                                                                                        + target
                                                                                                                .attr("data-id"),
                                                                                                "/travelin/places?group=2&aid="
                                                                                                        + target
                                                                                                                .attr("data-id"), ]
                                                                                        var pie_holder = Raphael(
                                                                                                "pie_btn", "100%", 500);
                                                                                        pie_holder
                                                                                                .circle(350, 270, 200)
                                                                                                .attr(
                                                                                                        {
                                                                                                            fill : "url(resources/libs/travelin/img/fullbtn.jpg)"
                                                                                                        });
                                                                                        pie_holder.pieChart(350, 270,
                                                                                                200, values, labels,
                                                                                                urls, "#000");

                                                                                    });
                                                                                });

                                                            },
                                                            error : function(e) {
                                                                alert("Get Description Failed");
                                                            }
                                                        });
                                            });
                        }());
                        $('#framelist').sly('activate', 0);
                    },
                    error : function(e) {
                        alert("Get Area List Failed");
                    }
                });

    }
});