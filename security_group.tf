variable "allowed_ports" {
    description = "Allowed ports from/to host"
    #type        = "list"
    default     = ["80", "443", "8080", "8443"]
}
#---------------------------------------------------
# Create security group
#---------------------------------------------------
resource "aws_security_group" "websrv_firewall" {
    name        = "aws_security_group"
    description = "Security Group aws_security_group"
    lifecycle {
        create_before_destroy = true
    }
    # allow traffic for TCP 22
    ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    # allow traffic from  TCP 22
    egress {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
}
#---------------------------------------------------
# Add security group rules (one more way)
#---------------------------------------------------
resource "aws_security_group_rule" "ingress_ports" {
    type                = "ingress"
    count               = length(var.allowed_ports)
    security_group_id   = aws_security_group.websrv_firewall.id
    from_port           = element(var.allowed_ports, count.index)
    to_port             = element(var.allowed_ports, count.index)
    protocol            = "tcp"
    cidr_blocks         = ["0.0.0.0/0"]
}
resource "aws_security_group_rule" "egress_ports" {
    type                = "egress"
    count               = length(var.allowed_ports)
    security_group_id   = aws_security_group.websrv_firewall.id
    from_port           = element(var.allowed_ports, count.index)
    to_port             = element(var.allowed_ports, count.index)
    protocol            = "tcp"
    cidr_blocks         = ["0.0.0.0/0"]
}