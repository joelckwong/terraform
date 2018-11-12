resource "aws_elb_attachment" "this" {
  count = "${var.count}"
  elb      = "${var.elb}"
  instance = "${element(var.instance, count.index)}"
  lifecycle {
    create_before_destroy = true
  }
}
