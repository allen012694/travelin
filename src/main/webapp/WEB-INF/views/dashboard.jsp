<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<jsp:include page="header.jsp">
    <jsp:param value="TravelIn - ${currentAccount.firstname}" name="headtitle"/>
</jsp:include>


	<div id="profilecontainer">
		<div class="w3-col l3"  style="width: 24%;margin-right: 1%">
			<div class="panel">
				<div class="media media-photo-block">
					<div> <img
						src="<c:url value="/resources/images/accounts/${currentAccount.id}/avatar.jpg"/>"
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

				<div class="panel-body" style="padding:0px">
					<ul class="list-unstyled text-bold">
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

		<div class="w3-col l9"  style="width: 74%;margin-left: 1%">
			<div class="panel">
				<div class="panel-header">Thông báo</div>

				<div class="panel-body" id="notipanel">
					<ul class="list-unstyled">
						<c:if test="${not empty notis}">
							<c:forEach items="${notis}" var="noti">
								<li>
									<c:if test="${noti.object.objecttype == 'relationship'}">
										<span>${noti.actor.username} 
											<c:if test="${noti.action == 'request'}">
												vừa gửi lời đề nghị kết bạn. 
												<button type="button" class="btn w3-white" onclick="acknowledge(event,${noti.id},'relationship','n')" style="float:right; margin-left:2px; padding: 0 4px;">N</button>
												<button type="button" class="btn w3-white" onclick="acknowledge(event,${noti.id},'relationship','y')" style="float:right; margin-right:2px; padding: 0 4px;">Y</button>
											</c:if>
											<c:if test="${noti.action == 'accept'}">
												đã đồng ý kết bạn. <button type="button" class="btn w3-white" onclick="acknowledge(event,${noti.id},'relationship')" style="float:right; padding: 0 4px;" data-link="profile?k=${noti.actor.id}">Đã xem</button>
											</c:if>
										</span>
										
									</c:if>
									<c:if test="${noti.object.objecttype == 'journal'}">
										<span>${noti.actor.username} 
											<c:if test="${noti.action == 'share'}">
												vừa chia sẻ 1 chuyến đi mới. 
											</c:if>
											<c:if test="${noti.action == 'suggest'}">
												vừa đề xuất đến bạn một chuyến đi. 
											</c:if>
										</span>
										<button type="button" class="btn w3-white" onclick="acknowledge(event,${noti.id},'journal')" data-link="journals/${noti.detailobjectid}" style="float:right; padding: 0 4px;">Xem</button>
									</c:if>
									<c:if test="${noti.object.objecttype == 'place'}">
										<span>${noti.actor.username} 
											<c:if test="${noti.action == 'suggest'}">
												vừa đề xuất đến bạn một địa điểm. 
											</c:if>
										</span>
										<button type="button" class="btn w3-white" onclick="acknowledge(event,${noti.id},'place')">Đã xem</button>
									</c:if>
									<c:if test="${noti.object.objecttype == 'article'}">
										<span>${noti.actor.username} 
											<c:if test="${noti.action == 'suggest'}">
												vừa đề xuất đến bạn một bài viết. 
											</c:if>
										</span>
										<button type="button" class="btn w3-white" onclick="acknowledge(event,${noti.id},'article')">Đã xem</button>
									</c:if>
									<c:if test="${noti.object.objecttype == 'account'}">
										<span>
											<c:if test="${noti.action != 'promote'}">
												${noti.actor.username}
											</c:if>
											<c:if test="${noti.action == 'suggest'}">
												muốn giới thiệu cho bạn một người. 
											</c:if>
											<c:if test="${noti.action == 'promote'}">
												Tài khoản của bạn vừa được phân quyền . 
											</c:if>
										</span>
										<button type="button" class="btn w3-white" onclick="acknowledge(event,${noti.id},'account')">Đã xem</button>
									</c:if>
									<hr class="section-divider">
								</li>
							</c:forEach>
						</c:if>
					</ul>
				</div>
			</div>
		</div>
	</div>
<jsp:include page="footer.jsp"></jsp:include>
<script type="text/javascript">
	$('#changeAvatar').unbind().on('click',function(){
		    $('#chooseImageBtn').click();
		});
		
	var acknowledge = function(e, notiId, objtype, answer) {
		var btn = $(e.target);
		$.ajax({
			url: "/travelin/noti/ack",
			type: "POST",
			data: {
				'noid': notiId,
				// 'responseCode' : resStatus
				'notiobjtype': objtype,
				'answer': answer
			},
			dataType: 'json'
		}).success(function(data) {
			// console.log(data);
			btn.parent().remove();
			if (btn.attr('data-link') !== undefined) {
				var link = "/travelin/" + btn.attr('data-link');
				window.location.href=link;
			}
		})
	}
</script>