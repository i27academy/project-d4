# Creating a cloudsql(Mysql) database

resource "google_sql_database_instance" "tf_sql_instance" {
    name = "i27-db-instance"
    region = "us-central1"
    database_version = "MYSQL_8_0"   
    settings  {
       tier=  "db-custom-1-3840" # 1 cpu, 3.75 gb ram
       ip_configuration {
         ipv4_enabled = true
         authorized_networks {
            name = "allow-all"
            value = "0.0.0.0/0"
         }
       }
       disk_size = "10"
    }
}

# Create a database 
resource "google_sql_database" "database" {
  name     = "learnerCrownClothing"
  instance = google_sql_database_instance.tf_sql_instance.name
}
