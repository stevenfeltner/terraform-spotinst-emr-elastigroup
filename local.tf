locals {
  cmd         = "${path.module}/scripts/get-emr"
  cluster_id  = data.external.cluster_id.result["cluster_id"]
  dns_name    = data.external.dns_name.result["dns_name"]
}