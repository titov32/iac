
# --------------------------
# 1. Bucket для terraform state
# --------------------------
resource "yandex_storage_bucket" "tf_state" {
  bucket    = var.bucket_name
  folder_id = var.folder_id

  versioning {
    enabled = true
  }

  lifecycle_rule {
    id      = "expire_old_versions"
    enabled = true
    noncurrent_version_expiration {
      days = 30
    }
  }

  # Защита от удаления
  lifecycle {
    prevent_destroy = true
  }
}
output "ys_bucket" {
  value = yandex_storage_bucket.tf_state.bucket
}
# --------------------------
# 2. YDB база для блокировок
# --------------------------
resource "yandex_ydb_database_serverless" "tf_lock_db" {
  name      = "terraform-lock-db"
  folder_id = var.folder_id
}
output "ydb_full_endpoint" {
  value = yandex_ydb_database_serverless.tf_lock_db.ydb_full_endpoint
}
# --------------------------
# 3. Таблица для блокировок
# --------------------------
# resource "yandex_ydb_table" "tf_lock_table" {
#   depends_on = [yandex_ydb_database_serverless.tf_lock_db]

#   path              = "terraform-locks"
#   connection_string = yandex_ydb_database_serverless.tf_lock_db.ydb_full_endpoint

#   column {
#     name = "LockID"
#     type = "Utf8"
#   }

#   primary_key = ["LockID"]
# }
