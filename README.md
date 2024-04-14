# Terraform Project
Terraform Custom VPC


### S3 (Backend)
- init
```shell
(cd src/global && terraform init)
```
- plan
```shell
(cd src/global && terraform plan)
```
- apply
```shell
(cd src/global && terraform apply)
```

<br>  

### Web Service 구성
- init
```shell
(cd src/stage/service/webserver-cluster && terraform init)
```
- plan
```shell
(cd src/stage/service/webserver-cluster && terraform plan)
```
- apply
```shell
(cd src/stage/service/webserver-cluster && terraform apply) 
```

<br>

### Database 구성
DB 구성 전 AWS Secrets Manager 키 생성 필요  
> 사용한 암호명 : "mysql-master-password-stage"  
> 사용한 암호의 키값 : "mysql"

- init
```shell
(cd src/stage/data-stores/mysql && terraform init)
```
- plan
```shell
(cd src/stage/data-stores/mysql && terraform plan)
```
- apply
```shell
(cd src/stage/data-stores/mysql && terraform apply)
```

---
### 구성한 인프라 제거
- Web Service Destroy
```shell
(cd src/stage/service/webserver-cluster && terraform destroy)
```
- Database Destroy
```shell
(cd src/stage/data-stores/mysql && terraform destroy)
```
- S3 Backend Destroy
```shell
(cd src/global && terraform destroy)
```