resource "vault_policy" "policy" {
  name     =  var.name
  policy   = file(var.hcl)
}
