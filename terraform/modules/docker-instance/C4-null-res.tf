resource "null_resource" "deploy_docker_compose" {
  connection {
    type        = "ssh"
    host        = aws_instance.ec2_instance.public_ip
    user        = "ec2-user"
    private_key = file(local_file.tf_key.filename)
    timeout = "2m"
  }

  for_each = { for idx, f in var.files_to_copy : idx => f }
  provisioner "file" {
    source      = each.value.source
    destination = each.value.destination
  }


  provisioner "remote-exec" {
    inline = [
      "cd /home/ec2-user",
      "echo '\nINSTANCE_PUBLIC_IP=${aws_instance.ec2_instance.public_ip}' >> /home/ec2-user/.env",
      var.monitor_instance_private_ip != null ? "\necho 'MONITOR_INSTANCE_PRIVATE_IP=${var.monitor_instance_private_ip}' >> /home/ec2-user/.env": "echo ''",
      "export DOCKER_USERNAME=${var.DOCKER_USERNAME}",
      "export DOCKER_PASSWORD=${var.DOCKER_PASSWORD}",
      "sudo docker login -u $DOCKER_USERNAME -p $DOCKER_PASSWORD",
      "sudo docker compose --env-file './.env' -f './Docker-compose.yaml' up -d --quiet-build --quiet-pull"
    ]
  }
  depends_on = [
    aws_instance.ec2_instance,
    local_file.tf_key
  ]
}
