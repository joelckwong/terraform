output "web_subnets" {
    value = "${module.networking.web_subnets}"
}
output "web_sg" {
    value = ["${module.networking.web_sg}"]
}
output "web_subnet_ips" {
    value = "${module.networking.web_subnet_ips}"
}
