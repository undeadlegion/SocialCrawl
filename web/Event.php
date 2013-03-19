<?php

include_once('FacebookInteraction/FacebookInteraction.php');
include_once('DatabaseInteraction/DatabaseInteraction.php');

class Event {
	
    public $id;
    public $creatorid;
    public $date;
    public $title;
    public $description;
    public $picture;
    public $privacy;
	
	/**
	 * getStartTime
	 * 
	 * @param 	bar array		$bars				This is an array of all the bars and times that the bar crawl is attending
	 * @return 	start_time		$$barArray[0][1]	This is the starttime for the first bar	
	 */
	function getStartTime($bars){
		//first element in bar array
		return $bars[0][1];
	}
	
	function createEvent($creatorID, $date, $title, $description, $picture, $privacy, $bars, $friends){
		$start_time = $this->getStartTime($bars);
		
		$unixDateTime = $this->createDateTime($start_time,$date);
		print "Start Time: $start_time  Date: $date Unixtime: $unixDateTime<br>";
		
		$location = $this->getStartBar($bars);
		
		$event = new FacebookEvents();
		$id = $event->newUserCreatedEvent($title, $description, $unixDateTime, $final_time, $location, $privacy, $creatorID);
		//ADD to database
		$db = new DatabaseInteraction();
		$db->createNewEvent($id, $creatorID, $date, $title, $description, $picture, $privacy);
		print ("Something from Facebook: $id");
		return $id;
	}
	
	/**
	 * createDateTime
	 * 
	 * @param SQL Time	 $start_time
	 * @param SQL Date 	 $date
	 */
	function createDateTime($start_time, $date){
		$dateTime = $date.' '.$start_time;
		$unixtime = $this->convert_datetime($dateTime);
		return $unixtime;
	}
	
	
	function getStartBar($bars){
		return $bars[0][0];
	}
	
	
	/**
	 * Converts a SQL style datetime string to a unix timestamp
	 * 
	 * @param  string $SQLDateTime 	SQLDateTime string to convert to unix timestamp
	 * @return int	  				Unix timestamp
	 * 
	 * *****This function was created by Jared Lambert during his work on SocialCal*****
	 */
	function convert_datetime($SQLDateTime) { 
	
	    list($date, $time) = explode(' ', $SQLDateTime); 
	    list($year, $month, $day) = explode('-', $date); 
	    list($hour, $minute, $second) = explode(':', $time); 
	     
	    $timestamp = mktime((int)($hour+3), (int)$minute, (int)$second, (int)$month, (int)$day, (int)$year); 
	     
	    return $timestamp; 
	}
	
	/**
	 * This function will change the name of the crawl in the database and on Facebook
	 *
	 * @param int 		$eventID
	 * @param string	$newTitle
	 */
	function editEventTitle($eventID,$newTitle){
		$data = new DatabaseInteraction();
		$event = new FacebookEvents();
		$data->editEventNameDB($eventID,$newTitle);
		$event->changeEventName($eventID,$newTitle);
	}
	
	function editEventDescription($eventID,$newDescription){
		$data = new DatabaseInteraction();
		$event = new FacebookEvents();
		$data->editEventDescriptionDB($eventID,$newDescription);
		$event->changeEventDescription($eventID,$newDescription);
	}
	
	function editEventDate($eventID,$newDate){
		$data = new DatabaseInteraction();
		$event = new FacebookEvents();
		$data->editEventDateDB($eventID,$newDate);
		
		//Convert for Facebook
		$data = new FacebookData();
		$details = $data->getEventInfo($eventID);
		$eventObject = $event->newEventObject($details);
		$oldUnix = $this->convert_datetime($eventObject->start_time);
		$secondsExtra = $oldUnix % 86400;
		$newUnix = $this->convert_datetime($newDate);
		print "The old time is $oldUnix, new time is $newUnix, diff is $secondsExtra";
		$event->changeEventStartTime($eventID,$newUnix+$secondsExtra);
		
	}	
	
}

?>
