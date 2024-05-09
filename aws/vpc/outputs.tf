output "id" {
  value       = aws_vpc.this.id
  description = "The unique identifier of the created VPC. Use this ID as a reference in other modules or resources requiring VPC identification."
}

output "subnet_ids" {
  value = concat(
    [for subnet in aws_subnet.public : subnet.id],
    [for subnet in aws_subnet.private : subnet.id]
  )
  description = "The list of subnet IDs associated with the created VPC. Use these IDs as a reference in other modules or resources requiring subnet identification."
}