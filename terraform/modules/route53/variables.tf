variable "domain_name" {
  description = "Apex domain name (e.g. example.com)"
  type        = string
}

variable "tags" {
  description = "A mapping of tags to assign to resources"
  type        = map(string)
  default     = {}
}
