<?php
include_once("FacebookInteraction.php");

@require_once(dirname(__FILE__) . '/simpletest/autorun.php');

define('FACEBOOK_APP_ID', '183973304975501');
define('FACEBOOK_SECRET', 'b3919b8c363f2c13faa09d0ece9e4497');

class testAuthentication extends UnitTestCase {

	function testGetFacebookCookie(){
		$authenticate = new FacebookAuthentication();
		$cookie = $authenticate->getFacebookCookie(FACEBOOK_APP_ID, FACEBOOK_SECRET);
		$userID = $cookie['uid'];
		$this->assertEqual($userID, 22918426, "Not proper userID in cookie: $userID\n");
	}
	
	function testsetandgetUserID(){
		$authenticate = new FacebookAuthentication();
		$authenticate->setUserID(2);
		$id = $authenticate->getUserID();
		$this->assertEqual($id, 2, "Not correct userID: $id\n");
	}
	
}
?>