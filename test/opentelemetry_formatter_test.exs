defmodule OpentelemetryFormatterTest do
  use ExUnit.Case

  alias OpentelemetryFormatter, as: Formatter

  require Record
  @fields Record.extract(:span, from: "deps/opentelemetry/include/otel_span.hrl")
  Record.defrecordp(:span, @fields)

  test "init returns a config" do
    opts = %{}
    expected_config = opts
    { :ok, config } = Formatter.init(opts)
    assert config == expected_config
  end

  test "it emits a span for a test" do
    :otel_batch_processor.set_exporter(:otel_exporter_pid, self())
    OpenTelemetry.get_tracer(:test_tracer)

    test = %ExUnit.Test{
      case: :test_case,
      logs: "logs",
      module: :module,
      name: :test_name,
      state: {:failed, "failure"},
      tags: %{tag: "tag"},
      time: 10000
    }

    state = %{}

    struct = %{__struct__: ExUnit.Test, case: :test_case, logs: "logs", module: :module, name: :test_name, time: 10000}

    attributes = :otel_attributes.new(struct, 128, :infinity)

    Formatter.handle_cast({:test_started, test}, state)

    assert_receive {:span, span(
      name: "test",
      attributes: ^attributes
      )}, 1_000
  end

  test "it returns status and config" do
    test = %ExUnit.Test{
      case: :test_case,
      logs: "logs",
      module: :module,
      name: :test_name,
      state: {:failed, "failure"},
      tags: %{tag: "tag"},
      time: 10000
    }

    state = %{}

    {:noreply, config } = Formatter.handle_cast({:test_started, test}, state)

    assert state == config
  end
end
