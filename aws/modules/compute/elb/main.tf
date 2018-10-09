provider "random" {
}

resource "random_id" "elb" {
  keepers = {
    # Generate a new id each time we switch to a new name
    name = "${var.name}"
  }

  byte_length = 2
}
resource "aws_elb" "this" {
  name            = "${var.name}-${random_id.elb.hex}"
  subnets         = ["${var.subnets}"]
  internal        = "${var.internal}"
  security_groups = ["${var.security_groups}"]

  cross_zone_load_balancing   = "${var.cross_zone_load_balancing}"
  idle_timeout                = "${var.idle_timeout}"
  connection_draining         = "${var.connection_draining}"
  connection_draining_timeout = "${var.connection_draining_timeout}"

  listener     = ["${var.listener}"]
  access_logs  = ["${var.access_logs}"]
  health_check = ["${var.health_check}"]

  tags = "${merge(var.tags, map("Name", format("%s", var.name)))}"
  lifecycle {
    create_before_destroy = true
  }
}
