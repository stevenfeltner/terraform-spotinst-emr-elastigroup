# Create a Elastigroup with EMR integration(Mr Scaler) with New strategy
resource "spotinst_mrscaler_aws" "MrScaler" {
  name              = var.name
  description       = var.description
  region            = var.region
  strategy          = var.strategy
  cluster_id        = var.cluster_id
  expose_cluster_id = var.expose_cluster_id

  provisioning_timeout {
    timeout        = var.timeout
    timeout_action = var.timeout_action
  }
  retries            = var.retries
  release_label      = var.release_label
  availability_zones = var.availability_zones

  // --- CLUSTER ------------
  log_uri                            = var.log_uri
  additional_info                    = var.additional_info
  security_config                    = var.security_config
  service_role                       = var.service_role
  job_flow_role                      = var.job_flow_role
  termination_protected              = var.termination_protected
  keep_job_flow_alive                = var.keep_job_flow_alive
  custom_ami_id                      = var.custom_ami_id
  ec2_key_name                       = var.ec2_key_name
  managed_primary_security_group     = var.master_sg_id
  managed_replica_security_group     = var.slave_sg_id
  service_access_security_group      = var.service_sg_id
  additional_primary_security_groups = var.additional_master_sg_ids
  additional_replica_security_groups = var.additional_slave_sg_ids

  dynamic "applications" {
    for_each = var.applications == null ? [] : var.applications
    content {
      name    = applications.value["name"]
      version = applications.value["version"]
    }
  }

  /* Uncomment if you need to use steps or configurations file
  steps_file {
    bucket  = var.steps_bucket
    key     = var.steps_key
  }

  configurations_file {
    bucket  = var.config_bucket
    key     = var.config_key
  }
*/

  bootstrap_actions_file {
    bucket = var.bootstrap_bucket
    key    = var.bootstrap_key
  }
  // -------------------------

  // --- MASTER GROUP -------------
  master_instance_types = var.master_instance_type
  master_lifecycle      = var.master_lifecycle
  master_ebs_optimized  = var.master_ebs_optimized

  master_ebs_block_device {
    volumes_per_instance = var.master_volume_per_instance
    volume_type          = var.master_volume_type
    size_in_gb           = var.master_size_in_gb
  }
  // ------------------------------

  // --- CORE GROUP -------------
  core_instance_types   = var.core_instance_types
  core_min_size         = var.core_min_size
  core_max_size         = var.core_max_size
  core_desired_capacity = var.core_desired_capacity
  core_lifecycle        = var.core_lifecycle
  core_ebs_optimized    = var.core_ebs_optimized
  core_unit             = var.core_unit

  core_ebs_block_device {
    volumes_per_instance = var.core_volume_per_instance
    volume_type          = var.core_volume_type
    size_in_gb           = var.core_size_in_gb
  }
  // ----------------------------

  // --- TASK GROUP -------------
  task_instance_types   = var.task_instance_types
  task_min_size         = var.task_min_size
  task_max_size         = var.task_max_size
  task_desired_capacity = var.task_desired_capacity
  task_lifecycle        = var.task_lifecycle
  task_ebs_optimized    = var.task_ebs_optimized
  task_unit             = var.task_unit

  task_ebs_block_device {
    volumes_per_instance = var.task_volume_per_instance
    volume_type          = var.task_volume_type
    size_in_gb           = var.task_size_in_gb
  }
  // ----------------------------
  dynamic "tags" {
    for_each = var.tags == null ? [] : var.tags
    content {
      key   = tags.value["key"]
      value = tags.value["value"]
    }
  }
  // ----------------------------
  # Task Scaling Policies
  task_scaling_up_policy {
    policy_name = var.task_scaling_up_policy_name
    metric_name = var.task_scaling_up_metric_name
    statistic   = var.task_scaling_up_statistic
    unit        = var.task_scaling_up_unit
    threshold   = var.task_scaling_up_threshold
    action_type = var.task_scaling_up_action_type
    //adjustment            = var.task_scaling_up_adjustment
    min_target_capacity = var.task_scaling_up_min_target_capacity
    max_target_capacity = var.task_scaling_up_max_target_capacity
    namespace           = var.task_scaling_up_namespace
    operator            = var.task_scaling_up_operator
    evaluation_periods  = var.task_scaling_up_evaluation_periods
    period              = var.task_scaling_up_period
    cooldown            = var.task_scaling_up_cooldown
    dimensions = {
      minimum = var.task_scaling_up_minimum
      maximum = var.task_scaling_up_maximum
      target  = var.task_scaling_up_target
    }
  }
  task_scaling_down_policy {
    policy_name = var.task_scaling_down_policy_name
    metric_name = var.task_scaling_down_metric_name
    statistic   = var.task_scaling_down_statistic
    unit        = var.task_scaling_down_unit
    threshold   = var.task_scaling_down_threshold
    action_type = var.task_scaling_down_action_type
    //adjustment            = var.task_scaling_down_adjustment
    min_target_capacity = var.task_scaling_down_min_target_capacity
    max_target_capacity = var.task_scaling_down_max_target_capacity
    namespace           = var.task_scaling_down_namespace
    operator            = var.task_scaling_down_operator
    evaluation_periods  = var.task_scaling_down_evaluation_periods
    period              = var.task_scaling_down_period
    cooldown            = var.task_scaling_down_cooldown
    dimensions = {
      minimum = var.task_scaling_down_minimum
      maximum = var.task_scaling_down_maximum
      target  = var.task_scaling_down_target
    }
  }
  // ----------------------------
  # Core Scaling Policies
  core_scaling_up_policy {
    policy_name = var.core_scaling_up_policy_name
    metric_name = var.core_scaling_up_metric_name
    statistic   = var.core_scaling_up_statistic
    unit        = var.core_scaling_up_unit
    threshold   = var.core_scaling_up_threshold
    action_type = var.core_scaling_up_action_type
    //adjustment            = var.core_scaling_up_adjustment
    min_target_capacity = var.core_scaling_up_min_target_capacity
    max_target_capacity = var.core_scaling_up_max_target_capacity
    namespace           = var.core_scaling_up_namespace
    operator            = var.core_scaling_up_operator
    evaluation_periods  = var.core_scaling_up_evaluation_periods
    period              = var.core_scaling_up_period
    cooldown            = var.core_scaling_up_cooldown
    dimensions = {
      minimum = var.core_scaling_up_minimum
      maximum = var.core_scaling_up_maximum
      target  = var.core_scaling_up_target
    }
  }
  core_scaling_down_policy {
    policy_name = var.core_scaling_down_policy_name
    metric_name = var.core_scaling_down_metric_name
    statistic   = var.core_scaling_down_statistic
    unit        = var.core_scaling_down_unit
    threshold   = var.core_scaling_down_threshold
    action_type = var.core_scaling_down_action_type
    //adjustment            = var.core_scaling_down_adjustment
    min_target_capacity = var.core_scaling_down_min_target_capacity
    max_target_capacity = var.core_scaling_down_max_target_capacity
    namespace           = var.core_scaling_down_namespace
    operator            = var.core_scaling_down_operator
    evaluation_periods  = var.core_scaling_down_evaluation_periods
    period              = var.core_scaling_down_period
    cooldown            = var.core_scaling_down_cooldown
    dimensions = {
      minimum = var.core_scaling_down_minimum
      maximum = var.core_scaling_down_maximum
      target  = var.core_scaling_down_target
    }
  }
  // ----------------------------
  ## Scheduled Task ##
  //  scheduled_task {
  //    is_enabled            = var.is_enabled
  //    task_type             = var.task_type
  //    instance_group_type   = var.instance_group_type
  //    cron                  = var.cron
  //    desired_capacity      = var.desired_capacity
  //    min_capacity          = var.min_capacity
  //    max_capacity          = var.max_capacity
  //  }

  termination_policies {
    statements {
      namespace          = var.namespace
      metric_name        = var.metric_name
      statistic          = var.statistic
      unit               = var.unit
      threshold          = var.threshold
      period             = var.period
      evaluation_periods = var.evaluation_periods
      operator           = var.operator
    }
  }
}

### Call script to get the cluster ID using Spot APIs ###
# This will store the value in a txt file
resource "null_resource" "cluster_id" {
  triggers = {
    cmd = "${path.module}/scripts/get-emr"
  }
  provisioner "local-exec" {
    interpreter = ["/bin/bash", "-c"]
    command     = "${local.cmd} get-id ${spotinst_mrscaler_aws.MrScaler.id} --token ${local.spotinst_token}"
  }
  provisioner "local-exec" {
    when        = destroy
    interpreter = ["/bin/bash", "-c"]
    command     = "${self.triggers.cmd} delete-id"
  }
}


### Call script to get the DNS name/Ip address from the cluster and store in a file ###
resource "null_resource" "dns_name" {
  triggers = {
    cmd = "${path.module}/scripts/get-emr"
  }
  provisioner "local-exec" {
    interpreter = ["/bin/bash", "-c"]
    command     = "${local.cmd} get-dns ${spotinst_mrscaler_aws.MrScaler.id} ${data.local_file.cluster.content} ${var.region}"
  }
  provisioner "local-exec" {
    when        = destroy
    interpreter = ["/bin/bash", "-c"]
    command     = "${self.triggers.cmd} delete-dns"
  }
}


