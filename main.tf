# creating vpc
resource "aws_vpc" "vpc" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"

  tags = {
    Name = "${local.name}-vpc"
  }
}

# public subnet1
resource "aws_subnet" "pub-subnet1" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.pub-sub1_cidr
  availability_zone = var.az1

  tags = {
    Name = "${local.name}-public-subnet1"
  }
}

#public subnet2
resource "aws_subnet" "pub-subnet2" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.pub-sub2_cidr
  availability_zone = var.az2

  tags = {
    Name = "${local.name}-public-subnet2"
  }
}

#private subnet1
resource "aws_subnet" "prv-subnet1" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.prv1_cidr
  availability_zone = var.az1

  tags = {
    Name = "${local.name}-private-subnet1"
  }
}

#private subnet 2
resource "aws_subnet" "prv-subnet2" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.prv2_cidr
  availability_zone = var.az2

  tags = {
    Name = "${local.name}-private-subnet2"
  }
}


# Internet gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${local.name}-igw"
  }
}

# Allocate Elastic IP Address (EIP)
resource "aws_eip" "eip" {
  domain = "vpc"

  tags = {
    Name = "${local.name}-eip"
  }
}

# Nat gateway
resource "aws_nat_gateway" "ngw" {
  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.pub-subnet1.id

  tags = {
    Name = "${local.name}-nat-gw"
  }
}

#public route table
resource "aws_route_table" "pub-rt" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = var.cidr_all
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${local.name}-pub-rt"
  }
}

#private route table
resource "aws_route_table" "prv-rt" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = var.cidr_all
    gateway_id = aws_nat_gateway.ngw.id
  }

  tags = {
    Name = "${local.name}-priv-rt"
  }
}

#Route table associations
resource "aws_route_table_association" "rta-pub1" {
  subnet_id      = aws_subnet.pub-subnet1.id
  route_table_id = aws_route_table.pub-rt.id
}

resource "aws_route_table_association" "rta-pub2" {
  subnet_id      = aws_subnet.pub-subnet2.id
  route_table_id = aws_route_table.pub-rt.id
}

resource "aws_route_table_association" "rta-prv1" {
  subnet_id      = aws_subnet.prv-subnet1.id
  route_table_id = aws_route_table.prv-rt.id
}

resource "aws_route_table_association" "rta-prv2" {
  subnet_id      = aws_subnet.prv-subnet2.id
  route_table_id = aws_route_table.prv-rt.id
}


# Security group for jenkins
resource "aws_security_group" "Jenkins-SG" {
  name        = "Jenkins-SG"
  description = "Allow Jenkins Traffic"
  vpc_id      = aws_vpc.vpc.id


  ingress {
    description = "Port traffic"
    from_port   = var.port_proxy
    to_port     = var.port_proxy
    protocol    = "tcp"
    cidr_blocks = [var.all-cidr]
  }

  ingress {
    description = "Alow ssh traffic"
    from_port   = var.port_ssh
    to_port     = var.port_ssh
    protocol    = "tcp"
    cidr_blocks = [var.all-cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.all-cidr]
  }
  tags = {
    Name = "${local.name}-Jenkins-sg"
  }
}

# Security Group for SonarQube Server
resource "aws_security_group" "sonar-SG" {
  name        = "sonar_sg"
  description = "sonar_sg"
  vpc_id      = aws_vpc.vpc.id

  # Inbound rules
  ingress {
    description = "ssh access"
    from_port   = var.port_ssh
    to_port     = var.port_ssh
    protocol    = "tcp"
    cidr_blocks = [var.all-cidr]
  }

  ingress {
    description = "Sonarqube port"
    from_port   = var.port_sonar
    to_port     = var.port_sonar
    protocol    = "tcp"
    cidr_blocks = [var.all-cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.all-cidr]
  }
  tags = {
    Name = "${local.name}-Sonarqube_SG"
  }
}

# Nexus Security Group
resource "aws_security_group" "nexus-SG" {
  name        = "nexus-SG"
  description = "Nexus Security Group"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description = "ssh port"
    from_port   = var.port_ssh
    to_port     = var.port_ssh
    protocol    = "tcp"
    cidr_blocks = [var.all-cidr]
  }

  ingress {
    description = "nexus port"
    from_port   = var.port_nexus
    to_port     = var.port_nexus
    protocol    = "tcp"
    cidr_blocks = [var.all-cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.all-cidr]
  }
  tags = {
    Name = "${local.name}-Nexus-sg"
  }
}

# Bastion and ansible security groups
resource "aws_security_group" "bastion-ansible-SG" {
  name        = "bastion-ansible-sg"
  description = "Bastion and Ansible Security Groups"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description = "bastion-ansible ssh port"
    from_port   = var.port_ssh
    to_port     = var.port_ssh
    protocol    = "tcp"
    cidr_blocks = [var.all-cidr]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.all-cidr]
  }
  tags = {
    Name = "${local.name}-Bastion-Ansible-sg"
  }
}

