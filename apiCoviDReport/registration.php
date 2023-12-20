<?php
require "connect.php";
$image = date('dmYHis').str_replace(" ","", basename($_FILES['image']['name']));
$imagePath = "upload/".$image;
move_uploaded_file($_FILES['image']['tmp_name'], $imagePath);
    
$response = array([
    $nama_user = $_POST['nama_user'],
    $nik = $_POST['nik'],
    $jns_kelamin = $_POST['jns_kelamin'],
    $tgl_lahir = $_POST['tgl_lahir'],
    $alamat = $_POST['alamat'],
    $no_tlp = $_POST['no_tlp'],
    $email = $_POST['email'],
    $password = $_POST['password'],
    $password = password_hash($password, PASSWORD_BCRYPT),
   // $fotoktp = $image,
   $fotoktp = $_POST['image']
]);

$cek = "SELECT * FROM users WHERE email = '$email', nik = '$nik'";
$result = mysqli_fetch_array(mysqli_query($con, $cek));

if(isset($result)){
    $response['message'] = 'nomor dan email telah digunakan';
    echo json_encode(($response));
}else{
    $insert = "INSERT INTO users 
    (nama_user, id_mitra, nik, jns_kelamin, tgl_lahir, alamat, no_tlp, email, password, fotoktp, status, role, created_at, updated_at)
    VALUES('$nama_user','0','$nik','$jns_kelamin','$tgl_lahir','$alamat','$no_tlp','$email','$password','$fotoktp','0','3', NOW(), NOW() )";
    if(mysqli_query($con, $insert)){
        $response ['message'] = "Berhasil didaftarkan";
        echo json_encode($response);

    }else{
        $response['message'] = "gagal didaftarkan";
        echo json_encode($response);
    }
}
?>