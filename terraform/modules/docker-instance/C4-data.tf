data "tls_public_key" "private_key_openssh" {
    private_key_openssh = tls_private_key.private_key.private_key_openssh
}
# data "aws_key_pair" "key_pair" {
#     key_name = var.key_pair_name
# }

output "private_key_openssh" {
    value = tls_private_key.private_key.private_key_openssh
}