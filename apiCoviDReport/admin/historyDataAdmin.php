<?php
require "../connect.php";

$id_mitra = $_GET['id_mitra'];

//$cek = "SELECT * FROM tb_kasus WHERE nama_pelapor='$nama_pelapor'";
$cek = "SELECT 
	tb_kasus.id_kasus, tb_kasus.nama_pelapor,tb_kasus.foto_ktp_confirm, tb_kasus.no_tlp, tb_kasus.nama_pas, tb_kasus.gejala_pas,tb_kasus.alamat_pas, tb_kasus.lat, tb_kasus.long, tb_kasus.id_mitra,
	tb_status_kasus.id_status_kasus, tb_status_kasus.status_name, tb_mitra.nama, tb_mitra.alamat, tb_mitra.telp_mitra, tb_kasus.updated_at
		FROM tb_kasus INNER JOIN tb_mitra ON tb_kasus.id_mitra = tb_mitra.id_mitra INNER JOIN tb_status_kasus ON tb_kasus.status = tb_status_kasus.id_status_kasus WHERE tb_mitra.id_mitra = '$id_mitra' 
		";
$result = mysqli_query($con, $cek);
if (isset($result)) {
	while ($row = mysqli_fetch_all($result, MYSQLI_ASSOC)) {
		$data['data'] = $row;
	}
	$data['message'] = 'Data ditemukan';
	echo json_encode($data);
} else {
	$data['message'] = "Data tidak ditemukan";
	echo json_encode($data);
}

$con->close();
