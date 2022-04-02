### Call script to get the cluster ID using Spot APIs ###
data "external" "cluster_id" {
  depends_on  = [spotinst_mrscaler_aws.MrScaler]
  program     = [local.cmd, "get-logs", spotinst_mrscaler_aws.MrScaler.id]
}

### Call script to get the DNS name/Ip address from the cluster###
data "external" "dns_name" {
  depends_on  = [data.external.cluster_id]
  program     = [local.cmd, "get-dns", local.cluster_id, var.region]
}