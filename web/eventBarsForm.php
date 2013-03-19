<?php session_start(); /// Start the session so we can use session variables. ?>  

<?php

ini_set('max_execution_time', 300);
define('FACEBOOK_APP_ID', '193718833988727');
define('FACEBOOK_SECRET', '96867640d16c52b69dc64446a038b76e');

include_once("FacebookInteraction/FacebookInteraction.php");
include_once("DatabaseInteraction/DatabaseInteraction.php");
include_once("HTMLTemplates/Form.php");

$authenticate = new FacebookAuthentication();
$cookie = $authenticate->getFacebookCookie(FACEBOOK_APP_ID, FACEBOOK_SECRET);
$form = new Form();

$user = new FacebookUser();

?>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<style type="text/css">@import "style.css";</style>
<script src="http://ajax.googleapis.com/ajax/libs/jquery/1.4.2/jquery.min.js"></script>
<script src="https://ajax.googleapis.com/ajax/libs/jqueryui/1.8.10/jquery-ui.min.js"></script>
<script src="FacebookInteraction/jquery.facebook.multifriend.select.js"></script>
<link rel="stylesheet" href="FacebookInteraction/jquery.facebook.multifriend.select.css" />
<style>
	h1 { padding: .2em; margin: 0; }
	#barslist { float:left; width: 200px; margin-right: 2em; }
	#barschedule { width: 300px; float: left; }
	/* style the list to maximize the droppable hitarea */
	#barschedule ol { margin: 0; padding: 1em 0 1em 3em; }
</style>
<script>
	$(function() {
		$( "#barslist li" ).draggable({
			appendTo: "body",
			helper: "clone"
		});
		$( "#barschedule ol" ).droppable({
			activeClass: "ui-state-default",
			hoverClass: "ui-state-hover",
			accept: ":not(.ui-sortable-helper)",
			drop: function( event, ui ) {
				$( this ).find( ".placeholder" ).remove();
				$( "<li></li>" ).text( ui.draggable.text() ).appendTo( this );
			}
		}).sortable({
			items: "li:not(.placeholder)",
			sort: function() {
				// gets added unintentionally by droppable interacting with sortable
				// using connectWithSortable fixes this, but doesn't allow you to customize active/hoverClass options
				$( this ).removeClass( "ui-state-default" );
			}
		});
	});
</script>
<title>CampusCrawler</title>
</head>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml"
     xmlns:fb="http://www.facebook.com/2008/fbml">
	<body>
 		<div class="header">
			<div class="logout">
			</div>
    	</div>
		<div class="board">
			<div class="boardcontent">
			<div id="fb-root"></div>
			
			<?php $form->printBarsUL(); ?>
			
			<div id="barschedule">
				<h1 class="ui-widget-header">Bar Schedule</h1>
				<div class="ui-widget-content">
				<ol>
					<li class="placeholder">Drag bars here</li>
				</ol>
				</div>
			</div>

			</div>
		</div>
	</body>
</html>