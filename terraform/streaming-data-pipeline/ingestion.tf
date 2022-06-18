#----------------------
# STREAM POOL
#----------------------

resource "oci_streaming_stream_pool" "test_streaming_pool" {
  compartment_id = local.oci_compartment_id
  name           = "test"

  kafka_settings {
    auto_create_topics_enable = false
    log_retention_hours       = 24
    num_partitions            = 1
  }
}

#----------------------
# STREAMS
#----------------------

resource "oci_streaming_stream" "test_stream" {
  name       = "oanda-raw-prices"
  partitions = 1

  retention_in_hours = 24
  stream_pool_id     = oci_streaming_stream_pool.test_streaming_pool.id
}

