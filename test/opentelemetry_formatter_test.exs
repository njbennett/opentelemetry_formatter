defmodule OpentelemetryFormatterTest do
  use ExUnit.Case, async: false

  alias OpentelemetryFormatter, as: Formatter

  require Record
  @fields Record.extract(:span, from: "deps/opentelemetry/include/otel_span.hrl")
  Record.defrecordp(:span, @fields)

  test "init returns a config" do
    opts = %{}
    expected_config = opts
    {:ok, config} = Formatter.init(opts)
    assert config == expected_config
  end

  describe "emitting spans" do
    setup do
      :otel_batch_processor.set_exporter(:otel_exporter_pid, self())
      OpenTelemetry.get_tracer(:test_tracer)

      on_exit(fn ->
        exporter_config = Enum.into(Application.get_all_env(:opentelemetry_exporter), %{})
        :otel_batch_processor.set_exporter(:opentelemetry_exporter, exporter_config)
      end)
    end

    test "it emits a span for a test that finishes" do
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

      Formatter.handle_cast({:test_finished, test}, state)

      assert_receive {:span, span(name: "test")},
                     1_000
    end
  end

  test "it returns status and config when it handles :test_finished" do
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

    {:noreply, config } = Formatter.handle_cast({:test_finished, test}, state)

    assert state == config
  end

  test "it returns status and config when it handles :suite_started" do
    state = %{}
    opts = %{}

    {:noreply, config } = Formatter.handle_cast({:suite_started, opts}, state)

    assert state == config
  end

  test "it returns status and config when it handles :suite_finished" do
    state = %{}
    opts = %{}

    {:noreply, config } = Formatter.handle_cast({:suite_finished, opts}, state)

    assert state == config
  end

  test "it returns status and config when it handles :case_started" do
    state = %{}
    opts = %{}

    {:noreply, config } = Formatter.handle_cast({:case_started, opts}, state)

    assert state == config
  end

  test "it returns status and config when it handles :case_finished" do
    state = %{}
    module = %{}

    {:noreply, config } = Formatter.handle_cast({:case_finished, module}, state)

    assert state == config
  end

  test "it returns status and config when it handles :module_started" do
    state = %{}
    module = %{}

    {:noreply, config } = Formatter.handle_cast({:module_started, module}, state)

    assert state == config
  end

  test "it returns status and config when it handles :module_finished" do
    state = %{}
    module = %{}

    {:noreply, config } = Formatter.handle_cast({:module_finished, module}, state)

    assert state == config
  end

  test "it returns status and config when it handles :test_started" do
    state = %{}
    test = %ExUnit.Test{
      case: :test_case,
      logs: "logs",
      module: :module,
      name: :test_name,
      state: nil,
      tags: %{tag: "tag"},
      time: 10000
    }

    {:noreply, config } = Formatter.handle_cast({:test_started, test}, state)

    assert state == config
  end
end
