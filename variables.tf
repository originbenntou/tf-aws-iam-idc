variable "account_assignments" {
  type = list(object({
    account_id     = string
    group_name     = string
    permission_set = string
  }))
  default = []
}
