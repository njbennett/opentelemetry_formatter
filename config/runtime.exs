import Config

config :opentelemetry,
  span_processor: :batch,
  traces_exporter: :otlp

 config :opentelemetry_exporter,
  otlp_protocol: :grpc,
  otlp_compression: :gzip,
  otlp_endpoint: "https://api.honeycomb.io:443",
  otlp_headers: [
          {"x-honeycomb-team", "0nOmkIaoRwFX7xGPlj1xNC"},
          {"x-honeycomb-dataset", "experiments"}
        ]
