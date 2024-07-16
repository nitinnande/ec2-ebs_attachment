data "aws_ami" "myami" {
  most_recent      = true
  

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }


  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  
}
resource "aws_security_group" "allow_tls" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.main.id
  ingress {
    description = "ssh connection"
    from_port        = 22
    to_port          = 22
    protocol         = "ssh"
    cidr_blocks      = ["0.0.0.0/0"]
    }

   egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
    }
   


  tags = {
    Name = "allow_tls"
  }
}
resource "aws_instance" "myinstance" {
  ami           = data.aws_ami.myami.id
  instance_type = "t2.micro"
  security_groups = [aws_security_group.allow_tls.name]
  availability_zone = "ap-south-1a"
  key_name = "ni3"
  root_block_device {
    volume_size = "50"
    volume_type = "gp2"
  }
  


  tags = {
    Name = "myinstances"
  }
}
resource "aws_ebs_volume" "myvol" {
  availability_zone = "ap-south-1a"
  size              = "40"
  device_name = "/dev/xvdh"

  tags = {
    Name = "HelloWorld"
  }
}
resource "aws_volume_attachment" "ebs_att" {
  device_name = "/dev/xvdh"
  volume_id   = aws_ebs_volume.myvol.id
  instance_id = aws_instance.myinstance.id
}

