defmodule OpentelemetryFormatterTest do
  use ExUnit.Case
  doctest OpentelemetryFormatter

  test "greets the world" do
    assert OpentelemetryFormatter.hello() == :world
  end
end
