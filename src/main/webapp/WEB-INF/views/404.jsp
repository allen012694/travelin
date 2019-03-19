<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%-- <%@ include file="header.jsp" %> --%>
<jsp:include page="header.jsp">
    <jsp:param value="TravelIn - Lỗi" name="headtitle"/>
</jsp:include>
<style type="text/css">

	
.wrap{
font-family: 'UTMBEBAS';
position:relative;
z-index:2;
background: transparent;
	height: 300px;
	margin:auto;
	width:100%;
}
.sign h1{
	
	color:#2e2e2e;
	text-align:center;
	margin-bottom:10px;
	text-shadow:1px 1px 6px #fff;
}	
.sign p{
	color:#d58459;
	font-size: 40px;
	margin-bottom:10px;
	text-align:center;
}	
.sign p span{
	color:lightgreen;
}	
.sub a{
	color:#faf5ef;
	background:#2e2e2e;
	text-decoration:none;
	padding:7px 120px;
	font-size:13px;
	font-family: arial, serif;
	font-weight:bold;
	-webkit-border-radius:3em;
	-moz-border-radius:.1em;
	-border-radius:.1em;
}	

</style>
<head>
<title></title>
</head>
<body>
<input type="hidden" id="error" value="${exception }"/>
<body>
	<div class="wrap">
	   <div class="sign">
	   <h1><img src="<c:url value="/resources/libs/travelin/img/error-logo.png"/>" align="middle"></img></h1>
	    <p>Trang không tồn tại</p>
  	      <div class="sub">
	        <p><a href="javascript:history.go(-1)">Back</a></p>
	      </div>
        </div>
	</div>
	
	
</body>
</body>
<%@ include file="footer.jsp" %>
<script type="text/javascript">
	console.log($("#error").val());
</script>