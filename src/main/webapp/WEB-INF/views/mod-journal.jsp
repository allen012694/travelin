<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<jsp:include page="header.jsp">
    <jsp:param value="TravelIn - ${currentAccount.firstname}" name="headtitle"/>
</jsp:include>
<link rel="stylesheet" type="text/css" href="<c:url value="/resources/libs/tageditor/jquery.tag-editor.css" />">
<%-- <link rel="stylesheet" type="text/css" href="<c:url value="/resources/libs/admin/css/bootstrap.css" />"> --%>
	<meta http-equiv="content-type" content="text/html; charset=utf-8" />
<style type="text/css">
#banner{
	font-family: "UTMBEBAS";
	margin-top: 20px;
	margin-left:5%;
	margin-right:5%;
	width: 90%;
	background: #2e2e2e;
	color: #faf5ef;
	text-align: center;
	font-size: 28px;
	letter-spacing: 2px;
	word-spacing: 6px;
	line-height: 40px;
	border: 1px solid #2e2e2e;
	margin-bottom: 20px;
	}
	.tag-editor{
	margin-left:5%;
	margin-right:5%;
	width:90%;
	}
	.bright-input {
		color: #FFFFFF !important;
		font-family:"SVN-Nexa Bold" !important;
	}
	#mapsearch-pac {
		margin-top: 10px;
        border: 1px solid transparent;
        border-radius: 2px 0 0 2px;
        box-sizing: border-box;
        -moz-box-sizing: border-box;
        height: 32px;
        outline: none;
        box-shadow: 0 2px 6px rgba(0, 0, 0, 0.3);

		background-color: #fff;
        font-family: Roboto;
        font-size: 15px;
        font-weight: 300;
        margin-left: 12px;
        padding: 0 11px 0 13px;
        text-overflow: ellipsis;
        width: 300px;

	}
	#mapsearch-pac:focus {
		border-color: #4d90fe;
	}
</style>
<div id="newJournal">
	<c:if test="${newJour!=null}">
		<form:form action="/travelin/journals/new" method="POST" modelAttribute="newJour" enctype="multipart/form-data" onkeypress="return event.keyCode != 13;">

		
		<div class="w3-row" id="journalHeader">
	<div class="w3-col" id="journalInfo"
		style="width: 74%; height: 100%; margin-right: 1%">
		
			<form:input path="title" class="bright-input form-text-underline"  placeholder="Tiêu đề..." required="true"/>
			<div id="chooseImage">Chọn ảnh nền</div>
		</div>
		<div class="w3-col" id="journalAuthor"
		style="display:inline-block;width: 19%; height: 100%; margin-left: 1%;margin-right: 5%;text-align: center">
		<div style="margin-bottom:50px;"><a href="/travelin/profile?k=${currentAccount.id}"><img class="circled" src="<c:url value="/resources/images/accounts/${currentAccount.id}/avatar.jpg"/>"></a></div>
		<a href="/travelin/profile?k=${currentAccount.id}" style="margin-top: 20px;color: #faf5ef; font-size: 16px;font-weight: 600;text-decoration:none">${currentAccount.username }</a>
		</div>
		
	<div class="w3-row" id="journalGlass"></div>
	<div class="w3-row" id="journalBlur"></div>
