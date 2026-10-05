resource "aws_network_acl" "public" {
  vpc_id = aws_vpc.main.id
  
}

resource "aws_network_acl_association" "public_a" {
  subnet_id = aws_subnet.public_a.id
  network_acl_id = aws_network_acl.public.id
}

resource "aws_network_acl_rule" "https_in" {
  network_acl_id = aws_network_acl.public.id

  rule_number = 100
  egress = False
  
  protocol = "tcp"
  rule_action = "allow"

  cidr_block = "0.0.0.0/0"

  from_port = 443
  to_port = 443
}

resource "aws_network_acl_rule" "ephemeral_out" {
  network_acl_id = aws_network_acl.public.id

  rule_number = 100
  egress      = true

  protocol    = "tcp"
  rule_action = "allow"

  cidr_block = "0.0.0.0/0"

  from_port = 1024
  to_port   = 65535
}
