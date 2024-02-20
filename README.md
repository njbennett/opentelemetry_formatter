# OpenTelemetryFormatter

**TODO: Add description**

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `opentelemetry_formatter` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:opentelemetry_formatter, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at <https://hexdocs.pm/opentelemetry_formatter>.

To get this to actually run you'll need to configure your OpenTelemetry credentials,
and add the OpenTelemetry releases to your application, which will look something like:

```elixir
def project do
  # everything else in this section of mix.exs
releases: [
  my_instrumented_releases: [
    applications: [opentelemetry_exporter: :permanent, opentelemetry: :temporary]
  ]
]
end
```
