output "web_public_ip" {

    description = "The Public IP Address of the webserver"

    value = aws_eip.tutorial_web_eip[0].public_ip

    depends_on = [aws_eip.tutorial_web_eip]
}

output "web_public_dns" {

    description = "The public DNS address of the web server"

    value = aws_eip.tutorial_web_eip[0].public_dns

    depends_on = [aws_eip.tutorial_web_eip]
  
}

output "database_endpoint" {

    description = "The database endpoint"

    value = aws_db_instance.tutorial_database.address
}

output "database_port" {
    
    description = "The database port"
    
    value = aws_db_instance.tutorial_database.port
  
}