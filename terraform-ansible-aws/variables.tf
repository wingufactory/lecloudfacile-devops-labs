variable "profile" {
  type    = string
  default = "default"

}

variable "region-master" {
  type    = string
  default = "us-east-1"
}

variable "external_ip" {
  type    = string
  default = "0.0.0.0/0"
}

variable "instance-type" {
  type    = string
  default = "t2.micro"
}

#Add the variable webserver-port to variables.tf
variable "webserver-port" {
  type    = number
  default = 8080
}



