<?php


for($id = 12; $id <= 12; $id++){
	print "******************************************************************************\n";
	print "                          Getting School id=$id\n";
	print "******************************************************************************\n";

	$ids = getBarIds($id);
	parseBarDetailsFromIds($ids);
	getBarGeolocations($ids, $id);
	getBarImages($ids, $id);
	
	$specials =	parseBarSpecials($ids, $id);

//	loadSpecialsIntoDatabase($specials, $id);
//	loadBarsIntoDatabase($ids);
}
print_r(array_values($ids));
print_r(array_values($specials));
writeSpecials($specials);
$days = getDaysOfTheWeek();
writeBars($ids);
writeDays($days);
getBarImages($ids, $id);

function &getBarIds($schoolId){
	$objDOM = new DOMDocument();

	
	$objDOM->load("http://www.theblacksheeponline.com/mobile/bardetails.php?id=" . $schoolId);
	$ids[0] = "";
	$event = $objDOM->getElementsByTagName("event");
	print "Fetching bar ids\n|";
	for($i = 0; $i < $event->length; $i++){
		print "-";
	}
	print "|\n|";

	foreach( $event as $value){
		$eventimage = $value->getElementsByTagName("eventimage");
		$eventid = $value->getElementsByTagName("eventid");
		$eventimage = $eventimage->item(0)->nodeValue;
		$eventid = $eventid->item(0)->nodeValue;
		$bar['eventid'] = substr($eventid, 0, -2);
		$bar['quickURL'] = $eventimage;
		$bar['schoolid'] = $schoolId;
		print ".";		
		$ids[] = $bar;
	}
	print "|\n\n";
	unset($ids[0]);
	return $ids;
}

function parseBarDetailsFromIds(&$ids){
	print "Fetching bar details\n|";
	for($i = 0; $i < count($ids); $i++){
		print "-";
	}
	print "|\n|";
	foreach( $ids as $key => &$bar){
		$url = "http://www.theblacksheeponline.com/mobile/barspecial.php?id=";
		$url = $url . $bar['eventid'] . "~1";
		$objDOM = new DOMDocument();
		$objDOM->load($url);
		$barname = $objDOM->getElementsByTagName("barname");
		$barimage = $objDOM->getElementsByTagName("barimage");
		$bardescription = $objDOM->getElementsByTagName("bardescription");
		$address1 = $objDOM->getElementsByTagName("address1");
		$address2 = $objDOM->getElementsByTagName("address2");
		$city = $objDOM->getElementsByTagName("city");
		$state = $objDOM->getElementsByTagName("state");
		$barwebsite = $objDOM->getElementsByTagName("barwebsite");
		$barphonenumber = $objDOM->getElementsByTagName("barphonenumber");
		$bar['barname'] = $barname->item(0)->nodeValue;
		$bar['detailedURL'] = $barimage->item(0)->nodeValue;
		$bar['bardescription'] = $bardescription->item(0)->nodeValue;
		$bar['address1'] = $address1->item(0)->nodeValue;
		$bar['address2'] = $address2->item(0)->nodeValue;
		$bar['city'] = $city->item(0)->nodeValue;
		$bar['state'] = $state->item(0)->nodeValue;
		$bar['barwebsite'] = $barwebsite->item(0)->nodeValue;
		$bar['barphonenumber'] = $barphonenumber->item(0)->nodeValue;
		print '.';
	}
	print "|\n\n";
}

