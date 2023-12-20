<?php
require "connect.php";
$response = array([
    $id_kasus = $_POST['id_kasus'],
    $namaPasien = $_POST['namaPasien'],
    $gejalaPasien = $_POST['gejalaPasien'],
    $alamatPasien = $_POST['alamatPasien'],
    $lat = $_POST['lat'],
    $long = $_POST['long'],
])  ;
$insert = "UPDATE tb_kasus SET nama_pas='$namaPasien', gejala_pas='$gejalaPasien', alamat_pas='$alamatPasien', lat='$lat', tb_kasus.long='$long' WHERE id_kasus='$id_kasus'";
if (mysqli_query($con, $insert)) {
    $response['message'] = "Berhasil diubah";
    echo json_encode($response);
} else {
    $response['message'] = "Gagal diubah" . mysqli_error($con);;
    echo json_encode($response);
}
