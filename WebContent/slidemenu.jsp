<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<head>

  <meta charset="utf-8"/>
  <link rel="stylesheet" type="text/css" href="css/slidemenu.css">
  <jsp:include page="link.jsp"/>
  <script src="js/bootbox.js"></script>
	<script defer src="https://use.fontawesome.com/releases/v5.0.13/js/solid.js"></script>
    <script defer src="https://use.fontawesome.com/releases/v5.0.13/js/fontawesome.js"></script>
    <!-- Popper.JS -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.0/umd/popper.min.js" integrity="sha384-cs/chFZiN24E4KMATLdqdvsezGxaGsi4hLGOzlXwp5UZB1LY//20VyM2taTB4QvJ" crossorigin="anonymous"></script>
    <!-- Bootstrap JS -->
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.1.0/js/bootstrap.min.js" integrity="sha384-uefMccjFJAIv6A+rW+L4AHf99KvxDjWSu1z9VI8SKNVmz4sk7buKt/6v9KI65qnm" crossorigin="anonymous"></script>
    <!-- jQuery Custom Scroller CDN -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/malihu-custom-scrollbar-plugin/3.1.5/jquery.mCustomScrollbar.concat.min.js"></script> 	
   
<style>

/* *{border:1px solid #000;} */
</style>
</head>
<body>
 <div class="wrapper">
        <!-- Sidebar  -->
        <nav id="sidebar">
            <div id="dismiss">
                <i class="fas fa-arrow-left"></i>
            </div>

            <div class="sidebar-header">
            </div>

            <ul class="list-unstyled components">
                <li id="homepage">
                    <a href=${pageContext.request.contextPath}/HomeServlet?TYPE=0>首頁</a>
                </li>
                <li id="productmenu">
                    <a id="producta" href=${pageContext.request.contextPath}/OpenMagPrdpageServlet?MAG=prd>商品管理</a>

                </li>
                <li id="accountmag">
                    <a href=${pageContext.request.contextPath}/OpenMagAccountServlet>使用者管理</a>
                </li>
                <li id="shopchart">
                    <a href=${pageContext.request.contextPath}/OpenShopChartServlet>商店銷售報表</a>
                </li>
                <li>
                    <a href="#orderSubmenu" data-toggle="collapse" aria-expanded="false" id="ordermag">訂單管理</a>
                    <ul class="collapse list-unstyled" id="orderSubmenu">
                        <li id="orderchange">
                            <a href=${pageContext.request.contextPath}/OpenMagOrderServlet?OAG=mag>訂單處理</a>
                        </li>
                        <li id="reqcheck">
                            <a href=${pageContext.request.contextPath}/OpenMagOrderServlet?OAG=req>需求審核</a>
                        </li>
                    </ul>
                </li> 

                <li>    
                    <a href="#shopSubmenu" data-toggle="collapse" aria-expanded="false" id="shopmag">商店管理</a>
                    <ul class="collapse list-unstyled" id="shopSubmenu">
                        <li id="shopinfo">
                            <a href=${pageContext.request.contextPath}/OpenMagShopServlet?BS=S>商店資訊</a>
                        </li>
                         <li id="shopcate">
                            <a href=${pageContext.request.contextPath}/OpenMagPrdpageServlet?MAG=type>商品分類</a>
                        </li>
                        <li id="prdchart">
                            <a href=${pageContext.request.contextPath}/OpenPrdChartServlet>銷售報表</a>
                        </li>
                    </ul>
                </li>    
                <li>
                    <a href="#pageSubmenu" data-toggle="collapse" aria-expanded="false" id="membermenu" >個人專區</a>
                    <ul class="collapse list-unstyled" id="pageSubmenu">
                        <li id="ordersearch">
                            <a href=${pageContext.request.contextPath}/OpenOrderSearchServlet>訂單查詢</a>
                        </li>
                        <li id="membermag">
                            <a href=${pageContext.request.contextPath}/OpenMagMemberServlet>會員資料</a>
                        </li>
                    </ul>
                </li>
            </ul>

            <ul class="list-unstyled CTAs">
                <li id="loginbtn">
                    <a href=${pageContext.request.contextPath}/LoginSessionServlet class="download">會員登入</a>
                </li>
                <li id="logoutbtn">
                    <a href=${pageContext.request.contextPath}/LogoutServlet class="article">會員登出</a>
                </li>
            </ul>
        </nav>

        <!-- Page Content  -->
        <div id="content">

            <nav class="navbar navbar-expand-lg">
                <div class="container-fluid">

                    <button type="button" id="sidebarCollapse" class="btn btn-light">
                        <i class="fas fa-align-left"></i>
                        <span>功能選單</span>
                    </button>
                    <div class="row" id="menubtn" style="background-color: transparent;width: 100%;margin-left: 10%;"></div>
                    <button type="button" id="shopcart" class="btn btn-light">
                        <i class="fas fa-shopping-cart"></i>
                        <span>購物車</span>
                    </button>
                   
                </div>
                
            </nav>
		<div class="row" id="card" style="width: 1200px;background-color: transparent;left: 50%; position: relative;transform: translate(-50%, 10px);"></div>
		<div id="page" style="width: 1200px;background-color: transparent;left: 50%; position: relative;transform: translate(-50%, 10px);"></div>
            
        </div>
    </div>

    <div class="overlay"></div>
    <script type="text/javascript">
    function sidemenu(){
    	var vaild ="${vaild}"
    	var dolevel ="${level}"
    		if(dolevel){
    			if(dolevel.indexOf('1')===0){//是管理員
    				document.getElementById("homepage").remove();//首頁
    				document.getElementById("productmenu").remove();//商品選單
    				document.getElementById("ordermag").remove();//訂單管理
    				document.getElementById("shopmag").remove();//商店管理
    				document.getElementById("shopcart").remove();//購物車
    				document.getElementById("ordersearch").remove();//個人專區
    			}else if(dolevel.indexOf('3')===0){//買家
    				if(vaild==-1){
    		    		$('#membermenu').on('click', function () {
    		                alert('會員身分尚未驗證 無法使用此功能')
    		                document.getElementById("ordersearch").remove();
    		                document.getElementById("membermag").remove();
    		            });
    				}
	    			document.getElementById("productmenu").remove();//商品選單
	    			document.getElementById("accountmag").remove();//使用者管理
	    			document.getElementById("shopmag").remove();//商店管理
					document.getElementById("ordermag").remove();//訂單管理
					document.getElementById("shopchart").remove();//商店銷售報表
    			}else{//買賣家
    				
    				if(vaild==-1){
    		    		$('#membermenu').on('click', function () {
    		                alert('會員身分尚未驗證 無法使用此功能')
    		                document.getElementById("ordersearch").remove();
    		                document.getElementById("membermag").remove();
    		            });
    		    		$('#shopmag').on('click', function () {
    		                alert('會員身分尚未驗證 無法使用此功能')
    		                document.getElementById("shopinfo").remove();
    		            	document.getElementById("shopcate").remove();
    		            	document.getElementById("prdchart").remove();
    		            });
    		    		$('#ordermag').on('click', function () {
    		                alert('會員身分尚未驗證 無法使用此功能')
    		                document.getElementById("orderchange").remove();
    		                document.getElementById("reqcheck").remove();
    		            });
    		    		$('#producta').attr('href',"#")
    		    		$('#productmenu').on('click', function () {
    		                alert('會員身分尚未驗證 無法使用此功能')
    		                
    		            });
    				}
        			document.getElementById("accountmag").remove();//使用者管理
        			document.getElementById("shopchart").remove();//商店銷售報表
    			}
    		}
    	var doID ="${doID}"
    		if(doID){
    			document.getElementById("loginbtn").remove();
    		}else{
    			document.getElementById("shopchart").remove();//商店銷售報表
    			document.getElementById("membermenu").remove();//個人專區
    			document.getElementById("productmenu").remove();//商品選單
    			document.getElementById("ordermag").remove();//訂單管理
    			document.getElementById("accountmag").remove();//使用者管理
    			document.getElementById("logoutbtn").remove();//登出	
    			document.getElementById("shopmag").remove();//商店管理
    		}
    	$.ajax({
    		type:"post", 
            url:"${pageContext.request.contextPath}/IDSearchServelt",
            dataType:"json",
            async: false,
            data: {
            	id:doID,
            	tablename : 'Account',
            	},
            //<%-- 回傳成功 --%>
            success: function(result){
			if(result.length>0){
				$(".sidebar-header").html('<h4>您好! '+result[0].Account_Name+'</h4>');
			}else{
				$(".sidebar-header").html('<h4>您好! 遊客</h4>');				
			}
            },
            //<%-- 回傳失敗 --%>
            error:
                function(xhr, ajaxOptions, thrownError){
                    alert(xhr.status+"\n"+thrownError);
                }
		});
    	
            //自訂樣式的srtollbar
            $("#sidebar").mCustomScrollbar({
                theme: "minimal"
            });

            $('#dismiss, .overlay').on('click', function () {
                $('#sidebar').removeClass('active');
                $('.overlay').removeClass('active');
            });

            $('#sidebarCollapse').on('click', function () {
                $('#sidebar').addClass('active');
                $('.overlay').addClass('active');
                $('.collapse.in').toggleClass('in');
                $('a[aria-expanded=true]').attr('aria-expanded', 'false');
            });
            $('#shopcart').on('click', function () {
            	var bootbox_buttons = {};
            	bootbox_buttons.clear = {
						label: '<i class="fa fa-trash" id="clearcart"></i> 清空購物車',
						className:"btn btn-outline-danger",
						callback:function(){
							cleancart();
						}
				}
            	bootbox_buttons.confirm = {
            	        label: '<i class="fa fa-dollar-sign"></i> 結帳',
            	        className:"btn btn-outline-success",
            	        callback:function(){
            	        	var count=0;
            	        	$("input[name='shopcheck']").each(function(){
        						if($(this).prop('checked')==true){
        							count++
        						}
                        	});
            	        	if(count>1){
            	        		bootbox.alert("一次只能夠結帳一個店家的商品哦!");
            	        		//alert('一次只能夠結帳一個店家的商品哦!')
            	        		return false;
            	        	}else if(count==0){
            	        		bootbox.alert("請選擇您要結帳的店家");
            	        		//alert('請選擇您要結帳的店家')
            	        		return false;
            	        	}else{
            	        		var prdID=[];
            	        		$("input[name='prdcheck']").each(function(){
            						if($(this).prop('checked')==true){
            							prdID.push($(this).attr('value'))
            						}
                            	});
            	        		//alert(prdID)
	            	        	renewcart();
	            	        	
	            	        	$.ajax({
	            	        		type:"post", 
	            	                url:"${pageContext.request.contextPath}/FilterShopCartServlet",
	            	                dataType:"json",
	            	                async: false,
	            	                data: {
	            	                	prdID:prdID
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
	            	        	window.location.assign("${pageContext.request.contextPath}/OpenShopCartServlet");
            	        	}
        				}
            	}        
            	bootbox_buttons.close = {
                    	label: '<i class="fa fa-times"></i>關閉',
                    	className:"btn btn-outline-dark",
                    	callback:function(){
                    		renewcart();
                		}           	        
            	    },
            	    bootbox.dialog({
            	        title:"購物車",
            	    	message: getcart(),
            	        buttons: bootbox_buttons,
            	        closeButton: false,
            	        className: "medium",
            	        callback: function (result) {
            	        }
            	    });
            	if($("input[id*='input_product_quantity']").val()==1){
        			$("button[id*='product_quantity_decrement']").attr('disabled', true);
        		}
            	var inputid="";
            	$("button[name*='product_quantity_decrement']").on('click', function () {
            		if($("input[id*='input_product_quantity']").val()==1){
            			$("button[id*='product_quantity_decrement']").attr('disabled', true);
            		}
            		var deid=$(this).attr('id');
                		inputid=deid.replace('product_quantity_decrement','input_product_quantity');
                		var number=$('#'+inputid).val();
                			number--;
                    		$('#'+inputid).val(number);
                    		if(number==1){
                    			$('#'+deid).attr('disabled', true);	
                    		}
                	});
            	$("button[name*='product_quantity_increment']").on('click', function () {
            			
            		var prd_quanity=get_quanity();
            		var inid = $(this).attr('id');
            		$('#'+inid.replace('product_quantity_increment','product_quantity_decrement')).attr('disabled',false);
            		var quanity=0;
            		for(var i=0;i<prd_quanity.length;i++){
                		console.log(prd_quanity[i].ProductStyle_ID+' '+inid.substring(0,inid.indexOf('_')))
            			if(prd_quanity[i].ProductStyle_ID==inid.substring(0,inid.indexOf('_'))){
            				quanity=prd_quanity[i].ProductStyle_Quanity
            			}
            		}
                		inputid=inid.replace('product_quantity_increment','input_product_quantity');
                	var number=$('#'+inputid).val();
                	console.log('number'+number+'quanity'+quanity)
                		if(number==quanity){
                			bootbox.alert({
							    message:'目前商品存貨: '+quanity+' 因此無法供應更多',
							})
                		}else{	
                			number++;
                		}
                    		$('#'+inputid).val(number);
                    		
                	});
            	
            	$("button[name='product_remove']").on('click', function () {
            		var removepid = $(this).data('remove_pid');
            		var removediv = 'cardinfo'+$(this).data('remove_pid');
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
                        	bootbox.alert({
							    message: "商品已從購物車刪除"
							})
                        },
                        //<%-- 回傳失敗 --%>
                        error:
                            function(xhr, ajaxOptions, thrownError){
                                alert(xhr.status+"\n"+thrownError);
                            }
            		});
            		$('#'+removediv).remove();
                });
            	
            	$(".shopcheck").change(function () {
            		//alert($(this).prop('checked'))
            		if($(this).prop('checked')==true){
            			var shopid = $(this).attr('value');
            			var prdid='prdcheck'+shopid;
                		$("input[id='"+prdid+"']").prop('checked',true)
            		}else if($(this).prop('checked')==false){
            			var shopid = $(this).attr('value');
            			var prdid='prdcheck'+shopid;
                		$("input[id='"+prdid+"']").prop('checked',false)
            		}
            	 });
           	});
            	
            
    }
	function getcart(){
		var return_data=""
		var row=""
		$.ajax({
    		type:"post", 
            url:"${pageContext.request.contextPath}/GetShopCartServlet",
            dataType:"json",
            async: false,
            data: {
            	prdID:0,
            	tablename : 'Product',
            	},
            //<%-- 回傳成功 --%>
            success: function(result){
            	if (typeof result[0].CartState !== 'undefined'){
            		return_data=result[0].CartState;
            	}else{
            	console.log(result)	
            	var shopname=[];	
            	var shopsellerid=[];
            	for(var i=0;i<result.length;i++){
            		if (shopname.indexOf(result[i].Shop_Name) == -1){
            			shopname.push(result[i].Shop_Name);
            			shopsellerid.push(result[i].Product_SellerID);
            		}	
            	}
            	for(var i=0;i<shopname.length;i++){
            		return_data+='<input type="checkbox" id="shopcheck'+shopsellerid[i]+'" class="shopcheck" name="shopcheck" value="'+shopsellerid[i]+'"data-shop_name="'+shopname[i]+'">'+
            					'<span>'+shopname[i]+'</span>'
            					'<div id="shopname'+shopsellerid[i]+'">';
      			      for(var j=0;j<result.length;j++){
      			    	  
      							if(result[j].Product_SellerID==shopsellerid[i]){
      								return_data+='<div id="cardinfo'+result[j].ProductStyle_ID+'" style="width: 100%;display: inline-table;border-bottom: 2px solid #fca311;color:#3D5A80;">'+
      							  	  '<span id="card_text_info"style="float: left;">'+
      							    	'<input type="checkbox" id="prdcheck'+shopsellerid[i]+'" class="prdcheck" name="prdcheck" value="'+result[j].ProductStyle_ID+'"data-shop_name="'+result[j].Product_Name+'" style="margin-top: 2%;float: left;">'+
      							          '<span class="prd-info-name"id="'+result[j].Product_ID+'_prdname">'+result[j].Product_Name+'</span>'+
      							          '<span class="prd-info-price" id="'+result[j].Product_ID+'_prdprice"> NT$'+result[j].Product_Price+'</span>'+
      							        	'<span class="prd-info-style" id="'+result[j].ProductStyle_ID+'_prdstyle"> 款式'+result[j].ProductStyle_Vaule+'</span>'+
        							  '</span>'+  
      								  '<div id="card_btn_info"  style="float: right;margin-bottom: 1%;">'+
      								      '<button type="button" name="product_quantity_decrement" class="btn btn-light" id="'+result[j].ProductStyle_ID+'_product_quantity_decrement">'+
      								      '<i class="fas fa-minus">'+'</i>'+
      								      '</button>'+  
      								      '<input class="prd-info-amount" type="text" id="'+result[j].ProductStyle_ID+'_input_product_quantity" value="'+result[j].BuyNumber+'" style="width:40px;text-align: center;"></input>'+
      								      '<button type="button" name="product_quantity_increment" class="btn btn-light" id="'+result[j].ProductStyle_ID+'_product_quantity_increment">'+       
      								      '<i class="fas fa-plus">'+'</i>'+
      								      '</button>'+
      								    '<button type="button" name="product_remove" class="btn btn-danger" id="'+result[j].ProductStyle_ID+'_remove" data-remove_pid="'+result[j].ProductStyle_ID+'"><i class="fas fa-times"></i></button>'+
      							      '</div>'+
      							   '</div>';
      							}			    	  
      			      		
                  			}
      			    return_data+='</div>';
            		}
            	
            		
            	}
            },
            //<%-- 回傳失敗 --%>
            error:
                function(xhr, ajaxOptions, thrownError){
                    alert(xhr.status+"\n"+thrownError);
                }
		});
	return return_data;
	}
	function get_quanity(){
		var q;
		$.ajax({
    		type:"post", 
            url:"${pageContext.request.contextPath}/GetShopCartServlet",
            dataType:"json",
            async: false,
            data: {
            	prdID:0,
            	tablename : 'Product',
            	},
            //<%-- 回傳成功 --%>
            success: function(result){
            	console.log(result)
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
	function cleancart(){
		$.ajax({
    		type:"post", 
            url:"${pageContext.request.contextPath}/ShopCartServlet",
            dataType:"json",
            async: false,
            data: {
            	prdID:-1,
            	tablename : 'Product',
            	},
            success: function(result){
            	bootbox.alert({
				    message: "購物車已清空"
				})
            },
            //<%-- 回傳失敗 --%>
            error:
                function(xhr, ajaxOptions, thrownError){
                    alert(xhr.status+"\n"+thrownError);
                }
		});
	}
	function renewcart(){
		//<%-- account_user 物件 --%>
		var account_user = $("#account_user");
		var x = document.getElementsByClassName("prd-info-style");
		var y = document.getElementsByClassName("prd-info-amount");

		var i;
		var prdid_incart=[];
		var prdamount_incart=[];
		if(y!=''){
			for (i = 0; i < x.length; i++) {
				prdid_incart.push(x[i].id.substring(0,x[i].id.indexOf('_')));
			}
			for (i = 0; i < y.length; i++) {
				prdamount_incart.push(y[i].value);
			}
			console.log(prdamount_incart);
			$.ajax({
	    		type:"post", 
	            url:"${pageContext.request.contextPath}/RenewShopCartServlet",
	            dataType:"json",
	            async: false,
	            data: {
	            	prdamount_incart:prdamount_incart,
	            	prdid_incart:prdid_incart,
	            	tablename : 'Product',
	            	type:'side'
	            	},
	            success: function(result){  	
	            },
	            //<%-- 回傳失敗 --%>
	            error:
	                function(xhr, ajaxOptions, thrownError){
	                    alert(xhr.status+"\n"+thrownError);
	                }
			});
		}else{
			//cleancart()
		}
	}
    </script>	
    
</body>
