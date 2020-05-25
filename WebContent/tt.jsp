<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<head>

  <meta charset="utf-8"/>
  <title>Side Menu</title>
  <link rel="stylesheet" type="text/css" href="css/slidemenu.css">
  <link rel="stylesheet" type="text/css" href="https://cdn.jsdelivr.net/npm/daterangepicker/daterangepicker.css" />
  <script src="js/bootbox.js"></script>
  	<script src="vendor/jquery/jquery-3.2.1.min.js"></script>
  	<script type="text/javascript" src="https://cdn.jsdelivr.net/jquery/latest/jquery.min.js"></script>
	<script type="text/javascript" src="https://cdn.jsdelivr.net/momentjs/latest/moment.min.js"></script>
	<script type="text/javascript" src="https://cdn.jsdelivr.net/npm/daterangepicker/daterangepicker.min.js"></script>
	<script defer src="https://use.fontawesome.com/releases/v5.0.13/js/solid.js"></script>
    <script defer src="https://use.fontawesome.com/releases/v5.0.13/js/fontawesome.js"></script>
	<!-- jQuery CDN - Slim version (=without AJAX) -->
    <!-- Popper.JS -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.0/umd/popper.min.js" integrity="sha384-cs/chFZiN24E4KMATLdqdvsezGxaGsi4hLGOzlXwp5UZB1LY//20VyM2taTB4QvJ" crossorigin="anonymous"></script>
    <!-- Bootstrap JS -->
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.1.0/js/bootstrap.min.js" integrity="sha384-uefMccjFJAIv6A+rW+L4AHf99KvxDjWSu1z9VI8SKNVmz4sk7buKt/6v9KI65qnm" crossorigin="anonymous"></script>
    <!-- jQuery Custom Scroller CDN -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js@2.8.0"></script>
</head>
<body>
<div id="prd_chart" style="width: 1000px;height: 400px;">
<canvas id="myChart"></canvas>
</div>
	<script type="text/javascript">
	window.onload=function(){
		sidemenu();
	};
    function sidemenu(){
    	bootbox.confirm("This is the default confirm!", function(result){ 
		    console.log('This was logged in the callback: ' + result); 
		});
		});
    	var ctx = document.getElementById('myChart').getContext('2d');
    	var chart = new Chart(ctx, {
    	    // The type of chart we want to create
    	    type: 'bar',

    	    // The data for our dataset
    	    data: {
    	        labels: ['30Z Origami典藏馬克杯', 'MB STAR R典藏不鏽鋼杯', 'Pattern R不鏽鋼Togo冷水杯', 'Mercury典藏不鏽鋼杯', 'STAR R典藏皮套不鏽鋼杯', 'STAR R托盤'],
    	        datasets: [{
    	            label:'本月銷量',
    	            backgroundColor: ['rgba(255, 99, 132, 0.2)',
                    'rgba(54, 162, 235, 0.2)',
                    'rgba(255, 206, 86, 0.2)',
                    'rgba(75, 192, 192, 0.2)',
                    'rgba(153, 102, 255, 0.2)',
                    'rgba(255, 159, 64, 0.2)'],
    	            borderColor: ['rgba(255, 99, 132, 1)',
                    'rgba(54, 162, 235, 1)',
                    'rgba(255, 206, 86, 1)',
                    'rgba(75, 192, 192, 1)',
                    'rgba(153, 102, 255, 1)',
                    'rgba(255, 159, 64, 1)'],
    	            data: [1, 10, 5, 2, 12, 7, 2]
    	        }]
    	    },

    	    // Configuration options go here
    	    options: {}
    	});
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
            	alert("購物車已清空")
            },
            //<%-- 回傳失敗 --%>
            error:
                function(xhr, ajaxOptions, thrownError){
                    alert(xhr.status+"\n"+thrownError);
                }
		});
	}
    </script>    
</body>
