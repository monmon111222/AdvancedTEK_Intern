<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<!DOCTYPE html>
<html>
<head>
	<link rel="stylesheet" type="text/css" href="css/util.css">
	<link rel="stylesheet" type="text/css" href="css/userview.css">
	<link rel="stylesheet" type="text/css" href="css/shopcart.css">
	<link rel="stylesheet" type="text/css" href="vendor/bootstrap/css/bootstrap.min.css">
	<link rel="icon" type="image/png" href="images/icons/favicon.ico" />
	<link rel="stylesheet" type="text/css" href="fonts/iconic/css/material-design-iconic-font.min.css">
<!--===============================================================================================-->
	<script src="vendor/jquery/jquery-3.2.1.min.js"></script>
	<script src="vendor/bootstrap/js/popper.js"></script>
	<script src="vendor/bootstrap/js/bootstrap.js"></script>
	<script defer src="https://use.fontawesome.com/releases/v5.0.13/js/solid.js"></script>
    <script defer src="https://use.fontawesome.com/releases/v5.0.13/js/fontawesome.js"></script>
	<script type="text/javascript">
	window.onload=function(){
		shopcart();
		sidemenu();
		
	}
	
	function shopcart(){
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
		document.getElementById("shopcart").remove();//購物車	
		var check_data="";
		var return_data="";
		var fotter_data="";
		var subtotal=0;
		var shipping=60;
		var total=0;
		$.ajax({
    		type:"post", 
            url:"${pageContext.request.contextPath}/GetShopCartServlet",
            dataType:"json",
            async: false,
            data: {
            	prdID:1,
            	tablename : 'Product',
            	},
            //<%-- 回傳成功 --%>
            success: function(result){
            	console.log(result)
            	if (typeof result[0].CartState !== 'undefined'){
            		return_data=result[0].CartState;
            	}else{
            	for(var i=0;i<result.length;i++){
            	subtotal+=(result[i].Product_Price*result[i].BuyNumber);
			      return_data+=	'<article class="product">'+
								'<header>'+
									'<a class="remove" id="'+result[i].ProductStyle_ID+'">'+
										'<img src="${pageContext.request.contextPath}/upload/Product/'+result[i].ProductPhotos_SellerID+'/'+result[i].ProductPhotos_FileName+'" alt="">'+
										'<h3>移除商品</h3>'+
									'</a>'+
								'</header>'+
								'<div class="prd-content" id="'+result[i].ProductStyle_ID+'_prdname">'+result[i].Product_Name+' 款式:'+result[i].ProductStyle_Vaule+
								'</div>'+
								'<footer class="prd-footer">'+
									'<div class="qt-minus" id="'+result[i].ProductStyle_ID+'_minus">-</div>'+
									'<div class="qt" id="'+result[i].ProductStyle_ID+'_prdprice">'+result[i].BuyNumber+'</div>'+
									'<div class="qt-plus" id="'+result[i].ProductStyle_ID+'_plus">+</div>'+
									'<h2 class="price">'+
									'$'+result[i].Product_Price+
									'</h2>'+
									'<h2 class="full-price">'+
										'$'+(result[i].BuyNumber*result[i].Product_Price)+
									'</h2>'+
								'</footer>'+
							'</article>'
            		}
            		
            	$("#cart").html(return_data);
            	if(subtotal>getshipfee()){
            		shipping=0;
            		total=subtotal;
            	}else{
            		total=subtotal+shipping;
            	}
            	footer_data='<div class="left">'+
							'<h2 class="subtotal">商品總額: <span>'+subtotal+'</span></h2>'+
							'<h3 class="shipping">運費(本店消費滿 '+getshipfee()+' 即免運): <span>'+shipping+'</span></h3>'+
							'</div>'+
							'<div class="right">'+
							'<h1 class="total">訂單總額: <span>'+total+'</span></h1>'+
							'<article class="product" style="height: fit-content;">'+
							'<a class="btn-check">結帳去</a>'+
							'</article>';
				$("#pay-footer").html(footer_data);
            	}
            	check_data=checkcart(result);
            },
            //<%-- 回傳失敗 --%>
            error:
                function(xhr, ajaxOptions, thrownError){
                    alert(xhr.status+"\n"+thrownError);
                }
            
		});
		  $(".remove").click(function(){
			var removepid = $(this).attr('id');
      		$.ajax({
          		type:"post", 
                  url:"${pageContext.request.contextPath}/ShopCartRemoveItemServlet",
                  dataType:"text",
                  async: false,
                  data: {
                  	removepid:removepid
                  	},
                  //<%-- 回傳成功 --%>
                  success: function(result){
                  },
                  //<%-- 回傳失敗 --%>
                  error:
                      function(xhr, ajaxOptions, thrownError){
                          alert(xhr.status+"\n"+thrownError);
                      }
      		});
			    var el = $(this);
			    el.parent().parent().addClass("removed");
			    window.setTimeout(
			      function(){
			        el.parent().parent().slideUp('fast', function() { 
			          el.parent().parent().remove(); 
			          if($(".product").length == 1) {
			              $("#cart").html("<h1>沒有商品!</h1>");
			          }
			          changeTotal(); 
			        });
			      }, 200);
			  });
		  
		 	 $(".btn-check").click(function(){
		 		renewcart2();
  			  var bootbox_buttons = {};
          	      
          	bootbox_buttons.close = {
                  	label: '<i class="fa fa-times"></i>返回',
                  	className:"btn btn-outline-dark",
                  	callback:function(){
              		}           	        
          	    },
          	bootbox_buttons.confirm = {
              	    label: '<i class="fa fa-arrow-right"></i>下一步',
              	    className:"btn btn-outline-success",
              	    callback:function(){
        	 		window.location.href="${pageContext.request.contextPath}/OpenCheckupServlet"	
          			}
              	} 
          	    bootbox.dialog({
          	        title:"確認購買",
          	    	message:checkcart(),
          	        buttons: bootbox_buttons,
          	        closeButton: false,
          	        callback: function (result) {
          	        }
          	    });
  				
  			  }); 
			  $(".qt-plus").click(function(){
			    var number=parseInt($(this).parent().children(".qt").html(), 10);
			    var prd_quanity=get_quanity();
        		var inid = $(this).attr('id');
        		var quanity=0;
        		for(var i=0;i<prd_quanity.length;i++){
        			if(prd_quanity[i].ProductStyle_ID==inid.substring(0,inid.indexOf('_'))){
        				quanity=prd_quanity[i].ProductStyle_Quanity
        			}
        		}
        		console.log('number'+number)
        		if(number==quanity){
        			bootbox.alert('目前商品存貨: '+quanity+' 因此無法供應更多')
        		}else{
        			$(this).parent().children(".qt").html(parseInt($(this).parent().children(".qt").html()) + 1);
        		}
            	console.log('quanity'+quanity)
			    
			    var el = $(this);
			    window.setTimeout(function(){el.parent().children(".full-price").removeClass("added"); changeVal(el);}, 150);
			    renewcart2()
			  });
			  
			  $(".qt-minus").click(function(){
			    
			    child = $(this).parent().children(".qt");
			    
			    if(parseInt(child.html()) > 1) {
			      child.html(parseInt(child.html()) - 1);
			    }
			    
			    
			    var el = $(this);
			    window.setTimeout(function(){el.parent().children(".full-price").removeClass("minused"); changeVal(el);}, 150);
			    renewcart2()
			  });
			  
//			  window.setTimeout(function(){$(".is-open").removeClass("is-open")}, 1200);
			  
			  
	}
		function get_quanity(){
			var q;
			$.ajax({
	    		type:"post", 
	            url:"${pageContext.request.contextPath}/GetShopCartServlet",
	            dataType:"json",
	            async: false,
	            data: {
	            	prdID:1,
	            	tablename : 'Product',
	            	},
	            //<%-- 回傳成功 --%>
	            success: function(result){
	            	q=result;
	            },
	            //<%-- 回傳失敗 --%>
	            error:
	                function(xhr, ajaxOptions, thrownError){
	                    alert(xhr.status+"\n"+thrownError);
	                }
			});
			return q;
		}
		function changeVal(el) {
			  var qt=0;
			  qt = parseInt(el.parent().children(".qt").html());
			  var price=0;
			  price = parseInt(el.parent().children(".price").html().replace('$',''));
			  var eq=0;
			  
			  eq = price * qt;
			  console.log(qt+' '+eq+' ')
			  el.parent().children(".full-price").html('$'+eq);
			  changeTotal();      
			}

		function changeTotal() {
		  var price = 0;
		  $(".full-price").each(function(index){
			  console.log('price'+$(".full-price").eq(index).html().replace('$',''))

		    price += parseFloat($(".full-price").eq(index).html().replace('$',''));
		  });
		  var shipping = 60;
		  if(price>getshipfee()){
			  shipping=0;
		  }
		  var fullPrice = Math.round(price+shipping);
		  
		  if(price == 0) {
		    fullPrice = 0;
		  }
		  
		  $(".subtotal span").html(price);
		  $(".shipping span").html(shipping);		  
		  $(".total span").html(fullPrice);
		}
		function getshipfee() {
			var limit=0;
			$.ajax({
	    		type:"post", 
	            url:"${pageContext.request.contextPath}/GetShopCartServlet",
	            dataType:"text",
	            async: false,
	            data: {
	            	prdID:2,
	            	tablename : 'Product',
	            	},
	            //<%-- 回傳成功 --%>
	            success: function(result){
	            	limit=result;
	            },
	            //<%-- 回傳失敗 --%>
	            error:
	                function(xhr, ajaxOptions, thrownError){
	                    alert(xhr.status+"\n"+thrownError);
	                }
	            
			});
			return limit;
		}
		function checkcart() {
			var check_data="";
			$.ajax({
	    		type:"post", 
	            url:"${pageContext.request.contextPath}/GetShopCartServlet",
	            dataType:"json",
	            async: false,
	            data: {
	            	prdID:1,
	            	tablename : 'Product',
	            	},
	            //<%-- 回傳成功 --%>
	            success: function(result){
	            	check_data='<h6 style="color:#48A6CE;">此次您選購以下商品及數量。如需修改或有誤請按"返回"修改</h6>';
	    			for(var i=0;i<result.length;i++){
	    			      check_data+='<div id="cardinfo" style="width: 100%;display: inline-table;border-bottom: 2px solid #E89158;color:#3D5A80;">'+
	    			      '<div id="card_text_info"style="float: left;">'+
	    			      '<div class="profile-card-info profile-user-info-striped">'+ 
	    			            '<div class="prd-info-name"id="'+result[i].ProductStyle_ID+'_prdname">'+result[i].Product_Name+' 款式:'+result[i].ProductStyle_Vaule+'</div>'+
	    			          '</div>'+ 
	    			        '</div>'+
	    			        '<br>'+  
	    			        '<div class="profile-card-info profile-user-info-striped">'+  
	    			          '<div class="prd-info-price" id="'+result[i].ProductStyle_ID+'_prdprice">$'+result[i].Product_Price+'×'+result[i].BuyNumber+'</div>'+
	    			          '</div>'+
	    			        '</div>'+
	    			      '</div>'+
	    			  '</div>'
	              		}
	    			
	    			},
	            //<%-- 回傳失敗 --%>
	            error:
	                function(xhr, ajaxOptions, thrownError){
	                    alert(xhr.status+"\n"+thrownError);
	                }
	            
				});
			return check_data;
			}
		function renewcart2(){
			var x = document.getElementsByClassName("prd-content");
			var y = document.getElementsByClassName("qt");
			var i;
			var prdid_incart=[];
			var prdamount_incart=[];
			for (i = 0; i < x.length; i++) {
				console.log(x[i].id.substring(0,x[i].id.indexOf('_')))
				prdid_incart.push(x[i].id.substring(0,x[i].id.indexOf('_')));
			}
			for (i = 0; i < y.length; i++) {
				console.log(y[i].innerHTML)			
				prdamount_incart.push(y[i].innerHTML);
			}
			$.ajax({
	    		type:"post", 
	            url:"${pageContext.request.contextPath}/RenewShopCartServlet",
	            dataType:"json",
	            async: false,
	            data: {
	            	prdamount_incart:prdamount_incart,
	            	prdid_incart:prdid_incart,
	            	tablename : 'Product',
	            	type:'shopcart'
	            	},
	            success: function(result){
	            	console.log(result)
	            	cartinfo();
	            },
	            //<%-- 回傳失敗 --%>
	            error:
	                function(xhr, ajaxOptions, thrownError){
	                    alert(xhr.status+"\n"+thrownError);
	                }
			});
			
		}
		function cartinfo(){
			var check_info="";
			$.ajax({
	    		type:"post", 
	            url:"${pageContext.request.contextPath}/GetShopCartServlet",
	            dataType:"json",
	            async: false,
	            data: {
	            	prdID:1,
	            	tablename : 'Product',
	            	},
	            //<%-- 回傳成功 --%>
	            success: function(result){
	            	return checkcart(result);
	            },
	            //<%-- 回傳失敗 --%>
	            error:
	                function(xhr, ajaxOptions, thrownError){
	                    alert(xhr.status+"\n"+thrownError);
	                }
	            
			});
		}
	</script>
<meta charset="UTF-8">
<title>ShopCart</title>
<style>
img{
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
</style>
</head>
<body>
<jsp:include page="../slidemenu.jsp"/>
<div id="testinfo">

</div>
	<header id="site-header">
		<div class="container">
			<h1>購物車-結帳</h1>		
		</div>
	</header>

	<div class="container-shopcart">

		<section id="cart"> 
		</section>

	</div>

	<footer id="site-footer">
		<div class="container-clearfix" id="pay-footer">
			
			</div>

	</footer>

</body>
</html>