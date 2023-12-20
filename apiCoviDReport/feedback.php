<?php
require "connect.php";
$response = array([
  	$email = $_POST['email'],
	$id_pengguna = $_POST['id_pengguna'], 
	$feedback = $_POST['feedback'], ]);
	$cek = "SELECT * FROM users WHERE email='$email'";
	$result = mysqli_query($con, $cek);
	$row = mysqli_fetch_array($result, MYSQLI_ASSOC);
	if(isset($row)){
			$insert = "INSERT INTO tb_feedback
            VALUES(NULL, $id_pengguna, '$feedback', '0',NOW(), NOW())";
			if(mysqli_query($con, $insert)){
				$response['message'] = "Berhasil disimpan";
				echo json_encode($response);
    		}else{
            $response['message'] = "Gagal disimpan";
            echo json_encode($response);
        }
	}
 //    $con->close();
?>