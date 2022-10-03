data "aws_availability_zones" "all" {
  state = "available"
  # exclude_names = ["${var.region}c"]
}
