resource "confluent_connector" "mongodb_products" {
    environment {
        id = confluent_environment.training.id 
    }
    kafka_cluster {
        id = confluent_kafka_cluster.kafka_cluster.id
    }
    status = "RUNNING"
    config_sensitive = {
        "connection.user": "${var.db_user}",
        "connection.password": "${var.db_pass}",
    }
    config_nonsensitive = {
    "connector.class": "MongoDbAtlasSource",
    "name": "MongoDbAtlasSourceConnector_${var.db_name}",
    "kafka.auth.mode": "KAFKA_API_KEY",
    "kafka.api.key": "${confluent_api_key.kafka_api_key.id}"
    "kafka.api.secret": "${confluent_api_key.kafka_api_key.secret}",
    "connection.host": "${var.atlas_cluster_connection_string}",
    "database": "${var.db_name}",
    "collection": "${var.collection_name}",
    "poll.await.time.ms": "5000",
    "poll.max.batch.size": "100",
    "pipeline": "[]",
    "copy.existing": "true",
    "copy.existing.pipeline": "[]",
    "batch.size": "0",
    "output.data.format": "JSON",
    "publish.full.document.only": "true",
    "json.output.decimal.format": "NUMERIC",
    "change.stream.full.document": "default",
    "output.json.format": "DefaultJson",
    "topic.separator": ".",
    "heartbeat.interval.ms": "0",
    "heartbeat.topic.name": "__mongodb_heartbeats",
    "mongo.errors.tolerance": "NONE",
    "server.api.deprecation.errors": "false",
    "server.api.strict": "false",
    "tasks.max": "1"
  }
    depends_on = [
        confluent_kafka_cluster.kafka_cluster,
        confluent_api_key.kafka_api_key,
    ]
}
