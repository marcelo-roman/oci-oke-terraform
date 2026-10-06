config {
  call_module_type = "local"
}

plugin "terraform" {
  enabled = true
  preset  = "all"
}

rule "terraform_standard_module_structure" {
  enabled = true
}

rule "terraform_unused_required_providers" {
  enabled = false
}
