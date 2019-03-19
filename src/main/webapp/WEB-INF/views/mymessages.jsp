<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<jsp:include page="header.jsp">
	<jsp:param value="TravelIn - Tin nhắn"
		name="headtitle" />
</jsp:include>

<input id="currentAccountId" type="hidden" value="${currentAccount.id }"/>
<div id="profilecontainer">
	<div class="w3-col l3" style="width: 24%; margin-right: 1%">
		<div class="panel">
			<div class="media media-photo-block">
				<div> <img src="<c:url value="/resources/images/accounts/${currentAccount.id}/avatar.jpg"/>"
					style="width: 100%; height: 220px;" class="img-responsive">
				</div>
			</div>
			<div class="panel-body">
					<h2 class="text-center" style="margin-top: 0;">${currentAccount.username}</h2>
					<ul class="list-unstyled text-center text-bold" style="margin-bottom: 0;">
						<li><a href="/travelin/profile?k=${currentAccount.id}" class="link-styled">Xem hồ sơ</a></li>
					</ul>
				</div>
		</div>

		<div class="panel">
			<div class="panel-header">Chuyển tiếp</div>

			<div class="panel-body" style="padding:0px;">
					<ul class="list-unstyled text-bold"style="padding-top:20px;">
					<c:if test="${(currentAccount.role == 1) || (currentAccount.role == 2) || (currentAccount.role == 3)}">
						<a href="/travelin/admin"><li style="padding: 20px 20px 0px 20px; margin-bottom: -20px;">Trang quản trị<hr></li></a>
					</c:if>
						<a href="/travelin/myjournals"><li style="padding: 20px 20px 0px 20px; ">Chuyến đi của bạn<hr></li></a>
						<a href="/travelin/favorite/list"><li style="padding: 0px 20px 0px 20px;">Danh sách yêu thích<hr></li></a>
						<a href="/travelin/list-friends"><li style="padding: 0px 20px 0px 20px;">Bạn bè<hr></li></a>
						<a href="/travelin/messages"><li style="padding: 0px 20px 0px 20px;">Tin nhắn<hr></li></a>
						<a href="/travelin/logout"><li style="padding: 0px 20px 20px 20px;">Đăng xuất</li></a>
					</ul>
				</div>
		</div>
	</div>

	<div class="w3-col l9" style="width: 74%; margin-left: 1%">
		<div class="panel">

			<c:if test="${convid != null}">
				<input type="hidden" name="convid" value="${convid}">
			</c:if>
			<div class="w3-col l4" id="messengers" >
			<div id="searchmessenger"><input type="text" id="searchsender" placeholder="Nhập tên bạn bè..."></input></div>
			<div id="senders">
				<c:if test="${not empty conversations }">
					<c:forEach items="${conversations }" var="conversation">
					<div class="w3-row" style="margin-left:95%;width:5%;font-size: 12px;height:0;line-height:20px;"><span id="deletemark" style="cursor:pointer;z-index:" onclick="removeConv(${conversation.id}, event)">X</span></div>
						<div class="w3-row sender" data-id="${conversation.id}">
						
							<c:if test="${conversation.accountfirst.id == currentAccount.id}">
								<div class="w3-col l3">
									<a href="/travelin/profile?k=${conversation.accountsecond.id}"> <img
										src="<c:url value="/resources/images/accounts/${conversation.accountsecond.id}/avatar.jpg"/>" style="width: 50px; height: 50px;" class="img-responsive">
									</a>
								</div>
								<div class="w3-col l9" >${conversation.accountsecond.username}</div>
							</c:if>
							<c:if test="${conversation.accountsecond.id == currentAccount.id}">
								<div class="w3-col l3">
									<a href="/travelin/profile?k=${conversation.accountfirst.id}"> <img
										src="<c:url value="/resources/images/accounts/${conversation.accountfirst.id}/avatar.jpg"/>"
										style="width: 50px; height: 50px;" class="img-responsive">
									</a>
								</div>
								<div class="w3-col l9" >${conversation.accountfirst.username}</div>
							</c:if>
							<c:if test="${unreadCounts[conversation.id] > 0}"><div class="notimess">!</div></c:if>
						</div>
					</c:forEach>
				</c:if>
				<!-- <div class="w3-row sender"></div>
				<div class="w3-row sender"></div>
				<div class="w3-row sender"></div>
				<div class="w3-row sender"></div>
				<div class="w3-row sender"></div>
				
				<div class="w3-row sender new" ></div>
				<div class="w3-row sender active"></div> -->
			</div>	
			</div>
			
			<div class="w3-col l8" id="message" >
				<div id="sendername"></div>
				<div id="messagecontent" data-id=""></div>
				<div id="composer">
					<textarea class="w3-input" id="messagebox" placeholder="Viết tin nhắn..."
								style="resize:none;border: 1px solid #2e2e2e" rows="3" ></textarea>
					<button class="w3-btn w3-red send-btn" type="button" class="w3-btn w3-red" style="float: right;" onclick="pushmsg(event)" data-uid="${currentAccount.id}" data-un="${currentAccount.username}">Gửi</button>
				</div>
			</div>
		</div>
	</div>
