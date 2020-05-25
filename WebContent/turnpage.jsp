<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<!DOCTYPE html>
<html>
<head>
	<link rel="stylesheet" type="text/css" href="css/util.css">
	<link rel="stylesheet" type="text/css" href="css/userview.css">
	<link rel="stylesheet" type="text/css" href="css/datatables.min.css">	
	<link rel="stylesheet" type="text/css" href="vendor/bootstrap/css/bootstrap.min.css">
	<link rel="icon" type="image/png" href="images/icons/favicon.ico" />
	<link rel="stylesheet" type="text/css" href="fonts/iconic/css/material-design-iconic-font.min.css">
	<link rel="stylesheet" href="//maxcdn.bootstrapcdn.com/font-awesome/4.3.0/css/font-awesome.min.css">
	<script src="vendor/jquery/jquery-3.2.1.min.js"></script>
	<script type="text/javascript">
	window.onload=function(){
		turnpage();
	};
	function turnpage(){
		var vaild_username ="${vaild_username}"
		$('#vaild_username').append(vaild_username);
		setTimeout(function(){ window.location.href= '${pageContext.request.contextPath}/HomeServlet';}, 5000);
	}
	</script>
<title>首頁</title>

</head>
<body  style="background-image: url('images/bgblack.png');">
<div style="position: absolute;left: 50%;top: 50%; margin-left: -250px; margin-top: -100px;width: 500px;">
		<img src="images/business-and-finance.png" style="width: 200px;float: left;">
		<h4 id=vaild_username style="color:white;font-family:HanyiSentyGarden;margin-top: 10%;"></h4>
		<h4 style="color:white;font-family:HanyiSentyGarden;">您的帳號已完成驗證</h4>
		<h4 style="color:white;font-family:HanyiSentyGarden;">稍後畫面將自動轉向首頁</h4>
		<h4 style="color:white;font-family:HanyiSentyGarden;">若無跳轉請點擊以下連結</h4>
		<a href=${pageContext.request.contextPath}/HomeServlet style="color: #ef9a9a !important;font-family:HanyiSentyGarden;font-size:large;float: left;">返回首頁</a>
	</div>
		
</body>
</html>