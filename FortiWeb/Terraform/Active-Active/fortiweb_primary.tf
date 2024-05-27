// FortiWeb-VM active-1 instance

resource "aws_network_interface" "active1eth0" {
  description = "active1-port1"
  subnet_id   = aws_subnet.publicsubnet1.id
  private_ips = [var.active1port1]
}

resource "aws_network_interface" "active1eth1" {
  description       = "active1-port2"
  subnet_id         = aws_subnet.privatesubnet1.id
  private_ips       = [var.active1port2]
  source_dest_check = false
}


resource "aws_network_interface_sg_attachment" "publicattachment" {
  depends_on           = [aws_network_interface.active1eth0]
  security_group_id    = aws_security_group.public_allow.id
  network_interface_id = aws_network_interface.active1eth0.id
}

resource "aws_network_interface_sg_attachment" "internalattachment" {
  depends_on           = [aws_network_interface.active1eth1]
  security_group_id    = aws_security_group.allow_all.id
  network_interface_id = aws_network_interface.active1eth1.id
}

resource "aws_instance" "fwbactive1" {
  //it will use region, architect, and license type to decide which ami to use for deployment
  ami               = var.fwbami[var.region][var.arch][var.license_type]
  instance_type     = var.size
  availability_zone = var.az1
  key_name          = var.keyname
  user_data = templatefile("${var.bootstrap-active1}", {
    type           = "${var.license_type}"
    format         = "${var.license_format}"
    port1_ip       = "${var.active1port1}"
    port1_mask     = "${var.active1port1mask}"
    port2_ip       = "${var.active1port2}"
    port2_mask     = "${var.active1port2mask}"
    adminsport     = "${var.adminsport}"
  })

  root_block_device {
    volume_type = "standard"
    volume_size = "2"
  }

  ebs_block_device {
    device_name = "/dev/sdb"
    volume_size = "30"
    volume_type = "standard"
  }

  network_interface {
    network_interface_id = aws_network_interface.active1eth0.id
    device_index         = 0
  }

  network_interface {
    network_interface_id = aws_network_interface.active1eth1.id
    device_index         = 1
  }

  tags = {
    Name = "FortiWebVM Active1"
  }
}