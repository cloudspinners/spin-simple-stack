
resource "aws_codepipeline" "simple_env_pipeline" {
  name     = "simple_env_pipeline"
  role_arn = "${aws_iam_role.simple_env_pipeline_role.arn}"

  artifact_store {
    location = "${aws_s3_bucket.artefact_repository.bucket}"
    type     = "S3"
    # encryption_key {
    #   id   = "${data.aws_kms_alias.s3kmskey.arn}"
    #   type = "KMS"
    # }
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeCommit"
      version          = "1"

      output_artifacts  = [ "simple-env-infra-source" ],

      configuration {
        RepositoryName = "simple-env"
        BranchName     = "master"
      }
    }
  }

  stage {
    name = "Build"

    action {
      name            = "Build"
      category        = "Build"
      owner           = "AWS"
      provider        = "CodeBuild"
      input_artifacts = [ "simple-env-infra-source" ]
      version         = "1"

      configuration {
        ProjectName = "build-simple-env"
      }
    }
  }
}
