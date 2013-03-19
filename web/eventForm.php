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
				<form action="eventcreate.php" method="post"><br></br>
				Title: <input type="text" name="title" /><br></br>
				Date: <input type="text" name="date" /><br></br>
				Description: <textarea rows="10" cols="50" name="description"></textarea><br></br>
				Privacy: <select name = "privacy">
						<option value = "open">Open</option>
						<option value = "closed">Closed</option>
						<option value = "private">Private</option>
						</select>
				<br/>
				Bars - Times:<br/>		
				<?php 
					$form->printBarsTimesSelectors();
				?>		
				<input type="submit" />
				</form>
   
			</div>
		</div>
	</body>
</html>