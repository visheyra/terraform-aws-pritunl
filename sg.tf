resource "aws_security_group" "instance_sg" {
  name        = "${var.name}-asg-sg"
  description = "Security group for vpn asg"
  vpc_id      = "${module.vpc.vpc_id}"
}

resource "aws_security_group_rule" "https" {
  type            = "ingress"
  from_port       = 443
  to_port         = 443
  protocol        = "tcp"
  cidr_blocks = "${var.allowed_cidrs}"

  security_group_id = "${aws_security_group.instance_sg.id}"

  depends_on = ["aws_security_group.instance_sg"]
}

resource "aws_security_group_rule" "ssh" {
  type            = "ingress"
  from_port       = 22
  to_port         = 22
  protocol        = "tcp"
  cidr_blocks = "${var.allowed_cidrs}"

  security_group_id = "${aws_security_group.instance_sg.id}"

  depends_on = ["aws_security_group.instance_sg"]
}

resource "aws_security_group_rule" "vpn" {
  count           = "${length(var.additional_vpn_port)}"
  type            = "ingress"
  from_port       = "${var.additional_vpn_port[count.index]}"
  to_port         = "${var.additional_vpn_port[count.index]}"
  protocol        = "udp"
  cidr_blocks     = "${var.allowed_cidrs}"

  security_group_id = "${aws_security_group.instance_sg.id}"

  depends_on = ["aws_security_group.instance_sg"]
}

resource "aws_security_group_rule" "outbound" {
  type = "egress"
  from_port = 0
  to_port = 0
  protocol = -1
  cidr_blocks = "${var.allowed_cidrs}"

  security_group_id = "${aws_security_group.instance_sg.id}"

  depends_on = ["aws_security_group.instance_sg"]

}