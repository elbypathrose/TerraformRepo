provider "aws" {
access_key = "AKIAZTIMJ7JHPVODYVZA"
secret_key = "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"
region = "${var.region}"
}

resource "aws_instance" "elbytf" {

ami ="ami-06358f49b5839867c"
instance_type="t2.micro"
key_name="${aws_key_pair.TFkey.id}"
tags = {
Name = "elby"
hello = "world"
}

vpc_security_group_ids =["${aws_security_group.elbytfsecgrp.id}"]
provisioner "local-exec" {
when = "create"
command ="echo ${aws_instance.elbytf.public_ip}>smaple.txt"
}

provisioner "chef" {
connection {
host = "${self.public_ip}"
type = "ssh"
user = "ubuntu"
private_key = "${file("C:\\Users\\elby.pathrose\\Documents\\Project\\Terraform\\TF_RSA.pem")}"

}
client_options=["chef_license 'accept'"]
run_list = ["testenv_aws_tf_chef::default"]
recreate_client= true
node_name="elby_node"
server_url = "https://manage.chef.io/organizations/elby"
user_name="elbypathrose"
user_key="${file("C:\\chef\\chef-starter\\chef-repo\\.chef\\elbypathrose.pem")}"
ssl_verify_mode=":verify_none"


}

}

resource "aws_instance" "elbytfw" {

ami ="ami-00b49e2d0e1fc7fad"
instance_type="t2.micro"
key_name="${aws_key_pair.TFkey.id}"
tags = {
Name = "elbywindows"
hello = "world"
}

}

resource "aws_key_pair" "TFkey"{

key_name = "elbykeypair"
public_key="${file("C:\\Users\\elby.pathrose\\Documents\\Project\\Terraform\\TF_RSA.pub")}"

}

resource "aws_security_group" "elbytfsecgrp"{
name = "elbysecgrp"
description = "security grp details"
ingress{
from_port="0"
to_port= "0"
protocol ="-1"
cidr_blocks=["0.0.0.0/0"]
}

egress{
from_port="0"
to_port= "0"
protocol ="-1"
cidr_blocks=["0.0.0.0/0"]
}

}

resource "aws_eip" "elbytfeip"{
tags ={
Name="elbyip"
}
instance = "${aws_instance.elbytf.id}"
}

output "elbyip" {
value = "${aws_instance.elbytf.public_ip}"
}


resource "aws_s3_bucket" "elbybkt"{
bucket = "elby123456"
acl = "private"
force_destroy="true"

}

terraform{
backend "s3"{
bucket= "elby123456"
key= "terraform.tfstate"
region = "eu-west-1"

}

}


