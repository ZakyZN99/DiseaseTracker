<?php
require "connect.php";

    $response = array([
    $email = $_POST["email"],
    $nik = $_POST["nik"],
   // $notlp = $_POST["no_tlp"],
    $newpass = $_POST["password"],
    $repeatpass = $_POST['repeatpass'],
    $newpass1 = password_hash($newpass, PASSWORD_BCRYPT)
    ]);
    
    $cek = "SELECT * FROM users WHERE users.email='$email' AND nik = '$nik'";
    $result =  mysqli_query($con, $cek);
	
	if (mysqli_num_rows($result) > 0) {
        if ($newpass != $repeatpass) {
            $response['message'] = "Password Baru Harus Sama Dengan Ulangi Password Baru";
            echo json_encode($response);
        } else if($newpass == $repeatpass){
                $insert = "INSERT INTO tb_forgot_password (id_user, password, status, created_at, updated_at)
                VALUES ((select id_users from users WHERE users.email='$email'), '$newpass1','0', NOW(), NOW())";
                        if(mysqli_query($con, $insert)){
                            $response['message'] = "Request Kata Sandi Berhasil!";
                            echo json_encode($response);
                        }else{
                            $response['message'] = "Request Kata Sandi Gagal!";
                            echo json_encode($response);
                        }
        }
        
        }else if(mysqli_num_rows($result)== 0){
            $response['message'] = 'Data Tidak Ditemukan';
            echo json_encode($response);
        }
	?>