<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<link rel="stylesheet" type="text/css" href="<c:url value="/resources/libs/tageditor/jquery.tag-editor.css" />">
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<style type="text/css">
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
<div class='row mt'>
	<div class='col-lg-12'>
		<div class='form-panel'>
			<c:if test="${curPlace!=null}">
				<form:form class="form-horizontal style-form"
					action="/travelin/places/update" method="POST"
					modelAttribute="curPlace" enctype="multipart/form-data" onkeypress="return event.keyCode != 13;">
					<h4 class="mb">
						<i class="fa fa-angle-right"></i> Chỉnh sửa địa điểm
					</h4>
					<div class="form-group">
						<label class="col-sm-2 col-sm-2 control-label">Tên địa điểm: </label>
						<div class="col-sm-10">
							<c:if test="${curPlace.createdaccount.id  == currentAccount.id || currentAccount.role > 1}"><form:input type="text" class="form-control" path="name" required="true" pattern=".{1,200}"/></c:if>
							<c:if test="${curPlace.createdaccount.id  != currentAccount.id && currentAccount.role <= 1}"><span>${curPlace.name}</span></c:if>
						</div>
					</div>
					<div class="form-group">
						<label class="col-sm-2 col-sm-2 control-label">Ảnh bìa: </label>
						<div class="col-sm-10">
						<span style="float:left; width: 10%;; margin-right: 1%;"><img src="<c:url value="/resources/images/places/${curPlace.id}/theme.jpg"/>" style="width: 100%;"></span>
							<div class="fileinput fileinput-new" data-provides="fileinput">
								<c:if test="${curPlace.createdaccount.id  == currentAccount.id || currentAccount.role > 1}">
								<span class="btn btn-default btn-file"><span>Choose
										file</span><input type="file" name="image" onchange="previewFile(this)"/></span> <span
									class="fileinput-filename"></span><span class="fileinput-new">No
									file chosen</span> <span class="help-block">Choose a cover
									image</span>
								</c:if>
							</div>
						</div>
					</div>
					<%--<div class="form-group">
						<label class="col-sm-2 col-sm-2 control-label">Ưu tiên: </label>
						<div class="col-sm-10">
							<form:select path="priority">
								<form:option value="0">0</form:option>
								<form:option value="1">1</form:option>
								<form:option value="2">2</form:option>
								<form:option value="3">3</form:option>
								<form:option value="4">4</form:option>
								<form:option value="5">5</form:option>
							</form:select>
						</div>
					</div>--%>
					<div class="form-group">
						<label class="col-sm-2 col-sm-2 control-label">Loại địa
							điểm: </label>
						<div class="col-sm-2">
						<c:if test="${curPlace.createdaccount.id  == currentAccount.id || currentAccount.role > 1}">
							<form:select class="form-control" path="type">
								<form:option value="1">Ăn Uống</form:option>
								<form:option value="2">Du Lịch</form:option>
								<form:option value="3">Sức Khỏe</form:option>
								<form:option value="4">Giải trí</form:option>
								<form:option value="5">Mua Sắm</form:option>
							</form:select>
						</c:if>
						<c:if test="${curPlace.createdaccount.id  != currentAccount.id && currentAccount.role <= 1}">
							<c:choose>
								<c:when test="${curPlace.type==1}">Ăn uống</c:when>
								<c:when test="${curPlace.type==2}">Du lịch</c:when>
								<c:when test="${curPlace.type==3}">Sức khỏe</c:when>
								<c:when test="${curPlace.type==4}">Giải trí</c:when>
								<c:when test="${curPlace.type==5}">Mua sắm</c:when>
								<c:otherwise></c:otherwise>
							</c:choose>	
						</c:if>
						</div>
					</div>
					<div class="form-group">
						<label class="col-sm-2 col-sm-2 control-label">Tags: </label>
						<div class="col-sm-10">
							<c:if test="${curPlace.createdaccount.id  != currentAccount.id && currentAccount.role <= 1}">
								${curTags}
							</c:if>
							<c:if test="${curPlace.createdaccount.id  == currentAccount.id || currentAccount.role > 1}">
								<input type="text" name="tags" id="tags" class="form-control" value="${curTags}" >
							</c:if>
						</div>
					</div>
					<div class="form-group">
						<label class="col-sm-2 col-sm-2 control-label">Khu vực:</label>
						<div class="col-sm-2">
							<c:if test="${curPlace.createdaccount.id  != currentAccount.id && currentAccount.role <= 1}">
								${curPlace.area.name}
							</c:if>
							<c:if test="${curPlace.createdaccount.id == currentAccount.id || currentAccount.role > 1}">
							<form:select path="area.id" class="form-control">
								<form:option value="-1">-- Chọn Tỉnh/TP --</form:option>
								<c:if test="${not empty cities}">
									<c:forEach items="${cities }" var="city">
										<form:option value="${city.id }">${city.name}</form:option>
									</c:forEach>
								</c:if>
							</form:select>
							</c:if>
						</div>
					</div>
					<div class="form-group">
						<label class="col-sm-2 col-sm-2 control-label">Địa chỉ: </label>
						<div class="col-sm-10">
							<c:if test="${curPlace.createdaccount.id  != currentAccount.id || currentAccount.role > 1}">
								${curPlace.address}
							</c:if>
							<c:if test="${curPlace.createdaccount.id  == currentAccount.id && currentAccount.role <= 1}">
								<form:input type="text" class="form-control" path="address" />
							</c:if>
						</div>
					</div>
					<div class="form-group">
						<label class="col-sm-2 col-sm-2 control-label">Giờ làm
							việc: </label>
						<div class="col-sm-4">
						<c:if test="${curPlace.createdaccount.id  != currentAccount.id && currentAccount.role <= 1}">
							${curPlace.workingtime}
						</c:if>
						<c:if test="${curPlace.createdaccount.id  == currentAccount.id || currentAccount.role > 1}">
							<form:input type="text" class="form-control" path="workingtime" />
						</c:if>
						</div>
					</div>
					<div class="form-group">
						<label class="col-sm-2 col-sm-2 control-label">SĐT: </label>
						<div class="col-sm-4">
							<c:if test="${curPlace.createdaccount.id  != currentAccount.id && currentAccount.role <= 1}">
								${curPlace.phone}
							</c:if>
							<c:if test="${curPlace.createdaccount.id  == currentAccount.id || currentAccount.role > 1}">
								<form:input type="text" class="form-control" path="phone" />
							</c:if>
						</div>
					</div>
					<div class="form-group">
						<label class="col-sm-2 col-sm-2 control-label">Website: </label>
						<div class="col-sm-4">
							 <c:if test="${curPlace.createdaccount.id  != currentAccount.id && currentAccount.role <= 1}">
							 	${curPlace.website}
							 </c:if>
							 <c:if test="${curPlace.createdaccount.id  == currentAccount.id || currentAccount.role > 1}">
								<form:input type="text" class="form-control" path="website" />
							 </c:if>
						</div>
					</div>
					<div class="form-group">
						<label class="col-sm-2 col-sm-2 control-label">Mô tả: </label>
						<div class="col-sm-10">
							<c:if test="${curPlace.createdaccount.id != currentAccount.id && currentAccount.role <= 1}">
								${curPlace.description}
							</c:if>
							<c:if test="${curPlace.createdaccount.id == currentAccount.id || currentAccount.role > 1}">
								<form:textarea type="text" id="description" class="form-control" path="description"/>
							</c:if>
						</div>
					</div>
					
					<div class="form-group">
						<label class="col-sm-2 col-sm-2 control-label">Vị trí: </label>
						<div class="col-sm-10">
							<input id="mapsearch-pac" placeholder="Search box...">
							<div id="mapzone" style="width: 100%; height: 600px"></div>
						</div>
					</div>
					<form:input type="hidden" path="longtitude" id="lng" />
					<form:input type="hidden" path="latitude" id="lat" />
					<form:input path="id" type="hidden" value="${curPlace.id}" />
					<span id="authorid" style="display:none;">${curPlace.createdaccount.id}</span>
					<c:if test="${curPlace.createdaccount.id  == currentAccount.id || currentAccount.role > 1}">
						<input type="hidden" name="curfunc" value="admin/places"/>
						<input type="hidden" name="cururl" value="admin"/>
						<form:input type="hidden" path="createdaccount.id" />
						<input type="submit" class="btn btn-default" value="Lưu cập nhật">
					</c:if>
				</form:form>









			</c:if>
			<c:if test="${newPlace!=null}">
				<form:form class="form-horizontal style-form"
					action="/travelin/places/new" method="POST"
					modelAttribute="newPlace" enctype="multipart/form-data" onkeypress="return event.keyCode != 13;">
					<h4 class="mb">
						<i class="fa fa-angle-right"></i> Tạo địa điểm
					</h4>
					<div class="form-group">
						<label class="col-sm-2 col-sm-2 control-label">Tên địa
							điểm: </label>
						<div class="col-sm-10">
							<input type="text" class="form-control" name="name" required pattern=".{1,200}"/>
						</div>
					</div>
					<div class="form-group">
						<label class="col-sm-2 col-sm-2 control-label">Ảnh bìa: </label>
						<div class="col-sm-10">
							<span style="float:left; width: 10%;; margin-right: 1%;"></span>
							<div class="fileinput fileinput-new" data-provides="fileinput">
								<span class="btn btn-default btn-file"><span>Choose
										file</span><input type="file" name="image" onchange="previewFile(this)" /></span> <span
									class="fileinput-filename"></span><span class="fileinput-new">No
									file chosen</span> <span class="help-block">Choose a cover
									image</span>
							</div>
						</div>
					</div>
					<!-- <div class="form-group">
						<label class="col-sm-2 col-sm-2 control-label">Ưu tiên: </label>
						<div class="col-sm-10">
							<form:select path="priority">
								<form:option value="0">0</form:option>
								<form:option value="1">1</form:option>
								<form:option value="2">2</form:option>
								<form:option value="3">3</form:option>
								<form:option value="4">4</form:option>
								<form:option value="5">5</form:option>
							</form:select>
						</div>
					</div> -->
					<div class="form-group">
						<label class="col-sm-2 col-sm-2 control-label">Loại địa
							điểm: </label>
						<div class="col-sm-2">
							<form:select class="form-control" path="type">
								<form:option value="1">Ăn Uống</form:option>
								<form:option value="2">Du Lịch</form:option>
								<form:option value="3">Sức Khỏe</form:option>
								<form:option value="4">Giải trí</form:option>
								<form:option value="5">Mua Sắm</form:option>
							</form:select>
						</div>
					</div>
					<div class="form-group">
						<label class="col-sm-2 col-sm-2 control-label">Tags: </label>
						<div class="col-sm-10">
							<input type="text" name="tags" id="tags" class="form-control" />
						</div>
					</div>
					<div class="form-group">
						<label class="col-sm-2 col-sm-2 control-label">Khu vực:</label>
						<div class="col-sm-2">
							<form:select path="area.id" class="form-control">
								<form:option value="-1">-- Chọn Tỉnh/TP --</form:option>
								<c:if test="${not empty cities}">
									<c:forEach items="${cities }" var="city">
										<form:option value="${city.id }">${city.name}</form:option>
									</c:forEach>
								</c:if>
							</form:select>
						</div>
					</div>
					<div class="form-group">
						<label class="col-sm-2 col-sm-2 control-label">Địa chỉ: </label>
						<div class="col-sm-6">
							<form:input type="text" class="form-control" path="address" />

						</div>
						<div class="col-sm-4">
							<button class="btn btn-default" onclick="toTheMap()" type="button">Tìm trên bản đồ</button>
						</div>
					</div>
					<div class="form-group">
						<label class="col-sm-2 col-sm-2 control-label">Giờ làm
							việc: </label>
						<div class="col-sm-4">
							<form:input type="text" class="form-control" path="workingtime" />
						</div>
					</div>
					<div class="form-group">
						<label class="col-sm-2 col-sm-2 control-label">SĐT: </label>
						<div class="col-sm-4">
							<form:input type="text" class="form-control" path="phone" />
						</div>
					</div>
					<div class="form-group">
						<label class="col-sm-2 col-sm-2 control-label">Website: </label>
						<div class="col-sm-4">
							<form:input type="text" class="form-control" path="website" />
						</div>
					</div>
					<div class="form-group">
						<label class="col-sm-2 col-sm-2 control-label">Mô tả: </label>
						<div class="col-sm-10">
							<form:textarea type="text" id="description" class="form-control"
								path="description" />
						</div>
					</div>
					<div class="form-group">
						<label class="col-sm-2 col-sm-2 control-label">Vị trí: </label>
						<div class="col-sm-10">
							<input id="mapsearch-pac" placeholder="Search box...">
							<div id="mapzone" style="width: 100%; height: 600px"></div>
						</div>
					</div>

					<form:input type="hidden" path="longtitude" id="lng" />
					<form:input type="hidden" path="latitude" id="lat" />
					<input type="hidden" name="curfunc" value="admin/places"/>
					<input type="hidden" name="cururl" value="admin"/>
					<input type="submit" class="btn btn-default" value="Tạo địa điểm">
				</form:form>

			</c:if>
		</div>
	</div>
