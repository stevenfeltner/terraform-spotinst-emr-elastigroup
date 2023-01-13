locals {
  cmd        = "${path.module}/scripts/get-emr"
  cluster_id = data.local_file.cluster.content
  dns_name   = data.local_file.dns_name.content
  spotinst_token  = var.debug == true ? nonsensitive(var.spotinst_token) : var.spotinst_token
}