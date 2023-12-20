<?php
require "connect.php";
// $image = date('dmYHis').str_replace(" ","", basename($_FILES['image']['name']));
// $imagePath = '../upload/'.$image;
// move_uploaded_file($_FILES['image']['tmp_name'], $imagePath);

$response = array([
    $nama_pelapor = $_POST['nama_pelapor'],
    $no_tlp = $_POST['no_tlp'],
    $namaPasien = $_POST['namaPasien'],
    $gejalaPasien = $_POST['gejalaPasien'],
    $alamatPasien = $_POST['alamatPasien'],
    $lat = $_POST['lat'],
    $long = $_POST['long'],
   // $konfirmasigfotoKTP = $image,
]);
    $insert = "INSERT INTO tb_kasus 
    (`nama_pelapor`, `no_tlp`, `nama_pas`, `gejala_pas`, `alamat_pas`, `lat`, `long`, `status`, `created_at`)VALUES
    ('$nama_pelapor','$no_tlp','$namaPasien','$gejalaPasien','$alamatPasien','$lat','$long','0', NOW())";
    if(mysqli_query($con, $insert)){
        $response ['message'] = "Berhasil didaftarkan";
        echo json_encode($response);
    
    }else{
        $response['message'] = "Gagal didaftarkan";
        echo json_encode($response);
    }