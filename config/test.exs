import Config

# Print only warnings and errors during test
config :logger, level: :warn

config :opentelemetry_exporter,
  otlp_protocol: :http_protobuf,
  otlp_compression: :gzip,
  otlp_endpoint: "https://api.honeycomb.io:443",
  otlp_headers: [
    {"x-honeycomb-dataset", "open-telemetry-formatter"}
  ]

config :opentelemetry, :processors, [
  {:otel_batch_processor, %{scheduled_delay_ms: 1}}
]

config :opentelemetry, :resource, service: %{name: "opentelemetry_formatter"}
