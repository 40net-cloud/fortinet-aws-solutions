module "network_lb" {
  source            = "./modules/nlb"
  prefix            = "external"
  subnet_id         = aws_subnet.publicsubnet1.id
  subnet2_id        = aws_subnet.publicsubnet2.id
  vpc_id            = aws_vpc.fwbvm-vpc.id
  target1_id        = var.active1port1
  target2_id        = var.active2port1
  healthport        = var.adminsport
  forwarding_config = var.test_forwarding_config
}