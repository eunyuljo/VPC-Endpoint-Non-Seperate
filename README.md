## 목적 및 설명

![Image](https://github.com/user-attachments/assets/7a1e0367-739b-4078-af81-dc299ea31658)


하나의 VPC 내 Endpoint를 생성했을 경우를 보여줍니다.
- 하나의 ECR, DKR 엔드포인트를 운영했을 경우 권한을 분리하는 방법에 대해 다룹니다.
---

## 🔧 인프라 구성
- **VPC** (CIDR: 10.0.0.0/16)
- **Subnet**
  - 서비스 A: `ap-northeast-2a`, `ap-northeast-2c`
  - 서비스 B: `ap-northeast-2a`, `ap-northeast-2c`
  - Common : `ap-northeast-2a`, `ap-northeast-2c`
- **ECS 클러스터**
  - 서비스 A (ECR `service-a-repo` 사용)
  - 서비스 B (ECR `service-a-repo` 사용)
- **ECR**
  - `service-a-repo`: 
  - `service-b-repo`: 
- **VPC 엔드포인트**
  - ECR, S3, SSM 엔드포인트 포함
- **IAM Role**
  - 하나의 ECR, DKR 엔드포인트를 운영했을 경우 권한을 분리하는 방법