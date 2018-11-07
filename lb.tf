resource "aws_elb" "kong" {
  name            = "edge"
  subnets  = ["${data.aws_subnet_ids.private.ids}"]
  security_groups = ["${aws_security_group.external-lb.id}"]

  # Proxy HTTPS
  listener {
    instance_port     = 8443
    instance_protocol = "tcp"
    lb_protocol       = "tcp"
    lb_port           = 443
  }

  # Proxy HTTP
  listener {
    instance_port     = 8000
    instance_protocol = "tcp"
    lb_protocol       = "tcp"
    lb_port           = 80
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 2
    target              = "TCP:8000"
    interval            = 5
  }

  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400
}
