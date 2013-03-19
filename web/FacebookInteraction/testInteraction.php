<?php
include_once("FacebookInteraction.php");
@require_once(dirname(__FILE__) . '/simpletest/autorun.php');

define('FACEBOOK_APP_ID', '183973304975501');
define('FACEBOOK_SECRET', 'b3919b8c363f2c13faa09d0ece9e4497');

class testInteraction extends UnitTestCase {
	
	

	
	function testTest(){
		$this->assertEqual($addResult, 0, "addEvent reports failure: $addResult\n");
	}

	function testLogin(){
			$authenticate = new FacebookAuthentication();
			$cookie = $authenticate->getFacebookCookie(FACEBOOK_APP_ID, FACEBOOK_SECRET);
			$userID = $cookie['uid'];
			$this->assertEqual($userID, 22918426, "Not the same userID: $userID\n");
	}
	
	function testGetUserName(){
			$authenticate = new FacebookAuthentication();
			$userObject = new FacebookUser();
			$user = new User();
			
			$cookie = $authenticate->getFacebookCookie(FACEBOOK_APP_ID, FACEBOOK_SECRET);
			$userID = $cookie['uid'];
			$user = $userObject->getUserInfo($userID);
			
			$firstName = $user->first_name;
			$this->assertEqual($firstName, Dan, "Not the same name user: $firstName\n");
	}
	


}
?>