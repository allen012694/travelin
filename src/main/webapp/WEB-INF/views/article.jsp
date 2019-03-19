<jsp:include page="header.jsp">
<jsp:param value="TravelIn - Bài viết" name="headtitle" />
</jsp:include>

<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="tag"
	uri="/resources/libs/travelin/taglib/customTaglib.tld"%>
	<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

</head>
<body>
	<div class="w3-row" id="articleHeader">
	</div>
	<div class="content">
		<span id="cid" style="display: none;">${curArt.id}</span>
		<div class="w3-row" id="article">
			<div class="w3-col l8" id="articlemain">
				<c:if test="${not empty curArt }">
					<div id="title">${curArt.title }</div>
					<div id="time">
						<fmt:formatDate type="both" dateStyle="short" timeStyle="short"
							value="${curArt.createddate }" pattern="dd/MM/yyyy HH:mm:ss" />
						đăng bởi <a href="#"
							style="color: #d54859; font-weight: 600; text-decoration: none">${curArt.author.username }</a>
					</div>
					<div id="descript">${curArt.description}</div>
					<div id="body">${curArt.content }</div>
					<c:if test="${currentAccount.email != null}">
						<div id="like">
							<c:if test="${likeArticles.account != null}">
								<a href="#" style="color: #d54859; text-decoration: none"
									class="likeArticle-btn" role="button"
									onclick="removeLike(event); return false">Bỏ thích</a>
							</c:if>
							<c:if test="${likeArticles.account == null}">
								<a href="#" style="color: #d54859; text-decoration: none"
									class="likeArticle-btn" role="button"
									onclick="addLike(event); return false">Thích</a>
							</c:if>
						</div>
					</c:if>
					<div id="countLikeArt" class="countLikeArts" style="display:none">
					<c:if test="${countLikeArticle != null}">
					<input type="hidden" name="count" id="countLike" value="${countLikeArticle}" />
						<i style="color: blue;"><i class='fa fa-thumbs-o-up'></i> <span >${countLikeArticle}</span> người đã thích
							</i>
					</c:if>
					</div>
					<div class="w3-row" id="tags">
						<span
							style="font-weight: bold; font-family: 'UTMBEBAS'; font-size: 20px;">Từ
							khóa:</span>
						<c:if test="${not empty curTags }">
							<c:forEach items="${curTags }" var="tag">
								<a href="/travelin/search?t=${tag }" id="tag">${tag }</a>
							</c:forEach>
						</c:if>
					</div>
					<div class="w3-row" id="comments">
						<div id="banner">BÌNH LUẬN</div>
						<c:if test="${currentAccount.email != null}">

							<form:form action="/travelin/articles/comments/new" method="POST"
								modelAttribute="newComment" acceptCharset="utf8" onkeypress="return event.keyCode != 13;">
								<div class="w3-row">
									<div class="w3-col l2">
										<img style="width: 80%;" class="square"
											src="<c:url value="/resources/images/accounts/${currentAccount.id }/avatar.jpg"  />"
											alt="${currentAccount.username }">
									</div>
									<form:textarea class="w3-input w3-col l10" id="commenttext"
										style="resize:none" rows="5" path="content" /> 
								</div>
								<input name="articleid" type="hidden" value="${curArt.id}" />

								<input type="submit" class="w3-col l2 w3-btn" id="commentbtn" value="Gửi">

							</form:form>
							<div class="w3-row" id="seperate"></div>

						</c:if>
						<c:if test="${not empty comments }">
							<c:forEach items="${comments }" var="comment" varStatus="i">
								<div class="w3-row" id="commentsitem">
									<div class="w3-col l2">
										<img class="square" width="100" height="100"
											src="<c:url value="/resources/images/accounts/${comment.account.id }/avatar.jpg"  />"
											alt="">
									</div>
									<div class="w3-col l10" data-id="${comment.id}">
										<div id="author" style="color: #d54859; font-weight: 600;"><a style="text-decoration: none" href="/travelin/profile?k=${comment.account.id}">${comment.account.username }</a></div>


										<div id="body">${comment.content }</div>
										<div id="time">
											<fmt:formatDate type="both" dateStyle="short"
												timeStyle="short" value="${comment.createddate }"
												pattern="dd/MM/yyyy HH:mm:ss" />
										</div>
										<c:if test="${currentAccount.email != null}">
											<div id="like">
												<c:if test="${likes[i.index].account != null}">
													<a href="#" style="color: #d54859; text-decoration: none"
														class="like-btn" role="button"
														onclick="removeLikeComment(event); return false">Bỏ
														thích</a>
												</c:if>
												<c:if test="${likes[i.index].account == null}">
													<a href="#" style="color: #d54859; text-decoration: none"
														class="like-btn" role="button"
														onclick="addLikeComment(event); return false">Thích</a>
												</c:if>
											</div>
										</c:if>
										<div class="countLikeCmt" id="countLikeComment" style="display:none">
											<c:if test="${countLikeComment != null}">
											<c:forEach items="${countLikeComment}" var="countLike">
											<c:if test="${countLike.cmtId == comment.id}">
											
											<input type="hidden"  name="count" id="countLikeCmt" value="${countLike.countLike}" />
											<i style="color: blue;"><i class='fa fa-thumbs-o-up'></i> <span>${countLike.countLike}</span> người đã
												thích</i>
												
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
				</c:if>
			</div>
			<div class="w3-col l4" id="articlessub">

				<div id="banner">BÀI VIẾT NỔi BẬT</div>
				<div id="hotarts">
				<c:if test="${not empty hotArticles }">
					<c:forEach items="${hotArticles }" var="hotArt">
						<div class="w3-row" id="articlesitem">
							<div class="w3-col l4">
								<a href="/travelin/articles/${hotArt.Id }">
								<img style="width: 100%; height: 80px;"
									src="<c:url value="/resources/images/articles/${hotArt.Id }.jpg"  />"
									alt="${hotArt.Title }">
									</a>
								</div>
								<div class="w3-col l8">
									<div id="title"><a href="/travelin/articles/${hotArt.Id }">${hotArt.Title }</a></div>
									<div style="margin: 5px 0 0 5%;">${fn:substring(hotArt.Description, 0, 60)}<c:if test="${fn:length(hotArt.Description) > 60}">...</c:if></div>
								</div>
								<div class="w3-row" id="seperate"></div>
							</div>
						</c:forEach>
					</c:if>
				</div>
				<div id="banner">BÀI VIẾT MỚI NHẤT</div>
				<div id="hotarts">
					<c:if test="${not empty lastarticles }">
						<c:forEach items="${lastarticles }" var="lastart">
							<div class="w3-row" id="articlesitem">
								<div class="w3-col l4">
									<a href="/travelin/articles/${lastart.id }">
									<img style="width: 100%; height: 80px;"
										src="<c:url value="/resources/images/articles/${lastart.id }.jpg"  />"
										alt="${lastart.title }">
										</a>
								</div>
								<div class="w3-col l8">
									<div id="title"><a href="/travelin/articles/${lastart.id }">${lastart.title }</a></div>
									<div style="margin: 5px 0 0 5%;">${fn:substring(lastart.description, 0, 60)}<c:if test="${fn:length(lastart.description) > 60}">...</c:if></div>
								</div>
								<div class="w3-row" id="seperate"></div>
							</div>
						</c:forEach>
					</c:if>
				</div>
				<div id="banner">TỪ KHÓA NỔI BẬT</div>
				<div id="hottags">
					<c:if test="${not empty hotTags}">
						<c:forEach items="${hotTags}" var="tag">
							<a href="/travelin/search?t=${tag.name}">${tag.name}</a>
						</c:forEach>
					</c:if>
				</div>
			</div>
		</div>
	</div>




	<script
		src="<c:url value="/resources/libs/jquery/jquery-2.2.0.min.js" />"></script>
	<script
		src="<c:url value="/resources/libs/esimakin-twbs-pagination/jquery.twbsPagination.js" />"></script>
	<script
		src="<c:url value="/resources/libs/admin/js/bootstrap.min.js" />"></script>
	<script type="text/javascript">
        $(document).ready(function() {
            $('.countLikeCmt').each(function(){
                if($(this).find("#countLikeCmt").val()>0){
                    $(this).show();
                }  
                else $(this).html("<input type='hidden'  name='count' id='countLikeCmt' value='0' />"
				+"<i style='color: blue;'><i class='fa fa-thumbs-o-up'></i> <span></span> người đã"
				+" thích</i>" );
            })
            $('.countLikeArts').each(function(){
                if($(this).find("#countLike").val()>0){
                    $(this).show();
                }  
                else $(this).html("<input type='hidden' name='count' id='countLike' value='0' />"
				+"<i style='color: blue;'><i class='fa fa-thumbs-o-up'></i> <span id='countLikeArticle'>${countLikeArticle}</span> người đã thích"
				+"</i>" );
            })
            $("#articleHeader").css({
                "background-image" : "url(../resources/images/articles/" + $("#cid").text() + ".jpg)",
            })
            $(".square").each(function() {
                var cw = $(this).width();
                $(this).css({
                    'height' : cw + 'px'
                });
            });
        });
        function addLike(e) {
            var count = $('.likeArticle-btn').parent().parent().find('#countLikeArt').find('span');
            var btn = $(this);
            
            $
                    .ajax({
                        url : "/travelin/likeArticle/new",
                        type : "POST",
                        data : {
                            articleid : $('#cid').text()
                        }
                    })
                    .success(
                            function(data) {
                                
                                
                                $('.likeArticle-btn')
                                        .replaceWith(
                                                '<a href="#" style="color: #d54859;text-decoration:none" class="likeArticle-btn" role="button" onclick="removeLike(event); return false">Bỏ thích</a>');

                                count.text(data);
                                if(parseInt(data)>0){
                                    count.parent().show();
                                    count.parent().parent().show();
                                }

                            });
        };
        function removeLike(e) {
            var count = $('.likeArticle-btn').parent().parent().find('#countLikeArt').find('span');
            var btn = $(this);
            
            $
                    .ajax({
                        url : "/travelin/likeArticle/del",
                        type : "POST",
                        data : {
                            articleid : $('#cid').text()
                        }
                    })
                    .success(
                            function(data) {
                                
                                
                                $('.likeArticle-btn')
                                        .replaceWith(
                                                '<a href="#" style="color: #d54859;text-decoration:none" class="likeArticle-btn" role="button" onclick="addLike(event); return false">Thích</a>');
                                if(data=="0"){
                                    count.parent().hide();
                                }else{
                                	count.text(data);
                            	}
                            });
        };
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
                                if(parseInt(data)>0){
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
                                if(data=="0"){
                                    count.parent().hide();
                                }
                                else{
                                count.text(data);}
                                /* count.load(document.URL + ' #countLikeComment'); */
                            });
        };
    </script>
	<jsp:include page="footer.jsp"></jsp:include>