<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%-- <%@ include file="header.jsp" %> --%>
<jsp:include page="header.jsp">
	<jsp:param value="TravelIn - Chuyến đi" name="headtitle" />
</jsp:include>
<div class="w3-row" id="journalHeader">
	<div class="w3-col" id="journalInfo"
		style="width: 74%; height: 100%; margin-right: 1%">

		<div id="journalName">${curJour.title }</div>
		<span id="cid" style="display:none;">${curJour.id}</span>
	</div>
	<div class="w3-col" id="journalAuthor"
		style="display: inline-block; width: 19%; height: 100%; margin-left: 1%; margin-right: 5%; text-align: center">
		<div style="margin-bottom: 50px;">
			<a href="/travelin/profile?k=${curJour.author.id}"><img class="circled"
				src="<c:url value="/resources/images/accounts/${curJour.author.id}/avatar.jpg"/>"></a>
		</div>
		<a href="/travelin/profile?k=${curJour.author.id}"
			style="margin-top: 20px; color: #faf5ef; font-size: 16px; font-weight: 600; text-decoration: none">${curJour.author.username }</a>
	</div>

	<div class="w3-row" id="journalGlass"></div>
	<div class="w3-row" id="journalBlur"></div>
</div>
<div class="content">
	<div class="w3-row" id="journal">
		<div class="w3-col l8" id="journalmain">

			<c:if test="${currentJournal != null}">
				<input type="hidden" value="cj" id="cj"></input>
			</c:if>

			<div id="body">
				<div id="time" style="padding-bottom: 20px">
					<fmt:formatDate type="both" dateStyle="short" timeStyle="short"
						value="${curJour.createddate }" pattern="dd/MM/yyyy HH:mm:ss" />
					đăng bởi <a href="/travelin/profile?k=${curJour.author.id}"
						style="color: #d54859; font-weight: 600; text-decoration: none">${curJour.author.username }</a>
				</div>

				<div id="locations">
					<div id="mapzone" style="width: 100%; height: 600px;"></div>
				</div>
				<div class="w3-row collection" style="padding-left:0; margin-top:20px;">
					<c:if test="${not empty curPlaces }">
						<c:forEach items="${curPlaces }" var="place" varStatus="i">
							<div class="w3-col card" style="border:1px solid rgba(46,46,46,0.5);margin:20px 1%; width: 31.33%" data-lat="${place.latitude}"
								data-lng="${place.longtitude}">
								<img data-holder-rendered="true"
									src="<c:url value="/resources/images/places/${place.id}/theme.jpg"/>"
									style="height: 180px; width: 100%; display: block;"
									class="card-img-top" data-src="holder.js/100px180/"
									alt="100%x180">
								<div class="card-block">
									<div class="card-middle">
										<h4 class="card-title">
											<a href="/travelin/places/${place.id}">${place.name}</a>
										</h4>
										<div class="w3-row card-detail">${place.address}</div>
									</div>
								</div>
							</div>
						</c:forEach>
					</c:if>
				</div>
				<div style="padding: 20px 0px">${curJour.content }</div>
				<div id="banner">Hình ảnh</div>
				<div class="w3-row">
					<div id="journalImg">
						<div class="fotorama" data-fit="contain" data-nav="thumbs"
							data-allowfullscreen="true">
							<img
								src="<c:url value="/resources/images/journals/${curJour.id}/theme.jpg"/>">
							<c:if test="${not empty journalImgs}">
								<c:forEach items="${journalImgs}" var="imgname">
									<img
										src="<c:url value="/resources/images/journals/${curJour.id}/${imgname}"/>">
								</c:forEach>
							</c:if>
						</div>
					</div>

					<input type="hidden" value="${curPlace.latitude}" id="cla">
					<input type="hidden" value="${curPlace.longtitude}" id="clo">
					<!-- <button class="w3-btn w3-red">up ảnh</button> -->
				</div>
				<div class="w3-row" id="tags">
					<span style="font-weight: bold; font-family: 'UTMBEBAS'; font-size: 20px;">Từ khóa:</span>
					<c:if test="${not empty curTags }">
						<c:forEach items="${curTags }" var="tag">
							<a href="/travelin/search?t=${tag }" id="tag">${tag }</a>
						</c:forEach>
					</c:if>
				</div>
				<!-- <button class="w3-btn w3-red">up ảnh</button> -->
				<%-- <div>
					<form:form action="/travelin/journals/uploadFileImage" method="POST"
						enctype="multipart/form-data">
						<input type="file" name="upfiles" multiple="">
						<input type="hidden" name="pid" value="${curPlace.id}">
						<input type="submit" class="w3-btn w3-red" value="Đăng ảnh">
					</form:form>
				</div> --%>
			</div>
			<div class="w3-row" id="comments">
				<div id="banner">BÌNH LUẬN</div>
				<c:if test="${currentAccount.email != null}">

					<form:form action="/travelin/journals/comments/new" method="POST"
						modelAttribute="newComment" acceptCharset="utf8" onkeypress="return event.keyCode != 13;">
						<input type="hidden" name="journalid" value="${curJour.id }">
						<div class="w3-row">
							<div class="w3-col l2">
								<img class="circled" width="80" height="80"
									src="<c:url value="/resources/images/accounts/${currentAccount.id }/avatar.jpg"  />"
									alt="${currentAccount.username }">
							</div>
							<form:textarea class="w3-input w3-col l10" id="commenttext"
								style="resize:none" rows="5" path="content" />
						</div>

						<input type="submit" class="w3-col l2 w3-btn" id="commentbtn"
							value="Gửi">

					</form:form>
					<div class="w3-row" id="seperate"></div>

				</c:if>
				<c:if test="${not empty comments }">
					<c:forEach items="${comments }" var="comment" varStatus="i">
						<div class="w3-row" id="commentsitem">
							<div class="w3-col l2">
								<img class="circled" width="80" height="80"
									src="<c:url value="/resources/images/accounts/${comment.account.id }/avatar.jpg"  />"
									alt="">
							</div>
							<div class="w3-col l10" data-id="${comment.id}">
								<div id="author" style="color: #d54859; font-weight: 600;">${comment.account.username }</div>


								<div id="body">${comment.content }</div>
								<div id="time">
									<fmt:formatDate type="both" dateStyle="short" timeStyle="short"
										value="${comment.createddate }" pattern="dd/MM/yyyy HH:mm:ss" />
								</div>
								<div id="like">
									<c:if test="${currentAccount.email != null}">
										<c:if test="${likes[i.index].account != null}">
											<a href="#" style="color: #d54859; text-decoration: none"
												class="like-btn" role="button"
												onclick="removeLikeComment(event); return false">Bỏ thích</a>
										</c:if>
										<c:if test="${likes[i.index].account == null}">
											<a href="#" style="color: #d54859; text-decoration: none"
												class="like-btn" role="button"
												onclick="addLikeComment(event); return false">Thích</a>
										</c:if>
									</c:if>
									<input type="hidden" id="lid" name="likeid"
										value="${comment.id}">
									<!-- <a href="#" style="color: #d54859;text-decoration:none" >Dislike</a> -->
								</div>
								<div class="countLikeCmt" id="countLikeComment"
									style="display: none">
									<c:if test="${countLikeComment != null}">
										<c:forEach items="${countLikeComment}" var="countLike">
											<c:if test="${countLike.cmtId == comment.id}">

												<input type="hidden" name="count" id="countLikeCmt"
													value="${countLike.countLike}" />
												<i style="color: blue;"><i class='fa fa-thumbs-o-up'></i> <span>${countLike.countLike}</span>
													người đã thích
												</i>

											</c:if>
										</c:forEach>
									</c:if>
								</div>
								
							</div>
							<div class="w3-row" id="seperate"></div>
						</div>
					</c:forEach>
				</c:if>
			</div>
			<div id="journalFooter"></div>

		</div>
		<div class="w3-col l4" id="journalsub">
			<div id="banner">BẢNG ĐIỀU KHIỂN</div>
			<div id="controlpanel">
				<%--<c:if test="${currentAccount.email != null}">--%>
					<c:if test="${fav.account != null}">
						<button class="w3-row w3-btn active" id="likebtn"
							style="background: #d54859;">Đã thích</button>
					</c:if>
					<c:if test="${fav.account == null}">
						<button class="w3-row w3-btn" id="likebtn">Yêu thích</button>
					</c:if>
				<%--</c:if>--%>

			</div>
			<div id="banner">CHUYẾN ĐI NỔI BẬT</div>
			<div class="tool-section">
				<c:if test="${not empty hot7DaysJours }">
					<c:forEach items="${hot7DaysJours }" var="jourWithFav">
						<div class="w3-row tool-section-item">
							<div class="w3-col l4">
								<a href="/travelin/journals/${jourWithFav.Id }">
								<img style="width: 100%; height: 80px;"
									src="<c:url value="/resources/images/journals/${jourWithFav.Id }/theme.jpg"  />"
									alt="${jourWithFav.Title }">
									</a>
							</div>
							<div class="w3-col l8">
								<div class="title"><a href="/travelin/journals/${jourWithFav.Id }">${jourWithFav.Title }</a></div>
								<div style="margin: 5px 0 0 5%;"><fmt:formatDate type="both" dateStyle="short"
												timeStyle="short" value="${jourWithFav.CreatedDate }"
												pattern="dd/MM/yyyy HH:mm:ss" /></div>
							</div>
							<div class="w3-row seperate"></div>
						</div>
					</c:forEach>
				</c:if>
			</div>

			<div id="banner">CÙNG NGƯỜI VIẾT</div>
			<div class="tool-section">
				<c:if test="${not empty sameAuJours }">
					<c:forEach items="${sameAuJours }" var="jour">
						<div class="w3-row tool-section-item">
							<div class="w3-col l4">
								<a href="/travelin/journals/${jour.id }">
								<img style="width: 100%; height: 80px;"
									src="<c:url value="/resources/images/journals/${jour.id }/theme.jpg"  />"
									alt="${jour.title }">
									</a>
							</div>
							<div class="w3-col l8">
								<div class="title"><a href="/travelin/journals/${jour.id }">${jour.title }</a></div>
								<div style="margin: 5px 0 0 5%;"><fmt:formatDate type="both" dateStyle="short"
												timeStyle="short" value="${jour.createddate }"
												pattern="dd/MM/yyyy HH:mm:ss" /></div>
							</div>
							<div class="w3-row seperate"></div>
						</div>
					</c:forEach>
				</c:if>
			</div>
	</div>
