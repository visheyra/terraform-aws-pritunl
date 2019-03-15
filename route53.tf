data "aws_route53_zone" "selected" {
  name         = "${var.dns_zone}."
  private_zone = false
}

resource "aws_route53_record" "dns-endpoint" {
  zone_id = "${data.aws_route53_zone.selected.zone_id}"
  name    = "${var.name}.${var.dns_zone}"
  type    = "CNAME"
  ttl     = "300"
  records = ["${aws_lb.vpn-nlb.dns_name}"]

  depends_on = ["aws_lb.vpn-nlb"]
}