</div>
<script src="<c:url value="/resources/libs/tageditor/jquery.tag-editor.min.js"/>" language="javascript"></script>
<script src="http://maps.google.com/maps/api/js?key=<spring:eval expression="@credentialsProp.getProperty('google.api.map.key')" />&libraries=geometry,places&v=3.exp&callback=initMap" async defer></script>
<script src="<c:url value="/resources/libs/ckeditor/ckeditor.js"/>"
	language="javascript"></script>
<script type="text/javascript" language="javascript">
    var toTheMap = function() {
    	if ($('select[name="area.id"] option:selected').val() == -1) {
    		alert('Xin vui lòng chọn khu vực!');
    		return false;
    	}
    	if ($('input[name="address"]').val().length ==0 ) {
    		alert('Xin vui lòng nhập địa chỉ!');
    		return false;
    	}
    	window.scrollBy(0,document.getElementById('mapzone').getBoundingClientRect().y-68);
    	$('#mapsearch-pac').val($('input[name="address"]').val()+', '+$('select[name="area.id"] option:selected').text());
		var input = document.getElementById('mapsearch-pac');
		google.maps.event.trigger(input, 'focus')
        google.maps.event.trigger(input, 'keydown', {
            keyCode: 13
        });
    };
    var previewFile = function(input) {
		var file = input.files;
		if (input.files.length >0 && input.files[0].type.match('image.*')) {
			var reader = new FileReader();
			reader.onload = function(e) {
				// $("#journalBlur").css("background-image", "url("+e.target.result+")");
				$(input).parent().parent().prev().html('<img src="'+e.target.result+'" style="width: 100%;">');
			}
			reader.readAsDataURL(input.files[0]);
		} else {
			input.files = [];
		}
	};
    $(document).ready(
            function() {
            	var curaccid = $('#ijklmn').text();
            	var createdaccid = $('#authorid').text();
            	if (createdaccid === undefined || curaccid == createdaccid || $('#ijklmn').attr('data-role') > 1) {
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
								 'Font', 'FontSize' ]]
					});

                	var tagProps = {
                        delimiter : ',; ',
                        placeholder : 'Gắn thẻ...',
                        forceLowercase : true,
                        removeDuplicates : true,
                        maxLength : 100,
                    };

                    if ($('input[name="id"]').val() !== undefined) {
                        var tString = $('#tags').val();
                        tagProps.initialTags = tString.split(",");
                        // console.log(tString);
                        // console.log(tagProps.initialTags);
                    }

                    $('#tags').tagEditor(tagProps);
                }
                /* $("#getcoor").on('click', function(e) {
                  for (var i = markers.length - 1; i >= 0; i--) {
                    console.log(markers[i].getPosition().lat(),markers[i].getPosition().lng());
                  
}                });  */
            });
    

    var initMap = function() {
    	var curaccid = $('#ijklmn').text();
		var createdaccid = $('#authorid').text();
        var mapProp = {
            center : new google.maps.LatLng(17.609123, 106.211239),
            zoom : 6,
            mapTypeId : google.maps.MapTypeId.ROADMAP
        };
        var mapDiv = document.getElementById("mapzone");//$("#mapzone");
        var map = new google.maps.Map(mapDiv, mapProp);

        var input = document.getElementById('mapsearch-pac');
        var searchBox = new google.maps.places.SearchBox(input);
        map.controls[google.maps.ControlPosition.TOP_LEFT].push(input);
        var markers = [];

        if (createdaccid === undefined || curaccid == createdaccid || $('#ijklmn').attr('data-role') > 1) {
	        
	        map.addListener('bounds_changed', function() {
			    searchBox.setBounds(map.getBounds());
			});

			searchBox.addListener('places_changed', function() {
				var places = searchBox.getPlaces();

			    if (places.length == 0) {
			      return;
			    }

			    // clean markers
			    markers.forEach(function(marker) {
			      marker.setMap(null);
			    });
			    markers = [];


	        	var bounds = new google.maps.LatLngBounds();

			    var marker = new google.maps.Marker({
			        map: map,
			        // icon: icon,
			        // title: places[0].name,
			        label: '',
			        position: places[0].geometry.location
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

			    if (places[0].geometry.viewport) {
					// Only geocodes have viewport.
					bounds.union(places[0].geometry.viewport);
				} else {
					bounds.extend(places[0].geometry.location);
				}

				map.fitBounds(bounds);
	        });

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
    	}
        if ($('input[name="id"]').val() !== undefined && $("#lat").val().length>0 && $("#lng").val().length > 0) {
            var marker = new google.maps.Marker({
                position : {
                    lat : parseFloat($("#lat").val()),
                    lng : parseFloat($("#lng").val())
                },
                label : '',
                map : map
            });
            if (createdaccid === undefined || curaccid == createdaccid || $('#ijklmn').attr('data-role') > 1) {
	            marker.addListener('click', function() {
	                marker.setMap(null);
	                $("#lat").val("");
	                $("#lng").val("");
	                markers = [];
	            });
        	}
            markers.push(marker);
            map.setCenter(marker.position);
            map.setZoom(15);
        }
    };
</script>