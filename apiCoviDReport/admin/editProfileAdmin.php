
<?php
require "../connect.php";     
    $response = array([
        $nama_user = $_POST['nama_user'],
        $jns_kelamin = $_POST['jns_kelamin'],
        $tgl_lahir = $_POST['tgl_lahir'],
        $email = $_POST['email'],
    ]);

        $insert = "UPDATE users SET users.nama_user = '$nama_user', users.jns_kelamin='$jns_kelamin',
                    users.tgl_lahir='$tgl_lahir' WHERE users.email='$email'";
        if(mysqli_query($con, $insert)){
				$response['message'] = "Berhasil diubah";
				echo json_encode($response);
    		}else{
            $response['message'] = "Gagal diubah";
            echo json_encode($response);
        }
	