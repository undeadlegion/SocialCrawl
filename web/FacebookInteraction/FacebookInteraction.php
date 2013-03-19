<?php 
define('FACEBOOK_APP_ID', '183973304975501');
define('FACEBOOK_SECRET', 'b3919b8c363f2c13faa09d0ece9e4497');


/**
 * FacebookAuthenication Class
 * 
 * This class takes care of all authentication 
 * from with Facebook.
 * 
 * @author Dan
 *
 */
class FacebookAuthentication
{	
	private  $currentToken;
	private  $id;
	
	/**
	 * getFacebookCookies
	 * 
	 * This function takes in the app_id and app_secret
	 * and returns a cookie.  The cookied contains the
	 * access token for the user.
	 * 
	 * @param 	string		$app_id					Defined from Facebook, specified above
	 * @param 	string		$application_secret		Defined from Facebook, specified above
	 */
	function getFacebookCookie($app_id, $application_secret) {
		$args = array();
		parse_str(trim($_COOKIE['fbs_' . $app_id], '\\"'), $args);
		ksort($args);
		$payload = '';
		foreach ($args as $key => $value) {
			if ($key != 'sig') {
				$payload .= $key . '=' . $value;
			}
		}
		if (md5($payload . $application_secret) != $args['sig']) {
		    return null;
		}
		
		global $currentToken;
		$currentToken = $args['access_token'];
		global $id;
		$id = $args['uid'];
		  
		return $args;
	}
	
	/**
	 * setUserID
	 * 
	 * This function take in a users ID from Facebook 
	 * authentication and set it to the local variable
	 * 
	 * @param	int 	$UserIDFromFacebook		ID of the user the global variable will be set to
	 */
	function setUserID($UserIDFromFacebook){
		global $id;
		$id = $UserIDFromFacebook;	
	}
	
	/**
	 * getUserID
	 * 
	 * This function will return the user ID of the
	 * current user
	 * 
	 * @return int 	$UserIDFromFacebook		ID of the user the global variable will be set to
	 */
	function getUserID(){
		global $id;	
		return $id;
	}
	
	/**
	 * setUserToken
	 * 
	 * This funciton will take in the users current token
	 * and set it to the local variable 
	 *
	 * @param 	string 	$UserTokenFromFacebook		This is the current token for the authenticated user
	 */
	function setUserToken($UserTokenFromFacebook){
		global $currentToken;
		$currentToken = $UserTokenFromFacebook;
	}
	
	/**
	 * getUserToken
	 * 
	 * This function will return the current user token
	 * for the current user.
	 * 
	 * @return 	string 	$currentToken		This is the current token for the authenticated user
	 */
	function getUserToken(){
		global $currentToken;
		return $currentToken;
	}
}





/**
 * FacebookData Class
 * 
 * This class contains functions that pull live data from 
 * Facebook.  Every time the you want information it will
 * make a call to Facebook so that it is always the most
 * up-to-date version of the data.
 * 
 * @author Dan
 * ******************NOTE*****************
 * The access token must be changed to 
 * ?access_token='.$cookie['access_token']
 * when the application is placed on website
 * ***************************************
 */	
class FacebookData
{	
	/**
	 * getUserJSONArray
	 * 
	 * This function will return the user JSONArray for
	 * a specific user id
	 * 
	 * @param int $id
	 * @return JSONArray user information
	 */
	function getUserJSONArray($id){
		$authentication = new FacebookAuthentication();
		$currentToken = $authentication->getUserToken();
		$user = json_decode(file_get_contents('https://graph.facebook.com/'.$id.'?access_token='.$currentToken));
		return $user;
	}
	
	/**
	 * getAllJSONArray
	 * 
	 * This function will return all Events JSON file for 
	 * a specific id
	 * 
	 * @param int $id
	 * @param String $currentToken
	 * @return JSONArray events all
	 */
	function getAllJSONArray($id){
		$authentication = new FacebookAuthentication();
		$currentToken = $authentication->getUserToken();
		$eventsAll = json_decode(file_get_contents('https://graph.facebook.com/'.$id.'/events/?access_token='.$currentToken));
		return $eventsAll;
	}
	
