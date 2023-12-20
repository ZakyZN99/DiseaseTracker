<?php
require "connect.php";

	$email = $_GET['email'];
	
	//$cek = "SELECT * FROM tb_kasus WHERE nama_pelapor='$nama_pelapor'";
	$cek = "SELECT 	tb_kasus.id_kasus, tb_kasus.nama_pelapor, tb_kasus.foto_ktp_confirm, tb_kasus.no_tlp, tb_kasus.nama_pas, tb_kasus.gejala_pas, tb_kasus.alamat_pas, tb_kasus.lat,
	tb_kasus.long, tb_kasus.id_mitra, tb_kasus.created_at, tb_kasus.status  FROM tb_kasus INNER JOIN users ON tb_kasus.nama_pelapor = users.nama_user WHERE users.email = '$email'";
	$result = mysqli_query($con, $cek);
	if (isset($result)) {
		while($row = mysqli_fetch_all($result, MYSQLI_ASSOC)) {
        $data['data'] = $row;
    }
		$data['message'] = 'Data ditemukan';
		echo json_encode($data);
	}else {
		$data['message'] = "Data tidak ditemukan";
		echo json_encode($data);
	}
	
     $con->close();
?>