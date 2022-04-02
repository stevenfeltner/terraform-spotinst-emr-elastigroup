variable "spotinst_token" {
  type        = string
}
variable "name" {
  type        = string
  description = "Name of the EMR Cluster and Elastigroup"
}
variable "description" {
  type = string
  default = "Created by Spot.io Terraform"
  description = "The MrScaler description."
}
variable "region" {
  type        = string
  description = "The MrScaler description."
}
variable "strategy" {
  type        = string
  default     = "new"
  description = "The MrScaler strategy. Allowed values are new clone and wrap."
}
variable "cluster_id" {
  type        = string
  default     = null
  description = "The MrScaler cluster id."
}
variable "expose_cluster_id" {
  type        = bool
  default     = true
  description = "Allow the cluster_id to set a Terraform output variable."
}

## Provisioning Timeout ##
variable "timeout" {
  type        = number
  default     = 15
  description = "EMR clusters occasionally get stuck in provisioning status due to unhealthy clusters, slowness or other issues. In such cases, a timeout can be used to automatically terminate the cluster after the defined period of time."
}
variable "timeout_action" {
  type        = string
  default     = "terminateAndRetry"
  description = "Desired action if the timeout is exceeded. Currently terminate and terminateAndRetry are supported."
}
##########################

## Cluster Configuration New Strategy Only ##
variable "log_uri" {
  type        = string
  description = "The path to the Amazon S3 location where logs for this cluster are stored."
  default     = ""
}
variable "additional_info" {
  type = string
  default = null
  description = "This is meta information about third-party applications that third-party vendors use for testing purposes."
}
variable "security_config" {
  type = string
  default = null
  description = "The name of the security configuration applied to the cluster."
}
variable "service_role" {
  type        = string
  description = "The IAM role that will be assumed by the Amazon EMR service to access AWS resources on your behalf"
  default     = ""
}
variable "job_flow_role" {
  type        = string
  description = "The IAM role that was specified when the job flow was launched. The EC2 instances of the job flow assume this role."
  default     = ""
}
variable "termination_protected" {
  type        = bool
  default     = false
  description = "Specifies whether the Amazon EC2 instances in the cluster are protected from termination by API calls, user numberervention, or in the event of a job-flow error"
}
variable "keep_job_flow_alive" {
  type        = bool
  default     = false
  description = "Specifies whether the cluster should remain available after completing all steps"
}
variable "retries" {
  type        = number
  default     = 2
  description = "(Requires: timeout_action is set to terminateAndRetry) Specifies the maximum number of times a capacity provisioning should be retried if the provisioning timeout is exceeded. Valid values: 1-5."
}
##########################

## Task Group (Wrap, Clone, and New strategies) ##
variable "task_instance_types" {
  type        = list(string)
  default     = [""]
  description = "The MrScaler instance types for the task nodes."
}
variable "task_desired_capacity" {
  type        = number
  default     = 0
  description = "amount of instances in task group."
}
variable "task_max_size" {
  type        = number
  default     = 100
  description = "maximal amount of instances in task group."
}
variable "task_min_size" {
  type        = number
  default     = 0
  description = "The minimal amount of instances in task group."
}
variable "task_unit" {
  type        = string
  default     = "instance"
  description = "Unit of task group for target, min and max. The unit could be instance or weight. instance - amount of instances. weight - amount of vCPU."
}
variable "task_lifecycle" {
  type        = string
  default     = "SPOT"
  description = "SPOT"
}
variable "task_ebs_optimized" {
  type        = bool
  default     = true
}
variable "task_volume_per_instance" {
  type        = number
  default     = 1
  description = "Amount of volumes per instance in the core group."
}
variable "task_volume_type" {
  type        = string
  default     = "gp2"
  description = "volume type. Allowed values are 'gp2', 'io1' and others."
}
variable "task_size_in_gb" {
  type        = number
  default     = 30
  description = "Size of the volume, in GBs."
}
variable "task_iops" {
  type        = string
  default     = null
  description = " IOPS for the volume. Required in some volume types, such as io1."
}
####################################

