# ECR Repository for image
resource "aws_ecr_repository" "app" {
  name                 = "${var.app_name}-repo"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  force_delete = true
}


locals {
  # Root of the application code (one level above infra/)
  project_root = abspath("${path.module}/..")

  # All files that should trigger a new image build when they change
  docker_build_files = concat(
    [
      "Dockerfile",
      "go.mod",
      "go.sum",
    ],

    # Go sources
    #TODO: messy...
    tolist(fileset(local.project_root, "*.go")),
    tolist(fileset(local.project_root, "cmd/**/*.go")),
    tolist(fileset(local.project_root, "handlers/**/*.go")),
    tolist(fileset(local.project_root, "views/**/*.go")),
    tolist(fileset(local.project_root, "data/**/*.go")),

    # templ views and static assets used in the container image
    tolist(fileset(local.project_root, "views/**/*.templ")),
    tolist(fileset(local.project_root, "static/**")),
  )

  docker_build_hash = md5(join("", [
    for f in local.docker_build_files : filemd5("${local.project_root}/${f}")
  ]))
}


# ecr push commands 
resource "terraform_data" "build_push" {

  triggers_replace = {
    ecr_repo_url = aws_ecr_repository.app.repository_url
    source_hash  = local.docker_build_hash
  }

  provisioner "local-exec" {

    working_dir = "../"

    # slightly different to recommended commands
    # assume user builds, have TF just tag the image
    command = <<-EOT
      aws ecr get-login-password --region ${var.aws_region} --profile ${var.aws_profile} | ${var.container_tool} login --username AWS --password-stdin ${aws_ecr_repository.app.repository_url}
      ${var.container_tool} tag ${var.app_name} ${aws_ecr_repository.app.repository_url}:latest
      ${var.container_tool} push ${aws_ecr_repository.app.repository_url}:latest
    EOT

  }

  depends_on = [aws_ecr_repository.app]

}


# get the 
data "aws_ecr_image" "app" {
  repository_name = aws_ecr_repository.app.name
  image_tag       = "latest"
  depends_on      = [terraform_data.build_push]
}
