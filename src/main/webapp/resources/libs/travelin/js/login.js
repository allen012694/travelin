jQuery(function($) {
    var mtp = $(window).resize(function() {
        if ($('.noti_bubble').length) {
            $('.noti_bubble').each(function(index, ele) {
                var $img = $(ele).prev();
                $(ele).css({
                    'top' : $img.offset().top,
                    'left' : $img.offset().left + $img.innerWidth() * .8,
                });

            });
        }
    });
    $(document).ready(function() {

        if ($('.noti_bubble').length) {
            $('.noti_bubble').each(function(index, ele) {
                var $img = $(ele).prev();
                $(ele).css({
                    'top' : $img.offset().top,
                    'left' : $img.offset().left + $img.innerWidth() * .8,
                });

            });
        }

        $('#login_btn').magnificPopup({
            items : {
                src : $('#popup-login').html(),
                type : 'inline'
            }
        });
        // $('#tempplace_btn').magnificPopup({
        // items : {
        // src : $('#popup-tempplace').html(),
        // type : 'inline',
        // },
        // callbacks: {
        // open: function() {
        // console.log('callback');
        // }
        // }
        // });

        // console.log(111111);
    });
});

var stompClient = null;

function connect(aid) {
    var socket = new SockJS('/travelin/nt');
    stompClient = Stomp.over(socket);
    stompClient.debug = null;
    stompClient.connect({}, function(frame) {
        // console.log('Connected: ' + frame);
        console.log('!Welcome to Travelin!');
        stompClient.subscribe('/topic/nt/' + aid, function(data) {
            // showGreeting(JSON.parse(greeting.body).content);
            // showGreeting(greeting.body);
            // console.log(data);
            // sendMsg(aid,"Open connect");
            notifyWS(JSON.parse(data.body));
        });

        stompClient.subscribe('/topic/remsg/' + aid, function(data) {
            parseMessage(JSON.parse(data.body));
        })
        invokeServer(aid, "Open connect");
    });
};
function disconnect() {
    if (stompClient != null) {
        stompClient.disconnect();
    }
    console.log("Sayonara");
}

function invokeServer(aid, msg) {
    // var name = document.getElementById('name').value;
    stompClient.send("/travelin/go/" + aid, {}, msg);
}

function sendMsg(aid, msg) {
    stompClient.send("/travelin/msg/" + aid, {}, msg);
}

function parseMessage(data) {
    // notificate msg
    var unseenConvers = data[0];
    var newMsg = data[1];
    // console.log(data);
    // console.log(unseenConvers);
    if (unseenConvers.length > 0) {
        $('#message-bubble').text(unseenConvers.length);
        $('#message-bubble').show();
    } else {
        $('#message-bubble').text(0);
        $('#message-bubble').hide();
    }
    // parse message into message box
    if (window.location.pathname === "/travelin/messages" && newMsg != null) {
        var msgbox = $('#messagecontent');
        var conversationlist = $('#senders');

        if (newMsg.conversation.id == msgbox.attr('data-id')) {
            // if user currently focus on the conversation
            msgbox.append('<div class="onemessage">' + newMsg.fromaccount.username + ': ' + newMsg.content + '</div>');
            msgbox.animate({
                scrollTop : msgbox.height()
            }, "slow");
            stompClient.send("/travelin/seen/" + $('#ijklmn').text(), {}, newMsg.conversation.id);
        } else {
            // handle case user not focus on that conversation
            var convPanel = conversationlist.find('div[data-id="' + newMsg.conversation.id + '"]');
            if (convPanel.length > 0) {
                convPanel.append('<div class="notimess">!</div>');
            } else {
                // handle case this is a new conversation
                var html = '<div class="w3-row sender" data-id="' + newMsg.conversation.id + '">'
                        + '<div class="w3-col l3">' + '<a href="/travelin/profile?k=' + newMsg.fromaccount.id + '">'
                        + '<img src="/travelin/resources/images/accounts/' + newMsg.fromaccount.id
                        + '/avatar.jpg" style="width: 50px; height: 50px;" class="img-responsive">'
                        + '</a></div><div class="w3-col l9" >' + newMsg.fromaccount.username
                        + '</div><div class="notimess"><i class="fa fa-circle" style="float:right;color:red"></i></div>';
                var htmlx = '<div class="w3-row" style="margin-left:95%;width:5%;font-size: 12px;height:0;line-height:20px;"><span id="deletemark" style="cursor:pointer;z-index:" onclick="removeConv('+newMsg.conversation.id+', event)">X</span></div>';
                conversationlist.prepend(html); // conversation div
                conversationlist.prepend(htmlx); // remove conversation button
                $('.sender').unbind().on(
                        'click',
                        function() {
                            var convPanel = $(this);
                            convPanel.parent().find('.active').removeClass("active");
                            convPanel.addClass("active");
                            $('#sendername').empty();
                            $('#sendername').append(convPanel.find('.l3').clone());
                            $('#sendername').append(convPanel.find('.l9').clone());

                            var msgbox = $('#messagecontent');
                            msgbox.empty();
                            $.ajax({
                                url : '/travelin/messages/acquire',
                                data : {
                                    'cid' : convPanel.attr('data-id')
                                },
                                dataType : 'JSON',
                                type : 'POST'
                            }).success(
                                    function(data) {
                                        convPanel.find('div.notimess').remove();
                                        msgbox.attr('data-id', convPanel.attr('data-id'));
                                        for (var i = 0; i < data.length; i++) {
                                            msgbox.prepend('<div class="onemessage">' + data[i].fromaccount.username
                                                    + ': ' + data[i].content + '</div>')
                                        }
                                        $('.send-btn').show();
                                        msgbox.animate({
                                            scrollTop : msgbox.height()
                                        }, 0);
                                        stompClient.send("/travelin/seen/" + $('#ijklmn').text(), {}, convPanel
                                                .attr('data-id'));
                                    });
                        });
            }
        }
    }
}

