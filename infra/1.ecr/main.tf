resource "aws_ecr_repository" "app_with_xray" {
  name         = "app_with_xray"
  force_delete = true
}

output "repository_name" {
  value = aws_ecr_repository.app_with_xray.name
}

output "repository_url_base" {
  value = join("/", slice(split("/", aws_ecr_repository.app_with_xray.repository_url), 0, length(split("/", aws_ecr_repository.app_with_xray.repository_url)) - 1))
}