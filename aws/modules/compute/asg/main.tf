resource "aws_autoscaling_group" "this" {
  name_prefix	       = "${var.name}-" 
  launch_configuration = "${var.launch_configuration}"
  vpc_zone_identifier       = ["${var.vpc_zone_identifier}"]
  load_balancers       = ["${var.load_balancers}"]
  min_size = 2
  max_size = 10
  tag {
    key = "Name"
    value = "asg-${var.env}"
    propagate_at_launch = true
  }
  lifecycle {
    create_before_destroy = true
  }
}
