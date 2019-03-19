<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title></title>
<link rel="stylesheet" type="text/css"
	href="<c:url value="/resources/libs/travelin/css/style.css" />">
<link rel="stylesheet" type="text/css"
	href="<c:url value="/resources/libs/travelin/css/w3.css" />">
<link rel="stylesheet" type="text/css"
	href="<c:url value="/resources/libs/travelin/css/top.css" />">
<link rel="stylesheet" type="text/css"
	href="<c:url value="/resources/libs/travelin/css/header.css" />">
<link rel="stylesheet" type="text/css"
	href="<c:url value="/resources/libs/travelin/css/footer.css" />">
<link rel="stylesheet" type="text/css"
	href="<c:url value="/resources/libs/travelin/css/content.css" />">
<link rel="stylesheet" type="text/css"
	href="<c:url value="/resources/libs/magnific-popup/magnific-popup.css" />">
<link rel="stylesheet" type="text/css"
	href="<c:url value="/resources/libs/magnific-popup/popup.css" />">
</head>

<body>
	<div class="main">
		<div class="top">
			<div class="top_top">
				<div class="languages">
					<div>
						<a href="#"><img
							src="<c:url value="/resources/libs/travelin/img/en.jpg"  />"
							alt="EN"></a> <a href="#"><img
							src="<c:url value="/resources/libs/travelin/img/vn.jpg" />"
							alt="VN"></a>
					</div>
				</div>
				<div class="user">
					<c:if test="${currentAccount.email == null}">
					<!-- <button class="popup-with-form w3-btn w3-red" id="login_btn">ĐĂNG NHẬP</button> -->
					<a href="/travelin/login" class="w3-btn w3-red" id="login_btn">ĐĂNG NHẬP</a>
					<div class="mfp-hide" id="popup-login">
						<form id="test-form" class="white-popup-block">
							<h1>Form</h1>
							<fieldset style="border: 0;">
								<p>
									Lightbox has an option to automatically focus on the first
									input. It's strongly recommended to use
									<code>inline</code>
									popup type for lightboxes with form instead of
									<code>ajax</code>
									(to keep entered data if the user accidentally refreshed the
									page).
								</p>
								<ol>
									<li><label for="name">Name</label> <input id="name"
										name="name" type="text" placeholder="Name" required></li>
									<li><label for="email">Email</label> <input id="email"
										name="email" type="email" placeholder="example@domain.com"
										required></li>
									<li><label for="phone">Phone</label> <input id="phone"
										name="phone" type="tel" placeholder="Eg. +447500000000"
										required></li>
									<li><label for="textarea">Textarea</label><br> <textarea
											id="textarea">Try to resize me to see how popup CSS-based resizing works.</textarea>
									</li>
								</ol>
							</fieldset>
							<button title="Close (Esc)" type="button" class="mfp-close">×</button>
						</form>
					</div>

					<!-- <button class="w3-btn w3-red" id="signup_btn">ĐĂNG KÝ</button> -->
					<a href="/travelin/register" class="w3-btn w3-red" id="signup_btn">ĐĂNG KÝ</a>
					</c:if>

					<c:if test="${currentAccount.email != null}">
						<h5 style="display: inline-block;">Xin chào <a href="/travelin/up-prof">${currentAccount.firstname}</h5></a>
						<a href="/travelin/logout" class="w3-btn w3-red">Đăng xuất</a>
					</c:if>
				</div>
			</div>
			<div class="logoAndSearch" id="smallLogoAndSearch">
				<div class="logo" id="smallLogo">
					<img src="<c:url value="/resources/libs/travelin/img/logo.jpg"/>"
						align="middle">
				</div>
				<div class="search" id="smallSearch">
					<input class="w3-input w3-border" id="search_input" type="text"
						placeholder="Nhập tên một đỉa điểm" />
				</div>
			</div>
		</div>
		<div class="content">
			<div class="place">

				<div class="w3-row" id="placeHeader">

					<div class="w3-col" id="placeLogo"
						style="width: 24%; height: 100%; margin-right: 1%"></div>
					<div class="w3-col" id="placeInfo"
						style="width: 74%; height: 100%; margin-left: 1%">
						<div id="placeName">${curPlace.name}</div>
						<div>
							<ul>
								<li id="placeTag">Tags</li>
								<li id="placeAddress">
									<a id="map-btn" href="#" style="text-decoration: none">Address</a>
									<div class="mfp-hide" id="popup-map">
										<div class="mfp-with-anim">
											<div id="mapzone" style="width:800px;height:600px;top:25%;left:22%"></div>
										</div>
									</div>
								</li>

								</li>
								<li id="placeTime">Open Time - Close TIme</li>
								<li id="placePhone">Phone Number</li>
								<li id="placeWebsite">Website</li>
							</ul>
						</div>
					</div>

				</div>
				
				<div class="w3-row" id="placeBody">
					<div class="w3-col" style="width: 54%; margin-right: 1%">
						<div id="placeImg">
							<img style="width: 100%; height: 400px"
								src="<c:url value="/resources/images/places/1_1.jpg"/>"
								alt="${curPlace.name }">

						</div>
					</div>
					<div class="w3-col" style="width: 44%; margin-left: 1%">
						<div id="placeDescription">${curPlace.description }</div>

					</div>





				</div>
				<div id="placeFooter"></div>

			</div>
		</div>
		<div class="footer">
			<div class="w3-row">
				<div class="w3-col w3-container l3">
					<h3>About us</h3>
					<ul class="practical">
						<li><a class="" href="/about/">About</a></li>
						<li><a class="" href="/press/">Press</a></li>
						<li><a class="" href="/terms/">Terms of use</a></li>
						<li><a class="" href="/privacy/">Privacy policy</a></li>
					</ul>
				</div>
				<div class="w3-col w3-container l3">
					<h3>Help</h3>
					<ul class="social">
						<li><a href="/support/">Contact</a></li>
						<li><a class="facebook" href="https://www.facebook.com/"
							target="_blank">Ask on Facebook</a></li>
						<li><a class="twitter" href="http://twitter.com/"
							target="_blank">@TravelIn</a></li>
					</ul>
				</div>
				<div class="w3-col w3-container l3">
					<h3>Connect with us</h3>
					<ul class="social">
						<li><a class="facebook" href="https://www.facebook.com/"
							target="_blank">Facebook</a></li>
						<li><a class="twitter" href="http://twitter.com/"
							target="_blank">Twitter</a></li>
						<li><a class="pinterest" href="https://www.pinterest.com/"
							target="_blank">Pinterest</a></li>
						<li><a class="instagram" href="https://instagram.com/"
							target="_blank">Instagram</a></li>
					</ul>
				</div>
				<div class="w3-col w3-container l3">
					<h3>Subscribe to get infomations</h3>

					<div id="mc_embed_signup">
						<form action="#" method="post" id="mc-embedded-subscribe-form"
							name="mc-embedded-subscribe-form" class="validate"
							target="_blank" novalidate="">
							<div id="mc_embed_signup_scroll">
								<div class="mc-field-group">
									<label for="mce-EMAIL" class="visually-hidden">Email
										Address</label> <input class="w3-input" type="email" value=""
										name="EMAIL" class="required email" id="mce-EMAIL"
										placeholder="Email address">
								</div>
								<input class="w3-btn w3-red" type="submit" value="Subscribe"
									name="subscribe" id="mc-embedded-subscribe">
							</div>
						</form>
					</div>
					<!--End mc_embed_signup-->

				</div>
				<p>TravelIn © 2016</p>
			</div>


		</div>
	</div>


	<script
		src="<c:url value="/resources/libs/jquery/jquery-2.2.0.min.js" />"></script>
	<!-- <script src="http://maps.google.com/maps/api/js"></script> -->
	<script
		src="<c:url value="/resources/libs/gs/plugins/CSSPlugin.min.js" />"></script>
	<script
		src="<c:url value="/resources/libs/gs/easing/EasePack.min.js" />"></script>
	<script src="<c:url value="/resources/libs/gs/TweenLite.min.js" />"></script>
	<script src="<c:url value="/resources/libs/gs/TweenMax.min.js" />"></script>
	<script src="<c:url value="/resources/libs/gs/TimelineMax.min.js" />"></script>
	<script src="<c:url value="/resources/libs/gs/TimelineLite.min.js" />"></script>
	<script src="<c:url value="/resources/libs/sly/sly.min.js" />"></script>
	<script src="<c:url value="/resources/libs/raphael/raphael-min.js" />"></script>
	<script
		src="<c:url value="/resources/libs/magnific-popup/jquery.magnific-popup.min.js" />"></script>
	<script src="<c:url value="/resources/libs/vendor/plugins.js" />"></script>
	<script src="<c:url value="/resources/libs/travelin/js/vertical.js" />"></script>
	<script src="<c:url value="/resources/libs/travelin/js/banner.js" />"></script>
	<script type="text/javascript">
        $(document).ready(function() {
            $('#login_btn').click(function() {
                $.magnificPopup.open({
                    items : {
                        src : $('#popup-login').html(),
                        type : 'inline'
                    }
                });
            });
            var paperHeight = $('#placeLogo').height();
            var paperWidth = $('#placeLogo').width();
            var paper = Raphael("placeLogo", "100%", "100%")
            paper.circle("75%", "50%", 75).attr({
                fill : "url(../resources/images/places/1.jpg)"
            });
            $("#placeHeader").css("background-image", "url('../resources/images/places/1.jpg')")
        });
    </script>
</body>
</html>
