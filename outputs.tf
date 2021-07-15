output "elastigroup_id" {
  value = spotinst_mrscaler_aws.MrScaler.id
}

output "cluster_id" {
  value = local.cluster_id
}

output "ip" {
  value = local.dns_name
}