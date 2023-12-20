<?php
$hostname = '203.175.8.35';
$username = 'disj4638_diseasetracker ';
$password = '@Webgiscovid123';
$database = 'disj4638_diseasetracker';
$con = mysqli_connect($hostname, $username, $password, $database) or die('tidak bisa konek');

if($con->connect_error){
    echo "Failed to connect to MySQL: " . $con->connect_error;
}else{
 
}
?>