import Config

config :opentelemetry_exporter,
 otlp_protocol: :http_protobuf,
 otlp_compression: :gzip,
 otlp_endpoint: "https://api.honeycomb.io:443",
 otlp_headers: [
         {"x-honeycomb-team", "0nOmkIaoRwFX7xGPlj1xNC"},
         {"x-honeycomb-dataset", "experiments"}
       ]

config :opentelemetry, :processors, [
  {:otel_batch_processor, %{scheduled_delay_ms: 1 }}
]
