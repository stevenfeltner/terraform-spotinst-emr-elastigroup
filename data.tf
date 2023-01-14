### Retrieve the cluster ID from the text file from script ###
data "local_file" "cluster" {
  depends_on = [null_resource.cluster_id]
  filename   = "${path.module}/scripts/cluster_id.txt"
}


# Retrieve the dns of EMR cluster
data "external" "dns" {
  depends_on = [null_resource.cluster_id]
  program = [
    local.cmd,
    "get-dns",
    spotinst_mrscaler_aws.MrScaler.id,
    data.local_file.cluster.content,
    var.region,
    "--token=${local.spotinst_token}"
  ]
}
