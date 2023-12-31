data "aws_ami" "amimumbai" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}


resource "aws_instance" "web" {
  ami                    = data.aws_ami.amimumbai.id
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.allow_dynamic_sg.id]
  key_name               = "terraform-prov"
  provisioner "file" {
    source      = "conf/myapp.conf"
    destination = "/var/tmp/myapp.conf"
    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file("./terraform-prov.pem")
      host        = self.public_ip
    }
  }
  tags = {
    Name = upper("file-provisioner-ec2")
  }
}
