provider "aws" {}


// Create source storage and send events for encoding and storing information in database.

module "event-driven-storage_sources" {
    source = "./event-driven-storage"
    name = "ede-sources"
}

module "create-sns-queue_encode-source" {
    source = "./create-sns-queue"
    name = "encode-sources"
    topic_arn = "${module.event-driven-storage_sources.topic_arn}"
}

module "create-sns-queue_add-source-to-db" {
    source = "./create-sns-queue"
    name = "add-source-to-db"
    topic_arn = "${module.event-driven-storage_sources.topic_arn}"
}

// Create encode storage and send events for storing information in database.

module "event-driven-storage_encodes" {
    source = "./event-driven-storage"
    name = "ede-encodes"
}

module "create-sns-queue_add-encode-to-db" {
    source = "./create-sns-queue"
    name = "add-encode-to-db"
    topic_arn = "${module.event-driven-storage_encodes.topic_arn}"
}
