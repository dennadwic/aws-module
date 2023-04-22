output "production_vpc" {
  value = aws_vpc.main.id
}

output "production_public_subnet" {
  value = aws_subnet.main.id
}

output "staging_vpc" {
  value = aws_vpc.main.id
}

output "staging_public_subnet" {
  value = aws_subnet.main.id
}

output "development_vpc" {
  value = aws_vpc.main.id
}

output "development_public_subnet" {
  value = aws_subnet.main.id
}