output "FWB-LB-Public-FQDN" {
  value = join("", tolist(["https://", "${aws_eip.LBPublicIP.public_dns}"]))
}

output "FWB-NLB-Public-IP" {
  value = aws_eip.LBPublicIP.public_ip
}

output "FWB-Active1-PublicIP" {
  value = aws_eip.Active1PublicIP.public_ip
}

output "FWB-Active2-PublicIP" {
  value = aws_eip.Active2PublicIP.public_ip
}

output "Username" {
  value = "admin"
}

output "First Login Password for FortiWeb-A" {
  value = aws_instance.fwbactive1.id
}

output "First Login Password for FortiWeb-B" {
  value = aws_instance.fwbactive2.id
}