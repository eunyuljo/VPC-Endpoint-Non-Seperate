provider "aws" {
  region = "ap-northeast-2" # 서울 리전
}

# VPC 생성
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

  enable_dns_support   = true  
  enable_dns_hostnames = true 

  tags = {
    Name = "main-vpc"
  }
}


#############################################################################################################################################

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main-igw"
  }
}


# 탄력적 IP (EIP) 생성
resource "aws_eip" "nat" {
  domain = "vpc"
  tags = {
    Name = "nat-eip"
  }
}

# NAT Gateway 생성
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id  # 탄력적 IP 연결
  subnet_id     = aws_subnet.public_az_a.id  # 퍼블릭 서브넷에 생성
  connectivity_type = "public"  # (기본값) 퍼블릭 NAT Gateway 생성

  tags = {
    Name = "nat-gateway"
  }
}


#############################################################################################################################################

# Subnet 생성 (각 서비스용 Private Subnet)
resource "aws_subnet" "public_az_a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.100.0/24"
  availability_zone = "ap-northeast-2a"

  tags = {
    Name = "public-az-a"
  }
}

resource "aws_subnet" "public_az_c" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.101.0/24"
  availability_zone = "ap-northeast-2c"

  tags = {
    Name = "public-az-c"
  }
}


# Subnet 생성 (각 서비스용 Private Subnet)
resource "aws_subnet" "service_a_private_az_a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "ap-northeast-2a"

  tags = {
    Name = "service-a-private-az-a"
  }
}

resource "aws_subnet" "service_a_private_az_c" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "ap-northeast-2c"

  tags = {
    Name = "service-a-private-az-c"
  }
}

# Subnet 생성 (각 서비스용 Private Subnet)
resource "aws_subnet" "service_b_private_az_a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "ap-northeast-2a"

  tags = {
    Name = "service-b-private-az-a"
  }
}

resource "aws_subnet" "service_b_private_az_c" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.4.0/24"
  availability_zone = "ap-northeast-2c"

  tags = {
    Name = "service-b-private-az-c"
  }
}

# Subnet 생성 (각 서비스용 Private Subnet)
resource "aws_subnet" "common_private_az_a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.5.0/24"
  availability_zone = "ap-northeast-2a"

  tags = {
    Name = "common-private-az-a"
  }
}

resource "aws_subnet" "common_private_az_c" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.6.0/24"
  availability_zone = "ap-northeast-2c"

  tags = {
    Name = "common-private-az-c"
  }
}


#############################################################################################################################################

resource "aws_vpc_endpoint" "ecr_service_a" {
  vpc_id            = aws_vpc.main.id
  service_name      = "com.amazonaws.ap-northeast-2.ecr.dkr"
  vpc_endpoint_type = "Interface"
  subnet_ids        = [aws_subnet.service_a_private_az_a.id, aws_subnet.service_a_private_az_c.id]
  security_group_ids = [aws_security_group.ecr_sg_a.id]
  private_dns_enabled = true

  tags = {
    Name = "ecr-endpoint-service-a"
  }
}

resource "aws_vpc_endpoint" "ecr_api_service_a" {
  vpc_id            = aws_vpc.main.id
  service_name      = "com.amazonaws.ap-northeast-2.ecr.api"
  vpc_endpoint_type = "Interface"
  subnet_ids        = [aws_subnet.service_a_private_az_a.id, aws_subnet.service_a_private_az_c.id]
  security_group_ids = [aws_security_group.ecr_sg_a.id]
  private_dns_enabled = true

  tags = {
    Name = "ecr-api-endpoint-service-a"
  }
}


# SSM 엔드포인트 (Interface)
resource "aws_vpc_endpoint" "ssm" {
  vpc_id            = aws_vpc.main.id
  service_name      = "com.amazonaws.ap-northeast-2.ssm"
  vpc_endpoint_type = "Interface"
  subnet_ids        = [aws_subnet.common_private_az_a.id, aws_subnet.common_private_az_c.id]
  security_group_ids = [aws_security_group.ssm_sg.id]
  private_dns_enabled = true

  tags = {
    Name = "ssm-endpoint-common"
  }
}

# SSM 메시지 엔드포인트
resource "aws_vpc_endpoint" "ssm_messages" {
  vpc_id            = aws_vpc.main.id
  service_name      = "com.amazonaws.ap-northeast-2.ssmmessages"
  vpc_endpoint_type = "Interface"
  subnet_ids        = [aws_subnet.common_private_az_a.id, aws_subnet.common_private_az_c.id]
  security_group_ids = [aws_security_group.ssm_sg.id]
  private_dns_enabled = true

  tags = {
    Name = "ssm-messages-endpoint-common"
  }
}