	/**
	 * getAttendingJSONArray
	 * 
	 * This functio will return the Attending Events JSON file for 
	 * a specific id
	 * 
	 * @param int $id
	 * @param String $currentToken
	 * @return JSONArray events attending
	 */
	function getAttendingJSONArray($id){
		$authentication = new FacebookAuthentication();
		$currentToken = $authentication->getUserToken();
		$eventsAttending = json_decode(file_get_contents('https://graph.facebook.com/'.$id.'/events/attending/?access_token='.$currentToken));
		return $eventsAttending;
	}
	
	
	/**
	 * getMaybeJSONArray
	 * 
	 * This function will return the maybe events JSONArray file
	 * for a specific user id
	 * 
	 * Enter description here ...
	 * @param int $id
	 * @return JSONArray events maybe attending
	 */
	function getMaybeJSONArray($id){
		$authentication = new FacebookAuthentication();
		$currentToken = $authentication->getUserToken();
		$eventsMaybe = json_decode(file_get_contents('https://graph.facebook.com/'.$id.'/events/maybe/?access_token='.$currentToken));
		return $eventsMaybe;
	}
	
	
	/**
	 * getDeclindedJSONArray
	 * 
	 * This function will return the Declined Events JSONArray for
	 * a specific user id
	 * 
	 * @param int $id
	 * @return JSONarray events declined
	 */
	function getDeclinedJSONArray($id){
		$authentication = new FacebookAuthentication();
		$currentToken = $authentication->getUserToken();
		$eventsDeclined = json_decode(file_get_contents('https://graph.facebook.com/'.$id.'/events/declined/?access_token='.$currentToken));
		return $eventsDeclined;
	}
	
	
	/**
	 * getNotRepliedJSONArray
	 * 
	 * This function will return the Not Replied Events JSONArray for a
	 * specific id
	 * 
	 * @param int $id
	 * @return JSONarray events not replied to
	 */
	function getNotRepliedJSONArray($id){
		$authentication = new FacebookAuthentication();
		$currentToken = $authentication->getUserToken();
		$eventsNot_replied = json_decode(file_get_contents('https://graph.facebook.com/'.$id.'/events/not_replied/?access_token='.$currentToken));
		return $eventsNot_replied;
	}
	
	/**
	 * getEventInfo
	 * 
	 * This function will return the Not Replied Events JSONArray for a
	 * specific id
	 * 
	 * @param 	int $id
	 * @return 	JSONarray $detailedEvent	This will contain detailed information about the event
	 */
	function getEventInfo($eventID){
		$authentication = new FacebookAuthentication();
		$currentToken = $authentication->getUserToken();
		$detailedEvent = json_decode(file_get_contents('https://graph.facebook.com/'.$eventID.'?access_token='.$currentToken));
		return $detailedEvent;
	}

	
	/**
	 * getEventFeed
	 * 
	 * @param	int		$eventID	This is the Facebook ID for the event
	 * @param	int		$page		There are 25 comments per page. Start
	 * 								out with page 0.  If the user would like more
	 * 								call page 1, then page 2 and so on. If first
	 * 								cell of array returned is null do not call again
	 * 								because all have been displayed.
	 */
	function getEventFeed($eventID,$pageNumber, $ttl = 86400){
		$authentication = new FacebookAuthentication();
		$currentToken = $authentication->getUserToken();
		$eventFeed = json_decode(file_get_contents('https://graph.facebook.com/'.$eventID.'/feed?access_token='.$currentToken,$ttl));
		return $eventFeed;
	}
	
	/**
	 * getUserFriends
	 * 
	 * Returns a JSON array of a Facebook users friends
	 * 
	 * @param int	 $userID	This is the unique Facebook user ID
	 */
	function getUserFriends($userID){
		$authentication = new FacebookAuthentication();
		$currentToken = $authentication->getUserToken();
		$userFriends = json_decode(file_get_contents('https://graph.facebook.com/'.$userID.'/friends?access_token='.$currentToken));
		return $userFriends;
	}
	
	/**
	 * Converts a SQL style datetime string to a unix timestamp
	 * 
	 * @param  string $SQLDateTime 	SQLDateTime string to convert to unix timestamp
	 * @return int	  				Unix timestamp
	 */
	function convert_datetime($SQLDateTime) { 
	
	    list($date, $time) = explode(' ', $SQLDateTime); 
	    list($year, $month, $day) = explode('-', $date); 
	    list($hour, $minute, $second) = explode(':', $time); 
	     
	    $timestamp = mktime((int)$hour, (int)$minute, (int)$second, (int)$month, (int)$day, (int)$year); 
	     
	    return $timestamp; 
	}
}




/**
 * FBEvent
 *
 * This is the FBEvent class.  The elements of the FBEvent
 * class correspond directly to the different parameters
 * that are accessible for a Facebook event.  
 * @author Dan
 * 
 * string	$name			Name of the Event
 * int		$start_time		Event start_time formatted in UNIX time
 * int		$end_time		Event end_time formatted in UNIX time (not needed for creation of event)
 * string	$location		Event location
 * coord	$latitude		Latidude coordinates of Event (not needed for creation of event)
 * coord	$longitude		Longitude coordinates of Event (not needed for creation of event)
 * int		$id				Unique event ID (not needed for creation of event)
 * string	$rsvp_status	Event attendance status attending, maybe, unsure
 * string	$ownerID		This is the Facebook ID of the creater.  ("Not Set" until getEventOwner($eventID) is called)
 * string	$description	Description of the event	("Not Set" until getEventOwner($eventID) is called)
 */
class FBEvent
{
    public $name;
  	public $start_time;
	public $end_time;
	public $location;
	public $latitude;
	public $longitude;
	public $id;
	public $rsvp_status;
	public $ownerID;
	public $description;
}

