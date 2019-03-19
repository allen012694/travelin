<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Insert title here</title>
<link rel="stylesheet" type="text/css" href="<c:url value="/resources/libs/tageditor/jquery.tag-editor.css" />">
</head>
<body>
	<c:if test="${curPlace!=null}">
		<form:form action="/travelin/updatePlace" method="POST" modelAttribute="curPlace" enctype="multipart/form-data" onkeypress="return event.keyCode != 13;">
			Tên địa điểm: <form:input path="name" />
			<br>
			Ảnh bìa: <input type="file" name="image" value="theme.jpg" />
			<br>
            Tags: <input type="text" name="tags" id="tags" value="${curTags}"/>
            <br>
			Loại địa điểm: <form:select path="type">
				<form:option value="1">Ăn Uống</form:option>
				<form:option value="2">Du Lịch</form:option>
				<form:option value="3">Sức Khỏe</form:option>
				<form:option value="4">Giải trí</form:option>
				<form:option value="5">Mua Sắm</form:option>
			</form:select>
			<br>
			Địa chỉ: <form:input path="address" />
			<br>
			Giờ làm việc: <form:input path="workingtime" />
						<br>
			SĐT: <form:input path="phone" />
						<br>
			Website: <form:input path="website" />
			<br>
			Mô tả: <form:textarea path="description" id="description" />
			<br>

			Vị trí: <div id="mapzone" style="width: 800px; height: 600px"></div>
			<br>
			<form:input path="id" type="hidden" value="${curPlace.id}" />
			<form:input type="hidden" path="longtitude" id="lng" />
			<form:input type="hidden" path="latitude" id="lat" />
			<input type="submit" value="Lưu cập nhật">
		</form:form>

	</c:if>
	<c:if test="${newPlace!=null}">
		<form:form action="/travelin/places/new" method="POST" modelAttribute="newPlace" enctype="multipart/form-data" onkeypress="return event.keyCode != 13;">
			Tên địa điểm: <form:input path="name" />
			<br>
			Ảnh bìa: <input type="file" name="image">
			<br>
            Tags: <input type="text" name="tags" id="tags"/>
            <br>
			Loại địa điểm: <form:select path="type">
				<form:option value="1">Ăn Uống</form:option>
				<form:option value="2">Du Lịch</form:option>
				<form:option value="3">Sức Khỏe</form:option>
				<form:option value="4">Giải trí</form:option>
				<form:option value="5">Mua Sắm</form:option>
			</form:select>
			<br>
			Địa chỉ: <form:input path="address" />
			<br>
			Giờ làm việc: <form:input path="workingtime" />
			<br>
			SĐT: <form:input path="phone" />
			<br>
			Website: <form:input path="website" />
			<br>
			Mô tả: <form:textarea path="description" id="description" />
			<br>
			Vị trí: <div id="mapzone" style="width: 800px; height: 600px"></div>
			<br>
			<form:input type="hidden" path="longtitude" id="lng" />
			<form:input type="hidden" path="latitude" id="lat" />
			<input type="submit" value="Lưu địa điểm">
		</form:form>

	</c:if>

	<script src="<c:url value="/resources/libs/jquery/jquery-2.2.0.min.js" />"></script>
    <script src="<c:url value="/resources/libs/tageditor/jquery.tag-editor.min.js"/>" language="javascript"></script>
    <script src="http://maps.google.com/maps/api/js?key=<spring:eval expression="@credentialsProp.getProperty('google.api.map.key')" />&libraries=geometry,places&v=3.exp"></script>
	<script src="<c:url value="/resources/libs/ckeditor/ckeditor.js"/>" language="javascript"></script>
	<script type="text/javascript" language="javascript">
        $(document).ready(
                function() {
                    var ckedit = CKEDITOR.replace('description', {
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

                    var tagProps = {
                        delimiter: ',; ',
                        placeholder: 'Gắn thẻ...',
                        forceLowercase: true,
                        removeDuplicates: true,
                        maxLength: 100,
                    };

                    if ($('input[name="id"]').val() !== undefined) {
                        var tString = $('#tags').val();
                        tagProps.initialTags = tString.split(",");
                        // console.log(tString);
                        // console.log(tagProps.initialTags);
                    }
                    
                    $('#tags').tagEditor(tagProps);


                    var mapProp = {
                        center : new google.maps.LatLng(14.460214, 108.19336),
                        zoom : 6,
                        mapTypeId : google.maps.MapTypeId.ROADMAP
                    };

                    var mapDiv = document.getElementById("mapzone");//$("#mapzone");
                    var map = new google.maps.Map(mapDiv, mapProp);
                    var markers = [];

                    /* var marker = new google.maps.Marker({
                        position: curCoor,
                        label: '',
                        map: map
                    }); */

                    google.maps.event.addListener(map, 'click', function(event) {
                        if (markers.length > 0) {
                            alert("Bạn không thể chấm nhiều hơn 1 điểm");
                            return false;
                        }
                        var marker = new google.maps.Marker({
                            position : event.latLng,
                            label : '',
                            map : map
                        });
                        marker.addListener('click', function() {
                            marker.setMap(null);
                            $("#lat").val("");
                            $("#lng").val("");
                            markers = [];
                        });
                        markers.push(marker);
                        $("#lat").val(marker.position.lat);
                        $("#lng").val(marker.position.lng);

                    });

                    if ($('input[name="id"]').val() !== undefined) {
                        var marker = new google.maps.Marker({
                            position : {
                                lat : parseFloat($("#lat").val()),
                                lng : parseFloat($("#lng").val())
                            },
                            label : '',
                            map : map
                        });
                        marker.addListener('click', function() {
                            marker.setMap(null);
                            $("#lat").val("");
                            $("#lng").val("");
                            markers = [];
                        });
                        markers.push(marker);
                        map.setCenter(marker.position);
                        map.setZoom(15);
                    }
                    /* $("#getcoor").on('click', function(e) {
                      for (var i = markers.length - 1; i >= 0; i--) {
                        console.log(markers[i].getPosition().lat(),markers[i].getPosition().lng());
                      }
                    });  */
                });
    </script>
</body>
</html>