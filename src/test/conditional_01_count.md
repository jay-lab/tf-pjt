참고링크:
https://kschoi728.tistory.com/44

### count Parameter를 사용한 조건문
count 매개변수를 사용하면 기본 반복문을 수행할 수 있습니다.


### 테라폼은 if문을 지원하지 않습니다. 그러나 count 매개변수의 특성을 사용하여 동일한 작업을 수행할 수 있습니다.
**Resource 에 count 설정**  
- count = 1 -> 해당 resource의 사본 하나를 얻습니다.
- count = 0 -> 해당 resource 는 만들어지지 않습니다.  

<br/>

---
### ❓ webserver-cluster module 에서 aws_autoscaling_schedule 리소스를 정의하고, 조건부로 일부 사용자에게는 module 를 생성해주고 나머지 사용자에게는 생성해주지 않는 방법
1️⃣ module 의 autoscaling 사용 여부를 지정하는 데 사용할 Boolean 입력 변수를 추가합니다.  
file: modules/services/webserver-cluster/variables.tf
```terraform
variable "enable_autoscaling" {
  description = "If set to true, enable auto scaling"
  type        = bool
}
```

2️⃣ webserver-cluster module 을 업데이트합니다.  
- 📌 conditional logic
  - 👉 var.enable_autoscaling = true -> 각각의 aws_autoscaling_schedule 리소스에 대한 count 매개 변수가 1 로 설정 -> 리소스가 하나씩 생성됩니다.  
  - 👉 var.enable_autoscaling = false -> 각각의 aws_autoscaling_schedule 리소스에 대한 count 매개 변수가 0 로 설정 -> 어떤 리소스도 생성되지 않습니다.


file: modules/services/webserver-cluster/main.tf
```terraform
resource "aws_autoscaling_schedule" "scale_out_during_business_hours" {
  count = var.enable_autoscaling ? 1 : 0

  scheduled_action_name  = "${var.cluster_name}-scale-out-during-business-hours"
  min_size               = 2
  max_size               = 4
  desired_capacity       = 4
  recurrence             = "0 9 * * *"
  autoscaling_group_name = aws_autoscaling_group.example.name
}

resource "aws_autoscaling_schedule" "scale_in_at_night" {
  count = var.enable_autoscaling ? 1 : 0

  scheduled_action_name  = "${var.cluster_name}-scale-in-at-night"
  min_size               = 2
  max_size               = 2
  desired_capacity       = 2
  recurrence             = "0 17 * * *"
  autoscaling_group_name = aws_autoscaling_group.example.name
}
```

3️⃣ enable_autoscaling 을 false 로 설정하여 autoscaling 을 비활성화합니다.    
file: live/**stage**/services/webserver-cluster/main.tf  
*enable_autoscaling = **false***
```terraform
module "webserver_cluster" {
  source = "../../../../modules/services/webserver-cluster"

  cluster_name           = var.cluster_name
  instance_type        = "t2.micro"
  min_size             = 2
  max_size             = 2
  enable_autoscaling   = false
}
```


file: live/**prod**/services/webserver-cluster/main.tf  
*enable_autoscaling = **true***
```terraform
module "webserver_cluster" {
  source = "../../../modules/services/webserver-cluster"

  cluster_name  = "Ssoon-prod"
  instance_type = "t2.micro"
  min_size      = 2
  max_size      = 2
  enable_autoscaling   = true

  custom_tags = {
    Owner     = "team-Ssoon"
    ManagedBy = "terraform"
  }
}
```

<br/>
<br/>

---
### ❓ Boolean 값이 문자열 등의 더 복잡한 비교의 결과인 경우
✅ webserver-cluster module의 일부로 CloudWatch 경보를 생성합니다.  
✔ 특정 지표가 사전 정의된 임곗값을 초과하는 경우 이메일 등을 통해 알리도록 경보를 구성합니다.  


> ※ 평균 CPU 사용률이 5분 동안 90 % 이상인 경우 발생하는 경보  
namespace   = "AWS/EC2"  
metric_name = "CPUUtilization"  
comparison_operator = "GreaterThanThreshold"  
evaluation_periods  = 1  
period              = 300  
statistic           = "Average"  
threshold           = 90  
unit                = "Percent"  
  
<br/>

file: **modules**/services/webserver-cluster/main.tf
```terraform
resource "aws_cloudwatch_metric_alarm" "high_cpu_utilization" {
  alarm_name  = "${var.cluster_name}-high-cpu-utilization"
  namespace   = "AWS/EC2"
  metric_name = "CPUUtilization"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.example.name
  }

  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  period              = 300
  statistic           = "Average"
  threshold           = 90
  unit                = "Percent"
}
```

<br/><br/>

---

### ❓ CPU Credit 은 t 인스턴스에만 적용되는데 var.instance_type 이 문자 't'로 시작하는 경우에만 알람을 생성하는 방법
✅ CPU Credit 부족할 때 발생하는 알람을 추가합니다.  
✔ 조건문을 사용합니다.  
```terraform
# format 함수를 사용 var.instance_type 에서 1번째 문자만 추출합니다.
count = format("%.1s", var.instance_type) == "t" ? 1 : 0
# -> 첫번째 문자가 't'이면 count 을 1로 설정, 아니면 count 을 0으로 설정
```
  
file: **modules**/services/webserver-cluster/main.tf
```terraform
resource "aws_cloudwatch_metric_alarm" "low_cpu_credit_balance" {
  count = format("%.1s", var.instance_type) == "t" ? 1 : 0

  alarm_name = "${var.cluster_name}-low-cpu-credit-balance"
  namespace   = "AWS/EC2"
  metric_name = "CPUCreditBalance"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.example.name
  }

  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 1
  period              = 300
  statistic           = "Minimum"
  threshold           = 10
  unit                = "Count"
}
```