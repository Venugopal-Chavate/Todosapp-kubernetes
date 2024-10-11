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
  default     = "US"
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