</div>
<jsp:include page="footer.jsp"></jsp:include>
<script type="text/javascript">
	var removeConv = function(convid, e) {
		$.ajax({
			url: '/travelin/messages/delconv',
			type:'POST',
			dataType: 'JSON',
			data: {
				'convid': convid,
			}
		}).success(function(data) {
			if (data.status == 1) {
				$('#senders').find('div[data-id="' + convid + '"]').prev().remove();
				$('#senders').find('div[data-id="' + convid + '"]').remove();
				if ($('#messagecontent').attr('data-id') == convid) {
					$('#messagecontent').attr('data-id','');
					$('#sendername').empty();
					$('#messagecontent').empty();
					$('.send-btn').hide();
				}
			}
		});
	};
	var dataSet;
	$('#searchsender').on('keyup',(function(){
	    $.ajax({
	        url:'/travelin/messages/searchsenders',
	        data: {
	            'k': $(this).val()
	        },
	        dataType: 'JSON',
	        contentType: "application/json; charset=utf-8",
	        type: "GET"
	    }).success(function(data){
	        
	        $('#senders').html("");
	        for(var i = 0; i <= data[0].length-1;i++){
	            
	            $('#senders').append("<div class='w3-row deletemark'><span id='deletemark'>X</span></div>");
	            $('#senders').append("<div class='w3-row sender' data-id="+data[0][i].id+"></div>");
	            if(data[0][i].accountfirst.id == $("#currentAccountId").val()){
	                $(".sender[data-id='"+data[0][i].id+"']").append("<div class='w3-col l3'></div>");
	                $(".sender[data-id='"+data[0][i].id+"'] .l3").append("<a href='/travelin/profile?k="+data[0][i].accountsecond.id+"'>"
								+"<img src='<c:url value='/resources/images/accounts/"+data[0][i].accountsecond.id+"/avatar.jpg'/>' style='width: 50px; height: 50px;' class='img-responsive'></a>"
							
					);	
	                $(".sender[data-id='"+data[0][i].id+"']").append("<div class='w3-col l9' >"+data[0][i].accountsecond.username+"</div>");
	                        
	            }
	            if(data[0][i].accountsecond.id == $("#currentAccountId").val()){
	                $(".sender[data-id='"+data[0][i].id+"']").append("<div class='w3-col l3'></div>");
	                $(".sender[data-id='"+data[0][i].id+"'] .l3").append("<a href='/travelin/profile?k="+data[0][i].accountfirst.id+"'>"
								+"<img src='<c:url value='/resources/images/accounts/"+data[0][i].accountfirst.id+"/avatar.jpg'/>' style='width: 50px; height: 50px;' class='img-responsive'></a>"
							
	                );	
	                $(".sender[data-id='"+data[0][i].id+"']").append("<div class='w3-col l9' >"+data[0][i].accountfirst.username+"</div>"
						);
	                        
	            }
	            if (data[1][data[0][i].id] > 0){  $(".sender[data-id='"+data[0][i].id+"']").append("<div class='notimess'><i class='fa fa-circle' style='float:right;color:red'></i></div>")}
	        }
	        $('.sender').unbind().on('click',function(){
	       	    
	    		var convPanel = $(this);
	    		convPanel.parent().find('.active').removeClass("active");
	    		convPanel.addClass("active");
	    		$('#sendername').empty();
	    		$('#sendername').append(convPanel.find('.l3').clone());
	    		$('#sendername').append(convPanel.find('.l9').clone());

	    		var msgbox = $('#messagecontent');
	    		msgbox.empty();
	    		$.ajax({
	    			url: '/travelin/messages/acquire',
	    			data: {
	    				'cid': convPanel.attr('data-id')
	    			},
	    			dataType: 'JSON',
	    			type: 'POST'
	    		}).success(function(data) {
	    			convPanel.find('div.notimess').remove();
	    			msgbox.attr('data-id',convPanel.attr('data-id'));
	    			for (var i = 0; i < data.length; i++) {
	    				msgbox.prepend('<div class="onemessage">'+data[i].fromaccount.username+': '+data[i].content+'</div>')
	    			}
	    			$('.send-btn').show();
	    			msgbox.animate({ scrollTop: msgbox.height() }, 0);
	    			stompClient.send("/travelin/seen/"+$('#ijklmn').text(),{},convPanel.attr('data-id'));
	    		});
	       	});
	    }).error(function(){
	        $('#senders').html("<div style='padding:5px 5%'>Không tìm thấy</div>");
	    })
	}))
   	$('.sender').unbind().on('click',function(){
   	    
		var convPanel = $(this);
		convPanel.parent().find('.active').removeClass("active");
		convPanel.addClass("active");
		$('#sendername').empty();
		$('#sendername').append(convPanel.find('.l3').clone());
		$('#sendername').append(convPanel.find('.l9').clone());

		var msgbox = $('#messagecontent');
		msgbox.empty();
		$.ajax({
			url: '/travelin/messages/acquire',
			data: {
				'cid': convPanel.attr('data-id')
			},
			dataType: 'JSON',
			type: 'POST'
		}).success(function(data) {
			convPanel.find('div.notimess').remove();
			msgbox.attr('data-id',convPanel.attr('data-id'));
			for (var i = 0; i < data.length; i++) {
				msgbox.prepend('<div class="onemessage">'+data[i].fromaccount.username+': '+data[i].content+'</div>')
			}
			$('.send-btn').show();
			msgbox.animate({ scrollTop: msgbox.height() }, 0);
			stompClient.send("/travelin/seen/"+$('#ijklmn').text(),{},convPanel.attr('data-id'));
		});
   	});
   	function pushmsg(event) {
   		var btn = $(event.target);
   		// console.log(btn.prev().val());
   		var msgbox = $('#messagecontent');
   		var msg = {
   			'fromaccount': {'id': parseInt(btn.attr('data-uid')), 'username': btn.attr('data-un') },
   			'content': btn.prev().val(),
   			'conversation': {'id': parseInt(btn.parent().prev().attr('data-id'))},
   		};
   		sendMsg(btn.attr('data-uid'), JSON.stringify(msg));
   		msgbox.append('<div class="onemessage">'+btn.attr('data-un')+': '+btn.prev().val()+'</div>');
   		msgbox.animate({ scrollTop: msgbox.height() }, "slow");
   		btn.prev().val('');
   	};
   	$(document).ready(function() {
   		$('.send-btn').hide();
   	 // 	$('.send-btn').hide();
   		var newTargetConv = $('input[name="convid"]');
   		if (newTargetConv.length > 0) {
   		 // $('.send-btn').show();
   			$('#senders').find('div[data-id="'+newTargetConv.val()+'"]').trigger('click');
   		}
   		// var prevURL = (window.location.search).contains("t=${accountProfile.id}");
     //    if(prevURL == true)
     //        $('.send-btn').show();
     //    else
     //      alert("Not proper prev page");
       	
   		// if ($('input[name="convid"]').length > 0) $('.send-btn').show();
   	});
   	// $('.')
</script>