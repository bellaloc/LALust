<?php
$contact_name = $_POST['name'];
$contact_phone = $_POST['phone'];
$contact_email = $_POST['email'];
$contact_subject = $_POST['subject'];
$contact_message = $_POST['message'];

if( $contact_name == true )
{
$sender = $contact_email;

//your e-mail here :)
$receiver = "yourmail@mailserv";

$client_ip = $_SERVER['REMOTE_ADDR'];
$email_body = "Name: $contact_name \nPhone: $contact_phone \n\nEmail: $sender \n\nSubject: $contact_subject \n\nMessage: \n\n$contact_message \n\nIP: $client_ip \n\nFlash Contact Form provided by http://www.site.com"; //enter your site
$extra = "From: $sender\r\n" . "Reply-To: $sender \r\n" . "X-Mailer: PHP/" . phpversion();

if( mail( $receiver, "Flash Contact Form - $contact_subject", $email_body, $extra ) ) 
{
 echo "success=yes";
}
else
{
 echo "success=no";
}
}
?>

