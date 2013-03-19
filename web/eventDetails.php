<?php session_start(); /// Start the session so we can use session variables. ?>  

<?php

ini_set('max_execution_time', 300);
define('FACEBOOK_APP_ID', '183973304975501');
define('FACEBOOK_SECRET', 'b3919b8c363f2c13faa09d0ece9e4497');

include_once("FacebookInteraction/FacebookInteraction.php");
include_once("DatabaseInteraction/DatabaseInteraction.php");

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
 		$result = mysql_query("SELECT * FROM events WHERE id=$evalue");
 		if(!$result)
 			print "I am sorry that is not valid request";
 		else { 
			$event = $data->getEventDetail($evalue);
			$creatorID = $event->creatorid;
			$creatorName = $user->getUserNameFromID($creatorID);
			$currentUser = $data->getCurrentUserID();
			$HTMLvar = "";
			if($currentUser==$creatorID){
				$HTMLvar = "<div class='allCrawl'><a href='http://groovegene.com/cs428/editEvent.php?e=".$evalue."'><img src='images/EditCrawlButton.png'></a></div>";
			}
			$HTMLvar = $HTMLvar."<div class='allCrawl'><a href='http://groovegene.com/cs428/index.php'><img src='images/AllCrawlButton.png'></a></div>";
			$HTMLvar = $HTMLvar."<img src='images/".$event->picture."'>";
			$HTMLvar = $HTMLvar."<h2>$event->title</h2>";
			$HTMLvar = $HTMLvar."<c1>Creator: $creatorName</c1><br>";
			$HTMLvar = $HTMLvar."<d1>Date: $event->date</d1><br>";
			$HTMLvar = $HTMLvar."<d2>Description: $event->description</d2><br>";  
			print $HTMLvar;
 		}
 		
 		$this->showComments($evalue);
	?>
    
   <?php } else { ?>
   		<meta http-equiv="REFRESH" content="0;url=http://www.groovegene.com/cs428/index.php">
   <?php } ?>
   
   <br/><br/><br/>

   
   



	<div id="fb-root"></div>
 </body>
</html>

	<?php
	/**
	 * Shows the comments in the database
	 */
	function showComments($fbUserID){?> 
		<div class = "newCommentForm">
			<?php 
				echo "<div id='comment_form_pic'>";
					$profilePic = "../DataAccessLibrary/facebookPhoto.php?friendid=" . $fbUserID; 
					echo "<img src ='" . $profilePic . "'></img>";
				echo "</div>";
			?>
			<div id = 'comment_form_body'>
				<textarea class = "commentForm" name = "commentForm" id = "commentForm" onkeyup="checkComment()" onblur= "checkComment()"></textarea><br/>
			</div>
			<div id = 'submit_button'>
				<!-- SUBMIT BUTTON -->
				<input class="button ui-state-default ui-corner-all" type="button" id="commentButton" value="Submit" disabled = "disabled"></input><br/>
			</div>
			</form>
		</div>
	
		<div id = 'comments_container'>
	
		<?php 
			$fbUserInfoHandle = new FacebookUser();
			$allComments = $data->getComments($evalue);
			$commentsHTML;
			// Go through the comments printing them out in HTML
			// TODO: INSERT IN THE CHRONOLOGICAL ORDER
			// TODO: ADD DELETE BUTTON FOR OWNER
			// TODO: ID'S SHOULD BE COMMENT ID FOR REMOVAL
			
			$commentsHTML .= "<table id = 'comments_table'>";
			for($a = 0 ; $a < count($allComments) ; $a++){
				$commentsHTML .= "<tr class = 'comments_table_row'><td class = 'comments_table_cell_picture'>";
				$facebookID = $allComments[$a]->UserID;
				$url = "https://graph.facebook.com/" . $facebookID;
				$user = $fbUserInfoHandle->getUserObject($facebookID);

				
				$commentsHTML = $commentsHTML .
				 "" .
				 "  <div class = 'profilePic'>".
				 "		<img src='../images/testImage.png'/></div>". "</td><td class= 'comments_table_cell_body'><div class='comment'>" .
				 "		<a target='_blank' class = 'comment_name_link' href = 'http://www.facebook.com/profile.php?id=" . $user->id . "'>" . $user->name . "</a>".
				 		"<div class = 'comment_body'>" . $allComments[$a]->commentText. "</div>" .
				 "	</div>".
				 "";
				$commentsHTML .= "</td></tr>";
				
			}
			$commentsHTML .= "</table>";
			?><script> $('#loading').remove(); </script><?php 
			echo $commentsHTML;
		?>
		</div>
		<?php
	} ?>
