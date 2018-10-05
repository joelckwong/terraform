resource "aws_elb_attachment" "this" {
  count = "${var.instance_count}"

  elb      = "${var.elb}"
  instance = "${element(var.instance, count.index)}"
}
