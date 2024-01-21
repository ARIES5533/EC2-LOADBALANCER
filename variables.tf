variable "clients" {
  type = list(object({
    client_name = string
    subdomain   = string
  }))
  default = [
    
    { client_name = "Client1", subdomain = "client1" },
    { client_name = "Client2", subdomain = "client2" },
    { client_name = "Client3", subdomain = "client3" },
    # Add more clients as needed

  ]
}

variable "instance_profile" {
  default = ""
}

variable "ami" {

  default = ""
  
}

variable "key" {
  
  default = ""
}


variable "subnet-1" {

  default = ""
  
}


variable "subnet-2" {

  default = ""
  
}


variable "vpc_name" {

  default = ""
  
}


variable "security_group" {

  default = ""
  
}