# EC2 메시지 엔드포인트
resource "aws_vpc_endpoint" "ec2_messages" {
  vpc_id            = aws_vpc.main.id
  service_name      = "com.amazonaws.ap-northeast-2.ec2messages"
  vpc_endpoint_type = "Interface"
  subnet_ids        = [aws_subnet.common_private_az_a.id, aws_subnet.common_private_az_c.id]
  security_group_ids = [aws_security_group.ssm_sg.id]
  private_dns_enabled = true

  tags = {
    Name = "ec2-messages-endpoint-common"
  }
}

# # CloudWatch Logs 엔드포인트 (필요한 경우 추가)
# resource "aws_vpc_endpoint" "logs" {
#   vpc_id            = aws_vpc.main.id
#   service_name      = "com.amazonaws.ap-northeast-2.logs"
#   vpc_endpoint_type = "Interface"
#   subnet_ids        = [aws_subnet.common_private_az_a.id, aws_subnet.common_private_az_c.id]
#   security_group_ids = [aws_security_group.ssm_sg.id]

#   tags = {
#     Name = "logs-endpoint-common"
#   }
# }


# 🔹 S3 VPC 엔드포인트 (Gateway 방식)
resource "aws_vpc_endpoint" "s3" {
  vpc_id       = aws_vpc.main.id
  service_name = "com.amazonaws.ap-northeast-2.s3"
  vpc_endpoint_type = "Gateway"

  route_table_ids = [aws_route_table.private.id]

  tags = {
    Name = "s3-endpoint-common"
  }
}


#############################################################################################################################################

# 퍼블릭 서브넷용 라우트 테이블 (인터넷 연결)
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id  # 인터넷 트래픽을 IGW로 전달
  }

  tags = {
    Name = "public-route-table"
  }
}

# 퍼블릭 서브넷과 라우트 테이블 연결
resource "aws_route_table_association" "public_az_a" {
  subnet_id      = aws_subnet.public_az_a.id
  route_table_id = aws_route_table.public.id
}

# 퍼블릭 서브넷과 라우트 테이블 연결
resource "aws_route_table_association" "public_az_c" {
  subnet_id      = aws_subnet.public_az_c.id
  route_table_id = aws_route_table.public.id
}



resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }

  tags = {
    Name = "private-route-table"
  }
}


# 🔹 프라이빗 서브넷과 라우트 테이블 연결
resource "aws_route_table_association" "common_private_az_a" {
  subnet_id      = aws_subnet.common_private_az_a.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "service_a_private_az_a" {
  subnet_id      = aws_subnet.service_a_private_az_a.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "service_b_private_az_a" {
  subnet_id      = aws_subnet.service_b_private_az_a.id
  route_table_id = aws_route_table.private.id
}




# SSM 엔드포인트용 보안 그룹
resource "aws_security_group" "ssm_sg" {
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"] # 프라이빗 서브넷 내 EC2만 접근 가능
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # 모든 프로토콜 허용
    cidr_blocks = ["0.0.0.0/0"] # 모든 대상 허용 (필요 시 더 제한 가능)
  }

  tags = {
    Name = "ssm-sg"
  }
}





# 보안 그룹 (ECR 엔드포인트 접근 허용)
resource "aws_security_group" "ecr_sg_a" {
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["10.0.1.0/24", "10.0.2.0/24","10.0.3.0/24", "10.0.4.0/24"] # 서비스 A만 접근 가능
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # 모든 프로토콜 허용
    cidr_blocks = ["0.0.0.0/0"] # 모든 대상 허용 (필요 시 더 제한 가능)
  }

  tags = {
    Name = "ecr-sg-service-a"
  }
}


# IAM 정책 - 서비스 A의 ECS만 ECR 서비스 A에 접근 가능
resource "aws_iam_policy" "ecr_policy_a" {
  name        = "ECRPolicyServiceA"
  description = "Allow ECS Service A to access its own ECR"
  
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = "ecr:*"
        Resource = "arn:aws:ecr:ap-northeast-2:626635430480:repository/service-a"
        Condition = {
          StringEquals = {
            "aws:sourceVpc" = aws_vpc.main.id
          }
        }
      }
    ]
  })
}






