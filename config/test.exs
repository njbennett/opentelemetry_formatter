# config/test.exs
import Config

config :opentelemetry,
    traces_exporter: :undefined

config :opentelemetry, :processors, [
  {:otel_batch_processor, %{scheduled_delay_ms: 1}}
]

