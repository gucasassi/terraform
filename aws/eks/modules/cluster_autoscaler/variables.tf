variable "cluster_name" {
  description = "The name of the EKS cluster"
  type        = string
}

variable "cluster_issuer" {
  description = "The OIDC issuer URL of the EKS cluster"
  type        = string
}