function getBarGeolocations(&$bars, $schoolId){
	$url = "http://maps.google.com/maps/geo?q=";
	$url2 = "&output=csv";

	print "Looking up bar geolocations\n|";
	for($i = 0; $i < count($bars); $i++){
		print "-";
	}
	print "|\n|";
	foreach( $bars as $key => &$bar){
		$requestString = $bar['address1'];
		switch($schoolId){
			case 12:
				$requestString = $requestString . " Champaign, IL 61820";
				break;
			case 13:
				$requestString = $requestString . " East Lansing, MI 48824";
				break;
			case 14:
				$requestString = $requestString . " Normal, IL 61790 ";
				break;
			case 15:
				$requestString = $requestString . " Kalamazoo, MI 49008";
				break;
		}
		$geoRequestURL = urlencode($requestString);
		$geoRequestURL = $url . $geoRequestURL . $url2;
		
		//print "Looking up coordinates for " . $bar['barname'] . "...";
		$contents = file_get_contents($geoRequestURL);
		sleep(.6);
		$contentsArray = explode(',', $contents);
		$bar['longitude'] = $contentsArray[3];
		$bar['latitude'] = $contentsArray[2];
		
		print ".";
		//print $bars[$key]['longitude'] . ',' . $bars[$key]['latitude'] . "\n";
	}
	print "|\n\n";
}

function getBarImages(&$bars, $schoolId){
	$quickDir = "./images/quick/" . $schoolId . "/";
	$detailedDir = "./images/detailed/" . $schoolId . "/";

	print "Fetching bar images\n|";
	for($i = 0; $i < count($bars); $i++){
		print "-";
	}
	print "|\n|";
	foreach( $bars as $key => &$bar){
		$quickURL = $bar['quickURL'];
		$detailedURL = $bar['detailedURL'];

//		print "Fetching quick image for" . $bar['barname'] . " from ". $quickURL . "\n";
//		print "Fetching detailed image for" . $bar['barname'] . " from " . $detailedURL . "\n";

		$escapedName = strtolower($bar['barname']);
		$escapedName = str_replace(' ', '_', $escapedName) . ".png";
		file_put_contents($quickDir . $escapedName, file_get_contents($quickURL));
		file_put_contents($detailedDir . $escapedName, file_get_contents($detailedURL));

		$bar['detailedlogo'] = "images/logos/detailed/" . $schoolId . "/" . $escapedName;
		$bar['quicklogo'] = "images/logos/quick/" . $schoolId . "/" . $escapedName;
		print ".";
	}
	print "|\n\n";

}

function &getDaysOfTheWeek(){
	print "Reading days";
	$objDOM = new DOMDocument();
	$url = "http://www.theblacksheeponline.com/mobile/date_details.php";
	$objDOM->load($url);
	$listings = $objDOM->getElementsByTagName("BarListingDate");
	
	foreach( $listings as $date){
		print '.';
		$barDate = $date->getElementsByTagName("BarDate")->item(0)->nodeValue;
		$dateId = $date->getElementsByTagName("DateId")->item(0)->nodeValue;
		$arr['dateid'] = $dateId;
		$arr['date'] = $barDate;
		$dateArr[] = $arr;
	}
	print "\n";
	return $dateArr;
}

function &parseBarSpecials(&$bars, $schoolId){
	$url = "http://www.theblacksheeponline.com/mobile/bardetails_mobile.php?id=".$schoolId ."&dateid=";
	
	print "Loading specials \n|--------|\n|";
	$specials[0] = "";
	foreach($bars as $key => $bar){
		$specials[$key+1][0] = "";
	}
	for($i = 1; $i <= 8; $i++){
		$objDOM = new DOMDocument();
		$objDOM->load($url . $i);
		$events = $objDOM->getElementsByTagName("event");

		foreach($events as $key => $event){
			$specials[$key+1][] = $event->getElementsByTagName("eventdescription")->item(0)->nodeValue;
		}
		print ".";
	}
	print "|\n\n";

	foreach($specials as $key => $special){
		unset($specials[$key+1][0]);
	}
	unset($specials[0]);
	
	return $specials;
}

