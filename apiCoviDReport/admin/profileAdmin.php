<?php
require "../connect.php";

	$email = $_GET['email'];
	
	$cek = "SELECT users.id_users, users.nama_user, users.id_mitra, tb_jnskel.jns_kelamin, users.tgl_lahir, users.email, users.password,
	users.status, users.role, tb_mitra.nama, tb_mitra.alamat, tb_mitra.telp_mitra FROM users INNER JOIN tb_jnskel ON users.jns_kelamin = tb_jnskel.id_jnskel INNER JOIN tb_mitra ON users.id_mitra = tb_mitra.id_mitra WHERE users.email='$email'";
	$result = mysqli_query($con, $cek);
	if (isset($result)) {
		while($row = mysqli_fetch_array($result, MYSQLI_ASSOC)) {
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