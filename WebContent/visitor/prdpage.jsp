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
	        	   $('body').css('background-image', 'linear-gradient(to right, rgba(27, 60, 121, 0.7),rgba(27, 60, 121, 0.7)),url("images/about-video.jpg")');
	              $('body').css('background-size','100% 100%,100% 100%');
            }
         }else{//訪客  $('body').css('background-image', 'linear-gradient(to right, rgba(41, 28, 10, 0.65),rgba(41, 28, 10, 0.65)),url("images/about-video.jpg")');        	   
             $('body').css('background-image', 'linear-gradient(to right, rgba(25, 40, 103, 0.65),rgba(25, 40, 103, 0.65)),url("images/about-video.jpg")');
      	   $('body').css('background-size','100% 100%,100% 100%');
         }
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
					console.log(obj)
					var title=obj[0].Product_Name;
					
					document.title = title;
					carddata+='<div id="prdinfo">'+
					'<div id="carouselExampleIndicators" class="carousel slide" data-ride="carousel"style="width: 300px; height: 300px;float: left;">'+show_phs(prdID,obj[0].Product_SellerID)+'</div>'+
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
						if(obj[0].Product_Quanity.indexOf('F')>=0){//只有一個款式
							console.log(obj[0].Product_Quanity.substring(obj[0].Product_Quanity.indexOf(':')+2))
							carddata+='<div class="btn-group btn-group-toggle" data-toggle="buttons">'+
								  '<label class="btn btn-outline-warning active" style="margin-top: 25%;">'+
							    '<input type="radio" name="qu_radio" id="qu_radio'+obj[0].ProductStyle_ID+'" autocomplete="off" checked value="" >F'+
							  '</label>'+
							'</div>'
							if(obj[0].Product_Quanity.substring(obj[0].Product_Quanity.indexOf(':')+2)<10&&obj[0].Product_Quanity.substring(obj[0].Product_Quanity.indexOf(':')+2)>0){
								carddata+='<div class="profile-info-value" style="color:#e57373;white-space: pre-line;">此商品僅剩: '+obj[0].Product_Quanity.substring(obj[0].Product_Quanity.indexOf(':')+2)+'</div>'
								carddata+='<div class="profile-info-value" style="color:#c0b3c2;font-size: smaller;">加入購物車時，預設數量為1</div>'
								carddata+='<div class="profile-info-value" style="color:#c0b3c2;font-size: smaller;">欲增加購買數量或刪除該商品點擊右上方購物車進行操作</div>'+
								'<button type="button" class="btn btn-outline-light" data-prd_id="'+obj[0].Product_ID+'"data-style_id="'+obj[0].ProductStyle_ID+'">加入購物車</button>'
							}else if(obj[0].Product_Quanity.substring(obj[0].Product_Quanity.indexOf(':')+2)==0){
								carddata+='<button type="button" class="btn btn-outline-light"data-prd_id="'+obj[0].Product_ID+'" disabled="disabled" style="margin-left:5%;">缺貨中</button>'	
							}else{
								carddata+='<div class="profile-info-value" style="color:#fff59d;">加入購物車時，預設數量為1，欲增加購買數量或刪除該商品點擊右上方購物車進行操作</div>'+
								'<button type="button" class="btn btn-outline-light" data-prd_id="'+obj[0].Product_ID+'"data-style_id="'+obj[0].ProductStyle_ID+'">加入購物車</button>'	
							}
						}else{
							var strs= new Array();
							var strid= new Array();
							strs=obj[0].Product_Quanity.split(',');
							strid=obj[0].ProductStyle_ID.split(',');
							carddata+='<div class="btn-group btn-group-toggle" data-toggle="buttons"><label class="btn btn-warning active">'+
								'<input type="radio" name="qu_radio" id="qu_radio'+strid[0]+'" checked="ckecked" value="'+strid[0]+'"data-sty_va="'+strs[0].substring(0,strs[0].indexOf(':'))+'" data-sty_qu="'+strs[0].substring(strs[0].indexOf(':')+2)+'">'+strs[0].substring(0,strs[0].indexOf(':'))+
								'</label>'
							for(var i=1;i<strs.length;i++){
							carddata+='<label class="btn btn-warning"><input type="radio" name="qu_radio" id="qu_radio'+strid[i]+'" value="'+strid[i]+'" data-sty_va="'+strs[i].substring(0,strs[i].indexOf(':'))+'"data-sty_qu="'+strs[i].substring(strs[i].indexOf(':')+2)+'">'+strs[i].substring(0,strs[i].indexOf(':'))+
								'</label>'
							}
							carddata+='</div>'	
							if(strs[0].substring(strs[0].indexOf(':')+2)==0){
								carddata+='<button type="button" class="btn btn-outline-light"data-prd_id="'+obj[0].Product_ID+'" disabled="disabled">缺貨中</button>'	
							}else if(strs[0].substring(strs[0].indexOf(':')+2)<10){
								carddata+='<div id="remain_qu" class="profile-info-value" style="color:#e57373;white-space: pre-line;">此商品 款式:'+strs[0].substring(0,strs[0].indexOf(':'))+' 僅剩: '+strs[0].substring(strs[0].indexOf(':')+2)+'</div>'
								carddata+='<div id="reminder"class="profile-info-value" style="color:#c0b3c2;font-size: smaller;">加入購物車時</div>'
								carddata+='<div class="profile-info-value" style="color:#c0b3c2;font-size: smaller;">欲增加購買數量或刪除該商品點擊右上方購物車進行操作</div>'+
								'<br>'+'<button type="button" id="addcart"class="btn btn-outline-light" data-prd_id="'+obj[0].Product_ID+'"data-style_id="'+strid[0]+'">加入購物車</button>'
							}else{
							carddata+='<br>'
							carddata+='<div class="profile-info-value" style="color:#c0b3c2;">加入購物車時，預設數量為1，欲增加購買數量或刪除該商品點擊右上方購物車進行操作</div>'+
								'<button type="button" id="addcart"class="btn btn-outline-light" data-prd_id="'+obj[0].Product_ID+'"data-style_id="'+strid[0]+'">加入購物車</button>'
							}
						}
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
			var styleID = $(this).data('style_id');
			add2cart(prdID,styleID);
			
 		});
		$("input[type=radio][name='qu_radio']").change(function(){
			if($(this).data('sty_qu')==0){
				$('#remain_qu').css('display','none')
				$('#reminder').css('display','none')
				$('#addcart').text('缺貨中')
				$('#addcart').attr('disabled',true)
			}else if($(this).data('sty_qu')<10){
				$('#remain_qu').css('display','block')
				$('#reminder').css('display','block')
				$('#remain_qu').text('此商品 款式'+$(this).data('sty_va')+'僅剩'+$(this).data('sty_qu'))
				$('#reminder').text('加入購物車時，預設數量為1，欲增加購買數量或刪除該商品點擊右上方購物車進行操作')
				$('#addcart').data('style_id',$(this).attr('id').substring($(this).attr('id').indexOf('o')+1))
			}else {
				$('#remain_qu').css('display','none')
				$('#reminder').css('display','block')
				$('#reminder').text('加入購物車時，預設數量為1，欲增加購買數量或刪除該商品點擊右上方購物車進行操作')
				$('#addcart').attr('disabled',false)
				$('#addcart').text('加入購物車')
				$('#addcart').data('style_id',$(this).attr('id').substring($(this).attr('id').indexOf('o')+1))
			}
		});
		$.ajax({
			type:"post",
			url:"${pageContext.request.contextPath}/IDSearchServelt",
			datatype:"json",
			//contentType:"false",
			data:{
				tablename:"ShopCategoryPrd",
				id:prdID
			},
			success:function(result){
				var obj = JSON.parse(result);
				console.log(result)
				var btndata='<a href=${pageContext.request.contextPath}/OpenShoppageServlet?SID='+obj[0].Product_SellerID+' class="btn btn-link" style="color: #cfd8dc !important">所有商品</a>';
				for(var i=0;i<obj.length;i++){
					//btndata+='<button type="button" class="btn btn-link" style="color: cadetblue;"data-cate_id="'+obj[i].ShopCategory_ID+'">'+obj[i].ShopCategory_Name+'</button>'
				    btndata+='<a href=${pageContext.request.contextPath}/OpenShoppageServlet?CATE='+obj[i].ShopCategory_ID+'&SID='+obj[i].Product_SellerID+' class="btn btn-link" style="color: #cfd8dc !important">'+obj[i].ShopCategory_Name+'</a>'
					$("#menubtn").html(btndata);
				}


			},
			error:function(xhr,ajaxOptions,thrownError){
				alert("");
				alert(xhr.status);
				alert(thrownError);
			}
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
			    carousel_data+= '</ol><div class="carousel-inner" >'    
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
	function add2cart(prdID,styleID){
		$.ajax({
    		type:"post", 
            url:"${pageContext.request.contextPath}/ShopCartServlet",
            dataType:"text",
            async: false,
            data: {
            	styleID:styleID,
            	prdID:prdID,
            	tablename : 'Product'
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
<body>
<jsp:include page="../slidemenu.jsp"/>
<!--
<div style="background-color: #FFFFFF;position: absolute;top: 50%;right: 50%;width: auto;transform: translate(50%,-50%);">
		<a href="login.view">Login Page(Session)</a>
		<a href="login.view2">Login Page(Cookie)</a></div>-->
		
</body>
</html>