</div>
<%@ include file="footer.jsp"%>
<script
	src="http://maps.google.com/maps/api/js?key=<spring:eval expression="@credentialsProp.getProperty('google.api.map.key')" />&libraries=geometry,places&v=3.exp&callback=initMap"
	async defer></script>
<script type="text/javascript">
    $(document).ready(
            function() {
                $(window).resize(function() {
                    $('#journalAuthor img').css("height", $('#journalAuthor img').width());
                })
                $('.countLikeCmt').each(function(){
                if($(this).find("#countLikeCmt").val()>0){
                    $(this).show();
                }  
                else $(this).html("<input type='hidden'  name='count' id='countLikeCmt' value='0' />"
				+"<i style='color: blue;'><i class='fa fa-thumbs-o-up'></i> <span></span> người đã"
				+" thích</i>" );
            })
                $('#journalAuthor img').css("height", $('#journalAuthor img').width());

                $("#journalBlur").css("background-image",
                        "url(../resources/images/journals/" + $("#cid").text() + "/theme.jpg)")
                $('.btn-update').hide();

                $('.btn-delete').on('click', function() {
                    var aId = $(this).parent().parent().attr('data-id');
                    $.ajax({
                        url : "/travelin/articles/comments/del",
                        type : "POST",
                        data : {
                            "id" : aId
                        },
                    // dataType : 'json',
                    }).success(function() {
                        $('tr[data-id="' + aId + '"]').remove();
                    });
                });

                //*****************************
                $('.btn-edit').on(
                        'click',
                        function() {
                            var p = $(this).parent().prev();
                            var t = p.text().replace("\n", "").replace(/\s{2,}/g, "").trim();
                            p.replaceWith("<td><textarea class='edit'>" + t + "</textarea></td>");
                            $(this).hide();
                            $(this).parent().next().find('.btn-delete').hide();
                            $(this).parent().find('.btn-update').show();

                            $('.btn-update').unbind().on(
                                    'click',
                                    function() {
                                        var btnedittd = $(this).parent();
                                        var q = btnedittd.prev().find("textarea.edit").val();
                                        var id = btnedittd.parent().attr("data-id");
                                        $.ajax({
                                            url : "/travelin/updateComment",
                                            type : "POST",
                                            contentType : 'application/json',
                                            data : JSON.stringify({
                                                id : id,
                                                content : q
                                            }),
                                            dataType : 'json'
                                        }).success(
                                                function(comment) {
                                                    btnedittd.prev().find("textarea.edit").replaceWith(
                                                            "<td class='contents'>" + comment.content + "</td>");
                                                    btnedittd.find('.btn-update').hide();
                                                    btnedittd.find('.btn-edit').show();
                                                    btnedittd.next().find('.btn-delete').show();

                                                });
                                    });

                        });
				
                function addFav() {
                    // console.log();
                    if ($('#ijklmn').length == 0){
                    	$('#login_btn').trigger('click');
                    	return false;	
                    } 
                    var btn = $(this);
                    $.ajax({
                        url : "/travelin/favoriteJournal/new",
                        type : "POST",
                        data : {
                            jid : $('#cid').text()
                        }
                    }).success(function() {
                        $('#likebtn').addClass('active');
                        $('#likebtn').text('Đã thích');
                        $('#likebtn').css('background', '#d54859');

                        $('#likebtn').unbind('click')
                        $('#likebtn').bind('click', removeFav)
                    });
                }
                ;
                function removeFav() {
                    // console.log();
                    var btn = $(this);

                    $.ajax({
                        url : "/travelin/favoriteJournal/del",
                        type : "POST",
                        data : {
                            jid : $('#cid').text()
                        }
                    }).success(function() {
                        $('#likebtn').removeClass('active');
                        $('#likebtn').text('Yêu thích');
                        $('#likebtn').css('background', 'rgba(46,46,46,0.5)');

                        $('#likebtn').unbind('click')
                        $('#likebtn').bind('click', addFav)
                    });
                }
                ;
                if ($('#likebtn').hasClass('active')) {
                    $('#likebtn').bind('click', removeFav);
                } else {
                    $('#likebtn').bind('click', addFav);
                }
                ;

                // var atags = $("#artTags").text().split(","); 
                //*************************************

                /* if ($('a.like-btn').hasClass('active')){
                    $('a.like-btn').bind('click', removeLike(this));
                    }
                else{
                    $('a.like-btn').bind('click', addLike(this));
                }; */
            });
    function addLikeComment(e) {
        var count = $(e.target).parent().parent().find("#countLikeComment").find("span");
        var aId = $(e.target).parent().parent().attr('data-id');

        $
                .ajax({
                    url : "/travelin/likeComment/new",
                    type : "POST",
                    data : {
                        commentid : aId
                    }
                })
                .success(
                        function(data) {

                            $(e.target)
                                    .replaceWith(
                                            '<a href="#" style="color: #d54859;text-decoration:none" class="like-btn" role="button" onclick="removeLikeComment(event); return false">Bỏ thích</a>');

                            count.text(data);
                            if (parseInt(data) > 0) {
                                count.parent().show();
                                count.parent().parent().show();
                            }
                            /* count.innerHTML = countLikeComment;
                            count.text(data);
                            count.load(document.URL + ' #countLikeComment'); */
                        });
    };
    function removeLikeComment(e) {
        var count = $(e.target).parent().parent().find("#countLikeComment").find("span");
        var aId = $(e.target).parent().parent().attr('data-id');

        $
                .ajax({
                    url : "/travelin/likeComment/del",
                    type : "POST",
                    data : {
                        commentid : aId
                    }
                })
                .success(
                        function(data) {

                            $(e.target)
                                    .replaceWith(
                                            '<a href="#" style="color: #d54859;text-decoration:none" class="like-btn" role="button" onclick="addLikeComment(event); return false">Thích</a>');
                            if (data == "0") {
                                count.parent().hide();
                            } else {
                                count.text(data);
                            }
                            /* count.load(document.URL + ' #countLikeComment'); */
                        });
    };