# Docker security groups
resource "aws_security_group" "docker-SG" {
  name        = "docker-SG"
  description = "Docker Security Group"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description = "docker ssh port"
    from_port   = var.port_ssh
    to_port     = var.port_ssh
    protocol    = "tcp"
    cidr_blocks = [var.all-cidr]
  }

  ingress {
    description = "docker port proxy"
    from_port   = var.port_proxy
    to_port     = var.port_proxy
    protocol    = "tcp"
    cidr_blocks = [var.all-cidr]
  }

  ingress {
    description = "http port"
    from_port   = var.port_http
    to_port     = var.port_http
    protocol    = "tcp"
    cidr_blocks = [var.all-cidr]
  }

  ingress {
    description = "https port"
    from_port   = var.port_https
    to_port     = var.port_https
    protocol    = "tcp"
    cidr_blocks = [var.all-cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.all-cidr]
  }
  tags = {
    Name = "${local.name}-Docker-sg"
  }
}

# Mysql Security Group
resource "aws_security_group" "mysql-SG" {
  name        = "mysql-sg"
  description = "Mysql Security Group"
  vpc_id      = aws_vpc.vpc.id


  ingress {
    description     = "mysql port"
    from_port       = var.port_mysql
    to_port         = var.port_mysql
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion-ansible-SG.id, aws_security_group.docker-SG.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.all-cidr]
  }
  tags = {
    Name = "${local.name}-Mysql-sg"
  }
}

# dynamic keypair resource
resource "tls_private_key" "keypair" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "private_key" {
  content         = tls_private_key.keypair.private_key_pem
  filename        = "${local.name}-private-key.pem"
  file_permission = "600"
}

resource "local_file" "public_key_file" {
  content         = tls_private_key.keypair.public_key_openssh
  filename        = "${local.name}-public-key.pem"
  file_permission = "600"
}

resource "aws_key_pair" "public_key" {
  key_name   = "${local.name}-public-key.pub"
  public_key = tls_private_key.keypair.public_key_openssh
}

# Docker server
resource "aws_instance" "docker-server" {
  ami                    = var.red_hat
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.prv-subnet1.id
  key_name               = aws_key_pair.public_key.id
  vpc_security_group_ids = [aws_security_group.docker-SG.id]
  user_data              = templatefile("./user-data/docker-script.sh",{
  privatekey = tls_private_key.keypair.key_name,
  newrelic-license-key = var.newrelic-license-key,
  acct-id = var.newrelic-acct-id
})

  tags = {
    Name = "${local.name}-docker"
  }
}

# create bastion host server
resource "aws_instance" "bastion" {
  ami                         = var.red_hat
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.public-subnet1.id
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.bastion-ansible.id]
  key_name                    = aws_key_pair.public_key.id
  user_data                   = templatefile("./user-data/bastion-script.sh",{
  privatekey = tls_private_key.keypair.key_name,
})
  tags = {
    Name = "${local.name}-bastion"
  }
}
#create ansible server
resource "aws_instance" "ansible-server" {
  ami                         = var.red_hat
  instance_type               = "t2.micro"
  vpc_security_group_ids      = [aws_security_group.bastion-ansible.id]
  subnet_id                   = aws_subnet.public-subnet2.id
  associate_public_ip_address = true
  key_name                    = aws_key_pair.public_key.key_name
  user_data                   = templatefile("./user-data/ansible-script.sh",{
  privatekey = tls_private_key.keypair.key_name,
  Docker-host-ip = aws_instance.docker-server.private_ip,
  Nexus-ip = aws_instance.nexus.private_ip,
  newrelic-license-key = var.newrelic-license-key,
  acct-id = var.newrelic-acct-id
})
  tags = {
    name = "${local.name}-ansible-server"
  }
}
#Create nexus server
resource "aws_instance" "nexus" {
  ami                         = var.red_hat
  instance_type               = "t2.medium"
  associate_public_ip_address = true
  subnet_id                   = aws_subnet.public-subnet1.id
  key_name                    = aws_key_pair.public_key.id
  vpc_security_group_ids      = [aws_security_group.nexus-SG.id]
  user_data                   = ("./user-data/nexus-script.sh")
  tags = {
    Name = "${local.name}-nexus"
  }
}
resource "aws_db_subnet_group" "db_subnet" {
  name       = "db-subnet-group"
  subnet_ids = [aws_subnet.private-subnet1.id, aws_subnet.private-subnet2.id]

  tags = {
    Name = "${local.name}-db-sg"
  }
}

resource "aws_db_instance" "petclinic-db" {
  identifier             = var.db-identifier
  db_subnet_group_name   = aws_db_subnet_group.db_subnet.name
  vpc_security_group_ids = [aws_security_group.mysql-sg.id]
  allocated_storage      = 10
  db_name                = var.db-name
  engine                 = "mysql"
  engine_version         = "5.7"
  instance_class         = "db.t3.micro"
  username               = var.db-username
  password               = var.db-password
  parameter_group_name   = "default.mysql5.7"
  skip_final_snapshot    = true
  publicly_accessible    = false
  storage_type           = "gp2"
}