/**
 * Comment
 * 
 * This class is used for the gathering of comments.
 * Every comment has a post 
 * 
 * int							$posterID			This is the ID of the person that created the post
 * string 						$message			This is the message that the poster left
 * SQL Date Time				$postTime			This is the time that the post was created
 * Boolean						$subComment			This will be true if ther are subcomment and false if there are not
 * Array of SubComment Objects	$ArrayOfSubComments	This is an array of subcomments which were made on a comment
 * @author Dan
 *
 */
class Comment
{
	public $posterID;
	public $message;
	public $postTime;
	public $subCommentsExist;
	public $arrayOfSubComments;
}


/**
 * SubComment
 * 
 * Comments may have comments made on them as well. 
 * The difference is that SubComments may not have additional
 * subcomment. Therefor they do not contain an array of comments
 * 
 * int				$posterID	This is the ID of the person that created the post
 * string 			$message	This is the message that the poster left
 * SQL Date Time	$postTime	This is the time that the post was created
 * @author Dan
 *
 */
class SubComment
{
	public $posterID;
	public $message;
	public $postTime; 
}


/**
 * FacebookEvents Class
 * 
 * This class contains all of funcitons that create, edit, or pull
 * information from Facebook regarding an event
 * 
 * @author Dan Kaufman
 */
class FacebookEvents{

	
//	function getEventObjectFromEventID($eventID){
//		$data = new FacebookData();
//		$data->getEventInfo($eventID);
//	}
	
	/**
	 * getUserEventsAllFromID
	 * 
	 * This will return the array of event objects that the user is
	 * attending.
	 * 
	 * @param	int			$userID					ID of the user that attending events are desired
	 * @return  eventArray 	$allEventsArray	Array of FBEvent objects
	 */
	function getUserEventsAllFromID($userID){		
		$data = new FacebookData();
		$event = new FacebookEvents();
		
		$eventsAllArray = $data->getAllJSONArray($userID);
		$allEventsArray = $event->createEventsArrayFromJSON($eventsAllArray);
		
		return $allEventsArray;
	}
	
	/**
	 * getUserEventsAttendingFromID
	 * 
	 * This will return the array of event objects that the user is
	 * attending.
	 * 
	 * @param	int			$userID					ID of the user that attending events are desired
	 * @return  eventArray 	$attendingEventsArray	Array of FBEvent objects
	 */
	function getUserEventsAttendingFromID($userID){		
		$data = new FacebookData();
		$event = new FacebookEvents();
		
		$eventsAttendingArray = $data->getAttendingJSONArray($userID);
		$attendingEventsArray = $event->createEventsArrayFromJSON($eventsAttendingArray);
		
		return $attendingEventsArray;
	}
	
	/**
	 * getUserEventsMaybeFromID
	 * 
	 * This will return the array of event objects that the user is
	 * maybe attending.
	 * 
	 * @param	int			$userID				ID of the user that maybe attending events are desired
	 * @return  eventArray 	$maybeEventsArray	Array of FBEvent objects
	 */
	function getUserEventsMaybeFromID($userID){
		$data = new FacebookData();
		$event = new FacebookEvents();
		$eventsMaybeArray = $data->getMaybeJSONArray($userID);
		$maybeEventsArray = $event->createEventsArrayFromJSON($eventsMaybeArray);
		
		return $maybeEventsArray;
	}

	/**
	 * getUserEventsDeclinedFromID
	 * 
	 * This will return the array of event objects that the user has
	 * declined.
	 * 
	 * @param	int			$userID					ID of the user that maybe declined events are desired
	 * @return  eventArray 	$declinedEventsArray	Array of FBEvent objects
	 */
	function getUserEventsDeclinedFromID($userID){
		$data = new FacebookData();
		$event = new FacebookEvents();
		$eventsDeclinedArray = $data->getDeclinedJSONArray($userID);
		$declinedEventsArray = $event->createEventsArrayFromJSON($eventsDeclinedArray);
		
		return $declinedEventsArray;
	}
	
	/**
	 * getUserEventsNotRepliedFromID
	 * 
	 * This will return the array of event objects that the user has
	 * not replied to.
	 * 
	 * @param	int			$userID					ID of the user that maybe not replied events are desired
	 * @return  eventArray 	$notRepliedEventsArray	Array of FBEvent objects
	 */
	function getUserEventsNotRepliedFromID($userID){
		$data = new FacebookData();
		$event = new FacebookEvents();
		$eventsNotRepliedArray = $data->getNotRepliedJSONArray($userID);
		$notRepliedEventsArray = $event->createEventsArrayFromJSON($eventsNotRepliedArray);
		
		return $notRepliedEventsArray;
	}
		
	
	/**
	 * getEventsUserTime
	 *
	 * This function will return the events for a specific
	 * user for a given time window
	 * 
	 *
	 * @param 	int								$id					ID of the user that you would like to return the events
	 * @param 	UNIXDateTime or SQL Date Time	$start_time			Start time of the window that events are pulled from
	 * @param 	UNIXDateTime or SQL Date Time	$end_time			End time of the window that events are pulled from
	 * @return	eventArray						$eventsBetweenTime	Array of FBEvent objects for a given time window
	 */
	function getEventsUserTime($userID, $start_time, $end_time){
		
		$authenticate = new FacebookAuthentication();
		$event = new FacebookEvents();

		$cookie = $authenticate->getFacebookCookie(FACEBOOK_APP_ID, FACEBOOK_SECRET);
		$eventsBetweenTime = array();

		$eventArray = $event->getUserEventsAllFromID($userID);		
		$eventsBetweenTime = $event->buildArray($eventsBetweenTime, $eventArray,$start_time, $end_time);	
		$eventNotRepliedArray = $event->getUserEventsNotRepliedFromID($userID);	
		$eventsBetweenTime = $event->buildArray($eventsBetweenTime, $eventNotRepliedArray,$start_time, $end_time);
		
       return $eventsBetweenTime;
	}
	
