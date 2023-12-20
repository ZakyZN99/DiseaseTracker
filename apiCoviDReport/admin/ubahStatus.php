<?php

require "../connect.php";

$response = array([
    $id_kasus = $_POST["id_kasus"],
    $status = $_POST["status"],
]);

$cek = "SELECT * FROM tb_kasus WHERE id_kasus='$id_kasus'";
$result = mysqli_query($con, $cek);
$row = mysqli_fetch_array($result, MYSQLI_ASSOC);

if ($row) {
    $row['message'] = 'Data Ditemukan';
    $update = "UPDATE tb_kasus SET tb_kasus.status = '$status' WHERE tb_kasus.id_kasus='$id_kasus'";
    if (mysqli_query($con, $update)) {
        $row['message'] = "Berhasil diubah";
        echo json_encode($row);
    } else {
        $response['message'] = "Gagal diubah";
        echo json_encode($response);
    }
} else {
    $row['message'] = 'Data Tidak Ditemukan';
    echo json_encode($row);
}
