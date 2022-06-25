output "oci_streaming_pool_id" {
  value = oci_streaming_stream_pool.test_streaming_pool.id
}

output "oci_streaming_bootstrap_kafka_server" {
  value = oci_streaming_stream_pool.test_streaming_pool.kafka_settings[0].bootstrap_servers
}

output "endpoint" {
  value = data.google_container_cluster.gke_autopilot_paris.endpoint
}
