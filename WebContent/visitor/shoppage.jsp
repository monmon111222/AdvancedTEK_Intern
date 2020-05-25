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
		shoppage();
		sidemenu();
	};
	function shoppage(){
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
		var shopsellerID ="${shopsellerID}"
		var cateID="${cateID}";
		var prdaccount=0;
		var page="${page}";
		if(cateID){
			$.ajax({
				type:"post",
				url:"${pageContext.request.contextPath}/GetShopServlet",
				datatype:"json",
				async: false,
				//contentType:"false",
				data:{
					tablename:"Product",
					doID:0,
					shopsellerID:shopsellerID,
					cateID:cateID
				},
				success:function(result){
					var obj = JSON.parse(result);
					console.log(obj)
					var carddata="";
					var title=obj[0].Shop_Name+'-'+obj[0].ShopCategory_Name;
					document.title = title;
					if(page){
						var start=0;
						var end=10
						if(page>1){
							start=(page-1)*10;
							end=(page*10)
							if(end>obj.length){
								end=obj.length;
							}
						}
						for(var i=start;i<end;i++){
							carddata+='<div class="card" style="background: transparent;"><div class="shop_img"><img class="card-img-top"'+
							'src="${pageContext.request.contextPath}/upload/Product/'+obj[i].Product_SellerID+'/'+obj[i].ProductPhotos_FileName+'"></div>'+
						      '<div class="card-body" style="background-color:transparent;">'+
						        '<h8 class="card-title">'+obj[i].Product_Name+'</h8>'
						        if(obj[i].Product_Quanity.indexOf('F')>=0){//only F style
			                        if(obj[i].Product_Quanity.substring(obj[i].Product_Quanity.indexOf(':')+2)<=0){
			                        	carddata+='<h15 class="card-outstock" style="color: #e57373;font-size: smaller;float: right;">缺貨中</h15>'
			                        	}
			                        if(obj[i].Product_Quanity.substring(obj[i].Product_Quanity.indexOf(':')+2)<10&&obj[i].Product_Quanity.substring(obj[i].Product_Quanity.indexOf(':')+2)>0){
			                        	carddata+='<h15 class="card-outstock" style="color: #e57373;font-size: smaller;float: right;">商品僅剩 '+obj[i].Product_Quanity+'</h15>'
			                        	}
			                    }else{
			                    	var strs= new Array();
			                    	strs=obj[i].Product_Quanity.split(',');
			                    	var totalqu=0;
			                    	var showqu="";
			                    	for(var j=0;j<strs.length;j++){
			                    		totalqu=totalqu+parseInt(strs[j].substring(strs[j].indexOf(':')+2));	
									}
									console.log('totalqu'+totalqu)
				                    if(totalqu<0){//各款式庫存加總=0
				                       carddata+='<h15 class="card-outstock" style="color: #e57373;font-size: smaller;float: right;">缺貨中</h15>'
				                    }
									if(obj[i].Product_Quanity.indexOf(' 0')>0){//表示有款式已售完
										if(totalqu>10){
											for(var j=0;j<strs.length;j++){
												if(strs[j].indexOf(' 0')>0){
												showqu+=strs[j].replace(' 0','售完')
												}
											}
											carddata+='<h15 class="card-outstock" style="color: #e57373;font-size: smaller;float: right;">'+showqu+'</h15>'	
										}
				                    }else if(totalqu<10&&totalqu>0){//各款式庫存加總<10
				                    	for(var j=0;j<strs.length;j++){
											showqu+=strs[j].replace(' 0','售完')
										}
				                        carddata+='<h15 class="card-outstock" style="color: #e57373;font-size: smaller;float: right;">僅剩 '+showqu+'</h15>'
				                    }
			                    }
						    carddata+='<a id="into_prd" data-prd_id="' + obj[i].Product_ID+'" href=${pageContext.request.contextPath}/OpenPrdpageServlet?PID='+obj[i].Product_ID+' class="btn btn-dark" style="position: absolute;right:0px;bottom: 0px;">查看詳細</a>'+
						      '</div></div>'
						    $("#card").html(carddata);
						    }
							carddata='';
					    	carddata+='<nav aria-label="Page navigation example"><ul class="pagination justify-content-center">'
					    	var pagecount=obj.length/10;
					    	for(var i=0;i<pagecount;i++){
					    		carddata+='<li class="page-item"><a class="page-link" href=${pageContext.request.contextPath}/OpenShoppageServlet?PAGE='+(i+1)+'&SID='+shopsellerID+'&CATE='+cateID+' style="color: black !important;">'+(i+1)+'</a></li>'
					    	}
					    	carddata+='</li></ul></nav>'
					    	$("#page").html(carddata);
					}else{
						
						for(var i=0;i<10;i++){
							carddata+='<div class="card" style="background: transparent;"><div class="shop_img"><img class="card-img-top"'+
							'src="${pageContext.request.contextPath}/upload/Product/'+obj[i].Product_SellerID+'/'+obj[i].ProductPhotos_FileName+'"></div>'+
						      '<div class="card-body" style="background-color:transparent;">'+
						        '<h8 class="card-title">'+obj[i].Product_Name+'</h8>'
						        
						        if(obj[i].Product_Quanity.indexOf('F')>=0){//only F style
			                        if(obj[i].Product_Quanity.substring(obj[i].Product_Quanity.indexOf(':')+2)<=0){
			                        	carddata+='<h15 class="card-outstock" style="color: #e57373;font-size: smaller;float: right;">缺貨中</h15>'
			                        	}
			                        if(obj[i].Product_Quanity.substring(obj[i].Product_Quanity.indexOf(':')+2)<10&&obj[i].Product_Quanity.substring(obj[i].Product_Quanity.indexOf(':')+2)>0){
			                        	carddata+='<h15 class="card-outstock" style="color: #e57373;font-size: smaller;float: right;">商品僅剩 '+obj[i].Product_Quanity+'</h15>'
			                        	}
			                    }else{
			                    	var strs= new Array();
			                    	strs=obj[i].Product_Quanity.split(',');
			                    	var totalqu=0;
			                    	var showqu="";
			                    	for(var j=0;j<strs.length;j++){
			                    		totalqu=totalqu+parseInt(strs[j].substring(strs[j].indexOf(':')+2));	
									}
			                    	console.log('totalqu'+totalqu)
				                    if(totalqu<0){//各款式庫存加總=0
				                       carddata+='<h15 class="card-outstock" style="color: #e57373;font-size: smaller;float: right;">缺貨中</h15>'
				                    }
									if(obj[i].Product_Quanity.indexOf(' 0')>0){//表示有款式已售完
										if(totalqu>10){
											console.log('str'+strs+'strs.length'+strs.length)
											for(var j=0;j<strs.length;j++){
												if(strs[j].indexOf(' 0')>0){
													console.log('strs[j]2'+strs[j])
													showqu+=strs[j].replace(' 0','售完')
												}
											}
											carddata+='<h15 class="card-outstock" style="color: #e57373;font-size: smaller;float: right;">'+showqu+'</h15>'	
										}
				                    }else if(totalqu<10&&totalqu>0){//各款式庫存加總<10
				                    	for(var j=0;j<strs.length;j++){
											showqu+=strs[j].replace(' 0','售完')
										}
				                        carddata+='<h15 class="card-outstock" style="color: #e57373;font-size: smaller;float: right;">僅剩 '+showqu+'</h15>'
				                    }
			                    }
						    carddata+='<a id="into_prd" data-prd_id="' + obj[i].Product_ID+'" href=${pageContext.request.contextPath}/OpenPrdpageServlet?PID='+obj[i].Product_ID+' class="btn btn-dark" style="position: absolute;right:0px;bottom: 0px;">查看詳細</a>'+
						      '</div></div>'
						    $("#card").html(carddata);
						    }
						carddata='';
					    if(obj.length>10){
					    	carddata+='<nav aria-label="Page navigation example"><ul class="pagination justify-content-center">'
					    	var pagecount=obj.length/10;
					    	//alert(pagecount)
					    	for(var i=0;i<pagecount;i++){
					    		carddata+='<li class="page-item"><a class="page-link" href=${pageContext.request.contextPath}/OpenShoppageServlet?PAGE='+(i+1)+'&SID='+shopsellerID+'&CATE='+cateID+' style="color: black !important;">'+(i+1)+'</a></li>'
					    	}
					    	carddata+='</li></ul></nav>'
					    	$("#page").html(carddata);
					    } 
					}
	 
				},
				error:function(xhr,ajaxOptions,thrownError){
					alert("");
					alert(xhr.status);
					alert(thrownError);
				}
			});	
		}else{
			 $.ajax({
					type:"post",
					url:"${pageContext.request.contextPath}/GetShopServlet",
					datatype:"json",
					async: false,
					//contentType:"false",
					data:{
						tablename:"Products",
						doID:shopsellerID
					},
					success:function(result){
						var obj = JSON.parse(result);
						var carddata="";
						var title=obj[0].Shop_Name+'-所有商品';
						document.title = title;
						//prdaccount=obj.length;
						if(page){
							var start=0;
							var end=10
							if(page>1){
								start=(page-1)*10;
								end=(page*10)
								if(end>obj.length){
									end=obj.length;
								}
							}
							for(var i=start;i<end;i++){
								carddata+='<div class="card" style="background: transparent;"><div class="shop_img"><img class="card-img-top"'+
								'src="${pageContext.request.contextPath}/upload/Product/'+obj[i].Product_SellerID+'/'+obj[i].ProductPhotos_FileName+'"></div>'+
							      '<div class="card-body" style="background-color:transparent;">'+
							        '<h8 class="card-title">'+obj[i].Product_Name+'</h8>'
							        if(obj[i].Product_Quanity.indexOf('F')>=0){//only F style
				                        if(obj[i].Product_Quanity.substring(obj[i].Product_Quanity.indexOf(':')+2)<=0){
				                        	carddata+='<h15 class="card-outstock" style="color: #e57373;font-size: smaller;float: right;">缺貨中</h15>'
				                        	}
				                        if(obj[i].Product_Quanity.substring(obj[i].Product_Quanity.indexOf(':')+2)<10&&obj[i].Product_Quanity.substring(obj[i].Product_Quanity.indexOf(':')+2)>0){
				                        	carddata+='<h15 class="card-outstock" style="color: #e57373;font-size: smaller;float: right;">商品僅剩 '+obj[i].Product_Quanity+'</h15>'
				                        	}
				                    }else{
				                    	var strs= new Array();
				                    	strs=obj[i].Product_Quanity.split(',');
				                    	var totalqu=0;
				                    	var showqu="";
				                    	for(var j=0;j<strs.length;j++){
				                    		totalqu=totalqu+parseInt(strs[j].substring(strs[j].indexOf(':')+2));	
										}

					                    if(totalqu<0){//各款式庫存加總=0
					                       carddata+='<h15 class="card-outstock" style="color: #e57373;font-size: smaller;float: right;">缺貨中</h15>'
					                    }
										if(obj[i].Product_Quanity.indexOf(' 0')>0){//表示有款式已售完
											if(totalqu>10){
												for(var j=0;j<strs.length;j++){
													if(strs[j].indexOf(' 0')>0){
														console.log('strs[j]3'+strs[j])
														showqu+=strs[j].replace(' 0','售完')
													}
												}
												carddata+='<h15 class="card-outstock" style="color: #e57373;font-size: smaller;float: right;">'+showqu+'</h15>'	
											}
					                    }else if(totalqu<10&&totalqu>0){//各款式庫存加總<10
					                    	for(var j=0;j<strs.length;j++){
												showqu+=strs[j].replace(' 0','售完')
											}
					                    carddata+='<h15 class="card-outstock" style="color: #e57373;font-size: smaller;float: right;">僅剩 '+showqu+'</h15>'
					                    }
				                    }		
							    carddata+='<a id="into_prd" data-prd_id="' + obj[i].Product_ID+'" href=${pageContext.request.contextPath}/OpenPrdpageServlet?PID='+obj[i].Product_ID+' class="btn btn-dark" style="position: absolute;right:0px;bottom: 0px;">查看詳細</a>'+
							      '</div></div>'
							    $("#card").html(carddata);
							    }
								carddata='';
						    	carddata+='<nav aria-label="Page navigation example"><ul class="pagination justify-content-center">'
						    	var pagecount=obj.length/10;
						    	for(var i=0;i<pagecount;i++){
						    		carddata+='<li class="page-item"><a class="page-link" href=${pageContext.request.contextPath}/OpenShoppageServlet?PAGE='+(i+1)+'&SID='+shopsellerID+' style="color: black !important;">'+(i+1)+'</a></li>'
						    	}
						    	carddata+='</li></ul></nav>'
						    	$("#page").html(carddata);
						}else{
								for(var i=0;i<10;i++){
			                        carddata+='<div class="card" style="background: transparent;"><div class="shop_img"><img class="card-img-top"'+
			                        'src="${pageContext.request.contextPath}/upload/Product/'+obj[i].Product_SellerID+'/'+obj[i].ProductPhotos_FileName+'"></div>'+
			                           '<div class="card-body" style="background-color:transparent;">'+
			                             '<h8 class="card-title">'+obj[i].Product_Name+'</h8>';
			                        if(obj[i].Product_Quanity.indexOf('F')>=0){//only F style
				                        if(obj[i].Product_Quanity.substring(obj[i].Product_Quanity.indexOf(':')+2)<=0){
				                        	carddata+='<h15 class="card-outstock" style="color: #e57373;font-size: smaller;float: right;">缺貨中</h15>'
				                        	}
				                        if(obj[i].Product_Quanity.substring(obj[i].Product_Quanity.indexOf(':')+2)<10&&obj[i].Product_Quanity.substring(obj[i].Product_Quanity.indexOf(':')+2)>0){
				                        	carddata+='<h15 class="card-outstock" style="color: #e57373;font-size: smaller;float: right;">商品僅剩 '+obj[i].Product_Quanity+'</h15>'
				                        	}
				                        carddata+='<a id="into_prd" data-prd_id="' + obj[i].Product_ID+'" href=${pageContext.request.contextPath}/OpenPrdpageServlet?PID='+obj[i].Product_ID+' class="btn btn-dark" style="position: absolute;right:0px;bottom: 0px;">查看詳細</a>'+
				                           '</div></div>'
				                    }else{
				                    	var strs= new Array();
				                    	strs=obj[i].Product_Quanity.split(',');
				                    	var totalqu=0;
				                    	var showqu="";
				                    	for(var j=0;j<strs.length;j++){
				                    		totalqu=totalqu+parseInt(strs[j].substring(strs[j].indexOf(':')+2));	
										}

					                    if(totalqu<0){//各款式庫存加總=0
					                       carddata+='<h15 class="card-outstock" style="color: #e57373;font-size: smaller;float: right;">缺貨中</h15>'
					                    }
										if(obj[i].Product_Quanity.indexOf(' 0')>0){//表示有款式已售完
											if(totalqu>10){
												console.log('str'+strs)
												for(var j=0;j<strs.length;j++){
													if(strs[j].indexOf(' 0')>0){
														console.log('strs[j]4'+strs[j])
														showqu+=strs[j].replace(' 0','售完')
													}
												}
												carddata+='<h15 class="card-outstock" style="color: #e57373;font-size: smaller;float: right;">'+showqu+'</h15>'	
											}
					                    }else if(totalqu<10&&totalqu>0){//各款式庫存加總<10
					                    	for(var j=0;j<strs.length;j++){
													showqu+=strs[j].replace(' 0','售完')
											}
					                        carddata+='<h15 class="card-outstock" style="color: #e57373;font-size: smaller;float: right;">僅剩 '+showqu+'</h15>'
					                    }
					                    
				                    }    
					                carddata+='<a id="into_prd" data-prd_id="' + obj[i].Product_ID+'" href=${pageContext.request.contextPath}/OpenPrdpageServlet?PID='+obj[i].Product_ID+' class="btn btn-dark" style="position: absolute;right:0px;bottom: 0px;">查看詳細</a>'+
					                     '</div></div>'
								}
							$("#card").html(carddata);
			                     	carddata='';
			                      if(obj.length>10){
			                        carddata+='<nav aria-label="Page navigation example"><ul class="pagination justify-content-center">'
			                        var pagecount=obj.length/10;
			                        //alert(pagecount)
			                        for(var i=0;i<pagecount;i++){
			                           carddata+='<li class="page-item"><a class="page-link" href=${pageContext.request.contextPath}/OpenShoppageServlet?PAGE='+(i+1)+'&SID='+shopsellerID+' style="color: black !important;">'+(i+1)+'</a></li>'
			                        }
			                        carddata+='</li></ul></nav>'
			                        $("#page").html(carddata);
			                      }
							
						}
					},
					error:function(xhr,ajaxOptions,thrownError){
						alert("");
						alert(xhr.status);
						alert(thrownError);
					}
				});
		}	
		$('.btn-dark').on("click",function(){
			var prdID = $(this).data('prd_id');
			getprdinfo(prdID);
 		});
		$.ajax({
			type:"post",
			url:"${pageContext.request.contextPath}/IDSearchServelt",
			datatype:"json",
			//contentType:"false",
			data:{
				tablename:"ShopCategory",
				id:shopsellerID
			},
			success:function(result){
				var obj = JSON.parse(result);
				var btndata='<a href=${pageContext.request.contextPath}/OpenMagShopServlet?BS=B&SID='+shopsellerID+' class="btn btn-link" style="color: #cfd8dc !important">關於商店</a><a href=${pageContext.request.contextPath}/OpenShoppageServlet?SID='+shopsellerID+' class="btn btn-link" style="color: #cfd8dc !important">所有商品</a>';
				for(var i=0;i<obj.length;i++){
					//btndata+='<button type="button" class="btn btn-link" style="color: cadetblue;"data-cate_id="'+obj[i].ShopCategory_ID+'">'+obj[i].ShopCategory_Name+'</button>'
				    btndata+='<a href=${pageContext.request.contextPath}/OpenShoppageServlet?CATE='+obj[i].ShopCategory_ID+'&SID='+shopsellerID+' class="btn btn-link" style="color: #cfd8dc !important">'+obj[i].ShopCategory_Name+'</a>'
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
	function getprdinfo(prdID){
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
				document.chatform.action = 'OpenPrdpageServlet';
				//window.location.assign("prdpage.jsp");
 
			},
			error:function(xhr,ajaxOptions,thrownError){
				alert("");
				alert(xhr.status);
				alert(thrownError);
			}
		});		
	}
	function getcateprd(cateID){
		var shopsellerID ="${shopsellerID}"
		$.ajax({
			type:"post",
			url:"${pageContext.request.contextPath}/GetShopServlet",
			datatype:"json",
			async: false,
			//contentType:"false",
			data:{
				tablename:"Product",
				doID:0,
				shopsellerID:shopsellerID,
				cateID:cateID
			},
			success:function(result){
				var obj = JSON.parse(result);
				var carddata="";
				var title=obj[0].Shop_Name;
				document.title = title;
				for(var i=0;i<obj.length;i++){
				carddata+='<div class="card" style="background: transparent;"><div class="shop_img"><img class="card-img-top"'+
				'src="${pageContext.request.contextPath}/upload/Product/'+obj[i].Product_SellerID+'/'+obj[i].ProductPhotos_FileName+'"></div>'+
			      '<div class="card-body" style="background-color:transparent;">'+
			        '<h8 class="card-title">'+obj[i].Product_Name+'</h8>'
			        if(obj[i].Product_Quanity<0){carddata+='<h15 class="card-outstock" style="color: #e57373;font-size: smaller;float: right;">缺貨中</h15>'}
				if(obj[i].Product_Quanity<10&&obj[i].Product_Quanity>0){carddata+='<h15 class="card-outstock" style="color: #e57373;font-size: smaller;float: right;">商品僅剩 '+obj[i].Product_Quanity+'</h15>'}
			    carddata+='<a id="into_prd" data-prd_id="' + obj[i].Product_ID+'"href="prdpage.jsp" class="btn btn-dark" style="position: absolute;right:0px;bottom: 0px;">查看詳細</a>'+
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