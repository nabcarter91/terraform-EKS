# --- networking/main.tf ---

data "aws_availability_zones" "available" {}

#C'est une ressource Terraform qui génère un nombre entier aléatoire utile pour créer des noms uniques
resource "random_integer" "random" {
  min = 1
  max = 10
}

# Elle mélange les noms des zones de disponibilité disponibles récupérées grâce à la ressource de données aws_availability_zones.
resource "random_shuffle" "public_az" {
  input        = data.aws_availability_zones.available.names
  result_count = var.max_subnet
}

resource "aws_vpc" "project_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "project-vpc"
  }
  lifecycle {
    create_before_destroy = true
  }
}

# crée un certain nombre de sous-réseaux publics (tel que défini par public_sn_count) dans le VPC
resource "aws_subnet" "public_subnets" {
  count                   = var.public_sn_count
  vpc_id                  = aws_vpc.project_vpc.id
  cidr_block              = var.public_cidrs[count.index]
  map_public_ip_on_launch = true
  availability_zone       = random_shuffle.public_az.result[count.index]

  tags = {
    Name = "public-subnet-${count.index + 1}"
  }
}

#Création de la gateway
resource "aws_internet_gateway" "project_igw" {
  vpc_id = aws_vpc.project_vpc.id

  tags = {
    Name = "project-igw"
  }
  lifecycle {
    create_before_destroy = true
  }
}

#Création de la table de routage pour  déterminer où le trafic réseau est dirigé.
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.project_vpc.id

  tags = {
    Name = "public-rt"
  }
}

# Création de la règle de routage pour déterminent où le trafic réseau est dirigé en fonction de sa destination.
resource "aws_route" "default_public_route" {
  route_table_id         = aws_route_table.public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.project_igw.id
}


# Creation d'une ressource  aws_route_table_association, qui associe une sous-réseau à une table de routage spécifique dans AWS.
resource "aws_route_table_association" "public_assoc" {
  count          = var.public_sn_count
  subnet_id      = aws_subnet.public_subnets.*.id[count.index]
  route_table_id = aws_route_table.public_rt.id
}