# lib/otel_getting_started.ex
defmodule OtelGettingStarted do
  require OpenTelemetry.Tracer, as: Tracer

  def hello do
    Tracer.with_span "operation" do
      Tracer.set_attributes([{:a_key, "a_value"}])
      :world
    end
  end

  def eat_acacia() do
    send(self(), {"mlmlmlm"})
  end
end

