data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] // Canonical's (company created ubuntu) AWS account ID for Ubuntu Images

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}


# EC2 Key Pair (SSH usage)
resource "aws_key_pair" "web_server_kp" {
  key_name   = "jarvis-designs-kp"
  public_key = file("~/.ssh/jd-key-pair.pub")
}

resource "aws_instance" "server" {
  ami           = data.aws_ami.ubuntu.id
  region        = var.region
  instance_type = var.instance_type
  subnet_id     = var.subnet_id

  associate_public_ip_address = true
  key_name                    = aws_key_pair.web_server_kp.key_name
  vpc_security_group_ids      = [var.web_server_sg_id]

  iam_instance_profile = var.instance_profile_name

  root_block_device {
    volume_size = 30
    volume_type = "gp3"
    delete_on_termination = true
    encrypted = true
  }


  # Only use this extra EBS volume if you separate the scaling of OS and application data

  # ebs_block_device {
  #   device_name           = "/dev/sdh"
  #   volume_size           = 50
  #   volume_type           = "gp3"
  #   delete_on_termination = true
  # }

  monitoring = true
  tags = {
    Name = "Jarvis Designs"
  }
}

# ELASTIC IP ADDRESS
resource "aws_eip" "web_server_eip" {
  instance = aws_instance.server.id
}