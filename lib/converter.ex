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
      [{"test.name", test.name}]
    end
  end

end
