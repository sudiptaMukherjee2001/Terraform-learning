variable "bucket_name_list" {
  description = "List of bucket names to create"
  type        = list(string)
  default     = ["counter-meta-argument-1", "counter-meta-argument-2", "counter-meta-argument-3"]
  
}
variable "bucket_name_set" {
  description = "Set of bucket names to create"
  type        = set(string)
  default     = ["for-each-with-set-of-strings-meta-argument-1", "for-each-with-set-of-strings-meta-argument-2", "for-each-with-set-of-strings-meta-argument-3"]
  
}