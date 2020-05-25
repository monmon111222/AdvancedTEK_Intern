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
		prdpage();
		sidemenu();
	};
	function prdpage(){
		var prdID ="${prdID}"
			$.ajax({
				type:"post",
				url:"${pageContext.request.contextPath}/GetShopServlet",
				datatype:"json",
				async: false,
				//contentType:"false",
				data:{
					tablename:"Product",
					doID:prdID
				},
				success:function(result){
					var obj = JSON.parse(result);
					var carddata="";
					var title=obj[0].Product_Name;
					document.title = title;
					carddata+='<div id="prdinfo">'+
									'<div id="prd_text_info">'+
										'<div class="profile-prd-info profile-user-info-striped">'+ 
									        '<div class="profile-info-row">'+ 
									        '<div class="profile-info-name">商品名稱:</div>'+ 
									        '<div class="profile-info-value">'+obj[0].Product_Name+'</div>'+ 
									      '</div>'+ 
									    '</div>'+ 
									    '<div class="profile-prd-info profile-user-info-striped">'+  
									      '<div class="profile-info-row">'+ 
									        '<div class="profile-info-name">商品價格:</div>'+ 
									        '<div class="profile-info-value">'+obj[0].Product_Price+'</div>'+ 
									      '</div>'+
								   		'</div>'+
								   		'<div class="profile-prd-info profile-user-info-striped">'+  
									      '<div class="profile-info-row">'+ 
									        '<div class="profile-info-name">商品細節:</div>'+ 
									        '<div class="profile-info-value" style="white-space: pre-line;">'+obj[0].Product_Detail+'</div>'+ 
									      '</div>'+
								   		'</div>'
						if(obj[0].Product_Quanity>0){
							if(obj[0].Product_Quanity<=10){
								carddata+='<div class="profile-info-value" style="color:brown;white-space: pre-line;">此商品僅剩: '+obj[0].Product_Quanity+'</div>' 	
							}
							carddata+='<button type="button" class="btn btn-outline-light"data-prd_id="'+obj[0].Product_ID+'">加入購物車</button>'
						}else{
							carddata+='<button type="button" class="btn btn-outline-light"data-prd_id="'+obj[0].Product_ID+'" disabled="disabled">缺貨中</button>'
							}	   		
							carddata+='</div>'+
								   	'<div id="carouselExampleIndicators" class="carousel slide" data-ride="carousel"style="width: 300px; height: 300px;float: left;">'+show_phs(prdID,obj[0].Product_SellerID)+'</div>'+
							'</div>'
	   				 $("#card").html(carddata);
							    
				},
				error:function(xhr,ajaxOptions,thrownError){
					alert("");
					alert(xhr.status);
					alert(thrownError);
				}
			});
		$('.btn-outline-light').on("click",function(){
			var prdID = $(this).data('prd_id');
			add2cart(prdID);
			
 		});
	}
	function show_phs(prdID,sellerID){//取得該產品的照片檔名
		var sellerID=sellerID;
		var carousel_data;
		$.ajax({
    		type:"post", 
            url:"${pageContext.request.contextPath}/GetPrdPhsServlet",
            dataType:"json",
            async: false,
            data: {
            	sellerID:sellerID,
            	prdID:prdID,
            	tablename : 'Product',
            	},
            //<%-- 回傳成功 --%>
            success: function(result){
            	//var obj = JSON.parse(result);
				var i;
				var storepath='${pageContext.servletContext}/upload/Product/';
				
				carousel_data='<ol class="carousel-indicators" ><li data-target="#carouselExampleIndicators" data-slide-to="0" class="active"></li>';
				for(i=0;i<result.length-1;i++){
				carousel_data+='<li data-target="#carouselExampleIndicators" data-slide-to="'+(i+1)+'"></li>'
			        };
			    carousel_data+= '</ol><div class="carousel-inner">'    
			    for(i=0;i<1;i++){
						$.each(result[i], function(index, value) {
							carousel_data+='<div class="carousel-item active">'+
						      '<img class="d-block w-100" src="${pageContext.request.contextPath}/upload/Product/'+sellerID+'/'+value+'"alt="First slide">'+
						    '</div>'
				    });    
			    }
				for(i=1;i<result.length;i++){
					$.each(result[i], function(index, value) {
						carousel_data+= '<div class="carousel-item">'+
					      '<img class="d-block w-100" src="${pageContext.request.contextPath}/upload/Product/'+sellerID+'/'+value+'"alt="First slide">'+
					    '</div>'
			        });
				}
				carousel_data+= '</div>'+
							  '<a class="carousel-control-prev" href="#carouselExampleIndicators" role="button" data-slide="prev">'+
							    '<span class="carousel-control-prev-icon" aria-hidden="true" style="background-image:url(images/icons/back.png);">'+'</span>'+
							    '<span class="sr-only">'+'</span>'+
							  '</a>'+
							  '<a class="carousel-control-next" href="#carouselExampleIndicators" role="button" data-slide="next">'+
							    '<span class="carousel-control-next-icon" aria-hidden="true" style="background-image:url(images/icons/next.png);">'+'</span>'+
							    '<span class="sr-only">'+'</span>'+
							  '</a>'
						 $("#carouselExampleIndicators").html(carousel_data);
            },
            //<%-- 回傳失敗 --%>
            error:
                function(xhr, ajaxOptions, thrownError){
                    alert(xhr.status+"\n"+thrownError);
                }
		});
		return carousel_data;
	}
	function add2cart(prdID){//取得該產品的照片檔名
		$.ajax({
    		type:"post", 
            url:"${pageContext.request.contextPath}/ShopCartServlet",
            dataType:"text",
            async: false,
            data: {
            	prdID:prdID,
            	tablename : 'Product',
            	},
            //<%-- 回傳成功 --%>
            success: function(result){
            		alert("成功加入購物車")
            },
            //<%-- 回傳失敗 --%>
            error:
                function(xhr, ajaxOptions, thrownError){
                    alert(xhr.status+"\n"+thrownError);
                }
		});
	}
	</script>
<title>首頁</title>
<style>
#prd_text_info{
	width: 400px;
	font-size:18px;
	float: right;
	color: white;
	margin-left: 10px;
}
#prdinfo{
	position: relative;
	left: 50%;
	transform: translate(-50%, 10px);
}
.btn-outline-light{
	margin-top: 10px;
}
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
	height:100%;
	width:100%;
	overflow:hidden;
	border-radius: 8px;
}
.shop_img{
	position: relative;
	left: 50%;
	transform: translate(-50%, 0);
	width: 200px;
	height: 200px;
	border: 3px solid #6D6875;
    border-radius: 10px;
}

/* *{border:1px solid #000;} */
</style>
</head>
<body  style="background-image: url('images/bgblack.png');">
<jsp:include page="../slidemenu.jsp"/>
<!--
<div style="background-color: #FFFFFF;position: absolute;top: 50%;right: 50%;width: auto;transform: translate(50%,-50%);">
		<a href="login.view">Login Page(Session)</a>
		<a href="login.view2">Login Page(Cookie)</a></div>-->
		
</body>
</html>