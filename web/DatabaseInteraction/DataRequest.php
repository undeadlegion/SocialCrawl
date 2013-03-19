<?php
/*
 * This file will take data from the MySQL backend and publish it as XML.
 * Serves as an connection between the iPhone and backend MySQL database.
 * 
 */

include_once('DatabaseInteraction.php');

header('Content-type: text/xml');

$XMLDoc = new DOMDocument('1.0');
$XMLDoc->formatOutput = true; //make output XML file look nice		

$type = $_GET['type'];
$id = $_GET['id'];
$school_id = $_GET['school_id'];
$date_id = $_GET['date_id'];
$event_id = $_GET['event_id'];

//request for list of bar data
if ($type == "bars") {
	
	$db = new DatabaseInteraction();
	$bars = $db->getBarData($school_id);
	
	$root = $XMLDoc->createElement('Bars');
	$root = $XMLDoc->appendChild($root);
	
	foreach ($bars as $bar) {
		
		$barElement = $XMLDoc->createElement('Bar');
		$barElement = $root->appendChild($barElement);
		$barElement->setAttribute('id',$bar['id']); //set id
		
		$nameElement = $XMLDoc->createElement('name',$bar['name']);
		$addressElement = $XMLDoc->createElement('address',$bar['address']);
		$descriptionElement = $XMLDoc->createElement('description',utf8_encode($bar['description']));
		$quickElement = $XMLDoc->createElement('quicklogo',$bar['quick_logo']);
		$detailedElement = $XMLDoc->createElement('detailedlogo', $bar['detailed_logo']);
		$longitudeElement = $XMLDoc->createElement('longitude', $bar['longitude']);
		$latitudeElement = $XMLDoc->createElement('latitude', $bar['latitude']);
		
		$barElement->appendChild($nameElement);
		$barElement->appendChild($addressElement);
		$barElement->appendChild($descriptionElement);
		$barElement->appendChild($quickElement);
		$barElement->appendChild($detailedElement);
		$barElement->appendChild($longitudeElement);
		$barElement->appendChild($latitudeElement);
	}
	
	print $XMLDoc->saveXML();
} elseif ($type == "events") {
	$db = new DatabaseInteraction();
	$events = $db->getEventData();
	
	$root = $XMLDoc->createElement('Events');
	$root = $XMLDoc->appendChild($root);
	
	foreach ($events as $event) {
		
		$eventElement = $XMLDoc->createElement('Event');
		$eventElement = $root->appendChild($eventElement);
		$eventElement->setAttribute('id',$event[0]);
		
		$creatorElement = $XMLDoc->createElement('creatorid',$event[1]);
		$dateElement = $XMLDoc->createElement('date',$event[2]);
		$titleElement = $XMLDoc->createElement('title',$event[3]);
		$descriptionElement = $XMLDoc->createElement('description',$event[4]);
		$pictureElement = $XMLDoc->createElement('picture',$event[5]);
		$privacyElement = $XMLDoc->createElement('privacy',$event[6]);
		
		$eventElement->appendChild($creatorElement);
		$eventElement->appendChild($dateElement);
		$eventElement->appendChild($titleElement);
		$eventElement->appendChild($descriptionElement);
		$eventElement->appendChild($pictureElement);
		$eventElement->appendChild($privacyElement);
	}
	
	print $XMLDoc->saveXML();
} elseif ($type == "eventsforid") {
	$db = new DatabaseInteraction();
	$events = $db->getEventDataForID($id);
		
	$root = $XMLDoc->createElement('Events');
	$root = $XMLDoc->appendChild($root);
	
	foreach ($events as $event) {
		
		$eventElement = $XMLDoc->createElement('Event');
		$eventElement = $root->appendChild($eventElement);
		$eventElement->setAttribute('id',$event[0]);
		
		$creatorElement = $XMLDoc->createElement('creatorid',$event[1]);
		$dateElement = $XMLDoc->createElement('date',$event[2]);
		$titleElement = $XMLDoc->createElement('title',$event[3]);
		$descriptionElement = $XMLDoc->createElement('description',$event[4]);
		$pictureElement = $XMLDoc->createElement('picture',$event[5]);
		$privacyElement = $XMLDoc->createElement('privacy',$event[6]);
		
		$eventElement->appendChild($creatorElement);
		$eventElement->appendChild($dateElement);
		$eventElement->appendChild($titleElement);
		$eventElement->appendChild($descriptionElement);
		$eventElement->appendChild($pictureElement);
		$eventElement->appendChild($privacyElement);
	}
	
	print $XMLDoc->saveXML();
} elseif ($type == "barsforevent") {
	$db = new DatabaseInteraction();
	$bars = $db->getEventBars($id);
		
	$root = $XMLDoc->createElement('EventBars');
	$root = $XMLDoc->appendChild($root);
	
	foreach ($bars as $bar) {
		$barElement = $XMLDoc->createElement('Bar');
		$barElement = $root->appendChild($barElement);
		$barElement->setAttribute('id',$bar[0]);

		$timeElement = $XMLDoc->createElement('time',$bar[1]);
		$barElement->appendChild($timeElement);
	}
	
	print $XMLDoc->saveXML();
} elseif ($type == "specialsforevent"){
	$db = new DatabaseInteraction();
	$specials = $db->getEventSpecials($id);
	
	$root = $XMLDoc->setAttribute('id', $bar['id']);
}

?>