function loadSpecialsIntoDatabase(&$specials, $schoolId){
	$url = "groovegene.com";
	$dbname = "groovege_campuscrawler";
	$user = "groovege";
	$pw = "7arf476TjC";

	$query = "INSERT INTO bar_specials VALUES (:bar_id, :school_id, :date_id, :specials) ON DUPLICATE KEY UPDATE specials=:specials";
	$db = new PDO("mysql:dbname=$dbname;host=$url", $user, $pw);
	$db->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

	print "Inserting Specials into Database\n|";
	for($i = 0; $i < count($specials) * 8; $i++)
		print "-";
	print "|\n|";
	foreach( $specials as $key => &$bar){
		for($i = 0; $i < 8; $i++){		
			$stmt = $db->prepare($query);
			$date_id = $i + 1;
			$school_id = $schoolId;
			$stmt->bindParam(":bar_id", $key);
			$stmt->bindParam(":school_id", $school_id);
			$stmt->bindParam(":date_id", $date_id);
			$stmt->bindParam(":specials", $bar[$i]);
			$stmt->execute();
			print ".";
		}
	}
	print "|\n\n";

}

function loadBarsIntoDatabase(&$bars){
	$url = "groovegene.com";
	$dbname = "groovege_campuscrawler";
	$user = "groovege";
	$pw = "7arf476TjC";
	
	$query = "REPLACE INTO bars VALUES (:id, :bs_id, :school_id, :name, :address, :description, :website, :quick_logo, :detailed_logo, :longitude, :latitude )";
	$db = new PDO("mysql:dbname=$dbname;host=$url", $user, $pw);
	$db->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
	
	print "Inserting Bars into Database\n|";
	for($i = 0; $i < count($bars); $i++)
		print "-";
	print "|\n|";
	foreach( $bars as $key => $bar){
			$stmt = $db->prepare($query);
			$stmt->bindParam(":id", $key);
			$stmt->bindParam(":bs_id", $bar['eventid']);
			$stmt->bindParam(":school_id", $bar['schoolid']);
			$stmt->bindParam(":name", $bar['barname']);
			$stmt->bindParam(":address", $bar['address1']);
			$stmt->bindParam(":description", $bar['bardescription']);
			$stmt->bindParam(":website", $bar['barwebsite']);
			$stmt->bindParam(":quick_logo", $bar['quicklogo']);
			$stmt->bindParam(":detailed_logo", $bar['detailedlogo']);
			$stmt->bindParam(":longitude", $bar['longitude']);
			$stmt->bindParam(":latitude", $bar['latitude']);
			$stmt->execute();
			print ".";
	}
	print "|\n\n";
}

function writeBars(&$bars){
	$file = "./output/bars.txt";
	$fh = fopen($file, 'w+');
	
	foreach( $bars as $key => $bar){
		$bar['bardescription'] = str_replace(',', "\,", $bar['bardescription']);
		$row = $key . ", "
			 . $bar['eventid'] . ", "
			 . "12, "
 			 . $bar['barname'] . ", "
			 . $bar['address1'] . ", "
			 . '"' . $bar['bardescription'] . '"' . ", "
			 . $bar['barwebsite'] . ", "
			 . $bar['quicklogo'] . ", "
			 . $bar['detailedlogo'] . ", "
			 . $bar['longitude'] . ", "
			 . $bar['latitude'];
		$rows = $rows . $row . "\n";
	}
	
	fwrite($fh, $rows);
	fclose($fh);	
}
function writeDays(&$arr){
	$file = "./output/days.txt";
	$fh = fopen($file, 'w+');
	
	foreach( $arr as $element){
		unset($row);
		foreach( $element as $value){
			$row = $row . $value . ';';
		}
		$rows = $rows . $row . "\n";
	}
	fwrite($fh, $rows);
	fclose($fh);
}



function writeSpecials(&$bars){
	$file = "./output/specials.txt";
	$fh = fopen($file, 'w+');
	
	foreach($bars as $key => $bar){
		for($i = 1; $i <= 8; $i++){
//			$escaped_string = str_replace(';', "\;", $bar[$i]);
//			print $bar[$i] . "\n";
			print $escaped_string . "\n";
			$row = $key . "; "
				 . "12; "
				 . $i . "; "
				 . $bar[$i];
		
			$rows = $rows . $row . "\n";		
			print $row . "\n";
		}
	}
	
	fwrite($fh, $rows);
	fclose($fh);	
}
?>