provider "aws" {
	profile = "default"
	region = "us-west-2"
}

#https://stackoverflow.com/a/53782560
data "http" "current_ip" {
	url = "http://ipv4.icanhazip.com"
}

resource "aws_security_group" "current_net" {
	name = "current_network"
	description = "Allow connections from the current operating network only."
	
	ingress {
		from_port = 0
		to_port = 22
		protocol = "tcp"
		cidr_blocks = ["${chomp(data.http.current_ip.body)}/32"]
	}
	ingress {
		from_port = 0
		to_port = 80
		protocol = "tcp"
		cidr_blocks = ["${chomp(data.http.current_ip.body)}/32"]
	}
	ingress {
		from_port = 0
		to_port = 443
		protocol = "tcp"
		cidr_blocks = ["${chomp(data.http.current_ip.body)}/32"]
	}
	# Ensure to allow all traffic out.
	egress {
		from_port = 0
		to_port = 0
		protocol = "-1"
		cidr_blocks = ["0.0.0.0/0"]
	}
}

resource "aws_instance" "demosrv" {
	# Ubuntu 18.04 in Oregon
	ami = "ami-0d1cd67c26f5fca19"
	instance_type = "t2.micro"
	vpc_security_group_ids = ["${aws_security_group.current_net.id}"]
	key_name = "key2"
}