## Core Group (Clone, New strategies) ##
variable "core_instance_types" {
  type        = list(string)
  default     = [""]
}
variable "core_desired_capacity" {
  type        = number
  default     = 1
}
variable "core_max_size" {
  type        = number
  default     = 100
}
variable "core_min_size" {
  type        = number
  default     = 0
}
variable "core_unit" {
  type        = string
  default     = "instance"
  description = "Unit of task group for target, min and max. The unit could be instance or weight."
}
variable "core_lifecycle" {
  type        = string
  default     = "SPOT"
  description = "The MrScaler lifecycle for instances in core group. Allowed values are 'SPOT' and 'ON_DEMAND'."
}
variable "core_ebs_optimized" {
  type        = bool
  default     = true
  description = "EBS Optimization setting for instances in group."
}
variable "core_volume_per_instance" {
  type        = number
  default     = 1
  description = "Amount of volumes per instance in the core group."
}
variable "core_volume_type" {
  type        = string
  default     = "gp2"
  description = "Allowed valuse are 'gp2' and others"
}
variable "core_size_in_gb" {
  type        = number
  default     = 30
}
variable "core_iops" {
  type        = string
  default     = null
  description = "IOPS for the volume. Required in some volume types, such as io1."
}
####################################

## Master Group (Clone, New strategies) ##
### Master Node Variables ###
variable "master_instance_type" {
  type        = list(string)
  default     = [""]
}
variable "master_lifecycle" {
  type        = string
  default     = "ON_DEMAND"
}
variable "master_ebs_optimized" {
  type        = bool
  default     = true
}
variable "master_volume_per_instance" {
  type        = number
  default     = 1
}
variable "master_volume_type" {
  type        = string
  default     = "gp2"
}
variable "master_size_in_gb" {
  type        = number
  default     = 30
}
variable "master_iops" {
  type        = string
  default     = null
  description = "IOPS for the volume. Required in some volume types, such as io1."
}
####################################

## Tags (Clone, New strategies) ##
variable "tags" {
  type = list(object({
    key = string
    value = string
  }))
  default = null
  description = "Tags to be added to resources"
}
####################################

## Optional Compute Parameters (New strategy) ##
variable "master_sg_id" {
  type        = string
  default     = ""
  description = "EMR Managed Security group that will be set to the primary instance group."
}
variable "slave_sg_id" {
  type        = string
  default     = ""
  description = "EMR Managed Security group that will be set to the replica instance group."
}
variable "service_sg_id" {
  type        = string
  default     = ""
  description = "The identifier of the Amazon EC2 security group for the Amazon EMR service to access clusters in VPC private subnets."
}
variable "additional_master_sg_ids" {
  type        = list(string)
  default     = [""]
  description = "A list of additional Amazon EC2 security group IDs for the master node."
}
variable "additional_slave_sg_ids" {
  type        = list(string)
  default     = [""]
  description = "A list of additional Amazon EC2 security group IDs for the core and task nodes."
}
variable "custom_ami_id" {
  type        = string
  default     = null
  description = "The ID of a custom Amazon EBS-backed Linux AMI if the cluster uses a custom AMI."
}
variable "repo_upgrade_on_boot" {
  type        = string
  default     = null
  description = "Applies only when custom_ami_id is used. Specifies the type of updates that are applied from the Amazon Linux AMI package repositories when an instance boots using the AMI. Possible values include: SECURITY, NONE."
}
variable "ec2_key_name" {
  type        = string
  default     = null
  description = "The name of an Amazon EC2 key pair that can be used to ssh to the master node."
}
variable "applications" {
  type        = list(object({name = string, version = string}))
  default     = null
}
variable "instance_weights" {
  type        = list(object({instance_type = string, weighted_capacity = string}))
  default     = null
}
####################################

## Availability Zones (Clone, New strategies) ##
variable "availability_zones" {
  type        = list(string)
  description = "List of AZs and their subnet Ids"
}
####################################

## Configurations (Clone, New strategies) ##
variable "config_bucket" {
  type        = string
  default     = ""
}
variable "config_key" {
  type        = string
  default     = ""
}
####################################

## Steps (Clone, New strategies) ##
variable "steps_bucket" {
  type        = string
  default     = ""
}
variable "steps_key" {
  type        = string
  default     = ""
}
####################################

## Bootstrap Actions (Clone, New strategies) ##
variable "bootstrap_bucket" {
  type        = string
  default     = ""
}
variable "bootstrap_key" {
  type        = string
  default     = ""
}
####################################

