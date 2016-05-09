variable "name" {}
variable "topic_arn" {}

resource "aws_sqs_queue" "queue" {
    name = "${var.name}"
    policy = <<POLICY
{
  "Version":"2012-10-17",
  "Statement":[
    {
      "Effect":"Allow",
      "Principal":"*",
      "Action":"sqs:SendMessage",
      "Resource":"arn:aws:sqs:*:*:${var.name}",
      "Condition":{
        "ArnEquals":{
          "aws:SourceArn":"${var.topic_arn}"
        }
      }
    }
  ]
}
POLICY
}

resource "aws_sns_topic_subscription" "sns_subscription" {
    topic_arn = "${var.topic_arn}"
    protocol  = "sqs"
    endpoint  = "${aws_sqs_queue.queue.arn}"
}
