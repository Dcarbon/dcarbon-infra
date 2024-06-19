locals {
  current-time = replace(timestamp(), "/[-| |T|Z|:]/", "")
  key-name = "${var.KEY_NAME}-${local.current-time}"
}

resource "tls_private_key" "pk" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "ec2-key" {
  key_name   = local.key-name
  public_key = tls_private_key.pk.public_key_openssh

  provisioner "local-exec" {

    command = <<EOF
      echo '${tls_private_key.pk.private_key_pem}' > ${var.KEY_PATH}/${local.key-name}.pem
      chmod 400 ${var.KEY_PATH}/${local.key-name}.pem
    EOF
  }
}

resource "aws_instance" "ec2-instance" {
  ami           = var.AMI
  instance_type = var.INSTANCE_TYPE
  key_name      = aws_key_pair.ec2-key.key_name

  subnet_id = var.SUBNET_ID
  security_groups = var.SECURITY_GROUPS

  ebs_block_device {
    device_name = "/dev/xvda"
    volume_size = var.VOLUME_SIZE
    volume_type = var.VOLUME_TYPE
    delete_on_termination = var.DELETE_ON_TERMINATION
  }

  tags         = merge({
    Name    = "${var.PROJECT_NAME}-${var.ENV}-${var.PROJECT_SERVICE_TYPE}"
    Service = var.PROJECT_SERVICE_TYPE
  }, var.TAGS)

#  provisioner "local-exec" {
#    command = "echo ${aws_instance.example.private_ip} >> private_ips.txt"
#  }
  provisioner "file" {
    source      = "${path.module}/${var.SCRIPT_FILE_NAME}"
    destination = "/tmp/${var.SCRIPT_FILE_NAME}"
  }

  provisioner "file" {
    source      = "${path.module}/${var.SOURCE_FILE_NAME}"
    destination = "/tmp"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/${var.SCRIPT_FILE_NAME}",
      "sudo sed -i -e 's/\r$//' /tmp/${var.SCRIPT_FILE_NAME}",
      "sudo /tmp/${var.SCRIPT_FILE_NAME}",
    ]
  }
  connection {
    host        = coalesce(self.public_ip, self.private_ip)
    type        = "ssh"
    user        = "ec2-user"
    private_key = file("${var.KEY_PATH}/${local.key-name}.pem")
  }
}

