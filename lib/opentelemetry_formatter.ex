defmodule OpentelemetryFormatter do
  require OpenTelemetry.Tracer, as: Tracer

  def init(opts) do
    { :ok, opts }
  end

  def handle_cast({:test_started, _test}, state) do
    { :noreply, state }
  end

  def handle_cast({:test_finished, test}, state) do
    Tracer.with_span "test" do
      Tracer.set_attributes(test)
      { :noreply, state }
    end
  end

  def handle_cast({:suite_started, _opts}, state) do
    { :noreply, state }
  end

  def handle_cast({:suite_finished, _opts}, state) do
    { :noreply, state }
  end

  def handle_cast({:case_started, _test_module}, state) do
    { :noreply, state }
  end

  def handle_cast({:case_finished, _test_module}, state) do
    { :noreply, state }
  end

  def handle_cast({:module_started, _test_module}, state) do
    { :noreply, state }
  end

  def handle_cast({:module_finished, _test_module}, state) do
    { :noreply, state }
  end
end
