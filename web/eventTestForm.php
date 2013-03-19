<?php session_start(); /// Start the session so we can use session variables. ?>  

<?php

ini_set('max_execution_time', 300);
define('FACEBOOK_APP_ID', '193718833988727');
define('FACEBOOK_SECRET', '96867640d16c52b69dc64446a038b76e');

include_once("FacebookInteraction/FacebookInteraction.php");
//include_once("DatabaseInteraction/DatabaseInteraction.php");
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

<script>

	var endUrlString = "";
	var addString = "";
	
	$(document).ready(function() {
	
		$('#next').click(function() {
		
			var $inputs = $('#detailsForm :input');
	
			var urlString = "eventCreateAjax.php?p=2";
			var values = {};

			$inputs.each(function() {
				addString = addString + "&" + this.name + "=" + $(this).val();
				urlString = urlString + "&" + this.name + "=" + $(this).val();
			});
			
			$('.boardcontent').load(urlString, function() {
				endUrlString = urlString;
				
				$('#select').click(function() {
					var friendSelector = $("#jfmfs-container").data('jfmfs');
					var friendIds = friendSelector.getSelectedIds();

					var urlString = "eventCreateAjax.php?p=3&friends=";
					var i = 0;
					for (i = 0; i < friendIds.length; i++) {
						if (i > 0) {
							addString = addString + ",";
							urlString = urlString + ",";
						}
						addString = addString + friendIds[i];
						urlString = urlString + friendIds[i];
					}
					
				//indent more here
				$('.boardcontent').load(urlString + addString, function() {
				
					$('#finish').click(function() {
						alert(addString);
						alert($('#barschedule ul :visible').text());
					});

					$( "#barslist li" ).draggable({
						helper: "clone",
						cursor: "move"
					});
					$( "#barschedule ul" ).droppable({
						activeClass: "ui-state-default",
						hoverClass: "ui-state-hover",
						accept: ":not(.ui-sortable-helper)",
						over: function(event, ui) {
							$("#barschedule").css("color","#FF8D00");
						},
						out: function(event, ui) {
							$("#barschedule").css("color","#FFFFFF");
						},
						drop: function( event, ui ) {
							$( this ).find( ".placeholder" ).hide();
							$("#barschedule").css("color","#FFFFFF");
							$( "<li></li>" ).html( ui.draggable.html() + "<select name='time[]'><option value=''></option><option value='19:00'>7:00pm</option><option value='20:00'>8:00pm</option><option value='21:00'>9:00pm</option><option value='22:00'>10:00pm</option><option value='23:00'>11:00pm</option><option value='0:00'>12:00am</option><option value='1:00'>1:00am</option></select>" ).appendTo( this );
						}
					}).sortable({
						items: "li:not(.placeholder)",
						sort: function() {
							// gets added unintentionally by droppable interacting with sortable
							// using connectWithSortable fixes this, but doesn't allow you to customize active/hoverClass options
							$( this ).removeClass( "ui-state-default" );
						}
					});
					$( "#bartrash ul" ).droppable({
						over: function(event, ui) {
							$("#bartrash").css("color","#FF8D00");
						},
						out: function(event, ui) {
							$("#bartrash").css("color","#FFFFFF");
						},
						drop: function( event, ui ) {
							$("#bartrash").css("color","#FFFFFF");
							ui.draggable.remove();
							if ($("#barschedule ul").text().length == 25) {
								$('.placeholder').show();
							}
						}
			
					});

					});
				});
				
			});
		
		});
		
	});
</script>

<title>CampusCrawler</title>
</head>
	<body>
 		<div class="header">
			<div class="logout">
			</div>
    	</div>
		<div class="board">
			<div class="boardcontent">
			
			<div class="progress">
			<h2><b class="current">Event Details</b> &raquo; Select Friends &raquo; Select Bars</h2>
			</div>
			<div id="fb-root"></div>
				
				<script src="http://connect.facebook.net/en_US/all.js"></script>

				<form id="detailsForm">
				Title: <input type="text" name="title" /><br></br>
				Date: <input type="text" name="date" /><br></br>
				Description:<br/> <textarea rows="10" cols="50" name="description"></textarea><br></br>
				Privacy: <select name = "privacy">
						<option value = "open">Open</option>
						<option value = "closed">Closed</option>
						<option value = "private">Private</option>
						</select>
				<br/>
				
				</form>
				
				<div id="select-div">
				<button id="next">Next</button>
				</div>
			
			</div>
		
		</div>
		
	</body>
</html>