<?php
require "connect.php";

    $database = 'disj4638_diseasetracker';
    $response = array([
        $email = $_POST['email'],
        $password = $_POST['password'],
        //$password = md5($password)
        //$password = password_verify()
    ]);

    $cek = "SELECT * FROM users WHERE users.email = '$email'";
    $result = mysqli_query($con, $cek);

    if($result){
            $row = mysqli_fetch_assoc($result);
            $passHash = $row['password'];
            echo $passHash ;
            if(password_verify($password, $passHash)){
                $response['message'] = 'Login Berhasil';
                echo json_encode(($response));
            }
            else{
                $response['message'] = 'Login Gagal';
                echo json_encode($response);
            }
        }