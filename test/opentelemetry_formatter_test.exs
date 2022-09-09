defmodule OpentelemetryFormatterTest do
  use ExUnit.Case, async: false

  alias OpentelemetryFormatter, as: Formatter
  require OpenTelemetry.Span, as: Span

  require Record
  @fields Record.extract(:span, from: "deps/opentelemetry/include/otel_span.hrl")
  Record.defrecordp(:span, @fields)

  test "init returns a config" do
    opts = %{}
    expected_state = %{
      active_spans: %{}
    }
    {:ok, state} = Formatter.init(opts)
    assert state == expected_state
  end

  describe "handling :test_finished" do
    setup do
      :otel_batch_processor.set_exporter(:otel_exporter_pid, self())
      OpenTelemetry.get_tracer(:test_tracer)

      on_exit(fn ->
        exporter_config = Enum.into(Application.get_all_env(:opentelemetry_exporter), %{})
        :otel_batch_processor.set_exporter(:opentelemetry_exporter, exporter_config)
      end)
    end

    test "it emits a span for a test that finishes" do
      test_started = %ExUnit.Test{
        case: :test_case,
        logs: "logs",
        module: :module,
        name: :test_name,
        state: nil,
        tags: %{tag: "tag"},
        time: 10000
          }

      test_finished = %ExUnit.Test{
        case: :test_case,
        logs: "logs",
        module: :module,
        name: :test_name,
        state: {:failed, "failure"},
        tags: %{tag: "tag"},
        time: 10000
          }

      {:ok, state} = Formatter.init({})

      {:noreply, state_with_ctx } = Formatter.handle_cast({:test_started, test_started}, state)

      {:noreply, _final_state } = Formatter.handle_cast({:test_finished, test_finished}, state_with_ctx)

      assert_receive {:span, span(name: "test")},
                     1_000
    end

    test "ends the span ctx" do
      test_started = %ExUnit.Test{
        case: :test_case,
        logs: "logs",
        module: :module,
        name: :test_name,
        state: nil,
        tags: %{tag: "tag"},
        time: 10000
          }

      test_finished = %ExUnit.Test{
        case: :test_case,
        logs: "logs",
        module: :module,
        name: :test_name,
        state: {:failed, "failure"},
        tags: %{tag: "tag"},
        time: 10000
          }

      {:ok, state} = Formatter.init({})

      {:noreply, state_with_ctx } = Formatter.handle_cast({:test_started, test_started}, state)

      {:noreply, final_state } = Formatter.handle_cast({:test_finished, test_finished}, state_with_ctx)

      %{active_spans: %{ test_name: span_ctx }} = final_state
      refute Span.is_recording(span_ctx)
  end

  end

  test "it returns status and config when it handles :suite_started" do
    state = %{}
    opts = %{}

    {:noreply, config} = Formatter.handle_cast({:suite_started, opts}, state)

    assert state == config
  end

  test "it returns status and config when it handles :suite_finished" do
    state = %{}
    opts = %{}

    {:noreply, config} = Formatter.handle_cast({:suite_finished, opts}, state)

    assert state == config
  end

  test "it returns status and config when it handles :case_started" do
    state = %{}
    opts = %{}

    {:noreply, config} = Formatter.handle_cast({:case_started, opts}, state)

    assert state == config
  end

  test "it returns status and config when it handles :case_finished" do
    state = %{}
    module = %{}

    {:noreply, config} = Formatter.handle_cast({:case_finished, module}, state)

    assert state == config
  end

  test "it returns status and config when it handles :module_started" do
    state = %{}
    module = %{}

    {:noreply, config} = Formatter.handle_cast({:module_started, module}, state)

    assert state == config
  end

  test "it returns status and config when it handles :module_finished" do
    state = %{}
    module = %{}

    {:noreply, config} = Formatter.handle_cast({:module_finished, module}, state)

    assert state == config
  end

  test "when it starts a test it returns span context as part of state" do
    state = %{
      active_spans: %{
        existing_test: :fake_span
      }
    }

    test = %ExUnit.Test{
      case: :test_case,
      logs: "logs",
      module: :module,
      name: :test_name,
      state: nil,
      tags: %{tag: "tag"},
      time: 10000
    }

      {:noreply, new_state} = Formatter.handle_cast({:test_started, test}, state)

      %{active_spans: %{ test_name: span_ctx }} = new_state
      assert Span.is_valid(span_ctx)
    end

  test "it adds new spans to existing context" do
    state = %{
      active_spans: %{
        existing_test: :fake_span
      }
    }

    test = %ExUnit.Test{
      case: :test_case,
      logs: "logs",
      module: :module,
      name: :test_name,
      state: nil,
      tags: %{tag: "tag"},
      time: 10000
    }

      {:noreply, new_state} = Formatter.handle_cast({:test_started, test}, state)

      assert new_state[:active_spans][:existing_test] == :fake_span
  end
end