	/**
	 * buildArray
	 * 
	 * This function will create an array of all events
	 * between specific times. Helper for getEventsUserTime
	 * 

	 * @param	eventArray	 					$arrayOfEvents		Array of all FBevent Objects
	 * @param 	UNIXDateTime or SQL Date Time	$start_time			Start time of the window that events are pulled from
	 * @param 	UNIXDateTime or SQL Date Time	$end_time			End time of the window that events are pulled from
	 * @return	eventArray						$eventsBetweenTime	Array of FBEvent objects for a given time window
	 */
	function buildArray($eventsBetweenTime, $arrayOfEvents,$start_time, $end_time){
		$event = new FacebookEvents();
		
		$currentIndex = sizeof($eventsBetweenTime);
		$sizeOfEventArray = sizeof($arrayOfEvents);
		
		for($countUP = 0;$countUP<$sizeOfEventArray;$countUP++){
			$boolean = $event->checkTime($arrayOfEvents[$countUP],$start_time,$end_time);
			if($boolean){
				$eventsBetweenTime[$currentIndex]=$arrayOfEvents[$countUP];
				$currentIndex++;
			}			
		}
		
		return $eventsBetweenTime;
	}
	
	/**
	 * checkTime
	 * 
	 * This function will compare the time of an event
	 * to see if it is between the start_time and end_time. 
	 * 
	 * @param	FBEvent 						$eventObject	FBevent object that time will be checked				
	 * @param 	UNIXDateTime or SQL Date Time	$start_time		Start time of the window that events are pulled from
	 * @param 	UNIXDateTime or SQL Date Time	$end_time		End time of the window that events are pulled from
	 */
	function checkTime($eventObject,$start_time, $end_time){
		$dataAccess = new FacebookData();
		$eventStartTime = $eventObject->start_time;
		if(strpos($eventStartTime, "T") || strpos($eventStartTime, " ")){
			$strClean = str_replace("T", " ", $eventStartTime);
			$unixStart = $dataAccess->convert_datetime($strClean);
		} else {
			$unixStart = $eventStartTime;
		}
		
		if($start_time <= $unixStart && $unixStart <= $end_time){	
			return true;
		}else{
			return false;
		}
	}
	
	/**
	 * newEvent
	 * 
	 * This function will create a new event on Facebook
	 * 
	 * @param	string 			$name			Name of the Event
	 * @param	string			$description	Description of the event
	 * @param	UNIX DateTime	$start_time		Event start_time formatted in UNIX time
	 * @param	UNIX DateTime	$final_time		Event end_time formatted in UNIX time (not needed for creation of event)
	 * @param	string 			$location		Event location
	 * @param	string 			$privacy		"OPEN" | "CLOSED" | "SECRET"
	 * @param	string 			$id				Unique user ID	
	 * 
 	 * @return	int		 		$eventID		This is the eventID for the project
 	 * 
	 */
	function newUserCreatedEvent($name,$description,$start_time,$final_time,$location,$privacy,$id){		
		$authentication = new FacebookAuthentication();
		$currentToken = $authentication->getUserToken();		
		$ch = curl_init();		
		curl_setopt($ch, CURLOPT_URL, 'https://graph.facebook.com/'.$id.'/events/?access_token='.$currentToken);
		curl_setopt($ch, CURLOPT_POSTFIELDS, 'name='.$name.'&description='.$description.'&start_time='.$start_time.'&final_time='.$final_time.'&location='.$location.'&privacy_type='.$privacy); 
		curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
		$eventID = json_decode(curl_exec($ch))->id;
		curl_close($ch);
		return $eventID;
	}

	
	/**
	 * inviteGuests
	 * 
	 * This function will invite guests to an event that was created.  This
	 * may only be called on an event that was created by the person calling
	 * the function.
	 *
	 * @param	int			$eventID			ID of the event that guests will be invited to 
	 * @param 	int array	$arrayOfUserIds		Array of user IDs to invite to the event
	 */
	function inviteGuests($eventID,$arrayOfUserIds){
		$authentication = new FacebookAuthentication();
		$currentToken = $authentication->getUserToken();		
		
		for($countUP=0;$countUP<sizeof($arrayOfUserIds);$countUP++){
			$ch = curl_init();
			curl_setopt($ch, CURLOPT_URL, 'https://api.facebook.com/method/events.invite?eid='.$eventID.'&uids='.$arrayOfUserIds[$countUP].'&access_token='.$currentToken);
			curl_exec($ch);
			curl_close($ch);
		}
	}
	
	
	/**
	 * changeEventName 
	 * 
	 * This function will change the name of the event
	 * 
	 * @param	int			$eventID			ID of the event that guests will be invited to 
	 * @param	string 		$newName			New name of the event
	 * @return	boolean		$changed			True for changed, false for not changed
	 */
	function changeEventName($eventID,$newName){
		$authentication = new FacebookAuthentication();
		$currentToken = $authentication->getUserToken();		
		$ch = curl_init();		
		curl_setopt($ch, CURLOPT_URL, 'https://graph.facebook.com/'.$eventID.'/?access_token='.$currentToken);
		curl_setopt($ch, CURLOPT_POSTFIELDS, 'name='.$newName); 
		curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
		$eventID = json_decode(curl_exec($ch))->id;
		curl_close($ch);		
	}
	
