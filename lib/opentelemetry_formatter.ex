defmodule OpentelemetryFormatter do
  use GenServer
  require OpenTelemetry.Tracer, as: Tracer

  def hello do
    Tracer.with_span "operation" do
      Tracer.set_attributes([{:a_key, "a value"}])
      :world
    end
  end

  def init(opts) do
    config = %{
      seed: opts[:seed],
      trace: opts[:trace]
    }
    { :ok, config }
  end

  def handle_cast({event, _details}, state) do
    Tracer.with_span event do
      Tracer.set_attributes([{:a_key, "a value"}])
    end

    {:ok, state}
  end

  def test_cast do
    handle_cast({"test cast", {}}, {})
  end
end
