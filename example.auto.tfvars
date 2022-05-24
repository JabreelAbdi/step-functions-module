role_name = "step-function-role-configtemp"

name = "step-function-configtemp"

type = "express"


bandwidth = 33

ReplicationConfigurationTemplateID = "rct-3ffe7f7058fa142b5"

step-expression = "cron(0 18-6 ? * MON-FRI *)" # this cron will run monday to friday between 6pm to 6am

logging_configuration = {
  include_execution_data = true
  level                  = "ALL"
}

######################
# Additional policies
# Probably you are not going to need them (use `service_integrations` instead)!
######################

attach_policy_json = true
policy_json        = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "xray:GetSamplingStatisticSummaries"
            ],
            "Resource": ["*"]
        }
    ]
}
EOF

attach_policy_jsons = true
policy_jsons = [<<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "xray:*"
            ],
            "Resource": ["*"]
        }
    ]
}
EOF
]
number_of_policy_jsons = 1

attach_policy = true
policy        = "arn:aws:iam::aws:policy/AWSXRayDaemonWriteAccess"

attach_policies    = true
policies           = ["arn:aws:iam::aws:policy/AWSXrayReadOnlyAccess"]
number_of_policies = 1

attach_policy_statements = true
policy_statements = {
  dynamodb = {
    effect    = "Allow",
    actions   = ["dynamodb:BatchWriteItem"],
    resources = ["arn:aws:dynamodb:eu-west-1:052212379155:table/Test"]
  },
  s3_read = {
    effect    = "Deny",
    actions   = ["s3:HeadObject", "s3:GetObject"],
    resources = ["arn:aws:s3:::my-bucket/*"]
  }
}

###########################
# END: Additional policies
###########################

tags = {
  Module = "step_function"
}