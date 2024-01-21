
# Import existing subnet IDs using data sources
data "aws_subnet" "subnet1" {
  id = var.subnet-1
}

data "aws_subnet" "subnet2" {
  id = var.subnet-2
}

#Import existing subnet IDs using data sources
data "aws_vpc" "default-project-vpc" {
    
  tags = {
    Name = var.vpc_name
  }
}
    
#Import existing security group using data sources
data "aws_security_group" "moses_sg" {
    id = var.security_group
}


################################default#############
# AWS Load Balancer
resource "aws_lb" "ARIES_alb" {
  name                       = "ARIES-alb"
  internal                   = false
  load_balancer_type         = "application"
  security_groups            = [data.aws_security_group.moses_sg.id]
  subnets                    = [data.aws_subnet.subnet1.id, data.aws_subnet.subnet2.id]
  enable_deletion_protection = false

  tags = {
    Name = "ARIES-ALB"
  }
}

# Create target group
resource "aws_lb_target_group" "ARIES_default" {
  name        = "ARIES"
  target_type = "instance"
  port        = 443
  protocol    = "HTTPS"
  vpc_id      = "${data.aws_vpc.default-project-vpc.id}"

  health_check {
    path                = "/"
    port                = 443
    protocol            = "HTTPS"
    healthy_threshold   = 5
    unhealthy_threshold = 2
    matcher             = "200"
  }
}

# Create a new certificate
module "acm" {
  source  = "terraform-aws-modules/acm/aws"
  version = "~> 4.0"

  domain_name  = ""
  zone_id      = ""

  validation_method = "DNS"

  subject_alternative_names = [
    "",
  ]

  create_route53_records  = true 

  wait_for_validation = false

  tags = {
    Name = ""
  }
}

output "acm_validation_record_fqdns" {
  value = module.acm.acm_certificate_domain_validation_options
}


#########################default#################

# Create instances and associate them with target groups
resource "aws_instance" "client_instances" {
  count         = length(var.clients)
  ami           = var.ami  # Specify your AMI ID
  instance_type = "t2.micro"
  subnet_id     = data.aws_subnet.subnet1.id
  iam_instance_profile   = var.instance_profile
  key_name = var.key
  associate_public_ip_address = true

  tags = {
    Name = "SeamlessARIES-${var.clients[count.index].client_name}"
  }

}

output "instance_ids" {
  value = aws_instance.client_instances[*].id
}


###############################################

# Create a listener on port 443 with the new certificate and forward action
resource "aws_lb_listener" "ARIES_https_listener" {
  load_balancer_arn = aws_lb.ARIES_alb.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = module.acm.acm_certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ARIES_default.arn
  }

}

# Create HTTP listener for each client
resource "aws_lb_listener" "ARIES_http_lister" {

  load_balancer_arn = aws_lb.ARIES_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ARIES_default.arn
  }
}

locals {
  target_groups = [
    for client in var.clients : {
      name = "SeamlessARIES-${lower(replace(client.client_name, " ", "-"))}"
      subdomain = client.subdomain
    }
  ]
}


# Create target group
resource "aws_lb_target_group" "ARIES_tg" {
  count       = length(local.target_groups)
  name        = local.target_groups[count.index].name
  target_type = "instance"
  port        = 443
  protocol    = "HTTPS"
  vpc_id      = "${data.aws_vpc.default-project-vpc.id}"

  health_check {
    path                = "/"
    port                = 443
    protocol            = "HTTPS"
    healthy_threshold   = 3
    unhealthy_threshold = 3
    matcher             = "200"
  }
}


# Create condition for HTTP listener
resource "aws_lb_listener_rule" "ARIES_http_rule" {
  count         = length(local.target_groups)
  listener_arn  = aws_lb_listener.ARIES_http_lister.arn

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ARIES_tg[count.index].arn
  }

  condition {
    host_header {
      values = ["${local.target_groups[count.index].subdomain}.<Domain Name>"]
    }
  }
}

# Create condition for HTTPS listener
resource "aws_lb_listener_rule" "ARIES_https_rule" {
  count         = length(local.target_groups)
  listener_arn  = aws_lb_listener.ARIES_https_listener.arn


  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ARIES_tg[count.index].arn
  }

  condition {
    host_header {
      values = ["${local.target_groups[count.index].subdomain}.<Domain Name>"]
    }
  }
}



# Attach instances to target groups
resource "aws_lb_target_group_attachment" "client_attachments" {
  count            = length(var.clients)
  target_group_arn = aws_lb_target_group.ARIES_tg[count.index].arn
  target_id        = aws_instance.client_instances[count.index].id
  port             = 443
}



terraform {
  backend "s3" {
	bucket     	= ""
	key        	= ""
	region     	= ""
	encrypt    	= true
	dynamodb_table = ""
  }
}



