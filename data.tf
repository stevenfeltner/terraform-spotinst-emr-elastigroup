### Retrieve ip address from file ###
data "local_file" "dns_name" {
  depends_on = [null_resource.dns_name]
  filename   = "${path.module}/scripts/cluster_ip.txt"
}

### Retrieve the cluster ID from the text file from script ###
data "local_file" "cluster" {
  depends_on = [null_resource.cluster_id]
  filename   = "${path.module}/scripts/cluster_id.txt"
}