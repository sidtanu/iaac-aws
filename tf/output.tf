output "public_ip" {
  value = "${aws_instance.IAAC.public_ip}"
}
