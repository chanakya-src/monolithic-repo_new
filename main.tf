resource "aws_launch_template" "web_server_as" {
    name = "myproject"
    image_id           = "ami-03c4f11b50838ab5d"
    vpc_security_group_ids = [aws_security_group.web_server.id]
    instance_type = "t2.micro"
    key_name = "terraform03/10north Virginia"
    tags = {
        Name = "DevOps"
    }
}

resource "aws_elb" "web_server_lb" {
    name = "web-server-lb"
    security_groups = [aws_security_group.web_server.id]
    subnets = ["subnet-001c94845fdcc17e2", "subnet-0bf7e665914161460"]
    listener {
        instance_port     = 80
        instance_protocol = "http"
        lb_port           = 80
        lb_protocol       = "http"
    }
    tags = {
        Name = "terraform-elb"
    }
}

resource "aws_autoscaling_group" "web_server_asg" {
    name                 = "web-server-asg"
    min_size             = 1
    max_size             = 3
    desired_capacity     = 2
    health_check_type    = "EC2"
    load_balancers       = [aws_elb.web_server_lb.name]
    vpc_zone_identifier  = ["subnet-001c94845fdcc17e2", "subnet-0bf7e665914161460"]
    launch_template {
        id      = aws_launch_template.web_server_as.id
        version = "$Latest"
    }
}
