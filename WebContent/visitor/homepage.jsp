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
		homepage();
		sidemenu();
	};
	function homepage(){
	     var doID ="${doID}"
	     var dolevel ="${level}"
     	 if(doID){
	              if(dolevel.indexOf('1')===0){//管理員
	            	  $('body').css('background-image', 'linear-gradient(to right, rgba(10, 16, 41, 0.65),rgba(10, 16, 41, 0.65)),url("images/about-video.jpg")');
		              $('body').css('background-size','100% 100%,100% 100%');
	              }else if(dolevel.indexOf('3')===0){//買家
	            	  $('body').css('background-image', 'linear-gradient(to right, rgba(25, 40, 103, 0.65),rgba(25, 40, 103, 0.65)),url("images/about-video.jpg")');
		              $('body').css('background-size','100% 100%,100% 100%');
	              }else{//買賣家  
		        	  $('body').css('background-image', 'linear-gradient(to right, rgba(38, 63, 110, 0.7),rgba(38, 63, 110, 0.7)),url("images/about-video.jpg")');
		              $('body').css('background-size','100% 100%,100% 100%');
	              }
	           }else{//訪客  $('body').css('background-image', 'linear-gradient(to right, rgba(41, 28, 10, 0.65),rgba(41, 28, 10, 0.65)),url("images/about-video.jpg")');        	   
	               $('body').css('background-image', 'linear-gradient(to right, rgba(25, 40, 103, 0.65),rgba(25, 40, 103, 0.65)),url("images/about-video.jpg")');
	        	   $('body').css('background-size','100% 100%,100% 100%');
	           }
		//var doID ="${doID}"
		var shoptype ="${shoptype}"
			$.ajax({
				type:"post",
				url:"${pageContext.request.contextPath}/GetShopServlet",
				datatype:"json",
				async: false,
				//contentType:"false",
				data:{
					tablename:"Shop",
					doID:doID,
					shoptype:shoptype
				},
				success:function(result){
					console.log(result)
					var obj = JSON.parse(result);
					var carddata="";
					for(var i=0;i<obj.length;i++){
					carddata+='<div class="card" style="background-color: transparent;"><div class="shop_img"><img class="card-img-top"'+
					'src="${pageContext.request.contextPath}/upload/Shop/'+obj[i].Shop_SellerID+'/'+obj[i].Shop_CoverFileName+'"></div>'+
				      '<div class="card-body" style="background-color:transparent;">'+
				        '<h4 class="card-title">'+obj[i].Shop_Name+'</h4>'+
				        '<a id="into_shop" data-seller_id="' + obj[i].Shop_SellerID+'" href=${pageContext.request.contextPath}/OpenShoppageServlet?SID='+obj[i].Shop_SellerID+' class="btn btn-dark" style="position: absolute;right:10px;bottom: 5px;">進入商店</a>'+
				      '</div></div>'
				    $("#card").html(carddata);
				      }
				},
				error:function(xhr,ajaxOptions,thrownError){
					alert("");
					alert(xhr.status);
					alert(thrownError);
				}
			});
		$.ajax({
			type:"post",
			url:"${pageContext.request.contextPath}/IDSearchServelt",
			datatype:"json",
			//contentType:"false",
			data:{
				tablename:"ShopType",
				id:-1
			},
			success:function(result){
				var obj = JSON.parse(result);
				var btndata='<a href="#" class="btn">商店類型 :</a>'+
				'<a href=${pageContext.request.contextPath}/HomeServlet?TYPE=0 class="btn btn-link" style="color: #cfd8dc !important"><i class="fas fa-store"></i>所有商店</a>'
				for(var i=0;i<obj.length;i++){
				    btndata+='<a href=${pageContext.request.contextPath}/HomeServlet?TYPE='+obj[i].ShopType_ID+' class="btn btn-link" style="color: #cfd8dc !important">'+obj[i].ShopType_Icon+obj[i].ShopType_Detail+'</a>'
					$("#menubtn").html(btndata);
				}


			},
			error:function(xhr,ajaxOptions,thrownError){
				alert("");
				alert(xhr.status);
				alert(thrownError);
			}
		});
		$('.visibility-cart').on('click',function(){
		       
			  var $btn =  $(this);
			  var $cart = $('.cart');
			  console.log($btn);
			  
			  if ($btn.hasClass('is-open')) {
			     $btn.removeClass('is-open');
			     $btn.text('O')
			     $cart.removeClass('is-open');     
			     $cart.addClass('is-closed');
			     $btn.addClass('is-closed');
			  } else {
			     $btn.addClass('is-open');
			     $btn.text('X')
			     $cart.addClass('is-open');     
			     $cart.removeClass('is-closed');
			     $btn.removeClass('is-closed');
			  }

			                  
			});

				// SHOPPING CART PLUS OR MINUS
				$('a.qty-minus').on('click', function(e) {
					e.preventDefault();
					var $this = $(this);
					var $input = $this.closest('div').find('input');
					var value = parseInt($input.val());
			    
					if (value > 1) {
						value = value - 1;
					} else {
						value = 0;
					}
			    
			    $input.val(value);
			        
				});

				$('a.qty-plus').on('click', function(e) {
					e.preventDefault();
					var $this = $(this);
					var $input = $this.closest('div').find('input');
					var value = parseInt($input.val());

					if (value < 100) {
					value = value + 1;
					} else {
						value =100;
					}

					$input.val(value);
				});

			// RESTRICT INPUTS TO NUMBERS ONLY WITH A MIN OF 0 AND A MAX 100
			$('input').on('blur', function(){

				var input = $(this);
				var value = parseInt($(this).val());

					if (value < 0 || isNaN(value)) {
						input.val(0);
					} else if
						(value > 100) {
						input.val(100);
					}
			});

		
	}	
	function getprds(sellerID){
		
		$.ajax({
			type:"post",
			url:"${pageContext.request.contextPath}/GetShopServlet",
			datatype:"json",
			async: false,
			//contentType:"false",
			data:{
				tablename:"Products",
				doID:sellerID
			},
			success:function(result){
				//document.chatform.action = 'OpenPrdpageServlet';
				//window.location.assign("shoppage.jsp");
			},
			error:function(xhr,ajaxOptions,thrownError){
				alert("");
				alert(xhr.status);
				alert(thrownError);
			}
		});		
	}
	</script>
<title>首頁</title>
<style>
.card{
	margin: 1em;
	background-color: transparent;
}
.card-body{
	height:120px;	
	width: 200px;
	color:white;
}
.card-img-top{
	background-color: transparent;
    height: auto;
    width: auto !important;
    max-width: 100%;
    overflow: hidden;
    border-radius: 8px;
    max-height: 100%;
    position: absolute;
    top: 0;
    bottom: 0;
    left: 0;
    right: 0;
    margin: auto;
}
.shop_img{
	position: relative;
	left: 50%;
	transform: translate(-50%, 0);
	width: 200px;
	height: 200px;
    border-radius: 10px;
}

/* *{border:1px solid #000;} */
</style>
</head>
<body>
<jsp:include page="../slidemenu.jsp"/>
<!--
<div style="background-color: #FFFFFF;position: absolute;top: 50%;right: 50%;width: auto;transform: translate(50%,-50%);">
		<a href="login.view">Login Page(Session)</a>
		<a href="login.view2">Login Page(Cookie)</a></div>-->
		
</body>
</html>