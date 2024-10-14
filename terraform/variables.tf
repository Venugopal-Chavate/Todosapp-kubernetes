variable "region" {
  description = "The region to deploy resources"
  type        = string
  default     = "asia-northeast1"
}

variable "zone" {
  description = "The zone to deploy resources"
  type        = string
  default     = "asia-northeast1-a"
}

variable "location" {
  description = "The location to deploy resources"
  type        = string
  default     = "JAPAN"
}

variable "cluster_name" {
  description = "The cluster_name to deploy resources"
  type        = string
  default     = "test"
}

variable "zone_2" {
  description = "The zone2 to deploy resources"
  type        = string
  default     = "asia-northeast1-b"
}

variable "uri" {
  type        = string
  sensitive    = true
}

variable "username" {
  type        = string
  sensitive    = true
}

variable "password" {
  type        = string
  sensitive    = true
}
variable "project_id" {
  type        = string
  sensitive    = true
}
variable "project_number" {
  type        = string
  sensitive    = true
}