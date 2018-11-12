output "vpc_id" {
    value = "${module.networking.vpc_id}"
}
output "vpc_cidr" {
    value = "${module.networking.vpc_cidr}"
}
output "app_subnets" {
    value = "${module.networking.app_subnets}"
}
output "app_sg" {
    value = ["${module.networking.app_sg}"]
}
output "app_subnet_ips" {
    value = "${module.networking.app_subnet_ips}"
}
output "data_subnets" {
    value = "${module.networking.data_subnets}"
}
output "data_sg" {
    value = ["${module.networking.data_sg}"]
}
output "data_subnet_ips" {
    value = "${module.networking.data_subnet_ips}"
}
output "web_subnets" {
    value = "${module.networking.web_subnets}"
}
output "web_sg" {
    value = ["${module.networking.web_sg}"]
}
output "web_subnet_ips" {
    value = "${module.networking.web_subnet_ips}"
}
