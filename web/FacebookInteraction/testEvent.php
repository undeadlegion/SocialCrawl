<?php
include_once("FacebookInteraction.php");
@require_once(dirname(__FILE__) . '/simpletest/autorun.php');

define('FACEBOOK_APP_ID', '183973304975501');
define('FACEBOOK_SECRET', 'b3919b8c363f2c13faa09d0ece9e4497');

class testEvent extends UnitTestCase {

	/**
	 * testGetUserEventsAttendingFromID
	 * 
	 * This will test the list of events returned from 
	 * the array of events that the user has responded
	 * with attending.
	 * 
	 */
	function testGetUserEventsAttendingFromID(){
		$authenticate = new FacebookAuthentication();
		$cookie = $authenticate->getFacebookCookie(FACEBOOK_APP_ID, FACEBOOK_SECRET);
		$id = $authenticate->getUserID();
		
		$user = new FacebookUser();
		$events = new FacebookEvents();
		$data = new FacebookData();
		
		$eventsAttending = $events->getUserEventsAttendingFromID($id);
		for($countUP = 0;$countUP<sizeof($eventsAttending);$countUP++){
			$val = $eventsAttending[$countUP]->id;
			$testEventID="328804572620";
			if($val==$testEventID){
				$this->assertTrue(true);
				return;
			}
		}	
		print "Failed attending<br>";
		$this->assertTrue(false);
	}
	
	/**
	 * testGetUserEventsMaybeFromID
	 * 
	 * This will test the list of events returned from 
	 * the array of events that the user has responded
	 * with maybe.
	 * 
	 */
	function testGetUserEventsMaybeFromID(){
		$authenticate = new FacebookAuthentication();
		$cookie = $authenticate->getFacebookCookie(FACEBOOK_APP_ID, FACEBOOK_SECRET);
		$id = $authenticate->getUserID();
		
		$user = new FacebookUser();
		$events = new FacebookEvents();
		$data = new FacebookData();
		
		$eventsMaybe = $events->getUserEventsMaybeFromID($id);
		for($countUP = 0;$countUP<sizeof($eventsMaybe);$countUP++){
			$val = $eventsMaybe[$countUP]->id;
			$testEventID="132622296790172";
			if($val==$testEventID){
				$this->assertTrue(true);
				return;
			}
		}
		print "Failed maybe<br>";
		$this->assertTrue(false);
	}
	
	/**
	 * testGetUserEventsDeclinedFromID
	 * 
	 * This will test the list of events returned from
	 * the array of events that the user has declined
	 * 
	 */
	function testGetUserEventsDeclinedFromID(){
		$authenticate = new FacebookAuthentication();
		$cookie = $authenticate->getFacebookCookie(FACEBOOK_APP_ID, FACEBOOK_SECRET);
		$id = $authenticate->getUserID();
		
		$user = new FacebookUser();
		$events = new FacebookEvents();
		$data = new FacebookData();
		
		$eventsDeclined = $events->getUserEventsDeclinedFromID($id);
		for($countUP = 0;$countUP<sizeof($eventsDeclined);$countUP++){
			$val = $eventsDeclined[$countUP]->id;
			$testEventID="155812086410";
			if($val==$testEventID){
				$this->assertTrue(true);
				return;
			}
		}
		print "Failed Decline<br>";
		$this->assertTrue(false);
	}
	
	/**
	 * testGetUserEventsNotRepliedFromID
	 * 
	 * This will test the list of events returned from
	 * the array of events that the user hasn't responded
	 * to. 
	 * 
	 */
	function testGetUserEventsNotRepliedFromID(){
		$authenticate = new FacebookAuthentication();
		$cookie = $authenticate->getFacebookCookie(FACEBOOK_APP_ID, FACEBOOK_SECRET);
		$id = $authenticate->getUserID();
		
		$user = new FacebookUser();
		$events = new FacebookEvents();
		$data = new FacebookData();
		
		$eventsReplied = $events->getUserEventsNotRepliedFromID($id);
		for($countUP = 0;$countUP<sizeof($eventsReplied);$countUP++){
			$val = $eventsReplied[$countUP]->id;
			$testEventID="194109273948095";
			if($val==$testEventID){
				$this->assertTrue(true);
				return;
			}
		}
		print "Failed not replied<br>";
		$this->assertTrue(false);
	}
	
