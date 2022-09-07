defmodule OtelGettingStartedTest do
  use ExUnit.Case, async: true
  doctest OtelGettingStarted

  require Record
  @fields Record.extract(:span, from: "deps/opentelemetry/include/otel_span.hrl")
  Record.defrecordp(:span, @fields)

  test "greets the world" do
    :otel_batch_processor.set_exporter(:otel_exporter_pid, self())
    OpenTelemetry.get_tracer(:test_tracer)

    OtelGettingStarted.hello()

    attributes = :otel_attributes.new([a_key: "a_value"], 128, :infinity)

    assert_receive {:span, span(
      name: "operation",
      attributes: ^attributes
      )}
  end
end

