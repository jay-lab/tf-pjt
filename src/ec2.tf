resource "aws_key_pair" "mykey" {
  key_name   = var.key_pair_name
  public_key = file(var.key_pair_path)
}


resource "aws_instance" "example" {
  ami                    = var.image_id
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.instance.id]
  user_data_replace_on_change = true
  key_name                    = aws_key_pair.mykey.key_name

  user_data = <<-EOF
              #!/bin/bash
              yum -y install httpd
              sed -i 's/Listen 80/Listen ${var.server_port}/' /etc/httpd/conf/httpd.conf
              systemctl enable httpd
              systemctl restart httpd
              echo '<html><h1>Hello World!</h1></html>' > /var/www/html/index.html
              EOF

  tags = {
    Name = "terraform-example"
  }
}