## Scaling down task Policies ##
variable "task_scaling_down_policy_name" {
  type        = string
  default     = ""
  description = "The name of the policy."
}
variable "task_scaling_down_metric_name" {
  type        = string
  default     = "AppsPending"
  description = "The name of the metric, with or without spaces. Ex. AppsPending"
}
variable "task_scaling_down_statistic" {
  type        = string
  default     = "average"
  description = "The aggregation method of the given metric. Valid Values: average | sum | sampleCount | maximum | minimum"
}
variable "task_scaling_down_unit" {
  type        = string
  default     = "count"
  description = "The unit for the metric. Ex. count"
}
variable "task_scaling_down_threshold" {
  type        = number
  default     = 100
  description = "The value against which the specified statistic is compared."
}
//variable "task_scaling_down_adjustment" {
//  type        = number
//  default     = null
//  description = "The number of instances to add/remove to/from the target capacity when scale is needed."
//}
variable "task_scaling_down_min_target_capacity" {
  type        = number
  default     = null
  description = "Min target capacity for scale down."
}
variable "task_scaling_down_max_target_capacity" {
  type        = number
  default     = null
  description = "Max target capacity for scale down."
}
variable "task_scaling_down_namespace" {
  type        = string
  default     = "AWS/ElasticMapReduce"
  description = "The namespace for the metric."
}
variable "task_scaling_down_operator" {
  type        = string
  default     = "lt"
  description = "The operator to use. Allowed values are : 'gt', 'gte', 'lt' , 'lte'."
}
variable "task_scaling_down_evaluation_periods" {
  type        = number
  default     = 1
  description = "The number of periods over which data is compared to the specified threshold."
}
variable "task_scaling_down_period" {
  type        = number
  default     = 60
  description = "The granularity, in seconds, of the returned datapoints. Period must be at least 60 seconds and must be a multiple of 60."
}
variable "task_scaling_down_cooldown" {
  type        = number
  default     = 300
  description = "The amount of time, in seconds, after a scaling activity completes and before the next scaling activity can start."
}
variable "task_scaling_down_dimensions" {
  type        = string
  default     = null
  description = "A mapping of dimensions describing qualities of the metric."
}
variable "task_scaling_down_minimum" {
  type        = number
  default     = null
  description = "The minimum to set when scale is needed."
}
variable "task_scaling_down_maximum" {
  type        = number
  default     = null
  description = "The maximum to set when scale is needed."
}
variable "task_scaling_down_target" {
  type        = number
  default     = null
  description = "The number of instances to set when scale is needed."
}
variable "task_scaling_down_action_type" {
  type        = string
  default     = "adjustment"
  description = "The type of action to perform. Allowed values are : 'adjustment', 'setMinTarget', 'setMaxTarget', 'updateCapacity', 'percentageAdjustment'"
}
####################################

## Task Scaling Up task Policies ##
variable "task_scaling_up_policy_name" {
  type        = string
  default     = ""
  description = "The name of the policy."
}
variable "task_scaling_up_metric_name" {
  type        = string
  default     = "AppsPending"
  description = "The name of the metric, with or without spaces."
}
variable "task_scaling_up_statistic" {
  type        = string
  default     = "average"
  description = "The aggregation method of the given metric. Valid Values: average | sum | sampleCount | maximum | minimum"
}
variable "task_scaling_up_unit" {
  type        = string
  default     = "count"
  description = "The unit for the metric. Ex. count"
}
variable "task_scaling_up_threshold" {
  type        = number
  default     = 100
  description = "The value against which the specified statistic is compared."
}
//variable "task_scaling_up_adjustment" {
//  type        = number
//  default     = null
//  description = "The number of instances to add/remove to/from the target capacity when scale is needed."
//}
variable "task_scaling_up_min_target_capacity" {
  type        = number
  default     = null
  description = "Min target capacity for scale up."
}
variable "task_scaling_up_max_target_capacity" {
  type        = number
  default     = null
  description = "Max target capacity for scale up."
}
variable "task_scaling_up_namespace" {
  type        = string
  default     = "AWS/ElasticMapReduce"
  description = "The namespace for the metric."
}
variable "task_scaling_up_operator" {
  type        = string
  default     = null
  description = "The operator to use. Allowed values are : 'gt', 'gte', 'lt' , 'lte'."
}
variable "task_scaling_up_evaluation_periods" {
  type        = number
  default     = 1
  description = "The number of periods over which data is compared to the specified threshold."
}
variable "task_scaling_up_period" {
  type        = number
  default     = 60
  description = "The granularity, in seconds, of the returned datapoints. Period must be at least 60 seconds and must be a multiple of 60."
}
variable "task_scaling_up_cooldown" {
  type        = number
  default     = 300
  description = "The amount of time, in seconds, after a scaling activity completes and before the next scaling activity can start."
}
variable "task_scaling_up_dimensions" {
  type        = string
  default     = null
  description = "A mapping of dimensions describing qualities of the metric."
}
variable "task_scaling_up_minimum" {
  type        = number
  default     = null
  description = "The minimum to set when scale is needed."
}
variable "task_scaling_up_maximum" {
  type        = number
  default     = null
  description = "The maximum to set when scale is needed."
}
variable "task_scaling_up_target" {
  type        = number
  default     = null
  description = "The number of instances to set when scale is needed."
}
variable "task_scaling_up_action_type" {
  type        = string
  default     = "adjustment"
  description = "The type of action to perform. Allowed values are : 'adjustment', 'setMinTarget', 'setMaxTarget', 'updateCapacity', 'percentageAdjustment'"
}
####################################

