<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<!DOCTYPE >
<html>
<head>
	<script src="vendor/jquery/jquery-3.2.1.min.js"></script>

	<script type="text/javascript">
	window.onload=function(){
		$('#go').on("click",function(){
			uploadphoto();
 		});		
		function uploadphoto(){
			//上傳照片
			var formData = new FormData(form_jquery);
			$.ajax({
				type:"post",
				url:"${pageContext.request.contextPath}/uploadToDB",
				datatype:"text",
				processData: false,
				contentType:false,
				cache : false,
				data:formData,
				async: false,
				success:function(result){
						console.log("上傳"+result);
						//location.reload();
				},
				error:function(xhr,ajaxOptions,thrownError){
					alert("");
					alert(xhr.status);
					alert(thrownError);
				}
			});
		}		
	}
	</script>

<title>Upload files</title>

</head>
<body>
 
    <div style="padding:5px; color:red;font-style:italic;">
       ${errorMessage}
    </div>
    
    <h2>Upload Files</h2>
 
    <form id="form_jquery" enctype="multipart/form-data">
        
        Select file to upload:
        <br />
        <input type="file" name="file"  />
        <br />
        Description:
        <br />
        <input type="text" name="description" size="100" />
        <br />
        <br />
    </form>
    <button id="go"> 提交</button>
    
</body>
</html>