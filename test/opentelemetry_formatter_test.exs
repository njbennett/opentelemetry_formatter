defmodule OpentelemetryFormatterTest do
  use ExUnit.Case, async: true
  doctest OpentelemetryFormatter

  require Record
  @fields Record.extract(:span, from: "deps/opentelemetry/include/otel_span.hrl")
  Record.defrecordp(:span, @fields)

  test "emits trace" do
    OpentelemetryFormatter.test_cast
  end

  @tag :skip
  test "emits traces" do
    :otel_batch_processor.set_exporter(:otel_exporter_pid, self())
    OpenTelemetry.get_tracer(:test_tracer)

    callback = { :event, :details }

    OpentelemetryFormatter.handle_cast(callback, {})

    attributes = :otel_attributes.new([lupus: "it's never lupus"], 128, :infinity)

    assert_receive {:span, span(
      name: "handle_cast",
      attributes: ^attributes
    )}
  end
 
  @tag :skip
  test "greets the world" do
    :otel_batch_processor.set_exporter(:otel_exporter_pid, self())
    OpenTelemetry.get_tracer(:test_tracer)

    callback = { :event, :details }

    OpentelemetryFormatter.hello()

    attributes = :otel_attributes.new([lupus: "it's never lupus"], 128, :infinity)

    assert_receive {:span, span(
      name: "handle_cast",
      attributes: ^attributes
    )}
  end
end