</div>
<div>
				<input class="hidden" id="chooseImageBtn" type="file" name="image" onchange="previewFile(this)">
			</div>
			
			<!-- Ảnh bìa: <input type="file" name="image"> -->
			<div class="content">
			<div id="locations">
				<div id="banner">Các điểm đến </div>
				<div id="mapzone" style="margin-left:5%;margin-right:5%;width: 90%; height: 600px;margin-bottom:20px;"></div>
				
				<div class="collection" style="padding: 0 5%">
					<c:if test="${not empty currentPlaces}">
						<c:forEach items="${currentPlaces}" var="place">
							<div class="card" data-lat="${place.latitude}" data-lng="${place.longtitude}" data-id="${place.id}" style="; width: 24%">
							  	<img data-holder-rendered="true" src="<c:url value="/resources/images/places/${place.id}/theme.jpg"/>" style="width: 100%; display: block;" class="card-img-top">
							  	<div class="card-block">
							  		<div class="card-middle" >
							    		<h4 class="card-title"><a href="/travelin/journals/${place.id}">${place.name}</a></h4>
							    		<span style="text-align: justify; margin-left: 2%">${place.address}, ${place.area.name}</span>
							    	</div>
						    	<div class="card-bottom" style="position: static;">
						    	</div>
		  					</div>
		  					<button type="button" onclick="delPlace(${place.id},event)">X</button>
						</div>
					</c:forEach>
				</c:if>
				</div>
			</div>
			<button class="popup-with-form w3-btn w3-red" type="button" id="tempplace_btn">TẠO ĐỊA ĐIỂM TẠM</button>
			
			<div id="banner">Nội dung </div>
			<div style="padding: 0 5%;">
			<form:textarea path="content" id="contents" />
			</div>
			<br>			
			<form:select class="w3-select" path="datastatus" style="margin-left: 5%;">
				<form:option value="1">Công khai</form:option>
				<form:option value="2">Bạn bè</form:option>
				<form:option value="3">Riêng tư</form:option>
			</form:select>
			<br>
			<input type="text" name="tags" id="tags" class="form-control" />
			<button class="w3-btn banner" onclick="draftJournal(event)" type="button" style="border:none; margin-right:5%;">Lưu nháp</button>
			<input class="w3-btn w3-red banner" style="width: 10%;border:none; float:right; margin-right:5%;" type="submit" value="Tạo">
			</div>
		</form:form>

		<!-- popup for temp place create -->
		<div id="popUpDiv" class="w3-modal" >
				
				<div id="tempplaceform" class="w3-modal-content">
				<span class="w3-closebtn">×</span>
				<div id="templacecontent">
					<form:form action="/travelin/places/addtemp" method="POST" modelAttribute="newTempPlace" onkeypress="return event.keyCode != 13;">
						<div>
							<h1>TẠO ĐỊA ĐIỂM TẠM THỜI</h1>
						</div>

						<fieldset style="border: 0;">
						<form:input path="name" type="text" placeholder="Tên địa điểm" class="w3-input" required="true"/>
						<form:input path="address" type="text" placeholder="Địa chỉ" class="w3-input" required="true"/>
							<form:select path="area.id" class="w3-select">
								<form:option value="-1">-- Chọn tỉnh/tp --</form:option>
								<c:if test="${not empty cities}">
									<c:forEach items="${cities}" var="city">
										<form:option value="${city.id}">${city.name}</form:option>
									</c:forEach>
								</c:if>
							</form:select>
						
								<form:select path="type" class="w3-select">
									<form:option value="1">Ăn Uống</form:option>
									<form:option value="2">Du Lịch</form:option>
									<form:option value="3">Sức Khỏe</form:option>
									<form:option value="4">Giải trí</form:option>
									<form:option value="5">Mua Sắm</form:option>
								</form:select>
								<br>
								<input id="mapsearch-pac" placeholder="Search box...">
							<div id="maptemp" style="height:400px; width: 100%; background:#2e2e2e"></div>
							<form:input type="hidden" id="lat" path="latitude" required="true"/>
							<form:input type="hidden" id="lng" path="longtitude" required="true"/>
							<!-- <input type="hidden" name="joid" value=""> -->
							<%--<form:input type="hidden" path="createdaccount.id" value="${currentAccount.id}"/>--%>
							<form:input type="hidden" path="updatedaccount.id" value="${currentAccount.id}"/>
							<button class="w3-btn" id="tempplacemew" type="button">TẠO</button>
							<input type="submit" id="tsbm" style="display:none;">
						</fieldset>
					</form:form>
				</div>
			</div>
			</div>
	</c:if>













	<c:if test="${curJour!=null}">
		<form:form action="/travelin/journals/update" method="POST" modelAttribute="curJour" enctype="multipart/form-data" onkeypress="return event.keyCode != 13;">
			<div class="w3-row" id="journalHeader">
				<div class="w3-col" id="journalInfo"
					style="width: 74%; height: 100%; margin-right: 1%">
					
					<form:input path="title" class="bright-input form-text-underline " placeholder="Tiêu đề..." required="true"/>
					<div id="chooseImage">Chọn ảnh nền</div>
				</div>
				<div class="w3-col" id="journalAuthor"
				style="display:inline-block;width: 19%; height: 100%; margin-left: 1%;margin-right: 5%;text-align: center">
				<div style="margin-bottom:50px;"><a href="/travelin/profile?k=${currentAccount.id}"><img class="circled" src="<c:url value="/resources/images/accounts/${currentAccount.id}/avatar.jpg"/>"></a></div>
				<a href="/travelin/profile?k=${currentAccount.id}" style="margin-top: 20px;color: #faf5ef; font-size: 16px;font-weight: 600;text-decoration:none">${currentAccount.username }</a>
				</div>
					
				<div class="w3-row" id="journalGlass" ></div>
				<div class="w3-row" id="journalBlur" style="background-image: url('/travelin/resources/images/journals/${curJour.id}/theme.jpg')"></div>
			</div>
			<div>
				<input class="hidden" id="chooseImageBtn" type="file" name="image" onchange="previewFile(this)">
			</div>
			
			<!-- Ảnh bìa: <input type="file" name="image"> -->
			<div class="content">
			<div id="locations">
				<div id="banner">Các điểm đến </div>
				<div id="mapzone" style="width: 100%; height: 600px;"></div>
				
				<div class="collection" style="padding: 0 5%">
					<c:if test="${not empty curPlaces}">
						<c:forEach items="${curPlaces}" var="place">
							<div class="card" style=";width: 24%" data-lat="${place.latitude}" data-lng="${place.longtitude}" data-id="${place.id}">
							  	<img data-holder-rendered="true" src="<c:url value="/resources/images/places/${place.id}/theme.jpg"/>" style="width: 100%; display: block;" class="card-img-top">
							  	<div class="card-block">
							  		<div class="card-middle" >
							    		<h4 class="card-title"><a href="/travelin/journals/${place.id}">${place.name}</a></h4>
							    		<span style="text-align: justify; margin-left: 2%">${place.address}, ${place.area.name}</span>
							    	</div>
						    	<div class="card-bottom">
						    	</div>
		  					</div>
		  					<button  type="button" onclick="delPlace(${place.id},event)">X</button>
						</div>
					</c:forEach>
				</c:if>
				</div>
			</div>
			<button class="popup-with-form w3-btn w3-red" type="button" id="tempplace_btn">TẠO ĐIỂM ĐẾN TẠM</button>
			
			<div id="jourImg">
				<div class="fotorama" data-fit="contain" data-nav="thumbs" data-allowfullscreen="true" data-width="700" data-height="400">
					<img src="<c:url value="/resources/images/journals/${curJour.id}/theme.jpg"/>">
					<c:if test="${not empty jourImgs}">
						<c:forEach items="${jourImgs}" var="imgname">
							<img src="<c:url value="/resources/images/journals/${curJour.id}/${imgname}"/>">
						</c:forEach>
					</c:if>
				</div>
			</div>
			<button class="popup-with-form w3-btn w3-red" type="button" id="add-jour-img">THÊM ẢNH</button>
			
			<div id="banner">Nội dung </div>
			<div style="padding: 0 5%;">
			<form:textarea path="content" id="contents" />
			</div>
			
			<br>
			
			
			<form:select class="w3-select" style="margin-left: 5%;" path="datastatus">
				<form:option value="1">Công khai</form:option>
				<form:option value="2">Bạn bè</form:option>
				<form:option value="3">Riêng tư</form:option>
			</form:select><br>
			<input type="text" name="tags" id="tags" class="form-control" value="${curTags}" />
			<c:if test="${curJour.datastatus == 0}">
				<button class="w3-btn banner" onclick="draftJournal(event)" type="button" style="border:none; margin-right:5%;">Lưu nháp</button>
				<input class="w3-btn w3-red banner" style="width: 20%;border:none; float:right; margin-right:5%;" type="submit" value="Đăng chuyến đi">
			</c:if>
			<c:if test="${curJour.datastatus > 0}">
				<input class="w3-btn w3-red banner" style="width: 20%;border:none; float:right; margin-right:5%;" type="submit" value="Lưu cập nhật">
			</c:if>
			</div>
			<form:input path="id" type="hidden" value="${curJour.id}" />
			<form:input path="author.id" type="hidden" value="${curJour.author.id}" />
			<input type="hidden" name="splaces" value="${splaces}"/>
		</form:form>

		<!-- Popup for temp place create -->
		<div id="popUpDiv" class="w3-modal" >
				<form:form action="/travelin/places/addtemp" method="POST" modelAttribute="newTempPlace" onkeypress="return event.keyCode != 13;">
				<div id="tempplaceform" class="w3-modal-content">
				<span class="w3-closebtn">×</span>
				<div id="templacecontent">
				
					<div>
						<h1>TẠO ĐỊA ĐIỂM TẠM THỜI</h1>
					</div>

					<fieldset style="border: 0;">
					<form:input path="name" type="text" placeholder="Tên địa điểm" required="true" class="w3-input"/>
					<form:input path="address" type="text" placeholder="Địa chỉ" required="true" class="w3-input"/>
						<form:select path="area.id" class="w3-select">
							<form:option value="-1">-- Chọn tỉnh/tp --</form:option>
							<c:if test="${not empty cities}">
								<c:forEach items="${cities}" var="city">
									<form:option value="${city.id}">${city.name}</form:option>
								</c:forEach>
							</c:if>
						</form:select>
					
							<form:select path="type" class="w3-select">
								<form:option value="1">Ăn Uống</form:option>
								<form:option value="2">Du Lịch</form:option>
								<form:option value="3">Sức Khỏe</form:option>
								<form:option value="4">Giải trí</form:option>
								<form:option value="5">Mua Sắm</form:option>
							</form:select>
							<br>
							<input id="mapsearch-pac" placeholder="Search box...">
						<div id="maptemp" style="height:400px; width: 100%; background:#2e2e2e"></div>
						<form:input type="hidden" id="lat" path="latitude"/>
						<form:input type="hidden" id="lng" path="longtitude"/>
						<%--<form:input type="hidden" path="createdaccount.id" value="${currentAccount.id}"/>--%>
						<form:input type="hidden" path="updatedaccount.id" value="${currentAccount.id}"/>
						<input name="joid" value="${curJour.id}" type="hidden">
						<button class="w3-btn" id="tempplacemew" type="button">TẠO</button>
						<input type="submit" id="tsbm" style="display:none;">
					</fieldset>
				</div>
			</div>
			</form:form>
			</div>

			<!-- Popup for upload image -->
			<div id="popUpDivImg" class="w3-modal" >
				<div id="imageform" class="w3-modal-content">
				<span class="w3-closebtn">×</span>
				<div id="imagecontent">
				
					<div>
						<h1>Đăng ảnh</h1>
					</div>
					<div style="width:100%"> <!-- up ảnh -->
                    <form style="margin-left:20%; margin-right:20%" action="/travelin/journals/uploadFileImage" method="POST" enctype="multipart/form-data" class="box">
                        <input type="hidden" name="jid" value="${curJour.id}">
                        <div class="box__input">
                            <label class="box__label" for="file"><span class="box__dragndrop"><strong>Nhấn để chọn ảnh</strong> hoặc thả file ảnh vào đây.</span></label>
                            <input class="box__file" type="file" name="upfiles" id="file" data-multiple-caption="Có {count} ảnh được chọn" multiple />
                            
                        </div>
                        <div class="box__uploading">Đang tải lên&hellip;</div>
                        <div class="box__success">Hoàn tất!</div>
                        <div class="box__error">Có lỗi xảy ra! <span></span>.</div>
                    <button class="box__button" style="left:85%;background: transparent;border: 1px solid #2e2e2e;font-family: 'UTMBEBAS';padding-left: 2.5%;font-align:center;padding-right: 2.5%;line-height:40px;height: 60px;font-size: 28px;" type="submit">Đăng ảnh</button>    
                    </form>
                    
                    </div>
                    
				</div>
			</div>
			</div>
	</c:if>	
	</div>
	<script src="<c:url value="/resources/libs/jquery/jquery-2.2.0.min.js" />"></script>
	<script src="<c:url value="/resources/libs/admin/js/bootstrap.min.js" />"></script>
	<script src="<c:url value="/resources/libs/tageditor/jquery.tag-editor.min.js"/>" language="javascript"></script>
	<script src="<c:url value="/resources/libs/ckeditor/ckeditor.js"/>" language="javascript"></script>
	<jsp:include page="footer.jsp"></jsp:include>
	<script src="http://maps.google.com/maps/api/js?key=AIzaSyB2nQCgNH2GoGy41m46qkk45b-kv52fyq0&libraries=geometry,places&v=3.exp&callback=initMap" async defer></script>
	<!-- <script src="http://maps.google.com/maps/api/js?libraries=geometry,places&v=3.exp" async defer></script> -->
	<script type="text/javascript" language="javascript">
		var draftJournal = function(e) {
			$('select[name="datastatus"]').append('<option value="0" selected>Nháp</option>');
			$(e.target).next().click();
			if ($('#title').is(':focus') == true) {
				$('select[name="datastatus"] option:selected').remove();
				$('select[name="datastatus"]').val(1);
			}
		};

		$(document).ready(function() {
			// Get the modal
			var modal = $('#popUpDiv');
			var modalImg = $('#popUpDivImg');

			// Get the button that opens the modal
			var btn = $('#tempplace_btn');
			var btnImg = $('#add-jour-img');

			// Get the <span> element that closes the modal
			var closeBtn = $('.w3-closebtn');

			// When the user clicks the button, open the modal 
			btn.on('click', function() {
				modal.css('display','block');
				if (mapTemp !== null) {		
			    	google.maps.event.trigger(mapTemp, "resize");			
			    	var geocoder = new google.maps.Geocoder();		
			    	geocoder.geocode({'address': "Vietnam"}, function(results, status) {		
			    		if (status == google.maps.GeocoderStatus.OK) {		
					        mapTemp.setCenter(results[0].geometry.location);		
					    }		
			    	});		
			    }		
			});

			btnImg.on('click', function() {
				modalImg.css('display','block');		
			});

			// When the user clicks on <span> (x), close the modal
			closeBtn.on('click',function() {
				$(this).parent().parent().hide();
			});


			// When the user clicks anywhere outside of the modal, close it
			
			$(window).on('click', function(event) {
			    if ($(event.target).hasClass('w3-modal')) $(event.target).hide();
			})

	 	//init upload box
	    createUploadBox($('form.box'), {
	        height: '400px',
	        width: '60%',
	    });
	 	$(window).resize(function(){
		 	$('#journalAuthor img').css("height", $('#journalAuthor img').width());
			$('.card img').css("height", "150px");
			$('.card-middle').css("height", $('.card').width()*0.5);
			$('#newJournal .card button').css("top","-"+($('.card').height()-$('#newJournal .card button').height())+"px");
			$('#newJournal .card button').css("left",$('.card').width()-$('#newJournal .card button').width()+"px");

        });
		
		$('.card img').css("height", "150px");
		$('.card-middle').css("height", $('.card').width()*0.5);
		$('.card').removeClass("hidden");
		$('#journalAuthor img').css("height", $('#journalAuthor img').width());
		$('#newJournal .card button').css("width", $('#newJournal .card button').height());
		$('#newJournal .card button').css("top","-"+($('.card').height()-$('#newJournal .card button').height())+"px");
		$('#newJournal .card button').css("left",$('.card').width()-$('#newJournal .card button').width()+"px");
			
			var ckedit = CKEDITOR.replace('contents', {
				autoParagraph : false,
				resize_enabled : true,
				skin: 'minimalist',
				height : 250 + 'px',
				enterMode : CKEDITOR.ENTER_BR,
				shiftEnterMode : CKEDITOR.ENTER_P,
				toolbar : [ [ 'Source', 'NewPage', 'Preview', '-', 'Templates', '-' ,
						 'Cut', 'Copy', 'Paste', 'PasteText', 'PasteFromWord',
								'-', 'Undo', 'Redo' ,'-' ,
						 'Bold', 'Italic', 'Underline', 'Strike', '-',
								'RemoveFormat' ,'-' ,
						 'Maximize' ,'-',
						 'JustifyLeft', 'JustifyCenter', 'JustifyRight', '-',
								'JustifyBlock', '-',
						 'NumberedList', 'BulletedList', 'Indent', 'Outdent', '-',
								'Table', 'Blockquote', 'CreateDiv' ,'-',
						 'base64image', 'Link', 'Iframe', 'EqnEditor',
								'-', 'TextColor', 'BGColor', 'HorizontalRule' ,
						 'Font', 'FontSize' ] ]
				});
			});

		var tagProps = {
            delimiter : ',; ',
            placeholder : 'Gắn thẻ...',
            forceLowercase : true,
            removeDuplicates : true,
            maxLength : 100
            
        };

        if ($('input[name="id"]').val() !== undefined) {
            var tString = $('#tags').val();
            tagProps.initialTags = tString.split(",");
        }

        $('#tags').tagEditor(tagProps);


		$('#chooseImage').unbind().on('click',function(){
		    $('#chooseImageBtn').click();
		});
		
		$('#tempplacemew').unbind().on('click', function() {
			var lat = $('#lat').val();
			var lng = $('#lng').val();
			if (lat.length == 0 || lng.length == 0) alert("Xin đánh dấu địa điểm trên bản đồ");
			else $('#tsbm').trigger('click');
		});
	
		var previewFile = function(input) {
			var file = input.files;
			if (input.files.length >0 && input.files[0].type.match('image.*')) {
				var reader = new FileReader();
				reader.onload = function(e) {
					$("#journalBlur").css("background-image", "url("+e.target.result+")");
				}
				reader.readAsDataURL(input.files[0]);
			} else {
				input.files = [];
			}
		};
		var delPlace = function(id, e) {
			// console.log(markers);
			if ($('input[name="id"]').val() === undefined) {
				$.ajax({
					url: "/travelin/journals/del-place-session",
					type: "POST",
					data: {
						pid: id
					},
					dataType: 'JSON'
				}).success(function(data) {
					if (data.placessize == 0) $('#journal-bubble').hide();
					$('#journal-bubble').text(data.placessize);
					for (var i = 0 ; i< markers.length ; i++) {
						if (markers[i]['data-id'] == $(e.target).parent().attr('data-id')) {
							markers[i].setMap(null);
							markers.splice(i,1);
						}
					}
					$(e.target).parent().remove();
				});
			} else {
				var sPlaces = $('input[name="splaces"]').val().split(',');
				for (var i = 0; i < sPlaces.length; i++) {
					if (sPlaces[i] == id) {
						sPlaces.splice(i,1);
						break;
					}
				}
				$('input[name="splaces"]').val(sPlaces.join(','));
				for (var i = 0 ; i< markers.length ; i++) {
					if (markers[i]['data-id'] == $(e.target).parent().attr('data-id')) {
						markers[i].setMap(null);
						markers.splice(i,1);
					}
				}
				$(e.target).parent().remove();
			}
			return false;
		};
	</script>
	<script type="text/javascript">
	var map = null;	
	var mapTemp = null;
	var markers = []; // markers for main mapzone
	var infoWindows = []; // infowindow on main mapzone
	var initMap = function() {
        var mapProp = {
            center : new google.maps.LatLng(17.609123, 106.211239),
            zoom : 6,
            mapTypeId : google.maps.MapTypeId.ROADMAP
        };

        var mapDiv = document.getElementById("mapzone");//$("#mapzone");
        var mapTempDiv = document.getElementById("maptemp");//$("#mapzone");
	    map = new google.maps.Map(mapDiv, mapProp);
        mapTemp = new google.maps.Map(mapTempDiv, mapProp);       
        
        // maptemp search box
		var input = document.getElementById('mapsearch-pac');
        var searchBox = new google.maps.places.SearchBox(input);
        mapTemp.controls[google.maps.ControlPosition.TOP_LEFT].push(input);
        mapTemp.addListener('bounds_changed', function() {
		    searchBox.setBounds(mapTemp.getBounds());
		});

		var markersTemp = [];

		searchBox.addListener('places_changed', function() {
			var places = searchBox.getPlaces();

		    if (places.length == 0) {
		      return;
		    }

		    // clean markersTemp
		    markersTemp.forEach(function(marker) {
		      marker.setMap(null);
		    });
		    markersTemp = [];


        	var boundsTemp = new google.maps.LatLngBounds();

		    var marker = new google.maps.Marker({
		        map: mapTemp,
		        // icon: icon,
		        // title: places[0].name,
		        label: '',
		        position: places[0].geometry.location
		      });
		    marker.addListener('click', function() {
                marker.setMap(null);
                $("#lat").val("");
                $("#lng").val("");
                markersTemp = [];
            });
            markersTemp.push(marker);
            $("#lat").val(marker.position.lat);
            $("#lng").val(marker.position.lng);

		    if (places[0].geometry.viewport) {
				// Only geocodes have viewport.
				boundsTemp.union(places[0].geometry.viewport);
			} else {
				boundsTemp.extend(places[0].geometry.location);
			}

			mapTemp.fitBounds(boundsTemp);
        });

        google.maps.event.addListener(mapTemp, 'click', function(event) {
            if (markersTemp.length > 0) {
                alert("Bạn không thể chấm nhiều hơn 1 điểm");
                return false;
            }
            var marker = new google.maps.Marker({
                position : event.latLng,
                label : '',
                map : mapTemp
            });
            marker.addListener('click', function() {
                marker.setMap(null);
                $("#lat").val("");
                $("#lng").val("");
                markersTemp = [];
            });
            markersTemp.push(marker);
            $("#lat").val(marker.position.lat);
            $("#lng").val(marker.position.lng);

        });


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
            infowindow.find('button').remove();
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

			marker['data-id'] = parseInt($(ele).attr('data-id'));
            markers.push(marker);
            bounds.extend(marker.getPosition());

        });
        if (markers.length > 0) map.fitBounds(bounds);
    };
	</script>


