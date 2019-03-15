resource "aws_autoscaling_group" "vpn_instances" {
  name                 = "${var.name}-asg"
  launch_configuration = "${aws_launch_configuration.vpn.id}"
  min_size             = 1
  max_size             = 1
  desired_capacity     = 1
  vpc_zone_identifier  = ["${module.vpc.private_subnets}"]

  # target_group_arns = ["${list(aws_lb_target_group.vpn-nlb-tg-https.arn, aws_lb_target_group.vpn-nlb-tg-ssh.arn)}"]

  target_group_arns = ["${concat(
    list(
      aws_lb_target_group.vpn-nlb-tg-https.arn,
      aws_lb_target_group.vpn-nlb-tg-ssh.arn
    ),
    aws_lb_target_group.vpn-nlb-tg-tcp.*.arn
    )}"]
  

  depends_on = [
    "aws_launch_configuration.vpn",
    "aws_lb_target_group.vpn-nlb-tg-https",
    "aws_lb_target_group.vpn-nlb-tg-ssh",
    "aws_lb_target_group.vpn-nlb-tg-tcp"
  ]
}

resource "aws_launch_configuration" "vpn" {
  name = "${var.name}-lc"
  image_id = "${var.ami_id}"
  instance_type = "${var.instance_size}"
  security_groups = ["${aws_security_group.instance_sg.id}"]
  user_data_base64 = "${data.template_cloudinit_config.config.rendered}"
  key_name = "${var.key_name}"
  associate_public_ip_address = false

  depends_on = ["aws_security_group.instance_sg"]
}