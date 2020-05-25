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
<!--===============================================================================================-->
	<!--<script src="js/jquery.js"></script>-->
	<!--<script src="js/datatables.min.js"></script>-->
	<script src="vendor/jquery/jquery-3.2.1.min.js"></script>
	<script src="vendor/bootstrap/js/popper.js"></script>
	<script src="vendor/bootstrap/js/bootstrap.js"></script>
	<script src="js/bootbox.js"></script>
	<script src="js/jquery.dataTables.js"></script>
	<script src="js/jquery.dataTables.bootstrap.js"></script>
	<script type="text/javascript">
	window.onload=function(){
	 get_phsname();
	}
	
	function get_phsname(){//取得該產品的照片檔名
		var doID=12;
		var prdID=39;
		$.ajax({
    		type:"post", 
            url:"${pageContext.request.contextPath}/GetPrdPhsServlet",
            dataType:"json",
            async: false,
            data: {
            	doID:doID,
            	prdID:prdID,
            	tablename : 'Product',
            	},
            //<%-- 回傳成功 --%>
            success: function(result){
            	show_phs(result);
            },
            //<%-- 回傳失敗 --%>
            error:
                function(xhr, ajaxOptions, thrownError){
                    alert(xhr.status+"\n"+thrownError);
                }
		});
	}
	function show_phs(result){//拼接
		var doID=12;
		var i;
		
		var storepath='${pageContext.servletContext}/upload/Product/';
		var carousel_data;
		carousel_data='<ol class="carousel-indicators" ><li data-target="#carouselExampleIndicators" data-slide-to="0" class="active"></li>';
		for(i=0;i<result.length-1;i++){
		carousel_data+='<li data-target="#carouselExampleIndicators" data-slide-to="'+(i+1)+'"></li>'
	        };
	    carousel_data+= '</ol><div class="carousel-inner">'    
	    for(i=0;i<1;i++){
				$.each(result[i], function(index, value) {
					carousel_data+='<div class="carousel-item active">'+
				      '<img class="d-block w-100" src="${pageContext.request.contextPath}/upload/Product/'+doID+'/'+value+'"alt="First slide">'+
				    '</div>'
		    });    
	    }
		for(i=1;i<result.length;i++){
			$.each(result[i], function(index, value) {
				carousel_data+= '<div class="carousel-item">'+
			      '<img class="d-block w-100" src="${pageContext.request.contextPath}/upload/Product/'+doID+'/'+value+'"alt="First slide">'+
			    '</div>'
	        });
		}
		carousel_data+= '</div>'+
					  '<a class="carousel-control-prev" href="#carouselExampleIndicators" role="button" data-slide="prev">'+
					    '<span class="carousel-control-prev-icon" aria-hidden="true">'+'</span>'+
					    '<span class="sr-only">'+'</span>'+
					  '</a>'+
					  '<a class="carousel-control-next" href="#carouselExampleIndicators" role="button" data-slide="next">'+
					    '<span class="carousel-control-next-icon" aria-hidden="true">'+'</span>'+
					    '<span class="sr-only">'+'</span>'+
					  '</a>'
				 $("#carouselExampleIndicators").html(carousel_data);	
		
	}				    
	</script>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<div id="testinfo" style="float: left;">
	<div class="profile-user-info profile-user-info-striped"> 
		<div class="profile-info-row"> 
			<div class="profile-info-name">產品名稱:</div> 
			<div class="profile-info-value">ter</div> 
		</div> 
	</div>							
	<div class="profile-user-info profile-user-info-striped"> 
		<div class="profile-info-row"> 
			<div class="profile-info-name">產品價錢:</div> 
			<div class="profile-info-value"> 200  </div> 
		</div> 
	</div> 
	<div class="profile-user-info profile-user-info-striped"> 
		<div class="profile-info-row"> +
			<div class="profile-info-name">細節說明:</div> +
			<div class="profile-info-value">${pageContext.servletContext}</div> 
		</div> 
	</div>
</div>					
<div id="carouselExampleIndicators" class="carousel slide" data-ride="carousel"style="width: 300px; height: 300px;float: right;"></div>


</body>
</html>