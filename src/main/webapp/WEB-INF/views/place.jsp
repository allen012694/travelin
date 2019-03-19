<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%-- <%@ include file="header.jsp" %> --%>
<jsp:include page="header.jsp">
	<jsp:param value="TravelIn - Địa điểm" name="headtitle" />
</jsp:include>
<style>
.chosen-container {
margin-left:0;
margin-bottom:10px;
font-size: 12px;

}
</style>
<div class="w3-row" id="placeHeader">

	<div class="w3-col" id="placeLogo"
		style="width: 24%; height: 100%; margin-right: 1%">
		<img class="circled" src="<c:url value="/resources/images/places/${curPlace.id}/theme.jpg"/>">
		</div>
	<div class="w3-col" id="placeInfo"
		style="width: 74%; height: 100%; margin-left: 1%">
		<div id="placeName">${curPlace.name}</div>
		<div>
			<ul>
				<li id="placeTag">Tags: <c:forEach items="${curTags }"
						var="tag">
						<a href="/travelin/search?t=${tag }" id="tag">${tag }</a>
					</c:forEach>
				</li> <!-- id="map-btn" -->
				<li id="placeAddress">Địa chỉ: <span>${curPlace.address}, ${curPlace.area.name}</span>&nbsp&nbsp<button style="border: none; background: transparent; background: rgba(246, 246, 246, 0.85); color: #d54859; padding: 2px; border-radius: 50%;" id="map-btn"><i class="fa fa-eye"></i></button>
					<div class="mfp-hide" id="popup-map">
						<div class="mfp-with-anim">
							<div id="mapzone"
								style="width: 800px; height: 600px; top: 25%; left: 22%"></div>
						</div>
					</div></li>

				</li>
				<li id="placeTime">Giờ mở cửa: ${curPlace.workingtime}</li>
				<li id="placePhone">Sđt: ${curPlace.phone}</li>
				<li id="placeWebsite">Website: <a href="${curPlace.website}">${curPlace.website}</a></li>
				
				
			</ul>
		</div>
	</div>
	<div class="w3-row" id="placeGlass"></div>
	<div class="w3-row" id="placeBlur"></div>
