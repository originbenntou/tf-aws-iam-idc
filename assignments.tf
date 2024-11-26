locals {
  assignment_map = {
    for a in var.account_assignments :
    format("%v-%v-%v", a.account_id, a.group_name, a.permission_set) => a
  }

  unique_groups = distinct([for a in var.account_assignments : a.group_name])
}

data "aws_identitystore_group" "this" {
  for_each = toset(local.unique_groups)

  identity_store_id = local.identity_store_id

  alternate_identifier {
    unique_attribute {
      attribute_path  = "DisplayName"
      attribute_value = each.value
    }
  }
}

resource "aws_ssoadmin_account_assignment" "this" {
  for_each = local.assignment_map

  instance_arn       = local.instance_arn
  principal_id       = data.aws_identitystore_group.this[each.value.group_name].group_id
  principal_type     = "GROUP"
  target_id          = each.value.account_id
  target_type        = "AWS_ACCOUNT"
  permission_set_arn = local.permission_sets[each.value.permission_set]
}
