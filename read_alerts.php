#!/usr/bin/php -q
<?php
function WriteFile($filename,$somecontent){
$nf = touch($filename);
// Make sure the file exists, and is writable first.
if(is_writable($filename)){
//Note, this opens $filename in write mode.
//Thus, the file pointer is at the top of the file.
//That's where $somecontent will go when
//we fwrite() it, overwriting the old content.
if(!$handle = fopen($filename, 'w')){
echo "Cannot open file ($filename)";
exit;
}
//Write $somecontent to our opened file.
if(fwrite($handle,$somecontent) === FALSE){
echo "Cannot write to file ($filename)";
exit;
}
//echo "Success, saved ($somecontent) to file ($filename)";

fclose($handle);

}else{
echo "The file $filename is not writable";
}
}

function parseAlertData($url,$cc){
$my_url='http://www.kd8tig.com/talkbox/weather_data_xml.php?cc='.$cc.'&mode=alert&url='.$url;
$json=file_get_contents($my_url); //get the weather alert data for parsing.
$data=json_decode($json,true);
return($data['info']['description']);
} //EndFunction.

// function getNodeNumber(){
// $lNodes=trim(shell_exec('asterisk -rx "rpt localnodes"'));
// $oNode='';
// for($i=0;$i<=15;$i++){
// if($i>=10){
// $oNode.=$lNodes[$i];
// } // EndIf.
// } // EndFor.
// $oNode=trim($oNode);
// return($oNode);
// } //EndFunction.

function getCountyCode(){
    $lines_array = file("/home/repeater/WRKF394-utils/params.conf");
    $search_string = "county_code";
    
    foreach($lines_array as $line) {
        if(strpos($line, $search_string) !== false) {
            list(, $new_str) = explode(":", $line);
            str_replace('"', "", $new_str);
            $new_str = trim($new_str);
        }
    }
    return($new_str);
} //EndFunction.

function getNodeNumber(){
    $lines_array = file("/home/repeater/WRKF394-utils/params.conf");
    $search_string = "node_number";
    
    foreach($lines_array as $line) {
        if(strpos($line, $search_string) !== false) {
            list(, $new_str) = explode(":", $line);
            str_replace('"', "", $new_str);
            $new_str = trim($new_str);
        }
    }
    return($new_str);
} //EndFunction.

function getAPIKey(){
    $lines_array = file("/home/repeater/WRKF394-utils/params.conf");
    $search_string = "voicerss_key";
    
    foreach($lines_array as $line) {
        if(strpos($line, $search_string) !== false) {
            list(, $new_str) = explode(":", $line);
            str_replace('"', "", $new_str);
            $new_str = trim($new_str);
        }
    }
    return($new_str);
} //EndFunction.

function sendDebugLog($logData){
//debug log server  Url.
$url='http://www.kd8tig.com/debuglogs/submit.php';

//Initiate cURL.
$ch=curl_init($url);

//Encode the log date into JSON.
$jsonLogData=json_encode($logData);

//Tell cURL that we want to send a POST request.
curl_setopt($ch,CURLOPT_POST,1);

//Attach our encoded JSON string to the POST fields.
curl_setopt($ch,CURLOPT_POSTFIELDS,$jsonLogData);

//Set the content type to application/json.
curl_setopt($ch,CURLOPT_HTTPHEADER,array('Content-Type: application/json'));

//Execute the request.
$result=curl_exec($ch);
return($result);
} //EndFunction.

//$node=getNodeNumber(); // Get the default node number from asterisk.
$node=getNodeNumber();
$cc=getCountyCode(); // get the NWS county code from AutoSky.
//$cc='ARC125';
//$cc='NVC007';

$url='http://www.kd8tig.com/talkbox/weather_data_xml.php?cc='.$cc; // Real time weather data.
$json=file_get_contents($url);
$data=json_decode($json,true);

if(!array_key_exists("0",$data['entry'])){
$status=$data['entry']['title'];
$multiple_alerts=0;
}else{
$status=$data['entry'][0]['title'];
$multiple_alerts=1;
} //EndIf.

if($status!='There are no active watches, warnings or advisories'){
//There is at least one active alert!
// Check to see how many, and set the $alert_desc data accordingly.

if(!$multiple_alerts){
//There is only one active alert.
$alert_text=parseAlertData($data['entry']['link']['@attributes']['href'],$cc);
}else{
//There are multiple active alerts, so process each one, snagging its data.
$alerts=$data['entry'];
$noaa=count($alerts);
$alert_text='';

for($i=0; $i<$noaa; $i++){
$alert_text.=trim(parseAlertData($data['entry'][$i]['link']['@attributes']['href'],$cc));
} //EndFor.

} //EndInnerIf.

}else{
//There is no active Alert.
$alert_text=$status;
} //EndOuterIf.

// Create the text file for the tts engine, and send its resulting audio file to the node for playback.
$fn='/tmp/alert.txt';
$wf=WriteFile($fn,$alert_text);
shell_exec("cd /tmp");
if(is_file("/tmp/alert.ul")){
shell_exec("rm -f /tmp/alert.ul");
} //EndIf.

//shell_exec("/home/repeater/fixwxalert2.sh");
$text=file_get_contents("/tmp/alert.txt");
$apikey=getAPIKey();
$text2=str_replace(' ', '%20', $text);
$url="https://api.voicerss.org/?key=".$apikey."&hl=en-us&src=".$text2
$ttscommand="wget -q -U Mozilla -O \"/tmp/alert.wav\" ".$url
$tts=shell_exec($ttscommand);
$convert=shell_exec("sox -V /tmp/alert.wav -r 8000 -c 1 -t ul /tmp/alert.ul");
//$tts=shell_exec("pico2wave -w /tmp/alert.wav \"".$text."\" && sox -V /tmp/alerttest.wav -r 8000 -c 1 -t ul /tmp/alert.ul");
//echo "pico2wave -w /tmp/alert.wav \"".$text."\" && sox -V /tmp/alert.wav -r 8000 -c 1 -t ul /tmp/alert.ul";


//$asterisk=shell_exec("cp /tmp/alert.wav /home/repeater/alert.wav");

$asterisk=shell_exec('asterisk -rx "rpt localplay '.$node.' /tmp/alert"');

//$asterisk=shell_exec('asterisk -rx "rpt playback 1998 /tmp/alert"');


//Flag processing Section. Only runs if a flag was sent from the cli.
if(count($argv)>=2){

//A flag was sent, check for validity, and process it, if it's valid.
switch($argv[1]){

case "-l":
break;

//Create and Send a debug log.
$logData=array();
$logData['nodenumber']=$node;
$logData['countycode']=$cc;
$logData['tts']=$tts;
$logData['asterisk']=$asterisk;
$logData['alerttext']=$alert_text;

$ret=sendDebugLog($logData);
echo "\n";
if($ret!=1){
echo "$ret\n";
}else{
echo "Debug log sent!\n";
} //EndIf.
break;

case "-u":
//Check for a script update.
echo "No update available!\n";
break;

default:
echo "Invalid flag specified! Valid flags include:\n";
echo "-l (Sends a debug log to the developer.)\n";
echo "-u (Check for a script update.)\n";
} //EndSwitch.
} //EndIf.
?>
