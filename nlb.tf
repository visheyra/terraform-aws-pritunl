resource "aws_lb" "vpn-nlb" {
  name    = "${var.name}-nlb"
  internal        = false
  load_balancer_type = "network"
  subnets = ["${module.vpc.public_subnets}"]

  enable_deletion_protection = true
}

resource "aws_lb_target_group" "vpn-nlb-tg-https" {
  name     = "${var.name}-https-vpn"
  port     = "443"
  protocol = "TCP"
  vpc_id   = "${module.vpc.vpc_id}"
  deregistration_delay = "300"
  health_check {
    interval = "10"
    port = "443"
    protocol = "TCP"
    healthy_threshold = "3" 
    unhealthy_threshold= "3" 
  }
}

resource "aws_lb_target_group" "vpn-nlb-tg-ssh" {
  name    = "${var.name}-ssh-vpn"
  port    = "22"
  protocol = "TCP"
  vpc_id   = "${module.vpc.vpc_id}"
  deregistration_delay = "300"
  health_check {
    interval = "10"
    port = "22"
    protocol = "TCP"
    healthy_threshold = "3" 
    unhealthy_threshold= "3" 
  }
}

resource "aws_lb_target_group" "vpn-nlb-tg-tcp" {
  count = "${length(var.additional_vpn_port)}"
  name    = "${var.name}-tcp-vpn-${count.index}"
  port    = "${var.additional_vpn_port[count.index]}"
  protocol = "TCP"
  vpc_id   = "${module.vpc.vpc_id}"
  deregistration_delay = "300"
  health_check {
    interval = "10"
    port = "${var.additional_vpn_port[count.index]}"
    protocol = "TCP"
    healthy_threshold = "3" 
    unhealthy_threshold= "3" 
  }
}

resource "aws_lb_listener" "vpn-listener-https" {
  load_balancer_arn = "${aws_lb.vpn-nlb.arn}"
  port              = "443"
  protocol          = "TCP"
  default_action {
    target_group_arn = "${aws_lb_target_group.vpn-nlb-tg-https.arn}"
    type             = "forward"
  }

  depends_on = ["aws_lb_target_group.vpn-nlb-tg-https"]
}

resource "aws_lb_listener" "vpn-listener-ssh" {
  load_balancer_arn = "${aws_lb.vpn-nlb.arn}"
  port              = "22"
  protocol          = "TCP"
  default_action {
    target_group_arn = "${aws_lb_target_group.vpn-nlb-tg-ssh.arn}"
    type             = "forward"
  }

  depends_on = ["aws_lb_target_group.vpn-nlb-tg-ssh"]
}


resource "aws_lb_listener" "vpn-listener-tcp" {
  count = "${length(var.additional_vpn_port)}"
  load_balancer_arn = "${aws_lb.vpn-nlb.arn}"
  port  = "${var.additional_vpn_port[count.index]}"
  protocol = "TCP"
  default_action {
    target_group_arn = "${aws_lb_target_group.vpn-nlb-tg-tcp.*.arn[count.index]}"
    type = "forward"
  }

  depends_on = ["aws_lb_target_group.vpn-nlb-tg-tcp"]
}