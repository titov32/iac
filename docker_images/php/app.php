<?php
header('Content-Type: application/json');

$hostname = gethostname();
$ip_address = $_SERVER['REMOTE_ADDR'];

echo json_encode([
    'hostname' => $hostname,
    'ip_address' => $ip_address
]);

?>

