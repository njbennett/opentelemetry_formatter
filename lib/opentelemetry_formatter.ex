defmodule OpentelemetryFormatter do
  require OpenTelemetry.Tracer, as: Tracer

  def init(opts) do
    { :ok, opts }
  end

  def handle_cast({ _event_type, test}, state) do
    Tracer.with_span "test" do
      Tracer.set_attributes(test)
      { :noreply, state }
    end
  end
end
