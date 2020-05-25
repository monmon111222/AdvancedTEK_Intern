<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
	<link rel="stylesheet" href="css/signup.css">
	<link rel="stylesheet" type="text/css" href="css/userview.css">
	<link rel="stylesheet" type="text/css" href="css/util.css">
	<link rel="icon" type="image/png" href="images/icons/favicon.ico" />
	<link rel="stylesheet" type="text/css" href="vendor/bootstrap/css/bootstrap.min.css">
    <link rel="stylesheet" type="text/css" href="fonts/font-awesome-4.7.0/css/font-awesome.min.css">
	<link rel="stylesheet" type="text/css" href="fonts/iconic/css/material-design-iconic-font.min.css">
<title>註冊</title>
	<script src="vendor/jquery/jquery-3.2.1.min.js"></script>
	<script src="vendor/bootstrap/js/popper.js"></script>
	<script src="vendor/bootstrap/js/bootstrap.js"></script>
	<script src="js/bootbox.js"></script>
	<script src="js/jquery.dataTables.js"></script>
	<script src="js/jquery.dataTables.bootstrap.js"></script>

<script type="text/javascript">
	window.onload=function(){
		sidemenu();
		var rule=/^.+$/;//判斷為空的字串(正則表達式)
		$('.login100-form-btn').on("click",function(){
			if(validate()){
					var userID;
					var doID ="${doID}"
					$.ajax({
						type:"post",
						url:"${pageContext.request.contextPath}/SignupServlet",
						datatype:"text",
						//contentType:"false",
						data:{
							tablename:"Account",
							id:0,
							user:$("#account_user").val(),
							name:$("#account_name").val(),//getParameter(xx)
							ename:$("#account_ename").val(),
							password:$("#account_password1").val(),
							phone:$("#account_phone").val(),
							email:$("#account_email").val(),
							address:$("#account_address").val(),
							level:$("[name='account_level']:checked").val()
						},
						success:function(result){
							userID=result;//最新一筆被新增的userID
							if($("#account_photo").val()!=''){
								Accountupload(userID,'insert');
							}else if(userID!='0'){
								alert("註冊已完成請至郵件收取驗證信");
								window.location.href= '${pageContext.request.contextPath}/HomeServlet';
							}else{
								alert("註冊過程發生錯誤 請重新註冊");
								window.location.href= '${pageContext.request.contextPath}/HomeServlet';
							}
						},
						error:function(xhr,ajaxOptions,thrownError){
							alert("");
							alert(xhr.status);
							alert(thrownError);
						}
					});
			}
			return false;
		})

	}
	function Accountupload(userID,type_){
		//上傳照片到server 和 DB
		var doID ="${doID}"
		var formData = new FormData(form_account);
		formData.append("userID", userID);
		formData.append("doID", doID);
		formData.append("type", type_);			
		formData.append("tablename", "Account");
		$.ajax({
			type:"post",
			url:"${pageContext.request.contextPath}/AccountUploadServlet",
			datatype:"text",
			processData: false,
			contentType:false,
			cache : false,
			data:formData,
			async: false,
			success:function(result){
				if(result=='1'){
					alert("註冊已完成請至郵件收取驗證信");
					window.location.href= '${pageContext.request.contextPath}/HomeServlet';
				}else{
					alert("註冊過程發生錯誤 請重新註冊");
					window.location.href= '${pageContext.request.contextPath}/HomeServlet';
				}
					//location.reload();
			},
			error:function(xhr,ajaxOptions,thrownError){
				alert("");
				alert(xhr.status);
				alert(thrownError);
			}
		});
	}
	function validate(){
				var rule = /^.+$/;
				var phone_check=/^09[0-9]{8}$/;
				var return_boolean = true;
				var account_user = $("#account_user");
				var account_name = $("#account_name");
				var account_ename = $("#account_ename");
				var account_password1 = $("#account_password1");
				var account_password2 = $("#account_password2");
				var account_email=$('#account_email');
				var account_phone=$('#account_phone');
				var account_level_val=0;
				account_level_val =$("[name='account_level']:checked").val();
						if(rule.test(account_password1.val())){
							account_password1.siblings('.error').text('');
						}else{
							account_password1.siblings('.error').text('請輸入密碼');
							return_boolean = false;
						}
						if(rule.test(account_password2.val())){
							account_password2.siblings('.error').text('');
						}else{
							account_password2.siblings('.error').text('請輸入密碼');
							return_boolean = false;
						}
						if(rule.test(account_user.val())){
							if(check_repeat(account_user.val())){
								account_user.siblings('.error').text('');
							} else {
								account_user.siblings('.error').text('使用者帳號已存在');
								return_boolean = false;
							}
						}else{
							account_user.siblings('.error').text('請輸入使用者帳號');
							return_boolean = false;
						}
					
							if(rule.test(account_name.val())){
								account_name.siblings('.error').text('');
							}else{
								account_name.siblings('.error').text('請輸入中文名稱');
								return_boolean = false;
							}
							if(rule.test(account_ename.val())){
								account_ename.siblings('.error').text('');
							}else{
								account_ename.siblings('.error').text('請輸入英文名稱');
								return_boolean = false;
							}
							
							if(rule.test(account_email.val())){
								account_email.siblings('.error').text('');
							}else{
								account_email.siblings('.error').text('請輸入Email');
								return_boolean = false;
							}
							if(phone_check.test(account_phone.val())){
								account_phone.siblings('.error').text('');
							}else{
								account_phone.siblings('.error').text('請輸入正確格式');
								return_boolean = false;	
							}	
													
							if(rule.test(account_password1.val()) || rule.test(account_password2.val())){
								if(account_password1.val() == account_password2.val()){
									account_password1.siblings('span').text('');
									account_password2.siblings('span').text('');
									
								}else{
									account_password1.siblings('span').text('輸入的密碼不同');
									account_password2.siblings('span').text('輸入的密碼不同');
									
									return_boolean = false;
								}
							}
				return return_boolean;
			}
	function check_repeat(account_user){
		return_check = false;
		$.ajax({
    		type:"post", 
            url:"${pageContext.request.contextPath}/AccountSearchServelt",
            dataType:"json",
            async: false,
            data: {
            	//<%-- 使用者帳號 --%>
            	user : account_user,
            },
            success: function(result){
            	if(result.length === 0){
            		return_check = true;}
            },
            error:
                function(xhr, ajaxOptions, thrownError){
                    alert(xhr.status+"\n"+thrownError);
                }
		});
		return return_check;
	}
