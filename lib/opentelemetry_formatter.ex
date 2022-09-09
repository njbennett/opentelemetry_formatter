defmodule OpentelemetryFormatter do
  require OpenTelemetry.Tracer, as: Tracer
  require OpenTelemetry.Span, as: Span

  def init(_opts) do
    {:ok, %{active_spans: %{}}}
  end

  def handle_cast({:test_started, test}, state) do
    ctx = Tracer.start_span("test", %{})
    active_spans = state[:active_spans]
    new_active_spans = Map.put(active_spans, test.name, ctx)

    state_with_ctx = %{state | active_spans: new_active_spans }
    {:noreply, state_with_ctx}
  end

  def handle_cast({:test_finished, test}, state) do
    test_name = test.name
    %{active_spans: %{ ^test_name => span_ctx }} = state
    ended_ctx = Span.end_span(span_ctx)
    active_spans = state[:active_spans]
    new_active_spans = Map.put(active_spans, test.name, ended_ctx)

    state_with_ctx = %{state | active_spans: new_active_spans }
    {:noreply, state_with_ctx}
  end

  def handle_cast({:suite_started, _opts}, state) do
    {:noreply, state}
  end

  def handle_cast({:suite_finished, _opts}, state) do
    {:noreply, state}
  end

  def handle_cast({:case_started, _test_module}, state) do
    {:noreply, state}
  end

  def handle_cast({:case_finished, _test_module}, state) do
    {:noreply, state}
  end

  def handle_cast({:module_started, _test_module}, state) do
    {:noreply, state}
  end

  def handle_cast({:module_finished, _test_module}, state) do
    {:noreply, state}
  end
end
