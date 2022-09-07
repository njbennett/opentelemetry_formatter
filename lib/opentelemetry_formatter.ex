defmodule OpentelemetryFormatter do
  require OpenTelemetry.Tracer, as: Tracer

  def init(opts) do
    { :ok, opts }
  end

  def handle_event({ _event_type, test}) do
    Tracer.with_span "test" do
      Tracer.set_attributes(test)
      :world
    end
  end
end
