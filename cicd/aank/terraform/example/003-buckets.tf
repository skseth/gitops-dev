

resource "minio_s3_bucket" "state_terraform_s3" {
  bucket = "a-new-bucket-from-terraform"
  acl    = "public"
  # force_destroy defaults to false - bucket deletion will fail if not empty
}
