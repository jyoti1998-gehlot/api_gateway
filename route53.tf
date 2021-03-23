
resource "aws_route53_health_check" "xyz" {
  fqdn              = "3yb30eacl6.execute-api.us-west-2.amazonaws.com"
  port              = 443
  type              = "HTTPS"
  resource_path     = "/"
  failure_threshold = "3"
  request_interval  = "30"
  cloudwatch_alarm_region = "us-west-2"

  tags = {
    Name = "tf-test-health-check"
  }
}