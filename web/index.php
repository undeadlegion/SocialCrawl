<?php session_start(); /// Start the session so we can use session variables. ?>  

<?php

ini_set('max_execution_time', 300);
define('FACEBOOK_APP_ID', '183973304975501');
define('FACEBOOK_SECRET', 'b3919b8c363f2c13faa09d0ece9e4497');

include_once("FacebookInteraction/FacebookInteraction.php");
include_once("DatabaseInteraction/DatabaseInteraction.php");

$authenticate = new FacebookAuthentication();
$cookie = $authenticate->getFacebookCookie(FACEBOOK_APP_ID, FACEBOOK_SECRET);

$user = new FacebookUser();

?>


<LINK REL=StyleSheet HREF="./css/index.css" TYPE="text/css" MEDIA=screen>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
 <script type="text/javascript" src="js/jquery-1.4.4.min.js"></script>
<title>CampusCrawler</title>
</head>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml"
      xmlns:fb="http://www.facebook.com/2008/fbml">
   <body onload="setHeight();">
 
 	<div class="header">
        <div class="logout"></div>
       
 	
    </div>
 	<div class="board">
 	
 	<div class="boardcontent"> 
   
    <?php if ($cookie) { ?>
		<?php include 'mainPage.php';?>
    <?php } else { ?>
    <div id="mainBox">
    	<div id="loginButton">
    	  <fb:login-button perms="create_event,
    	  							rsvp_event,
    	  							user_events,
    	  							friends_events"></fb:login-button>
    	</div>
    </div>	
    <?php } ?>


    <div id="fb-root"></div>
    <script src="http://connect.facebook.net/en_US/all.js"></script>
    <script>
      FB.init({appId: '<?=FACEBOOK_APP_ID?>', status: true, cookie: true, xfbml: true});
      FB.Event.subscribe('auth.sessionChange', function(response) {
        if (response.session) {
          // A user has logged in, and a new cookie has been saved
          	var CampusCrawler = 'index.php';
            location.href = CampusCrawler;
        } else {
          // The user has logged out, and the cookie has been cleared
        }
      });
    </script>
  </body>
</html>