</script>
<script type="text/javascript">
    var initMap = function() {
        var mapProp = {
            center : new google.maps.LatLng(17.609123, 106.211239),
            zoom : 6,
            mapTypeId : google.maps.MapTypeId.ROADMAP
        };

        var mapDiv = document.getElementById("mapzone");//$("#mapzone");
        var map = new google.maps.Map(mapDiv, mapProp);

        var markers = [];
        var infoWindows = [];
        var bounds = new google.maps.LatLngBounds();
        var listPlacesElm = $('div.card');
        var lastOpenedWindow = null;
        listPlacesElm.each(function(index, ele) {
            var marker = new google.maps.Marker({
                map : map,
                label : '',
                // icon: '/travelin/resources/libs/travelin/img/en.jpg',
                position : new google.maps.LatLng(parseFloat($(ele).attr('data-lat')), parseFloat($(ele).attr(
                        'data-lng')))
            });

            // var contentStr = '<div><div>'+$(ele).find('.card-detail').text()+'</div></div>';
            var infowindow = $(ele).clone(deepWithDataAndEvents=true);
            var contentStr = infowindow.html();
            var infoWindow = new google.maps.InfoWindow({
                content : contentStr
            });
            infoWindows.push(infoWindow);
            marker.addListener('click', function() {
                if (lastOpenedWindow !== null)
                    lastOpenedWindow.close();
                infoWindow.open(map, marker);
                lastOpenedWindow = infoWindow;
            });

   //          marker.addListener('mouseout', function() {
			//     infoWindow.close();
			// });

            markers.push(marker);
            bounds.extend(marker.getPosition());

        });
        if (markers.length > 0) map.fitBounds(bounds);
    };
</script>

