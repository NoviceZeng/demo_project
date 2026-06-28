include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "../../../terraform-iam-apps/modules//role-flour-ec2-instance"
}

inputs = {
  session_duration = 3600
}
