resource "aws_secretsmanager_secret" "db_secret" {
  name = "three-tier-db-secret"
}

resource "aws_secretsmanager_secret_version" "db_secret_value" {
  secret_id     = aws_secretsmanager_secret.db_secret.id
  secret_string = jsonencode({
    username = "admin"
    password = "Rajendra@123"
  })
}
