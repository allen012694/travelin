<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="">
    <meta name="author" content="Dashboard">
    <meta name="keyword" content="Dashboard, Bootstrap, Admin, Template, Theme, Responsive, Fluid, Retina">

    <title>TravelIn - Quản trị</title>

    
    <link rel="stylesheet" type="text/css" href="<c:url value="/resources/libs/admin/css/bootstrap.css" />">
    <link rel="stylesheet" type="text/css" href="<c:url value="/resources/libs/admin/font-awesome/css/font-awesome.css" />">    
    <link rel="stylesheet" type="text/css" href="<c:url value="/resources/libs/admin/css/style.css" />">
    <link rel="stylesheet" type="text/css" href="<c:url value="/resources/libs/admin/css/style-responsive.css" />">
    <link rel="stylesheet" type="text/css" href="<c:url value="/resources/libs/admin/css/jasny-bootstrap.css" />">
    <link rel="stylesheet" type="text/css" href="<c:url value="/resources/libs/contextmenu/dist/jquery.contextMenu.css" />">
    <link rel="stylesheet" type="text/css" href="<c:url value="/resources/libs/datatable/jquery.dataTables.css"/>">
    <link rel="stylesheet" type="text/css" href="<c:url value="/resources/libs/datatable/dataTables.bootstrap.css"/>">
  </head>

  <body>

  <section id="container" >
      <!-- **********************************************************************************************************************************************************
      TOP BAR CONTENT & NOTIFICATIONS
      *********************************************************************************************************************************************************** -->
      <!--header start-->
      <header class="header black-bg">
              <div class="sidebar-toggle-box">
                  <div class="fa fa-bars tooltips" data-placement="right" data-original-title="Toggle Navigation"></div>
              </div>
            <!--logo start-->
            <a href="/travelin/" class="adminlogo"><b>TRAVELIN</b></a>
            <!--logo end-->
            
            <div class="top-menu">
              <ul class="nav pull-right top-menu">
                    <li><a class="logout" href="/travelin/logout">Đăng xuất</a></li>
              </ul>
            </div>
      </header>
      <!--header end-->
      
      <!-- **********************************************************************************************************************************************************
      MAIN SIDEBAR MENU
      *********************************************************************************************************************************************************** -->
      <!--sidebar start-->
      <aside>
          <div id="sidebar"  class="nav-collapse ">
              <!-- sidebar menu start-->
              <ul class="sidebar-menu" id="nav-accordion">
                  <span style="display:none" id="ijklmn" data-role="${currentAccount.role}">${currentAccount.id}</span>
                  <p class="centered" id="ava"><a  href="/travelin/dashboard"><img src="<c:url value="/resources/images/accounts/${currentAccount.id}/avatar.jpg"/>" class="img-circle" width="60" height="60"></a></p>
                  <h5 class="centered">${currentAccount.username}</h5>
                    
                  <li class="mt">
                      <a <c:if test="${fn:containsIgnoreCase(path, 'admindashboard')}">class="active"</c:if> id="admindashboard" href="/travelin/admin/dashboard">
                          <i class="fa fa-home"></i>
                          <span>Bảng tin</span>
                      </a>
                  </li>
                  <c:if test="${currentAccount.role == 3}">
                    <li class="sub-menu">
                        <a href="/travelin/admin/accounts" id="adminaccounts" <c:if test="${fn:containsIgnoreCase(path, 'adminaccounts')}">class="active"</c:if>>
                            <i class="fa fa-user"></i>
                            <span>Tài khoản</span>
                        </a>
                    </li>
                    <li class="sub-menu">
                        <a href="/travelin/admin/areas" <c:if test="${fn:containsIgnoreCase(path, 'adminareas')}">class="active"</c:if> id="adminareas">
                            <i class="fa fa-map"></i>
                            <span>Khu vực</span>
                        </a>
                    </li>
                  </c:if>
                  <c:if test="${currentAccount.role > 1}">
                  <li class="sub-menu">
                      <a href="/travelin/admin/articles" id="adminarticles" <c:if test="${fn:containsIgnoreCase(path, 'adminarticles')}">class="active"</c:if>>
                          <i class="fa fa-newspaper-o"></i>
                          <span>Bài viết</span>
                      </a>
                  </li>
                  </c:if>
                  <li class="sub-menu" >
                      <a href="/travelin/admin/places" <c:if test="${fn:containsIgnoreCase(path, 'adminplaces')}">class="active"</c:if> id="adminplaces">
                          <i class="fa fa-location-arrow"></i>
                          <span>Địa điểm</span>
                      </a>
                  </li>
                  <c:if test="${currentAccount.role > 1}">
                  <li class="sub-menu">
                      <a href="/travelin/admin/journals" id="adminjournals" <c:if test="${fn:containsIgnoreCase(path, 'adminjournals')}">class="active"</c:if>>
                          <i class="fa fa-cab"></i>
                          <span>Chuyến đi</span>
                      </a>
                  </li>
                  </c:if>
                  <c:if test="${currentAccount.role > 1}">
                  <li class="sub-menu">
                      <a href="/travelin/admin/feedbacks" id="adminfeedbacks" <c:if test="${fn:containsIgnoreCase(path, 'adminfeedbacks')}">class="active"</c:if>>
                          <i class="fa fa-comments"></i>
                          <span>Góp ý</span>
                      </a>
                  </li>
                  </c:if>
              </ul>
              <!-- sidebar menu end-->
          </div>
      </aside>
      <!--sidebar end-->
      


 <!-- js placed at the end of the document so the pages load faster -->
    <script src="<c:url value="/resources/libs/jquery/jquery-2.2.0.min.js" />"></script>
    <script src="<c:url value="/resources/libs/admin/js/jquery.js" />"></script>
    <script src="<c:url value="/resources/libs/admin/js/bootstrap.min.js" />"></script>
    <script src="<c:url value="/resources/libs/admin/js/jquery-ui-1.9.2.custom.min.js" />"></script>
    <script src="<c:url value="/resources/libs/admin/js/jquery.ui.touch-punch.min.js" />"></script>
    <script class="include" type="text/javascript" src="<c:url value="/resources/libs/admin/js/jquery.dcjqaccordion.2.7.js"/>"></script>
    <script src="<c:url value="/resources/libs/admin/js/jquery.scrollTo.min.js" />"></script>
    <script src="<c:url value="/resources/libs/admin/js/jquery.nicescroll.js" />"></script>
    <script src="<c:url value="/resources/libs/admin/js/jasny-bootstrap.js" />"></script>


    <!--common script for all pages-->
    <script src="<c:url value="/resources/libs/admin/js/common-scripts.js" />"></script>
    <script src="<c:url value="/resources/libs/datatable/jquery.dataTables.min.js"/>" language="javascript"></script>
    <script src="<c:url value="/resources/libs/datatable/dataTables.bootstrap.min.js"/>" language="javascript"></script>
    <script src="<c:url value="/resources/libs/contextmenu/dist/jquery.contextMenu.js"/>" language="javascript"></script>
    <script src="<c:url value="/resources/libs/contextmenu/dist/jquery.ui.position.js"/>" language="javascript"></script> 





      <!-- **********************************************************************************************************************************************************
      MAIN CONTENT
      *********************************************************************************************************************************************************** -->
      <!--main content start-->
      <section id="main-content">
        <section class="wrapper site-min-height">
          <c:if test="${path != null}">
            <jsp:include page="/${request.contextPath}/${path}"></jsp:include>
          </c:if>
          <c:if test="${path == null}">
            <jsp:include page="/${request.contextPath}/admindashboard"></jsp:include>
          </c:if>
        </section>
      </section><!-- /MAIN CONTENT -->

      <!--main content end-->
      <!--footer start-->
      <footer class="site-footer">
          <div class="text-center">
              2016 - TravelIn
              <a href="#" class="go-top">
                  <i class="fa fa-angle-up"></i>
              </a>
          </div>
      </footer>
      <!--footer end-->
  </section>

   

  </body>
</html>
