locals {
  cmd         ="${path.module}/scripts/get-emr"
  cluster_id  = data.local_file.cluster.content
  dns_name    = data.local_file.dns_name.content
}