function notifyWS(data) {
    // console.log(data.length);
    // console.log(data);
    if ($('#account-bubble').length) {
        if (data.length > 0) {
            $('#account-bubble').text(data.length);
            $('#account-bubble').show();
        } else {
            $('#account-bubble').text(0);
            $('#account-bubble').hide();
        }
    }

    if (window.location.pathname === "/travelin/dashboard") {
        if ($('#notipanel').length) {
            var listNoti = $('#notipanel ul');
            var currentNotis = listNoti.find('li');
            if (currentNotis.length !== data.length) {
                listNoti.animate({
                    opacity : 0
                }, 1);
                listNoti.empty();
                for (var i = 0; i < data.length; i++) {
                    var htm = "";
                    if (data[i].object.objecttype === "relationship") {
                        var descript = "";
                        if (data[i].action === "request")
                            descript = 'vừa gửi lời đề nghị kết bạn. '
                                    + '<button type="button" class="btn w3-white" onclick="acknowledge(event,'
                                    + data[i].id + ',\'relationship\',\'n\')" style="float:right; margin-left:2px; padding: 0 4px;">N</button>'
                                    + '<button type="button" class="btn w3-white" onclick="acknowledge(event,'
                                    + data[i].id + ',\'relationship\',\'y\')" style="float:right; margin-right:2px; padding: 0 4px;">Y</button> ';
                        else if (data[i].action === "accept")
                            descript = 'đã đồng ý kết bạn. '
                                    + '<button type="button" class="btn w3-white" onclick="acknowledge(event,'
                                    + data[i].id + ',\'relationship\')" style="float:right; padding: 0 4px;" data-link="profile?k='+data[i].actor.id+'">Đã xem</button>';
                        htm = '<li><span>' + data[i].actor.username + ' ' + descript
                                + '</span><hr class="section-divider"></li>';
                    } else if (data[i].object.objecttype === "journal") {
                        var descript = 'vừa chia sẻ 1 chuyến đi mới.';
                        htm = '<li><span>' + data[i].actor.username + ' ' + descript
                                + '</span> <button type="button" class="btn w3-white" onclick="acknowledge(event,'
                                + data[i].id + ',\'journal\')" style="float:right; padding: 0 4px;" data-link="journals/'+data[i].detailobjectid+'">Xem</button>' + '<hr class="section-divider"></li>';
                    } else if (data[i].object.objecttype === "place") {

                    } else if (data[i].object.objecttype === "article") {

                    }
                    listNoti.append($(htm));
                }
                listNoti.animate({
                    opacity : 1
                }, 500);
            }
        }
    }
}