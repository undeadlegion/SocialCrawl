<?php

include_once('FacebookInteraction/FacebookInteraction.php');
include_once('DatabaseInteraction/DatabaseInteraction.php');
include_once('Event.php');


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

$auth = new FacebookAuthentication();
$cookie = $auth->getFacebookCookie(FACEBOOK_APP_ID, FACEBOOK_SECRET);
$creatorID = $auth->getUserID();
 
$event = new Event();
$id = $event->createEvent($creatorID, $date, $title, $description, $picture, $privacy, $bars, $friends);

print $id;
?>