## core scaling down Policies ##
variable "core_scaling_down_policy_name" {
  type        = string
  default     = ""
  description = "The name of the policy."
}
variable "core_scaling_down_metric_name" {
  type        = string
  default     = "AppsPending"
  description = "The name of the metric, with or without spaces."
}
variable "core_scaling_down_statistic" {
  type        = string
  default     = "average"
  description = "The aggregation method of the given metric. Valid Values: average | sum | sampleCount | maximum | minimum"
}
variable "core_scaling_down_unit" {
  type        = string
  default     = "count"
  description = "The unit for the metric. Ex. count"
}
variable "core_scaling_down_threshold" {
  type        = number
  default     = 10
  description = "The value against which the specified statistic is compared."
}
//variable "core_scaling_down_adjustment" {
//  type        = number
//  default     = null
//  description = "The number of instances to add/remove to/from the target capacity when scale is needed."
//}
variable "core_scaling_down_min_target_capacity" {
  type        = number
  default     = null
  description = "Min target capacity for scale down."
}
variable "core_scaling_down_max_target_capacity" {
  type        = number
  default     = null
  description = "Max target capacity for scale down."
}
variable "core_scaling_down_namespace" {
  type        = string
  default     = "AWS/ElasticMapReduce"
  description = "The namespace for the metric."
}
variable "core_scaling_down_operator" {
  type        = string
  default     = null
  description = "The operator to use. Allowed values are : 'gt', 'gte', 'lt' , 'lte'."
}
variable "core_scaling_down_evaluation_periods" {
  type        = number
  default     = 1
  description = "The number of periods over which data is compared to the specified threshold."
}
variable "core_scaling_down_period" {
  type        = number
  default     = 60
  description = "The granularity, in seconds, of the returned datapoints. Period must be at least 60 seconds and must be a multiple of 60."
}
variable "core_scaling_down_cooldown" {
  type        = number
  default     = 300
  description = "The amount of time, in seconds, after a scaling activity completes and before the next scaling activity can start."
}
variable "core_scaling_down_dimensions" {
  type        = string
  default     = null
  description = "A mapping of dimensions describing qualities of the metric."
}
variable "core_scaling_down_minimum" {
  type        = number
  default     = null
  description = "The minimum to set when scale is needed."
}
variable "core_scaling_down_maximum" {
  type        = number
  default     = null
  description = "The maximum to set when scale is needed."
}
variable "core_scaling_down_target" {
  type        = number
  default     = null
  description = "The number of instances to set when scale is needed."
}
variable "core_scaling_down_action_type" {
  type        = string
  default     = "adjustment"
  description = "The type of action to perform. Allowed values are : 'adjustment', 'setMinTarget', 'setMaxTarget', 'updateCapacity', 'percentageAdjustment'"
}
####################################

