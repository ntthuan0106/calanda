output "app_instance_public_ip" {
  value = module.app_instance.instance_public_ip
}
output "monitor_instance_public_ip" {
  value = module.monitor_instance.instance_public_ip
}