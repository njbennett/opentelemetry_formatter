defmodule OpenTelemetryFormatter.Converter do
  @doc ~S"""
  Parses the given `line` into a command.

  ## Examples

      iex> OpenTelemetryFormatter.Converter.to_list(%ExUnit.Test{})
      []

  """
  def to_list(test) do
    if test == %ExUnit.Test{} do
      []
    else
      if test.state == nil do
        [
          {"test.name", test.name},
          {"test.status", :success},
          {"test.succeeded?", 1}
        ]
      else
        {state, _} = test.state

        success =
          if state == :failed do
            0
          else
            1
          end

        [
          {"test.name", test.name},
          {"test.status", state},
          {"test.succeeded?", success}
        ]
      end
    end
  end
end
