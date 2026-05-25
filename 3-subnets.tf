############################################
# Karpenter Subnet Tags
############################################

# private subnet 01

resource "aws_subnet" "private-us-east-1a" {
  vpc_id            = aws_vpc.k8svpc.id
  cidr_block        = "192.168.0.0/19"
  availability_zone = "us-east-1a"

  tags = {
    Name = "private-us-east-1a"

    # EKS internal load balancer
    "kubernetes.io/role/internal-elb" = "1"

    # EKS cluster ownership
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"

    # Karpenter discovery
    "karpenter.sh/discovery" = var.cluster_name
  }
}

############################################
# private subnet 02
############################################

resource "aws_subnet" "private-us-east-1b" {
  vpc_id            = aws_vpc.k8svpc.id
  cidr_block        = "192.168.32.0/19"
  availability_zone = "us-east-1b"

  tags = {
    Name = "private-us-east-1b"

    # EKS internal load balancer
    "kubernetes.io/role/internal-elb" = "1"

    # EKS cluster ownership
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"

    # Karpenter discovery
    "karpenter.sh/discovery" = var.cluster_name
  }
}

############################################
# public subnet 01
############################################

resource "aws_subnet" "public-us-east-1a" {
  vpc_id                  = aws_vpc.k8svpc.id
  cidr_block              = "192.168.64.0/19"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "public-us-east-1a"

    # Public ELB subnet
    "kubernetes.io/role/elb" = "1"

    # EKS cluster ownership
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"

    # Optional for Karpenter
    "karpenter.sh/discovery" = var.cluster_name
  }
}

############################################
# public subnet 02
############################################

resource "aws_subnet" "public-us-east-1b" {
  vpc_id                  = aws_vpc.k8svpc.id
  cidr_block              = "192.168.96.0/19"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = "public-us-east-1b"

    # Public ELB subnet
    "kubernetes.io/role/elb" = "1"

    # EKS cluster ownership
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"

    # Optional for Karpenter
    "karpenter.sh/discovery" = var.cluster_name
  }
}