</div>
<div class="content">
	<div class="w3-row" id="place">
		<div class="w3-col l8" id="placemain">

			<c:if test="${currentJournal != null}">
				<input type="hidden" value="cj" id="cj"></input>
			</c:if>


			<div id="body">
				<div style="font-family: 'UTMBEBAS';font-size: 28px;">Mô tả</div>
				<div style="margin: 0 0 15px 0">
					<div id="placeDescription" style="text-align: justify;">${curPlace.description }</div>
					<input type="hidden" value="${curPlace.latitude}" id="cla">
					<input type="hidden" value="${curPlace.longtitude}" id="clo">
				</div>
				<div id="banner">Hình ảnh</div>
				<div class="w3-row">
					<div id="placeImg">
						<div class="fotorama" data-fit="contain" data-nav="thumbs" data-allowfullscreen="true" data-width="700" data-height="400">
							<img src="<c:url value="/resources/images/places/${curPlace.id}/theme.jpg"/>">
							<c:if test="${not empty placeImgs}">
								<c:forEach items="${placeImgs}" var="imgname">
									<img src="<c:url value="/resources/images/places/${curPlace.id}/${imgname}"/>">
								</c:forEach>
							</c:if>
						</div>
					</div>
					
                    <!-- <button class="w3-btn w3-red">up ảnh</button> -->
                    
			<div id="popUpDiv" class="w3-modal" >
				
				<div id="imageform" class="w3-modal-content">
				<span class="w3-closebtn">×</span>
				<div id="imagecontent">
				
					<div>
						<h1>Đăng ảnh</h1>
					</div>
					<div style="width:100%"> <!-- up ảnh -->
                    <form style="margin-left:20%; margin-right:20%" action="/travelin/places/uploadFileImage" method="POST" enctype="multipart/form-data" class="box">
                        <input type="hidden" name="pid" value="${curPlace.id}">
                        <div class="box__input">
                            <label class="box__label" for="file"><span class="box__dragndrop"><strong>Nhấn để chọn ảnh</strong> hoặc thả file ảnh vào đây.</span></label>
                            <input class="box__file" type="file" name="upfiles" id="file" data-multiple-caption="Có {count} ảnh được chọn" multiple />
                            
                        </div>
                        <div class="box__uploading">Đang tải lên&hellip;</div>
                        <div class="box__success">Hoàn tất!</div>
                        <div class="box__error">Có lỗi xảy ra! <span></span>.</div>
                    <button class="box__button" style="left:85%;background: transparent;border: 1px solid #2e2e2e;font-family: 'UTMBEBAS';padding-left: 2.5%;font-align:center;padding-right: 2.5%;line-height:40px;height: 60px;font-size: 28px;" type="submit">Đăng ảnh</button>    
                   <!-- <input class="box__button" style="left:85%;background: transparent;border: 1px solid #2e2e2e;font-family: 'UTMBEBAS';padding-left: 2.5%;font-align:center;padding-right: 2.5%;line-height:40px;height: 60px;font-size: 28px;" type="submit" value="ĐĂNG ẢNH"> -->
                    </form>
                    
                    </div>
                    
				</div>
			</div>
			</div>
                    
				</div>
				<!-- <button class="w3-btn w3-red">up ảnh</button> -->
			</div>
			<div class="w3-row" id="suggests">
				<div id="banner">ĐỀ NGHỊ</div>

				<c:if test="${currentAccount.email != null}">
					<form:form action="/travelin/suggestions/new" method="POST"
						modelAttribute="newSuggestion" acceptCharset="utf8" onkeypress="return event.keyCode != 13;">
						<div class="w3-row">
							<div class="w3-col l2">
								<img class="circled" width="80" height="80"
									src="<c:url value="/resources/images/accounts/${currentAccount.id }/avatar.jpg"  />"
									alt="${currentAccount.username }">
								<div>${currentAccount.username}</div>
							</div>
							<form:textarea class="w3-input w3-col l10" id="suggestiontext"
								style="resize:none;border: 1px solid #2e2e2e;" rows="5" path="content" />
						</div>
						<input name="placeid" type="hidden" value="${curPlace.id}" />
						<div class="w3-row w3-col l10" style="float:right">
						<div class="w3-col l6" id="suggestchoice">Đề nghị của bạn:</div>
							<div class="w3-col l4 field switch" id="suggestornot">
								
								<input type="radio" value="1" id="radio1" name="recommend" path="recommend" checked /> <input
									type="radio" value="-1" id="radio2" name="recommend" path="recommend" /> <label for="radio1"
									class="cb-enable selected"><span><i class='fa fa-thumbs-o-up' style="height: 30px;line-height: 30px;font-size: 24px;color:#2e2e2e" alt="Nên đi"></i></span></label> <label
									for="radio2" class="cb-disable"><span><i class='fa fa-thumbs-o-down' style="height: 30px;line-height: 30px;font-size: 24px;color:#2e2e2e" alt="Không nên đi"></i></span></label>
							</div>
							<input type="submit" class="w3-col l2 w3-btn" id="suggestbtn"
							value="Gửi">
						</div>	
						

					</form:form>
					<div class="w3-row" id="seperate"></div>

				</c:if>
				<c:if test="${not empty suggestions }">
					<c:forEach items="${suggestions }" var="suggestion">
						<div class="w3-row" id="suggestsitem">
							<div class="w3-col l2">
								<img class="circled" width="80" height="80"
									src="<c:url value="/resources/images/accounts/${suggestion.author.id }/avatar.jpg"  />"
									alt="">
							</div>
							<div class="w3-col l10">
								<div id="author" style="color: #d54859; font-weight: 600;">${suggestion.author.username }
									<c:if test="${suggestion.recommend == 1}"><i class='fa fa-thumbs-o-up' style="height: 30px;line-height: 30px;font-size: 24px;color:#2e2e2e" alt="Nên đi"></i></c:if>
									<c:if test="${suggestion.recommend == -1}"><i class='fa fa-thumbs-o-down' style="height: 30px;line-height: 30px;font-size: 24px;color:#2e2e2e" alt="Không nên đi"></i></c:if>
								</div>


								<div id="body">${suggestion.content }</div>
								<div id="time">
									<fmt:formatDate type="both" dateStyle="short" timeStyle="short"
										value="${suggestion.createddate }" pattern="dd/MM/yyyy HH:mm:ss" />
								</div>
								
							</div>
							<div class="w3-row" id="seperate"></div>
						</div>
					</c:forEach>
				</c:if>
			</div>
			<div id="placeFooter"></div>

		</div>
		<div class="w3-col l4" id="placesub">
			<%---<c:if test="${currentAccount.email != null}">--%>
			<div id="banner">BẢNG ĐIỀU KHIỂN</div>
			<div id="controlpanel">
				<c:if test="${fav.account != null}">
					<button class="w3-row w3-btn active" id="likebtn" style="background: #d54859;">Đã thích</button>
				</c:if>
				<c:if test="${fav.account == null}">
					<button class="w3-row w3-btn" id="likebtn">Yêu thích</button>
				</c:if>

				<button class="w3-row w3-btn" id="addtooldjournalbtn" onclick="javascript:getOldJournals(event);">Thêm vào chuyến đi</button>
				<div class="w3-row" style="padding: 2%; display:none; border: 1px solid black; position:absolute; width:30%; top:38em; right: 3%; background: rgb(250, 245, 239) none repeat scroll 0% 0%;">
					<button type="button" style="position: absolute; top: 0; right: 1%; background: none; border: none;">X</button>
					<button class="w3-col l3 w3-btn" id="addoldjournalconfirm" style="float:left; margin:4px; width: 30%;" type="button" onclick="addToJour(event)">Thêm vào</button>
					<select class="w3-col l8 chosen-select" id="oldjournals"></select>
					<button class="w3-row w3-btn" id="addtonewjournalbtn" style="margin: 0 0 0 5px; width: 70%;margin-left: 20%;">+ Thêm vào chuyến đi mới</button>
				</div>
				
				<input type="hidden" id="cid" name="placeid" value="${curPlace.id }">
				
				<button class="w3-row w3-btn" id="image_btn">Đăng ảnh</button>
			</div>
			<%--</c:if>--%>
			<!-- theo tỉnh thành, theo loại của địa điểm đang click -->
			<div id="banner">ĐỊA ĐIỂM NỔi BẬT</div>
				<div class="tool-section">
					<c:if test="${not empty topRecPlaces }">
						<c:forEach items="${topRecPlaces }" var="recPlace">
							<div class="w3-row tool-section-item">
								<div class="w3-col l4">
									<a href="/travelin/places/${recPlace.Id }">
									<img style="width: 100%; height: 80px;"
										src="<c:url value="/resources/images/places/${recPlace.Id }/theme.jpg"  />"
										alt="${recPlace.Name }">
										</a>
								</div>
								<div class="w3-col l8">
									<div class="title"><a href="/travelin/places/${recPlace.Id }">${recPlace.Name }</a></div>
									<div style="margin: 5px 0 0 5%;">${recPlace.Address}, ${recPlace.Area.name}</div>
								</div>
								<div class="w3-row seperate"></div>
							</div>
						</c:forEach>
					</c:if>
				</div>
				<div id="banner">ĐỊA ĐIỂM MỚI NHẤT</div>
				<div class="tool-section">
					<c:if test="${not empty topLastPlaces }">
						<c:forEach items="${topLastPlaces }" var="lastplace">
							<div class="w3-row tool-section-item">
								<div class="w3-col l4">
									<a href="/travelin/journals/${lastplace.id }">
									<img style="width: 100%; height: 80px;"
										src="<c:url value="/resources/images/places/${lastplace.id }/theme.jpg"  />"
										alt="${lastplace.name }">
										</a>
								</div>
								<div class="w3-col l8">
									<div class="title"><a href="/travelin/places/${lastplace.id }">${lastplace.name }</a></div>
									<div style="margin: 5px 0 0 5%;">${lastplace.address}, ${lastplace.area.name}</div>
								</div>
								<div class="w3-row seperate"></div>
							</div>
						</c:forEach>
					</c:if>
				</div>
			
		</div>
	</div>
