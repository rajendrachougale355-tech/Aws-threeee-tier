# DB Server (MySQL on EC2 instead of RDS)
resource "aws_instance" "mysql_server" {
 ami           = "ami-05d2d839d4f73aafb" 
  instance_type = "t3.micro"               
  subnet_id     = aws_subnet.private_db_subnet.id
  vpc_security_group_ids = [aws_security_group.db_sg.id]
  associate_public_ip_address = false       
   key_name      = "Project_key"

  tags = {
    Name = "mysql-server"
  }
  

  user_data = <<-EOF
              #!/bin/bash
              apt-get update -y
              apt-get install -y mysql-server
              systemctl enable mysql
              systemctl start mysql
              mysql -e "CREATE USER 'admin'@'%' IDENTIFIED BY 'Rajendra@123';"
              mysql -e "GRANT ALL PRIVILEGES ON *.* TO 'admin'@'%';"
              mysql -e "FLUSH PRIVILEGES;"
              EOF
}
output "mysql_private_ip" {
  value = aws_instance.mysql_server.private_ip
}
