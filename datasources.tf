data "aws_availability_zones" "zones" {
  filter {
    name   = "opt-in-status"
    values = ["opt-in-not-required"]
  }
}