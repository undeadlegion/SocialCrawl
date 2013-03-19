<html>
<head>
 <!-- http://mike.brevoort.com/2010/08/10/introducing-the-jquery-facebook-multi-friend-selector-plugin/ s-->
 
 <script type = "text/javascript" src = "https://ajax.googleapis.com/ajax/libs/jquery/1.4.2/jquery.min.js"></script>
 <script type="text/javascript" src="jquery.facebook.multifriend.select.js"></script>
 <link href="jquery.facebook.multifriend.select.css" rel="stylesheet" />
 
 
 <script type = "text/javascript">
 
 // User hits enter or escape key, iframe will close
 $(document).bind('keyup', function(e){
	   if(e.which === 13) { // return
	      $('#selectFriendsSubmit').trigger('click');
	   }
	   if(e.keyCode == 27){ // esc
	      $('#selectFriendsSubmit').trigger('click');
	   }
	});


 // Hover and click events for button
 $(function(){
		(function(){ 
			$("#selectFriendsSubmit")
			 .hover(
			     function(){ 
			         $(this).addClass("ui-state-hover"); 
			     },
			     function(){ 
			         $(this).removeClass("ui-state-hover"); 
			     }
			 )
			.mousedown(
				function(){
		     		$(this).addClass("ui-state-active");
				}
			)
			.mouseup(
				function(){
		     		$(this).removeClass("ui-state-active");
				}
			);
		})();
 });

 /**
  *	Focus on the find friend text input on load 
  */
 function clickFindName(){
	 $('#jfmfs-friend-filter-text').focus();
 }
 
 </script>  
</head>
    
<body bgcolor = "#FFFFFF">
  <div id="jfmfs-container" style = "backbackground-color: #FFFFFF"> 	</div>
  <div id = "fb-root"></div>
    <script src="http://connect.facebook.net/en_US/all.js"></script>
    <script>
   		 FB.init({appId: '183973304975501', cookie: true});
   		 initSelector();
         /*FB.getLoginStatus(function(response) {
          	if (response.session) {
            	initSelector();
         	}
            else{
				alert("NOT LOGGED IN");
            }
          });*/

         function initSelector() {
             //var excluded = parent.getExcluded();
             //var excludedArray = excluded.split(", ");
             var excludedArray = 0;
             $("#jfmfs-container").jfmfs();  
    	 	}

  		 	// User clicks Save And Close
  		 	// Gather ID's and sent to addInvitees function
        	 $("#selectFriendsSubmit").live("click", function() {
           	  	 var friendSelector = $("#jfmfs-container").data('jfmfs');             
            	 var ids = friendSelector.getSelectedIds().join(', '); 
				 var sideBar = parent.document.getElementById("sideBar");
			 	if(<?php echo $action?> == "1")
         	 		sideBar.contentWindow.addInvitees(ids);
				 else if(<?php echo $action?> == "0")
					sideBar.contentWindow.viewFriendsCalendar(ids);
       		 }); 	
         function clickButton(){
			$('#selectFriendsSubmit').trigger("click");
         }
    </script>
    
    <div id="jfmfs-container"></div>
   
</body>
</html>

