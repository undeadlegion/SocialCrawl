<?php

include_once(dirname(__FILE__) . "/../DatabaseInteraction/DatabaseInteraction.php");

/*
 * Helper class for outputting HTML form elements
 * 
 * Author: Andrew Packer
 */
class Form {
	
	private $db = 0;
	
	function __construct() {
		
	}
	
	/*
	 * Print list of bars in an unordered HTML list
	 */
	function printBarsUL() {
		$db = new DatabaseInteraction();
		$bars = $db->getBarData();
		
		$outputString = "<div id='barslist'><ul>";
		
		foreach($bars as $bar) {
			$outputString .= "<li>" . $bar[1] . "</li>";
		}
		
		$outputString .= "</ul></div>";
		
		print $outputString;
	}
	
	/*
	 * Print list of bar and time selections
	 */
	function printBarsTimesSelectors() {
		$db = new DatabaseInteraction();
		$bars = $db->getBarData();
	
		$barOptionElements = "<option value=''></option>"; //first blank bar option
		$timeOptionElements = "<option value=''></option>"; //first blank time option
	
		foreach ($bars as $bar) {
			$barOptionElements .= "<option value='".$bar[1]."'>".$bar[1]."</option>";
		}
	
		for ($i=7;$i<13;$i++) {
			if ($i!=12) {
				$timeOptionElements .= "<option value='".($i+12).":00:00'>".$i.":00</option>";
			} else {
				$timeOptionElements .= "<option value='".($i-12).":00:00'>".$i.":00</option>";
			}
		}
		$timeOptionElements .= "<option value='1'>1:00</option>";
	
		//Output 5 bar and time selections
		for ($i=0;$i<4;$i++) {
			print "<select name='bar".($i+1)."'>";
			print $barOptionElements;
			print "</select> - ";
			
			print "<select name='bar".($i+1)."start'>";
			print $timeOptionElements;
			print "</select><br/>";
		}
	}
	
}

?>