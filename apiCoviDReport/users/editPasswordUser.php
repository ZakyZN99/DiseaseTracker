<?php
require "../connect.php";

$response = array([
    $email = $_POST["email"],
    $passwordlama = $_POST["password"],
    $newpass = $_POST["newpass"],
    $newpassHash= password_hash($newpass, PASSWORD_BCRYPT),
    $repeatnewpass = $_POST["repeatnewpass"],
    $repeatnewpassHash= password_hash($repeatnewpass, PASSWORD_BCRYPT),
]);

$cek = "SELECT * FROM users WHERE email='$email'";
$result = mysqli_query($con, $cek);

if ($result) {
    $row = mysqli_fetch_assoc($result);
    $passwordHashLama = $row['password'];
    if(password_verify($passwordlama, $passwordHashLama)){
        if ($newpass != $repeatnewpass) {
            $response['message'] = "Password Baru Harus Sama Dengan Ulangi Password Baru";
            echo json_encode($response);
        }else if($newpass == $repeatnewpass){
            $update = "UPDATE users SET password='$newpassHash' WHERE email='$email'";
            if (mysqli_query($con, $update)) {
                $response['message'] = "Berhasil Mengubah Password";
                echo json_encode($response);
            } else {
                $response['message'] = "Kata sandi tidak berhasil diubah";
                echo json_encode($response);
            }
        }
    }else{
        $response['message']='Password tidak sama';
        echo json_encode($response);
    }

} else {
    $response['message'] = 'Data Tidak Ditemukan';
    echo json_encode($response);
    }