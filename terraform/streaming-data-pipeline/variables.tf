variable "oci_private_key" {
  description = "Private key content, use to auth with OCI"
  type        = string
  sensitive   = true
  # This variable should be pass automatically using terraform Cloud (TF_VAR)
}

