<?php

require "connect.php";

$response = array([
    $id_kasus = $_POST['id_kasus']
]);

$sql = "DELETE FROM tb_kasus WHERE id_kasus='$id_kasus'";

if(mysqli_query($con,$sql)){
    $response['message'] = "Berhasil dihapus";
    echo json_encode($response);
}else{
    $response['message'] = "Gagal dihapus";
    echo json_encode($response);
}
