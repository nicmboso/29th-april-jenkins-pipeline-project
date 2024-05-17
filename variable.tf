variable "region" {
  default = "eu-west-3"
}
variable "profile" {
  default = "set19"
}
variable "red_hat" {
  default = "ami-05f804247228852a3"
}
variable "vpc_cidr" {
  default = "10.0.0.0/16"
}
variable "pub-sub1_cidr" {
  default = "10.0.1.0/24"
}
variable "pub-sub2_cidr" {
  default = "10.0.2.0/24"
}
variable "prv1_cidr" {
  default = "10.0.3.0/24"
}
variable "prv2_cidr" {
  default = "10.0.4.0/24"
}
variable "az1" {
  default = "eu-west-3a"
}
variable "az2" {
  default = "eu-west-3b"
}
variable "cidr_all" {
  default = "0.0.0.0/0"
}
variable "all-cidr" {
  default = "0.0.0.0/0"
}
variable "instance_type" {
  default = "t2.medium"
}
variable "port_ssh" {
  default = "22"
}
variable "port_sonar" {
  default = "9000"
}
variable "port_proxy" {
  default = "8080"
}
variable "port_http" {
  default = "80"
}
variable "port_https" {
  default = "443"
}
variable "port_nexus" {
  default = "8081"
}
variable "port_mysql" {
  default = "3306"
}
variable "red_hat" {
  default = "ami-05f804247228852a3"
}
variable "db-identifier" {
  default = "petclinic-db"
}
variable "db-name" {
  default = "petclinicdb"
}
variable "db-username" {
  default = "admin"
}
variable "db-password" {
  default = "admin123"
}
variable "newrelic-license-key" {
  default = ""
}
variable "newrelic-acct-id" {
  default = ""
}