	/**
	 * changeEventDescription 
	 * 
	 * This function will change the description of the event
	 * 
	 * @param	int			$eventID			ID of the event that guests will be invited to 
	 * @param	string 		$newDescription		New description of the event
	 * @return	boolean		$changed			True for changed, false for not changed
	 */
	function changeEventDescription($eventID,$newDescription){
		$authentication = new FacebookAuthentication();
		$currentToken = $authentication->getUserToken();
		print "Change Descriptions\n";		
		$ch = curl_init();		
		curl_setopt($ch, CURLOPT_URL, 'https://graph.facebook.com/'.$eventID.'/?access_token='.$currentToken);
		curl_setopt($ch, CURLOPT_POST,1);
		curl_setopt($ch, CURLOPT_POSTFIELDS, 'description='.$newDescription); 
		curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
		$eventID = json_decode(curl_exec($ch))->id;
		curl_close($ch);	
	}
	
	/**
	 * changeEventStartTime 
	 * 
	 * This funcation will change the start_time of the event
	 * 
	 * @param 	int				$eventID			ID of the event that guests will be invited to
	 * @param 	UNIXDateTime	$newStartTime		New start time of the event
	 * @return	boolean			$changed			True for changed, false for not changed
	 */
	function changeEventStartTime($eventID,$newStartTime){
		$authentication = new FacebookAuthentication();
		$currentToken = $authentication->getUserToken();		
		$ch = curl_init();		
		curl_setopt($ch, CURLOPT_URL, 'https://graph.facebook.com/'.$eventID.'/?access_token='.$currentToken);
		curl_setopt($ch, CURLOPT_POSTFIELDS, 'start_time='.$newStartTime); 
		curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
		$eventID = json_decode(curl_exec($ch))->id;
		curl_close($ch);
	}
	
	
	/**
	 * changeEventEndTime
	 * 
	 * This function will change the end_time of the event
	 *
	 * @param 	int 			$eventID		ID of the event that guests will be invited to
	 * @param 	UNIXDateTime	$newEndTime 	New end time of the event
	 * @return	boolean			$changed		True for changed, false for not changed
	 */
	function changeEventEndTime($eventID,$newEndTime){
		$authentication = new FacebookAuthentication();
		$currentToken = $authentication->getUserToken();		
		$ch = curl_init();		
		curl_setopt($ch, CURLOPT_URL, 'https://graph.facebook.com/'.$eventID.'/?access_token='.$currentToken);
		curl_setopt($ch, CURLOPT_POSTFIELDS, 'end_time='.$newEndTime); 
		curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
		$eventID = json_decode(curl_exec($ch))->id;
		curl_close($ch);
	}
	
	/**
	 * changeEventLocation
	 * 
	 * This funciton will change the location of the event
	 * 
	 * @param 	int 		$eventID		ID of the event that guests will be invited to
	 * @param 	string		$newLocation	New location of the event
	 * @return	boolean		$changed		True for changed, false for not changed
	 */
	function changeEventLocation($eventID,$newLocation){
		$authentication = new FacebookAuthentication();
		$currentToken = $authentication->getUserToken();		
		$ch = curl_init();		
		curl_setopt($ch, CURLOPT_URL, 'https://graph.facebook.com/'.$eventID.'/?access_token='.$currentToken);
		curl_setopt($ch, CURLOPT_POSTFIELDS, 'location='.$newLocation); 
		curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
		$eventID = json_decode(curl_exec($ch))->id;
		curl_close($ch);
	}
	
