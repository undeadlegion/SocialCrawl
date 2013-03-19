<?php
/**
 * Ajax HTTP response pages for event creation
 */
include_once("HTMLTemplates/Form.php");
$form = new Form();

$page = $_GET['p'];

if ($page == 2) { //Friend selector
?>

				
			<div class="progress">
			<h2>Event Details &raquo; <b class="current">Select Friends</b> &raquo; Select Bars</h2>
			</div>
			<div id="fb-root"></div>
				
				<script src="http://connect.facebook.net/en_US/all.js"></script>
				<script>

				FB.init({appId: '<?=FACEBOOK_APP_ID?>', status: true, cookie: true, xfbml: true});
 
                FB.getLoginStatus(function(response) {
                    if (response.session) {
                      init();
                    } else {
                      //not logged in
                      alert('Not logged into Facebook');
                    }
                });

                function init() {
                	FB.api('/me', function(response) {
                    	//alert('test');
                		$("#jfmfs-container").jfmfs();
                	});
                }
				</script>
				
				<div id="jfmfs-container"></div>
				<br/>
				<div id="select-div">
				<button id="select">Next</button>
				</div>
				

<?php
} else if ($page == 3) { //Bar Selector

$friendString = $_GET['friends'];
$title = $_GET['title'];
$description = $_GET['description'];
$date = $_GET['date'];
$privacy = $_GET['privacy'];

?>
	<div class="progress">
	<h2>Event Details &raquo; Select Friends &raquo; <b class="current">Select Bars</b></h2>
	</div>

			<div id="fb-root"></div>

			
			
			<?php $form->printBarsUL(); ?>
			
			<div id="barschedule">
				<h1 class="ui-widget-header">Bar Schedule</h1>
				<div class="ui-widget-content">
				<ul id="barList">
					<li class="placeholder">Drag bars here</li>
				</ul>

				</div>
			</div>
			
			<div id="bartrash">
				<h1 class="ui-widget-header">Remove</h1>
				<ul>
					<li class="remove">Drag here to remove</li>
				</ul>
			</div>
			
			<button id="finish">Create Event</button>

<?php
	
}

?>