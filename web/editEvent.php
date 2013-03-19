<?php session_start(); /// Start the session so we can use session variables. ?>  

<?php

ini_set('max_execution_time', 300);
define('FACEBOOK_APP_ID', '183973304975501');
define('FACEBOOK_SECRET', 'b3919b8c363f2c13faa09d0ece9e4497');

include_once("FacebookInteraction/FacebookInteraction.php");
include_once("DatabaseInteraction/DatabaseInteraction.php");
include_once("Event.php");

$authenticate = new FacebookAuthentication();
$cookie = $authenticate->getFacebookCookie(FACEBOOK_APP_ID, FACEBOOK_SECRET);
$data = new DatabaseInteraction();
$user = new FacebookUser();
$evalue = $_GET['e'];
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


	<div class="header">
        <div class="logout"></div>
       
 	
    </div>
 	<div class="board">
 	
 	<div class="boardcontent"> 
 	<?php 
 	if ($cookie) {
 		$result = mysql_query("SELECT * FROM events WHERE id=$evalue AND creatorid=$cookie['uid']");
 		if(!$result)
 			print "I am sorry that is not valid request";
 		else { 

 			?>
 			
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
 			
 			<?php 
 			
 		$title = $_POST['title'];
		$date = $_POST['date'];
		$description = $_POST['description'].": ";
		
		$privacy = $_POST['privacy'];
		for ($i = 0; $i < 5; $i++) {
			$bars[$i][0] = $_POST['bar'.($i+1)];
			$bars[$i][1] = $_POST['bar'.($i+1).'start'];
			$description = $description.$bars[$i][0].' '.$bars[$i][1];
			if(i<4){
				$description = $description.", ";
			} else {
				$description = $description.".";
			}
		}
 			
 			$event = $data->getEventDetail($evalue);
			$creatorID = $event->creatorid;
			$creatorName = $user->getUserNameFromID($creatorID);
			$currentUser = $data->getCurrentUserID();
			
			if($currentUser==$creatorID){
				$event = new Event();
				$event->editEventDate($evalue,"2011-04-08");
				$fbEvent = new FacebookEvents();
				$val = $fbEvent->changeEventDescription($evalue,"Test");
				print $val;
			}
 		}
	?>
    
   <?php } else { ?>
   		<meta http-equiv="REFRESH" content="0;url=http://www.groovegene.com/cs428/index.php">
   <?php } ?>
   
   <br/><br/><br/>

   
   



	<div id="fb-root"></div>
 </body>
</html>