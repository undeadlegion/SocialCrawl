<?php
include_once("FacebookInteraction.php");
@require_once(dirname(__FILE__) . '/simpletest/autorun.php');

define('FACEBOOK_APP_ID', '183973304975501');
define('FACEBOOK_SECRET', 'b3919b8c363f2c13faa09d0ece9e4497');

class testUser extends UnitTestCase {
	
	/**
	 * testGetUserInfo
	 * 
	 * This will test the function that will 
	 * pull information based on the id of the
	 * user.
	 */
	function testGetUserInfo(){
		$userObject = new FacebookUser();
		$user = $userObject->getUserInfo(22918426);
		
		$firstName = $user->first_name;	
		$this->assertEqual($firstName, Dan, "Not the same name user: $firstName\n");
	}
	
	/**
	 * testGetUserNameFromID
	 *
	 * This is a specific function that will
	 * return the name of the user that is 
	 * associated with the user id.
	 */
	function testGetUserNameFromID(){
		$userObject = new FacebookUser();
		$name = $userObject->getUserNameFromID(22918426);
		
		$this->assertEqual($name, "Dan Kaufman", "Not the same name user: $name\n");
	}
	
	/**
	 * testGetUserObject
	 * 
	 * This function will test the function
	 * that will return the user object. 
	 */
	function testGetUserObject(){
		$userObject = new FacebookUser();
		$user = $userObject->getUserObject(22918426);
			
		$firstName = $user->first_name;
		$this->assertEqual($firstName, Dan, "Not the same name user: $firstName\n");
	}

}
?>