	/**
	 * RSVPToEvent
	 * 
	 * This function will RSVP to an event
	 * 
	 * @param 	int			$eventID	ID of the event that guests will be invited to
	 * @param 	string 		$RSVP		***This must be "attending" or "declined"***
	 * @return	boolean		$changed	True for changed, false for not changed
	 */
	function RSVPToEvent($eventID,$RSVP){
		$authentication = new FacebookAuthentication();
		$currentToken = $authentication->getUserToken();
		$ch = curl_init();		
		curl_setopt($ch, CURLOPT_URL, "https://graph.facebook.com/".$eventID."/".$RSVP);
		curl_setopt($ch, CURLOPT_POSTFIELDS, "access_token=".$currentToken); 
		curl_exec($ch);
		curl_close($ch);
		$site = 'https://graph.facebook.com/'.$eventID.'/'.$RSVP;
	}
	
	/**
	 * changeEventPrivacy
	 * 
	 * This function will change the privacy setting of
	 * 
	 * @param	int 		$eventID		ID of the event that guests will be invited to
	 * @param	string 		$privacy		"OPEN" | "CLOSED" | "SECRET"
	 * @return	boolean		$changed		True for changed, false for not changed
	 */
	function changeEventPrivacy($eventID,$privacy){
		$authentication = new FacebookAuthentication();
		$currentToken = $authentication->getUserToken();		
		$ch = curl_init();		
		curl_setopt($ch, CURLOPT_URL, 'https://graph.facebook.com/'.$eventID.'/?access_token='.$currentToken);
		curl_setopt($ch, CURLOPT_POSTFIELDS, 'privacy_type='.$privacy); 
		curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
		$eventID = json_decode(curl_exec($ch))->id;
		curl_close($ch);
	}

	
	/**
	 * createEventsArrayFromJSON
	 * 
	 * This funciton will take in the JSONArray for events that
	 * the user has been invited to or rsvped to and create an 
	 * array of Event objects based on the users events
	 * 
	 * @param 	JSONarray	$eventInput		JSONarray available from Facebook
	 * @return 	eventArray	$eventArray		Array of event objects
	 */
	function createEventsArrayFromJSON($eventInput){
		$events = new FacebookEvents();
		$numberOfEvents = count($eventInput->data);
		$eventsArray = array($numberOfEvents);
		for($countUP=0; $countUP<$numberOfEvents; $countUP++){
			$newEvent = $events->newEventObject($eventInput->data[$countUP]);
			$eventsArray[$countUP] = $newEvent;
		}
		
		return $eventsArray;
	}
	
	/**
	 * newEventObject
	 * 
	 * This function will create a new event object and parse
	 * the JSONArray to get information about the event. Since
	 * description and owner take a long time the are initialized
	 * to "notSet".
	 * 
	 * @param 	JSONObject		$eventInput		JSONObject available from Facebook 
	 * @return 	eventArray		$eventArray		Event objects
	 */
	function newEventObject($eventInput){
		$eventObject = new FBEvent();
		$eventFunc = new FacebookEvents();
		$eventObject->name = $eventInput->name;
		$eventObject->start_time = $eventInput->start_time;
		$eventObject->end_time = $eventInput->end_time;
		$eventObject->location = $eventInput->location;
		$eventObject->id = $eventInput->id;
		$eventObject->rsvp_status = $eventInput->rsvp_status;
		$description = "not set";
		$eventObject->description = $description;
		$ownerID = "not set";
		$eventObject->ownerID = $ownerID;
		
		return $eventObject;
	}
	
	/**
	 * addDescriptionAndOwnerDetails
	 * 
	 * This function will add the details to the event.
	 * Specifically the ownerID and description.  If any
	 * other details are desired you would add them to the
	 * event here and add them to the class.
	 * 		
	 * @param	eventobject		$eventObject	Passing in an event object, this function
	 * 											will set description and owner details
	 */
	function addDescriptionAndOwnerDetails($eventObject){
		$data = new FacebookData();
		$details = $data->getEventInfo($eventObject->id);
		
		$ownerID = $details->owner->id;
		$description = $details->description;
		
		$eventObject->ownerID = $ownerID;
		$eventObject->description = $description;
		return $eventObject;
	}
	
	/**
	 * getEventDescription
	 * 
	 * This function will get the description of the event
	 * 
	 * @param 	int		$eventID	ID of the eventDescription
	 */
	function getEventDescription($eventID){
		$data = new FacebookData();
		$eventDetails = $data->getEventInfo($eventID);
		$description = $eventDetails->description;
		return $description;
	}
	
	/**
	 * getEventProfilePicture
	 *
	 * This function will return the url of the event profile picture
	 *
	 * @param 	int		 $eventID		ID of the event
	 * @param	string	 $size			Size of the picture valid entries include 
	 * 									"small" for ~50px X ~50px, "normal", and "large"
	 * @return	string	 $pictureURL	URL for the picture 
	 */
	function getEventProfilePicture($eventID,$size){
		$authentication = new FacebookAuthentication();
		$currentToken = $authentication->getUserToken();
		$pictureUrl = 'https://graph.facebook.com/'.$id.'/picture?access_token='.$currentToken."&type=".size;
		return $pictureUrl;
	}
	
	
	/**
	 * getEventOwner
	 * 
	 * This function will get the id of the event
	 * owner
	 * 
	 * @param 	int		$eventID	ID of the eventDescription
	 * @return	int		$ownerID	Facebook ID of the user owner
	 */
	function getEventOwner($eventID){
		$data = new FacebookData();
		$owner = $data->getEventInfo($eventID);
		$ownerID = $owner->owner->id;
		return $ownerID;
	}
	
