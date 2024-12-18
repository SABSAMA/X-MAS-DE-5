provider "aws" {
  region = "eu-west-3"
}

resource "aws_ebs_volume" "my_volume" {
  availability_zone = "eu-west-3a"  # Remplace par la zone de disponibilité appropriée
  size              = 25             # Taille du volume en Go
}

# Génération de la clé privée
resource "tls_private_key" "example" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Enregistrement de la clé publique sur AWS
resource "aws_key_pair" "example_key" {
  key_name   = "example-key"
  public_key = tls_private_key.example.public_key_openssh
}


# Groupe de sécurité pour autoriser le SSH, ainsi que les ports 8000 et 5000
resource "aws_security_group" "allow_ssh_and_ports" {
  name        = "allow_ssh_and_ports"
  description = "Allow SSH, port 8000 and port 5000 inbound traffic"
  vpc_id      = "vpc-014fc495b3068f0f7"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Autorisation pour le port 8000
  ingress {
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Autorisation pour le port 5000
  ingress {
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


# Instance EC2
resource "aws_instance" "example" {
  ami             = "ami-07dc1ccdcec3b4eab"
  instance_type   = "t2.micro"
  key_name        = aws_key_pair.example_key.key_name
  security_groups = [aws_security_group.allow_ssh_and_ports.name]

  root_block_device {
    volume_size = 25  # Taille du disque principal (25 Go)
  }

  tags = {
    Name = "mlops-instance-europe"
  }
}

# Sauvegarder la clé privée dans un fichier local
resource "local_file" "private_key" {
  filename = "${path.module}/example-key.pem"
  content  = tls_private_key.example.private_key_pem
  file_permission = "0600"
}

# Sorties : adresse IP publique et clé privée
output "instance_public_ip" {
  value = aws_instance.example.public_ip
}

output "private_key_path" {
  value = local_file.private_key.filename
}
