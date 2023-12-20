<!-- <?php
require "../connect.php";

	$email = $_GET['email'];
	
	$cek = "SELECT * FROM users INNER JOIN tb_jnskel ON users.jns_kelamin = tb_jnskel.id_jnskel WHERE users.email='$email'";
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
?> -->
<?php
require "../connect.php";

	$email = $_GET['email'];
	
	$cek = "SELECT users.id_users, users.nama_user, users.nik, users.id_mitra, tb_jnskel.jns_kelamin, users.alamat, users.tgl_lahir,users.no_tlp, users.email, users.password, users.status, users.role, users.fotoktp
	
	FROM users INNER JOIN tb_jnskel ON users.jns_kelamin = tb_jnskel.id_jnskel WHERE users.email='$email'";
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