</div>
<%@ include file="footer.jsp"%>
<script src="http://maps.google.com/maps/api/js?key=<spring:eval expression="@credentialsProp.getProperty('google.api.map.key')" />&libraries=geometry,places&v=3.exp"></script>
<script type="text/javascript">
	function addToJour(e){

		$.ajax({
			url: "/travelin/journals/addPlace",
			type: "POST",
			data: {
				"jid" : $('#oldjournals').val(),
				"pid" : $('#cid').val()
			},
			dataType: "JSON"
		}).success(function(data) {
			if (data.status == 1) {
				alert("thành công");
			} else if (data.status == 2) {
				alert("đã tồn tại");
			} else {
				alert("thất bại");
			}
		});
	};
	function getOldJournals(e){
		if ($('#ijklmn').length == 0){
        	$('#login_btn').trigger('click');
        	return false;	
        } 
	    $.ajax({
	        url: "/travelin/oldjournals",
	        type :"GET"
	    }).success(function(data){
	    	$("#oldjournals").empty();
	        $.each(data,function(i,item){
	            $("#oldjournals").append($("<option></option>")
	                    .attr("value",item.id)
	                    .text(item.title));
        });
        
      $(e.target).next().toggle();
	  $('.chosen-select').chosen({
				
		        search_contains : true,

		    })
	    });
	    
	};
    $(document).ready(function() {
      
     	// Get the modal
		var modal = document.getElementById('popUpDiv');

		// Get the button that opens the modal
		var btn = document.getElementById("image_btn");

		// Get the <span> element that closes the modal
		var span = document.getElementsByClassName("w3-closebtn")[0];

		// When the user clicks the button, open the modal 
		if (btn !== null) {
			btn.onclick = function() {
				if ($('#ijklmn').length == 0){
                	$('#login_btn').trigger('click');
                	return false;	
                } 
			    modal.style.display = "block";
			}

			// When the user clicks on <span> (x), close the modal
			span.onclick = function() {
			    modal.style.display = "none";
			}

			// When the user clicks anywhere outside of the modal, close it
			window.onclick = function(event) {
			    if (event.target == modal) {
			        modal.style.display = "none";
			    }
			};
		}
        $(".cb-enable").click(function() {
            var parent = $(this).parents('.switch');
            $('.cb-disable', parent).removeClass('selected');
            $(this).addClass('selected');
            $('.checkbox', parent).attr('checked', true);
        });
        $(".cb-disable").click(function() {
            var parent = $(this).parents('.switch');
            $('.cb-enable', parent).removeClass('selected');
            $(this).addClass('selected');
            $('.checkbox', parent).attr('checked', false);
        });
        $(document).one('click', '#addtonewjournalbtn', function(){
            // console.log();
            var btn = $(this);
            $.ajax({
                url : "/travelin/places/add-to-jour",
                type : "GET",
                data : {
                    jid : $('#cid').val()
                },
                dataType: "JSON"
            }).success(function(data) {
                $('#addtonewjournalbtn').text('Đã thêm');
                $('#journal-bubble').text(data.placessize);
                $('#journal-bubble').show();
                $('#addtonewjournalbtn').css('background','#d54859');
                $('#addtonewjournalbtn').css('opacity','0.5');
                $('#addtonewjournalbtn').css('cursor','default');
            });
        });
        
        function addFav(){
            // console.log();
            if ($('#ijklmn').length == 0){
            	$('#login_btn').trigger('click');
            	return false;	
            } 
            var btn = $(this);
            $.ajax({
                url : "/travelin/favoritePlace/new",
                type : "POST",
                data : {
                    placeid : $('#cid').val()
                }
            }).success(function() {
                $('#likebtn').addClass('active');
                $('#likebtn').text('Đã thích');
                $('#likebtn').css('background','#d54859');
                
                
                $('#likebtn').unbind('click')
                $('#likebtn').bind('click', removeFav)
            });
        };
        function removeFav(){
            // console.log();
            var btn = $(this);

            $.ajax({
                url : "/travelin/favoritePlace/del",
                type : "POST",
                data : {
                    placeid : $('#cid').val()
                }
            }).success(function() {
                $('#likebtn').removeClass('active');
                $('#likebtn').text('Yêu thích');
                $('#likebtn').css('background','rgba(46,46,46,0.5)');
                
                $('#likebtn').unbind('click')
                $('#likebtn').bind('click', addFav)
            });
        };
        if ($('#likebtn').hasClass('active')){
            $('#likebtn').bind('click', removeFav);
            }
        else{
            $('#likebtn').bind('click', addFav);
        };
        $('#map-btn').click(function() {

            $.magnificPopup.open({
                items : {
                    src : $('#popup-map').html(),
                    type : 'inline'
                },
                removalDelay : 300,
                mainClass : 'mfp-zoom-in',
                midClick : true

            });
            var lat = parseFloat($('#cla').val());
            var lng = parseFloat($('#clo').val());
            var curCoor = {
                lat : lat,
                lng : lng
            };
            var mapProp = {
                center : curCoor,//new google.maps.LatLng(51.000000, -0.120000),
                zoom : 18,
                mapTypeId : google.maps.MapTypeId.ROADMAP
            };

            var mapDiv = document.getElementById("mapzone");//$("#mapzone");
            var map = new google.maps.Map(mapDiv, mapProp);
            //var markers = [];

            var marker = new google.maps.Marker({
                position : curCoor,
                label : '',
                map : map
            });
        });
        
        var paperHeight = $('#placeLogo').height();
        var paperWidth = $('#placeLogo').width();

        $('#placeLogo img').css("height", $('#placeLogo img').width());
        $("#placeBlur").css("background-image", "url(../resources/images/places/" + $("#cid").val() + "/theme.jpg)")

        //init upload box
    createUploadBox($('form.box'), {
        height: '400px',
        width: '60%',
    });
});
    </script>


