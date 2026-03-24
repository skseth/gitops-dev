

# Provision a new database
resource "mysql_database" "app_db" {
  name = "my_new_local_db"
  default_character_set = "utf8mb4"
  default_collation =  "utf8mb4_general_ci"
}

# Optionally, create a user and grant privileges
resource "mysql_user" "app_user" {
  user               = "app_user"
  host               = "localhost"
  plaintext_password = "secure_password"
}

resource "mysql_grant" "app_user_privileges" {
  user       = mysql_user.app_user.user
  host       = mysql_user.app_user.host
  database   = mysql_database.app_db.name
  privileges = ["SELECT", "INSERT", "UPDATE", "DELETE"]
}

# Output the database name and username for easy access
output "database_name" {
  value = mysql_database.app_db.name
}

output "app_username" {
  value = mysql_user.app_user.user
}
