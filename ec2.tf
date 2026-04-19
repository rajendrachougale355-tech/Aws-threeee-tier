# EC2 for Web Layer (Nginx)
resource "aws_instance" "web_server" {
  ami           = "ami-05d2d839d4f73aafb" # Ubuntu 22.04 in ap-south-1
  instance_type = "t3.micro"
  subnet_id     = aws_subnet.public_subnet.id
  security_groups = [aws_security_group.web_sg.id]
  key_name      = "Project_key"  # Replace with your key pair
  associate_public_ip_address = true    


  user_data = <<-EOF
              #!/bin/bash
              apt update -y
              apt install nginx -y
              systemctl enable nginx
              systemctl start nginx
              echo "<h1>Welcome to Web Layer</h1>" > /var/www/html/index.html
              EOF

  tags = {
    Name = "web-server"
  }
}

# EC2 for App Layer (Tomcat)
resource "aws_instance" "app_server" {
  ami           = "ami-05d2d839d4f73aafb" # Ubuntu 22.04
  instance_type = "t3.micro"
  subnet_id     = aws_subnet.private_app_subnet.id
  security_groups = [aws_security_group.app_sg.id]
  key_name      = "Project_key"

  user_data = <<-EOF
              #!/bin/bash
              apt update -y
              apt install default-jdk -y
              apt install tomcat9 -y
              apt install mysql-client -y
              echo "jdbc:mysql://${aws_instance.mysql_server.private_ip}:3306/mydb?user=admin&password=Rajendra@123" > /etc/tomcat9/db.properties

              systemctl enable tomcat9
              systemctl start tomcat9
              echo "<h1>Welcome to App Layer</h1>" > /var/lib/tomcat9/webapps/ROOT/index.jsp
              EOF

  tags = {
    Name = "app-server"
  }
}
# Bastion Host (Jump Box)
resource "aws_instance" "bastion" {
  ami           = "ami-05d2d839d4f73aafb" # Ubuntu 22.04
  instance_type = "t3.micro"          # Free Tier eligible
  subnet_id     = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.web_sg.id]  # allow SSH from your IP
  associate_public_ip_address = true
  key_name = "Project_key"
  
  tags = {
    Name = "bastion-host"
  }

  
   # replace with your EC2 key pair name
}