	/**
	 * getEventComments
	 * 
	 * This will return an array of Comment objects will all parameters filled.
	 * See Comment Class (top of page) for details on Comment objects.
	 * 
	 * @param 	int		$eventID	ID of the event which the comments are desired
	 * @param	int		$page		There are 25 comments per page. Start
	 * 								out with page 0.  If the user would like more
	 * 								call page 1, then page 2 and so on. If first
	 * 								cell of array returned is null do not call again
	 * 								because all have been displayed.
	 */
	function getEventComments($eventID,$page){
		$data = new FacebookData();
		$event = new FacebookEvents();
		$array = $data->getEventFeed($eventID, $page,0);
		$size = sizeof($array->data);
		$arrayOfComments = array($size);
		if($size==0){
			return null;
		}
		for($countUP = 0;$countUP<$size;$countUP++){
			$data = $array->data[$countUP];
			$comment = new Comment();
			$subEventsBoolean = false;
			$comment->subCommentsExist = false;
			
			$subCommentData = $data->comments;
			$subEventsBoolean = $event->doSubCommentsExist($subCommentData);
			if($subEventsBoolean){
				$subCommentArray = $event->getEventSubComments($subCommentData);
				$comment->arrayOfSubComments = $subCommentArray;
				$comment->subCommentsExist = true;
			}
			
			$commentPoster = $data->from;
			$commentPosterID = $commentPoster->id;
			$comment->posterID = $commentPosterID;
			
			$message = $data->message; 
			$comment->message = $message;
			
			$created_time = $data->created_time; 
			$comment->postTime = $created_time;
			
			$arrayOfComments[$countUP] = $comment;
		}
		return $arrayOfComments;
	}
	
	/**
	 * doSubCommentsExist
	 * 
	 * This function will take in data->comments, which is the array of subcomments within a comment,
	 * and return true or false.  True means there are subcomments false means there are not.
	 *  
	 * @param JSON of SubComments 	$subCommentData	This contains and array of "comments" and a value "count"
	 * 												which tells how many comments there are.
	 * @return boolean true indicates that subComments due exist, false means they do not. 
	 */
	function doSubCommentsExist($subCommentData){
		$count = $subCommentData->count;
		if($count>0){
			return true;
		} else{
			return false;
		}
	}
	
	/**
	 * getEventSubComments
	 * 
	 * This function will take in an array of comments in the JSON format and create subComment
	 * objects that will be placed in an array for storing in the "arrayOfSubComments"
	 * 
	 * @param JSON Object Of Comments 	$subCommentArrayInput	This array contains all of the subcomments and information
	 * 															about them.
	 * @return array of subcomments		$subCommentArray		This is an array of SubComment objects	
	 */
	function getEventSubComments($subCommentArrayInput){
		$size = $subCommentArrayInput->count;
		$subCommentArray = array($size);
		for($countUP = 0;$countUP<=$size-1;$countUP++){
			$subComment = new SubComment();
			$data = $subCommentArrayInput->data[$countUP];
			$commentPoster = $data->from;
			
			$commentPosterID = $commentPoster->id;
			$subComment->posterID = $commentPosterID;
			
			$message = $data->message; 
			$subComment->message = $message;
			
			$created_time = $data->created_time;
			$subComment->postTime = $created_time; 
	
			$subCommentArray[$countUP] = $subComment;
		}
		return $subCommentArray;
	}
	
	/**
	 * createComment
	 * 
	 * This function is used to create a Facebook comment
	 * on an event feed.
	 * 
	 * @param int		$eventID	This is the Facebook ID of the event that you would like to add.
	 * @param string	$message	This is a message that you would like to post.
	 */
	function createComment($eventID,$message){
		$authentication = new FacebookAuthentication();
		$currentToken = $authentication->getUserToken();
		$ch = curl_init();
		curl_setopt($ch, CURLOPT_URL, 'https://graph.facebook.com/'.$eventID.'/feed/?access_token='.$currentToken);
		curl_setopt($ch, CURLOPT_POSTFIELDS, 'message='.$message); 
		curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
		curl_exec($ch);
		curl_close($ch);	
	}
	
