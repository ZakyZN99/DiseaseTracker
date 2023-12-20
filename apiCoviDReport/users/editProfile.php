
<?php
require "connect.php";
$image = date('dmYHis') . str_replace(" ", "", basename($_FILES['image']['name']));
$imagePath = 'upload/' . $image;
move_uploaded_file($_FILES['image']['tmp_name'], $imagePath);

$response = array([
    $nama_user = $_POST['nama_user'],
    $nik = $_POST['nik'],
    $jns_kelamin = $_POST['jns_kelamin'],
    $tgl_lahir = $_POST['tgl_lahir'],
    $alamat = $_POST['alamat'],
    $no_tlp = $_POST['no_tlp'],
    $email = $_POST['email'],
    $fotoktp = $image,
]);
$insert = "UPDATE users SET users.nama_user = '$nama_user', users.nik='$nik', users.jns_kelamin='$jns_kelamin',
                    users.tgl_lahir='$tgl_lahir', users.alamat='$alamat', users.no_tlp='$no_tlp', users.email='$email', users.fotoktp='$fotoktp' WHERE email='$email'";
if (mysqli_query($con, $insert)) {
    $response['message'] = "Berhasil diubah";
    echo json_encode($response);
} else {
    $response['message'] = "Gagal diubah";
    echo json_encode($response);
}
