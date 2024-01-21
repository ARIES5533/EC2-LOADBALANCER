variable "clients" {
  type = list(object({
    client_name = string
    subdomain   = string
  }))
  default = [
    
    { client_name = "Client116", subdomain = "client6" },
    { client_name = "Client117", subdomain = "client7" },
    { client_name = "Client118", subdomain = "client8" },
    { client_name = "Client119", subdomain = "client9" },
    { client_name = "Client1110", subdomain = "client10" },
    { client_name = "Client1111", subdomain = "client11" },
    { client_name = "Client1112", subdomain = "client12" },
    { client_name = "Client1113", subdomain = "client13" },
    { client_name = "Client1114", subdomain = "client14" },
    { client_name = "Client1115", subdomain = "client15" },
    { client_name = "Client1116", subdomain = "client16" },
    { client_name = "Client1117", subdomain = "client17" },
    { client_name = "Client1118", subdomain = "client18" },
    { client_name = "Client1119", subdomain = "client19" },
    { client_name = "Client2110", subdomain = "client20" },

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

