<?php
require "../connect.php";
$image = date('dmYHis').str_replace(" ","", basename($_FILES['image']['name']));
$imagePath = "../fotoktp/".$image;
move_uploaded_file($_FILES['image']['tmp_name'], $imagePath);


$response = array([
    $nama_pelapor = $_POST['nama_pelapor'],
    $no_tlp = $_POST['no_tlp'],
    $namaPasien = $_POST['namaPasien'],
    $gejalaPasien = $_POST['gejalaPasien'],
    $alamatPasien = $_POST['alamatPasien'],
    $lat = $_POST['lat'],
    $long = $_POST['long'],
   // $imageData = $_POST['imageData'],
    $konfirmasigfotoKTP = $image,
    //$konfirmasigfotoKTP = "upload/$imageName"
]);
    $insert = "INSERT INTO tb_kasus 
    (`nama_pelapor`, `no_tlp`,`foto_ktp_confirm`, `nama_pas`, `gejala_pas`, `alamat_pas`, `lat`, `long`, `status`, `created_at`, `updated_at`)VALUES
    ('$nama_pelapor','$no_tlp','$konfirmasigfotoKTP','$namaPasien','$gejalaPasien','$alamatPasien','$lat','$long','0', NOW(), NOW())";

   // file_put_contents($konfirmasigfotoKTP, base64_decode($imageData));
    if(mysqli_query($con, $insert)){
        $response ['message'] = "Berhasil didaftarkan";
        echo json_encode($response);
    
    }else{
        $response['message'] = "Gagal didaftarkan";
        echo json_encode($response);
    }