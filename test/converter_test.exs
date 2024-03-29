defmodule ConverterTest do
  use ExUnit.Case, async: true
  doctest OpenTelemetryFormatter.Converter

  describe "to_list" do
    test "it takes a test case and returns a list of tuples" do
      test_finished = %ExUnit.Test{
        case: :test_case,
        logs: "logs",
        module: :module,
        name: :test_name,
        state: {:failed, "failure"},
        tags: %{tag: "tag"},
        time: 10000
      }

      expected_list = [
        {"test.name", :test_name},
        {"test.status", :failed},
        {"test.succeeded?", 0}
      ]

      assert OpenTelemetryFormatter.Converter.to_list(test_finished) == expected_list
    end

    test "it interprets nil as success" do
      test_started = %ExUnit.Test{
        case: :test_case,
        logs: "logs",
        module: :module,
        name: :test_name,
        state: nil,
        tags: %{tag: "tag"},
        time: 10000
      }

      expected_list = [
        {"test.name", :test_name},
        {"test.status", :success},
        {"test.succeeded?", 1}
      ]

      assert OpenTelemetryFormatter.Converter.to_list(test_started) == expected_list
    end
  end
end
