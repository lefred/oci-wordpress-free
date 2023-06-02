output "wordpress_public_ip" {
  value = "http://${module.wordpress.public_ip}"
}

output "wordpress_db_user" {
  value = var.wp_name
}

output "wordpress_db_password" {
  value = var.wp_password
}

output "ssh_private_key" {
  value = local.private_key_to_show
  sensitive = true
}
