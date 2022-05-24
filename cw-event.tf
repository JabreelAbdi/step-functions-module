resource "aws_cloudwatch_event_rule" "update-replication-configuration-template-rule" {
  name        = "update-replication-configuration-template"
  description = "This rules will update-replication-configuration-template with shedule expression"

  schedule_expression = var.step-expression #UPDATE ME
}

resource "aws_cloudwatch_event_target" "update-replication-configuration-template-target" {
  rule     = aws_cloudwatch_event_rule.update-replication-configuration-template-rule.name
  arn      = aws_sfn_state_machine.this.arn
  role_arn = "arn:aws:iam::186431664837:role/test-step-event"

}


#########################################
# creating role for cloudwatch event rule
#########################################

resource "aws_iam_role" "cw-step-function-alarm-role" {
  assume_role_policy = data.aws_iam_policy_document.instance-assume-role-policy.json
  name               = "cw-step-function-alarm-role"
}

data "aws_iam_policy_document" "cw-step-function-alarm-poilcy-document" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["events.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "cw-event-step-function-policy-document" {
  statement {
    effect    = "Allow"
    actions   = ["states:StartExecution"]
    resources = [ "arn:aws:states:*:*:stateMachine:*" ]
  }
}

resource "aws_iam_policy" "cw-step-function-alarm-poilcy" {
  name   = "cw-step-function-alarm-poilcy"
  policy = data.aws_iam_policy_document.cw-event-step-function-policy-document.json
}

resource "aws_iam_role_policy_attachment" "cw-step-function-alarm-poilcy-attachment" {
  role       = aws_iam_role.cw-step-function-alarm-role.name
  policy_arn = aws_iam_policy.cw-step-function-alarm-poilcy.arn
}