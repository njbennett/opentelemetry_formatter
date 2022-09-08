import Config


# use OTEL_EXPORTER_OTLP_TRACES_HEADERS=x-honeycomb-team=$HONEYCOMB_API_TOKEN to set the dataset

config :opentelemetry_exporter,
 otlp_protocol: :http_protobuf,
 otlp_compression: :gzip,
 otlp_endpoint: "https://api.honeycomb.io:443",
 otlp_headers: [
         {"x-honeycomb-dataset", "open-telemetry-formatter"}
       ]

config :opentelemetry, :processors, [
  {:otel_batch_processor, %{scheduled_delay_ms: 1 }}
]

config :opentelemetry, :resource, service: %{name: "opentelemetry_formatter"}

