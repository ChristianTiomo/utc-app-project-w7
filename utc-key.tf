# Generate a new SSH key pair
resource "tls_private_key" "ec2_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

# Create AWS Key Pair
resource "aws_key_pair" "deployer_key" {
  key_name   = "utc-key"
  public_key = tls_private_key.ec2_key.public_key_openssh
}

# Save file locally
resource "local_file" "private_key_pem" {
  filename = "utc-key.pem"
  content  = tls_private_key.ec2_key.private_key_pem

}