## core Scaling Up Policies ##
variable "core_scaling_up_policy_name" {
  type        = string
  default     = ""
  description = "The name of the policy."
}
variable "core_scaling_up_metric_name" {
  type        = string
  default     = "AppsPending"
  description = "The name of the metric, with or without spaces."
}
variable "core_scaling_up_statistic" {
  type        = string
  default     = "average"
  description = "The aggregation method of the given metric. Valid Values: average | sum | sampleCount | maximum | minimum"
}
variable "core_scaling_up_unit" {
  type        = string
  default     = "count"
  description = "The unit for the metric. Ex. count"
}
variable "core_scaling_up_threshold" {
  type        = number
  default     = 100
  description = "The value against which the specified statistic is compared."
}
//variable "core_scaling_up_adjustment" {
//  type        = number
//  default     = 1
//  description = "The number of instances to add/remove to/from the target capacity when scale is needed."
//}
variable "core_scaling_up_min_target_capacity" {
  type        = number
  default     = null
  description = "Min target capacity for scale up."
}
variable "core_scaling_up_max_target_capacity" {
  type        = number
  default     = null
  description = "Max target capacity for scale up."
}
variable "core_scaling_up_namespace" {
  type        = string
  default     = "AWS/ElasticMapReduce"
  description = "The namespace for the metric."
}
variable "core_scaling_up_operator" {
  type        = string
  default     = "gt"
  description = "The operator to use. Allowed values are : 'gt', 'gte', 'lt' , 'lte'."
}
variable "core_scaling_up_evaluation_periods" {
  type        = number
  default     = 1
  description = "The number of periods over which data is compared to the specified threshold."
}
variable "core_scaling_up_period" {
  type        = number
  default     = 60
  description = "The granularity, in seconds, of the returned datapoints. Period must be at least 60 seconds and must be a multiple of 60."
}
variable "core_scaling_up_cooldown" {
  type        = number
  default     = 300
  description = "The amount of time, in seconds, after a scaling activity completes and before the next scaling activity can start."
}
variable "core_scaling_up_dimensions" {
  type        = string
  default     = null
  description = "A mapping of dimensions describing qualities of the metric. Ex JobFlowId"
}
variable "core_scaling_up_minimum" {
  type        = number
  default     = null
  description = "The minimum to set when scale is needed."
}
variable "core_scaling_up_maximum" {
  type        = number
  default     = null
  description = "The maximum to set when scale is needed."
}
variable "core_scaling_up_target" {
  type        = number
  default     = null
  description = "The number of instances to set when scale is needed."
}
variable "core_scaling_up_action_type" {
  type        = string
  default     = "adjustment"
  description = "The type of action to perform. Allowed values are : 'adjustment', 'setMinTarget', 'setMaxTarget', 'updateCapacity', 'percentageAdjustment'"
}
####################################

## Scheduled Tasks ##
variable "is_enabled" {
  type        = bool
  default     = false
  description = "Enable/Disable the specified scheduling task."
}
variable "task_type" {
  type        = string
  default     = "setCapacity"
  description = "The type of task to be scheduled. Valid values: setCapacity."
}
variable "instance_group_type" {
  type        = string
  default     = "task"
  description = "Select the EMR instance groups to execute the scheduled task on. Valid values: task."
}
variable "cron" {
  type        = string
  default     = "1 0 * * * *"
}
variable "desired_capacity" {
  type        = number
  default     = null
  description = "New desired capacity for the elastigroup."
}
variable "min_capacity" {
  type        = number
  default     = null
  description = "New min capacity for the elastigroup."
}
variable "max_capacity" {
  type        = number
  default     = null
  description = "New min capacity for the elastigroup."
}
####################################

## Termination Policies ##
variable "namespace" {
  type        = string
  default     = "AWS/ElasticMapReduce"
  description = "Must contain the value: AWS/ElasticMapReduce."
}
variable "metric_name" {
  type        = string
  default     = "AppsPending"
  description = "The name of the metric in CloudWatch which the statement will be based on."
}
variable "statistic" {
  type        = string
  default     = "sum"
  description = "The aggregation method of the given metric. Valid Values: average | sum | sampleCount | maximum | minimum"
}
variable "unit" {
  type        = string
  default     = "count"
  description = "Default: (count) The unit for a given metric. Valid Values: seconds | microseconds | milliseconds | bytes | kilobytes | megabytes | gigabytes | terabytes | bits | kilobits | megabits | gigabits | terabits | percent | count | bytes/second | kilobytes/second | megabytes/second | gigabytes/second | terabytes/second | bits/second | kilobits/second | megabits/second | gigabits/second | terabits/second | count/second | none"
}
variable "threshold" {
  type        = number
  default     = 10
  description = "The value that the specified statistic is compared to."
}
variable "period" {
  type        = number
  default     = 300
  description = "The time window in seconds over which the statistic is applied."
}
variable "evaluation_periods" {
  type        = number
  default     = 1
  description = "The number of periods over which data is compared to the specified threshold."
}
variable "operator" {
  type        = string
  default     = "gte"
  description = "The operator to use in order to determine if the policy is applicable. Valid values: gt | gte | lt | lte"
}
####################################


variable "release_label" {
  type        = string
  default     = "emr-5.33.0"
  description = "Version of EMR in format emr-5.33.0"
}

####################################







