<?php session_start(); /// Start the session so we can use session variables. ?>  

<?php

ini_set('max_execution_time', 300);
define('FACEBOOK_APP_ID', '183973304975501');
define('FACEBOOK_SECRET', 'b3919b8c363f2c13faa09d0ece9e4497');

include_once("FacebookInteraction/FacebookInteraction.php");
include_once("DatabaseInteraction/DatabaseInteraction.php");

$data = new DatabaseInteraction();
$authenticate = new FacebookAuthentication();
$cookie = $authenticate->getFacebookCookie(FACEBOOK_APP_ID, FACEBOOK_SECRET);

$user = new FacebookUser();

?>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<style type="text/css">@import "style.css";</style>
<title>Campus Crawler</title>
</head>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml"
     xmlns:fb="http://www.facebook.com/2008/fbml">
 <body>

 	
 	<?php 
	if ($cookie) {
  		print "Welcome!" ;
   		
	?>
    <div class="newCrawl"><a href="http://groovegene.com/cs428/eventForm.php"><img src="images/NewCrawlButton.png"></a></div>
   <?php } else { ?>
   		Please login to Facebook, and grant us access: <fb:login-button perms="create_event,rsvp_event,user_events,friends_events"></fb:login-button>
   <?php } ?>
   
   <br/><br/><br/>
   <?php 
   print "EVENTS YOU ARE INVITED TO:\n";
   
   $HTMLvar = "";
      
   $userEvents = $data->getEventDataForUser();
   for($outer = 0; $outer < count($userEvents);$outer++){
   		$outerLevel = $userEvents[$outer];
   		$creatorName = $user->getUserNameFromID($outerLevel[1]);
   			$HTMLvar = $HTMLvar."<h2>$outerLevel[3]</h2>";
   			$HTMLvar = $HTMLvar."Creator: $creatorName<br>";
   			$HTMLvar = $HTMLvar."Date: $outerLevel[2]<br>";
   			$HTMLvar = $HTMLvar."Description: $outerLevel[4]<br>";
   			$HTMLvar = $HTMLvar."<a href='eventDetails.php?e=".$outerLevel[0]."'>Details</a><br>";
   			$HTMLvar = $HTMLvar."<img src='images/thinLn.png'<br><br><br>";
   			
   			
   		
   }
   print "$HTMLvar \n";
   
   print "EVENTS YOU CREATED\n";
      $HTMLvar = "";
      
   $userEvents = $data->getEventsDataCreatedByUser();
   for($outer = 0; $outer < count($userEvents);$outer++){
   		$outerLevel = $userEvents[$outer];
   		$creatorName = $user->getUserNameFromID($outerLevel[1]);
   			$HTMLvar = $HTMLvar."<h2>$outerLevel[3]</h2>";
   			$HTMLvar = $HTMLvar."Creator: $creatorName<br>";
   			$HTMLvar = $HTMLvar."Date: $outerLevel[2]<br>";
   			$HTMLvar = $HTMLvar."Description: $outerLevel[4]<br>";
   			$HTMLvar = $HTMLvar."<a href='eventDetails.php?e=".$outerLevel[0]."'>Details</a><br>";
   			$HTMLvar = $HTMLvar."<img src='images/thinLn.png'<br><br><br>";
   }
    print "$HTMLvar \n";
   ?>
   
   



	<div id="fb-root"></div>
 </body>
</html>