</script>
</head>

<body  style="background-image: url('images/bgblack.png');">
<jsp:include page="../slidemenu.jsp"/>
 <div class="wrap-login100">
				<form id="form_account" class="form-horizontal" method="post" accept-charset="utf-8" role="form" enctype="multipart/form-data">
										<span class="login100-form-title p-b-34 p-t-27" style="font-family:HanyiSentyGarden;font-size: 70px;">
						註冊會員
					</span>

					<div class="wrap-input100 validate-input"  style="float:left;right: 10px;">
						<input class="input100" id="account_user" type="text" name="user" placeholder="帳號">
						<span class="focus-input100" id="userfocus" data-placeholder="&#xf207;"></span>
						<span class="red error"id="userempty" style="color: red;top: 50px;position: absolute; font-family: NotoSansCJKtc-DemiLight;"></span>
					</div>
					<div class="wrap-input100 validate-input"  style="float:right">
						<input class="input100" id="account_name" type="text" name="name" style="font-size:23px !important;" placeholder="中文姓名">
						<span class="focus-input100" id="userfocus" data-placeholder="&#xf207;"></span>
						<span class="red error"id="nameempty" style="color: red;top: 50px;position: absolute; font-family: NotoSansCJKtc-DemiLight;"></span>
					</div>
					<div class="wrap-input100 validate-input"  style="float:left;right: 10px;">
						<input class="input100" id="account_password1" type="password" name="password" style="font-size:23px !important;" placeholder=密碼>
						<span class="focus-input100" id="userfocus" data-placeholder="&#xf207;"></span>
						<span class="red error"id="userempty" style="color: red;top: 50px;position: absolute; font-family: NotoSansCJKtc-DemiLight;"></span>
					</div>
					<div class="wrap-input100 validate-input"  style="float:right">
						<input class="input100" id="account_ename" type="text" name="ename" style="font-size:23px !important;" placeholder="英文姓名">
						<span class="focus-input100" id="userfocus" data-placeholder="&#xf207;"></span>
						<span class="red error"id="nameempty" style="color: red;top: 50px;position: absolute; font-family: NotoSansCJKtc-DemiLight;"></span>
					</div>
					<div class="wrap-input100 validate-input"  style="float:left;right: 10px;">
						<input class="input100" id="account_password2" type="password" name="passwordcheck" style="font-size:23px !important;" placeholder=確認密碼>
						<span class="focus-input100" id="userfocus" data-placeholder="&#xf207;"></span>
						<span class="red error"id="userempty" style="color: red;top: 50px;position: absolute; font-family: NotoSansCJKtc-DemiLight;"></span>
					</div>
					<div class="wrap-input100 validate-input"  style="float:right">
						<input class="input100" id="account_email" type="email" name="email" style="font-size:23px !important;" placeholder="電子信箱">
						<span class="focus-input100" id="userfocus" data-placeholder="&#xf207;"></span>
						<span class="red error"id="nameempty" style="color: red;top: 50px;position: absolute; font-family: NotoSansCJKtc-DemiLight;"></span>
					</div>
					<div class="wrap-input100 validate-input"  style="float:left;right: 10px;">
						<input class="input100" id="account_phone" type="text" name="phone" style="font-size:23px !important;" placeholder=手機號碼>
						<span class="focus-input100" id="userfocus" data-placeholder="&#xf207;"></span>
						<span class="red error"id="userempty" style="color: red;top: 50px;position: absolute; font-family: NotoSansCJKtc-DemiLight;"></span>
					</div>
					<div class="wrap-input100 validate-input"  style="float:right;">
						<input class="input100" id="account_address" type="text" name="phone" style="font-size:23px !important;"placeholder=地址(選填)>
						<span class="focus-input100" id="addressfocus" data-placeholder="&#xf207;"></span>
						<span id="userempty" style="color: red;top: 50px;position: absolute; font-family: NotoSansCJKtc-DemiLight;"></span>
					</div>
					<div class="wrap-input100 validate-input"  style="float:left;right: 10px;">
						<label for="account_photo" style="font-family:NotoSansCJKtc-DemiLight;font-size:23px !important;color: white;">上傳頭像</label>
						<input type="file" class="form-control" id="account_photo" name="input_account_photo"style="font-family:NotoSansCJKtc-DemiLight;font-size:20px;color: white;background-color: transparent;"/>
					</div>
					<div class="wrap-input100 validate-input"  style="float:right;">
						<label for="account_level" style="font-family:NotoSansCJKtc-DemiLight;font-size:20px !important;color: white;">身分</label>
						<label for="account_level" style="font-family:NotoSansCJKtc-DemiLight;font-size:20px !important;color: gray;">(註冊後 身分無法作變更)</label><br>
						<input type="radio" checked id="account_level3" name="account_level"value="3">
						<label for="account_level" style="font-family:NotoSansCJKtc-DemiLight;font-size:20px !important;color: white;">買家</label>
						<input type="radio" id="account_level4" name="account_level"value="4">
						<label for="account_level"style="font-family:NotoSansCJKtc-DemiLight;font-size:20px !important;color: white;">買賣家</label>
					</div>
					<div class="container-login100-form-btn">
						<button class="login100-form-btn" id="insertuser" style="font-family:HanyiSentyGarden;font-size:30px;">
							註冊
						</button>
					</div>
				</form> 
			</div>   
</body>
</html>