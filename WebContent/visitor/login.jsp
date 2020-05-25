<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<!DOCTYPE html>
<html>
<head>
	<title>Login</title>
	
<script type="text/javascript">
	window.onload=function(){
		var rule=/^.+$/;//判斷為空的字串(正則表達式)
		$('.login100-form-btn').on("click",function(){
			if(rule.test($("#userinput").val())){//username input
				$('#userempty').html("");
			}else {
				$('#userempty').append("請輸入帳號");
				return false
			}
		    if(rule.test($("#passwordinput").val())){//password input
		    	$('#passwordempty').html("");
			}else {
				$('#passwordempty').append("請輸入密碼");
				return false
			}
		    
		})
	}
</script>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<link rel="stylesheet" type="text/css" href="css/util.css">
	<link rel="stylesheet" type="text/css" href="css/main.css">
	<link rel="icon" type="image/png" href="images/icons/favicon.ico" />
	<link rel="stylesheet" type="text/css" href="vendor/bootstrap/css/bootstrap.min.css">
    <link rel="stylesheet" type="text/css" href="fonts/font-awesome-4.7.0/css/font-awesome.min.css">
	<link rel="stylesheet" type="text/css" href="fonts/iconic/css/material-design-iconic-font.min.css">
<!--===============================================================================================-->
</head>
<body>
	
	<div class="limiter">
		<div class="container-login100" style="background-image: url('images/bg-01.jpg');">
			<div class="wrap-login100" style="background-image: url('images/bgblack.png');width: 500px;">
				<form class="login100-form validate-form" action=LoginServlet method="post">
					<span class="login100-form-logo">
						<i class="zmdi zmdi-landscape"></i>
					</span>

					<span class="login100-form-title p-b-34 p-t-27"style="font-family:HonyaJi-Re;">
						登入
					</span>

					<div class="wrap-input100 validate-input" data-validate = "Enter username">
						<input class="input100" id="userinput" type="text" name="user" placeholder="Username">
						<span class="focus-input100" id="userfocus" data-placeholder="&#xf207;"></span>
						<span id="userempty" style="color: red;top: 50px;position: absolute; font-family: HonyaJi-Re;"></span>

					</div>
					<div style="height: 10px,display: none;">www</div>
					<div class="wrap-input100 validate-input" data-validate="Enter password" >
						<input class="input100" id="passwordinput" type="password" name="password" placeholder="Password">
						<span class="focus-input100" id="passwordfocus" data-placeholder="&#xf191;"></span>
						<span id="passwordempty" style="color: red;top: 50px;position: absolute; font-family: HonyaJi-Re;"></span>

					</div>

					<div class="contact100-form-checkbox">
						<input class="input-checkbox100" id="ckb1" type="checkbox" name="autologin" value="auto">
						<label class="label-checkbox100" for="ckb1" style="font-family:NotoSansCJKtc-DemiLight;">
							記住我
						</label>
					</div>
					<div class="container-login100-form-btn">
						<button class="login100-form-btn" style="font-family:HonyaJi-Re;">
							登入
						</button>
					</div>

				<!-- 	<div class="text-center">
						<a class="txt1" href="#" style="font-family:NotoSansCJKtc-DemiLight;">
							忘記密碼?
						</a>
					</div>-->
					<div class="text-center">
						<a class="txt1" href=${pageContext.request.contextPath}/OpenSinguppageServlet style="font-family:NotoSansCJKtc-DemiLight;">
							註冊
						</a>
					</div>
				</form>
			</div>
		</div>
	</div>
	

	<script src="js/jquery.js"></script>

	<script src="vendor/bootstrap/js/bootstrap.min.js"></script>

<!-- 	<script src="js/main.js"></script>-->
	

</body>
</html>