	/**
	 * printEventsArray
	 * 
	 * This funciton will take in an events array and print
	 * out the different elements of each event.
	 * 
	 * @param	eventArray	$eventsArray	Array of FBevent objects	
	 */
	function printEventsArray($eventsArray){ 
		$numberOfEvents = count($eventsArray);
		for($countUP=0; $countUP<$numberOfEvents; $countUP++){
			$name = $eventsArray[$countUP]->name;
			print "$name<br>";
			$start_time = $eventsArray[$countUP]->start_time;
			print "$start_time<br>";
			$end_time = $eventsArray[$countUP]->end_time;
			print "$end_time<br>";
			$location = $eventsArray[$countUP]->location;
			print "$location<br>";
			$id = $eventsArray[$countUP]->id;
			print "$id<br>";
			$rsvp_status = $eventsArray[$countUP]->rsvp_status;
			print "$rsvp_status<br>";
			$eventOwner = $eventsArray[$countUP]->ownerID;
			print "$eventOwner<br>";
			$description = $eventsArray[$countUP]->description;
			print "$description<br>";
			print "<br>";
		}
	}
	
}



/**
 * User
 * 
 * This is the User class.  The elements of the user 
 * class are a subset of those provided by Facebook.
 * In addition to those provided by Facebook, each 
 * user has a list of different events which they have
 * marked as attending, maybe, declined, and not_replied
 * @author Dan
 *
 */
class User
{
	public $id;
	public $name;
	public $first_name;
	public $last_name;
	public $link;
	public $eventsAttendingArray;
	public $eventsMaybeArray;
	public $eventsDeclinedArray;
	public $eventsNot_repliedArray;
}

/**
 * Friend
 * 
 * This the Friend class.
 * 
 * @author Dan
 *
 */
class Friend
{
	public $id;
	public $name;
}



/**
 * FacebookUser Class
 * 
 * This class contains all of the functions that pull infor
 * 
 * @author Dan Kaufman
 *
 */
class FacebookUser
{
	/**
	 * 
	 * function getUserInfo
	 * 
	 * This function will take in the $id of the user and return 
	 * a User object that contains the details of that user.  This
	 * function will also find what events the user is associated 
	 * with.
	 * 
	 * @param int $id
	 * @return User userObject
	 * 
	 */
	function getUserInfo($id){
		$data = new FacebookData();
		$eventsAttending = $data->getAttendingJSONArray($id);
		$eventsMaybe = $data->getMaybeJSONArray($id);
		$eventsDeclined = $data->getDeclinedJSONArray($id);
		$eventsNot_replied = $data->getNotRepliedJSONArray($id);
	
		$userObject = new FacebookUser();
		$user = $userObject->getUserObject($id); 
		
		$events = new FacebookEvents();
		$eventsAttendingArray = $events->createEventsArrayFromJSON($eventsAttending);
		$eventsMaybeArray = $events->createEventsArrayFromJSON($eventsMaybe);
		$eventsDeclinedArray = $events->createEventsArrayFromJSON($eventsDeclined);
		$eventsNot_repliedArray = $events->createEventsArrayFromJSON($eventsNot_replied);
		
		$user->eventsAttendingArray = $eventsAttendingArray;
		$user->eventsMaybeArray = $eventsMaybeArray;
		$user->eventsDeclinedArray = $eventsDeclinedArray;
		$user->eventsNot_repliedArray = $eventsNot_repliedArray;
		
		return $user;
	}
	
	
	/**
	 * getUserNameFromID
	 * 
	 * This function returns the users name from their id
	 * 
	 * @param int $id
	 * @return String name of user
	 */
	function getUserNameFromID($id){
		$data = new FacebookData();
		$user = $data->getUserJSONArray($id);
		return $user->name;
	}
	
	
	
	/**
	 * getUserObject
	 * 
	 * This function will create a new user object and parse
	 * the user JSONArray to get the information about the user
	 * 
	 * @param  int $id
	 * @return User Object
	 */
	function getUserObject($id){
		$userObject = new User();
		$data = new FacebookData();
		$user = $data->getUserJSONArray($id);
		
		$id = $user->id;	
		$name=$user->name;	
		$first_name = $user->first_name;
		$last_name = $user->last_name;
		$link = $user->link;
		
		$userObject->id = $id;
		$userObject->name = $name;
		$userObject->first_name = $first_name;
		$userObject->last_name = $last_name;
		$userObject->link = $link;
		
		return $userObject;
	}

	/**
	 * getUserFriends
	 * 
	 * @param int						$id			Current User ID
	 * @return array of friend objects	$friendList	This is an array that contains all friend objects of a user.
	 */
	function getUserFriends($id){
		$userObject = new User();
		$data = new FacebookData();
		$friendList = $data->getUserFriends($id);
		$numberOfFriends = sizeof($friendList->data);
		
		$friendArray = array($numberOfFriends);
		
		for($countUP = 0;$countUP<$numberOfFriends;$countUP++){
			$friendData = $friendList->data[$countUP];
			$friendID = $friendData->id;
			$friendName = $friendData->name;
			
			$friend = new Friend();
			$friend->name = $friendName;
			$friend->id = $friendID;
			
			$friendArray[$countUP] = $friend;
		}
		
		return $friendArray;
		
	}
	
}

?>