resource "aws_route53_record" "api" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "api.healthcare.com"
  type    = "A"

  alias {
    name                   = aws_lb.healthcare.dns_name
    zone_id                = aws_lb.healthcare.zone_id
    evaluate_target_health = true
  }
}