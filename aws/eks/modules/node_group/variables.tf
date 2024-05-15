################################################################################################################
###############################                 CLUSTER                #########################################
################################################################################################################

variable "cluster_name" {
  description = "AWS EKS CLuster Name"
  type        = string
}

################################################################################################################
###############################                 SUBNETS                #########################################
################################################################################################################

variable "vpc_subnet_ids" {
  type        = list(string)
  description = "The list of subnet IDs associated with the created VPC. Use these IDs as a reference in other modules or resources requiring subnet identification."
}

################################################################################################################
###############################                  NODES                 #########################################
################################################################################################################

variable "instance_type" {
  description = "The instance type to use for the EKS nodes."
  type        = string
  default     = "t3.small"
}

variable "capacity_type" {
  description = "The capacity type for the EKS nodes. Possible values are ON_DEMAND or SPOT."
  type        = string
  default     = "ON_DEMAND"
}

variable "desired_size" {
  description = "The desired number of worker nodes in the node group."
  type        = number
  default     = 1
}

variable "max_size" {
  description = "The maximum number of worker nodes in the node group."
  type        = number
  default     = 5
}

variable "min_size" {
  description = "The minimum number of worker nodes in the node group."
  type        = number
  default     = 0
}

variable "max_unavailable" {
  description = "The maximum number of nodes that can be unavailable during a node group update."
  type        = number
  default     = 1
}

variable "security_group_ids" {
  description = "The list of security group IDs associated with the created VPC. Use these IDs as a reference in other modules or resources requiring security group identification."
  type        = list(string)
  default     = []
}