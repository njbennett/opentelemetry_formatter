import Config

# Print only warnings and errors during test
config :logger, level: :warn

# use OTEL_EXPORTER_OTLP_TRACES_HEADERS=x-honeycomb-team=$HONEYCOMB_API_TOKEN to set the dataset

config :opentelemetry, :processors,
otel_simple_processor: %{
  exporter: {:opentelemetry_exporter, %{endpoints: ["https://api.honeycomb.io:443"],
                                        headers: [{"x-honeycoomb-dataset", "elderflower-tests"}]}}
}

config :opentelemetry, :resource, service: %{name: "opentelemetry_formatter"}