	/**
	 * testGetEventsMyUserTime
	 * 
	 * This function tests the function that grabs
	 * the events of a user for a given window of time.
	 * Then checks to make sure they are all within the 
	 * given timeframe.
	 * 
	 */
	function testGetEventsMyUserTime(){
		$authenticate = new FacebookAuthentication();
		$cookie = $authenticate->getFacebookCookie(FACEBOOK_APP_ID, FACEBOOK_SECRET);
		$id = $authenticate->getUserID();
		
		$user = new FacebookUser();
		$events = new FacebookEvents();
		$data = new FacebookData();
		
		$start_time_window = "1289796923";
		$end_time_window = "1290142523";
		
		$arrayOfEvents = $events->getEventsUserTime($id, $start_time_window, $end_time_window);
		$size = sizeof($arrayOfEvents);
		
		for($countUP = 0;$countUP<sizeof($arrayOfEvents);$countUP++){
			$eventObject = $arrayOfEvents[$countUP];
			$correctTime = $events->checkTime($eventObject, $start_time_window, $end_time_window);
			if($correctTime==false){
				$this->assertTrue($correctTime);
				return;
			}
		}
		$this->assertTrue(true);
	}
	
	/**
	 * testGetEventsOtherUserTime
	 * 
	 * This function tests the function that grabs
	 * the events of a user for a given window of time.
	 * Then checks to make sure they are all within the 
	 * given timeframe.
	 * 
	 */
	function testGetEventsOtherUserTime(){
		$authenticate = new FacebookAuthentication();
		$cookie = $authenticate->getFacebookCookie(FACEBOOK_APP_ID, FACEBOOK_SECRET);
		$id = "1148280035";
		$user = new FacebookUser();
		$events = new FacebookEvents();
		$data = new FacebookData();

		$start_time_window = "1309309200";
		$end_time_window = "9309568400";
		
		$arrayOfEvents = $events->getEventsUserTime($id, $start_time_window, $end_time_window);
		$size = sizeof($arrayOfEvents);
		
		for($countUP = 0;$countUP<sizeof($arrayOfEvents);$countUP++){
			$eventObject = $arrayOfEvents[$countUP];
			$correctTime = $events->checkTime($eventObject, $start_time_window, $end_time_window);
			if($correctTime==false){
				$this->assertTrue($correctTime);
				return;
			}
		}
		$this->assertTrue(true);
	}
	
	/**
	 * testCheckTime
	 * 
	 * This test contructs an array of fake events with known
	 * times.  This is intended to check the function that
	 * returns events for a given window of time.
	 */
	function testCheckTime(){
		$eventTest = new testEvent();
		$event = new FacebookEvents();
		$testArray = $eventTest->createTestEventArray();
		$name = $testArray[0]->name;
		$countOfEvents = 0;
		for($countUP = 0;$countUP<sizeof($testArray);$countUP++){
			$time = $testArray[$countUP]->start_time;
			$boolean = $event->checkTime($testArray[$countUP], "1289844372", "1290017172");
			if($boolean){
				$countOfEvents++;
			}
		}
		$this->assertEqual(3, $countOfEvents);		
	}

	/**
	 * createTestObject
	 * 
	 * This will create and return a test
	 * object
	 * 
	 * @param integer $val
	 * @param UNIX time $start_time
	 */
	function createTestObject($val,$start_time){
		$event = new FBEvent();
		$event->name = "Test";
		$event->id = $val;
		$event->start_time = $start_time;
		$st = $event->start_time;
		return $event;
	}
	
	/**
	 * createTestEventArray
	 * 
	 * This is a helper funciton that will create an
	 * array of events that may be used for testing.
	 */
	function createTestEventArray(){
		$eventTest = new testEvent();
		
		$testEventArray = array();
		$testDateNov = array();

		$testDateNov[0] = "1289844372";
		$testDateNov[1] = "1289930772";
		$testDateNov[2] = "1290017172";
		$testDateNov[3] = "1290103572";
		$testDateNov[4] = "1290189972";
		$testDateNov[5] = "1290276372";
		
		for($countUP = 0;$countUP<sizeof($testDateNov);$countUP++){
			
			$testEventArray[$countUP] = $eventTest->createTestObject($countUP,$testDateNov[$countUP]);	
		}		
		return $testEventArray;
	}
	
}
?>