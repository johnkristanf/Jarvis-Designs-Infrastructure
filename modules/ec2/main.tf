data "aws_ami" "ubuntu_latest" {
  most_recent = true
  owners      = ["099720109477"] # Canonical's AWS account ID

  # Use filters to match the latest Ubuntu Noble 24.04 LTS 64-bit Server HVM SSD AMI
  filter {
    name   = "name"
    # Replace noble-24.04 with the appropriate version if you need a different release
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}



# EC2 Key Pair (SSH usage)
resource "aws_key_pair" "web_server_kp" {
  key_name   = "jarvis-designs-kp"
  public_key = file("jd-key-pair.pub") // This file will be mounted inside the terraform docker container
}

resource "aws_instance" "server" {
  ami           = data.aws_ami.ubuntu_latest.id
  region        = var.region
  instance_type = var.instance_type
  subnet_id     = var.public_subnet_id

  associate_public_ip_address = true
  key_name                    = aws_key_pair.web_server_kp.key_name
  vpc_security_group_ids      = [var.web_server_sg_id]

  iam_instance_profile = var.instance_profile_name

  root_block_device {
    volume_size = 30
    volume_type = "gp3"
    delete_on_termination = true
    encrypted = true

    tags = {
      Name = "Jarvis Designs Root Volume"
    }
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
  tags = {
    Name = "Web server main elastic IP"
  }
}