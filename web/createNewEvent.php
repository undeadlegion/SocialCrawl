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

<?php

$title = $_GET['title']
$friendString = $_GET['friends'];

echo $friendString;

?>

			</div>
		
		</div>
		
	</body>
</html>