#Create VPC 
resource "aws_vpc" "mainvpc" {
  cidr_block            = "10.0.0.0/16"
  instance_tenancy      = "default"
  enable_dns_hostnames  = true

  tags = {
      Name = "VPC_TF"
  }

}

#Creating Security group and allow port 22 for ssh from anywhere to connect
resource "aws_security_group" "allow_ssh" {
    name        = "allow_ssh"
    description = "Allow SSH inbound traffic/ Allow all outbound traffic"
    vpc_id      = "${aws_vpc.mainvpc.id}"

    ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] #Will accept any ip for ssh 
    }
    egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"  #All ports
    cidr_blocks     = ["0.0.0.0/0"]
    }

    tags = {
        Name = "SecurityGroup_TF"
    }

    depends_on = ["aws_vpc.mainvpc"]
}

#Create subnet 
resource "aws_subnet" "PublicSubnet" {
  vpc_id     = "${aws_vpc.mainvpc.id}"
  cidr_block = "10.0.0.0/24"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "PublicSubnet_A"
  }
  depends_on = ["aws_vpc.mainvpc"]
}

#creating instance
resource "aws_instance" "MyFirstInstance"{
    #add ami,instance,tag values to create instance 
    ami = "ami-02354e95b39ca8dec"
    instance_type = "t2.micro"
    vpc_security_group_ids = ["${aws_security_group.allow_ssh.id}"]
    subnet_id = "${aws_subnet.PublicSubnet.id}"
    tags = {
        Name = "MyEc2Instance"
    }

    #This will create a file and add private ip in it.
    provisioner "local-exec" {
    command = "echo ${aws_instance.MyFirstInstance.private_ip} >> private_ip.txt" 
    }

    depends_on = ["aws_vpc.mainvpc","aws_subnet.PublicSubnet","aws_security_group.allow_ssh"]
}

#Creating elastic ip and assigning it to instance
resource "aws_eip" "EipForInstance"{
    instance = "${aws_instance.MyFirstInstance.id}"
    tags = {
        Name = "Ec2_instance_ip"
    }
}

#Output of the elastic ip
output "my_eip" {
  value = "${aws_eip.EipForInstance.public_ip}"
}
