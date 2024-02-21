# OpenTelemetryFormatter

This is an ExUnit formatter that emits OpenTelemetry traces for each test suite,
with individual spans for each test. It's designed to be used to identify tests that fail intermittently and help understand why they're failing.

If you use it, or try to use it, please get in touch. My e-mail is nat@simplermachines.com and I also try to keep an eye on the issues in this repo.

## Installation

This package isn't on Hex yet, so you'll need to either get it from Github directly, or clone it locally and include it in your deps like this:

```elixir
def deps do
  [
    {:opentelemetry_formatter, path: "~/workspace/opentelemetry_formatter"}
  ]
end
```

Then configure ExUnit to use it by including it in the list of formatters:
```elixir
ExUnit.configure(formatters: [OpenTelemetryFormatter, ExUnit.CLIFormatter])
```

# Configuring OpenTelemetry

To actually emit spans you'll need to include the OpenTelemetry exporter
in your project as a release,
and configure it to send spans during test.

Your `releases` section will look something like this:

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

There are several different ways to configure the OpenTelemetry exporter, but one way is to add this to your `./config/test.exs`

```elixir
config :opentelemetry, :processors,
  otel_simple_processor: %{
    exporter:
      {:opentelemetry_exporter,
       %{
         endpoints: ["https://api.honeycomb.io:443"]
       }}
  }

config :opentelemetry, :resource, service: %{name: "opentelemetry_formatter"}
```

I've mainly tested this using Honeycomb, where I set the team and provide the credentials using the OTEL_EXPORTER_OTLP_TRACES_HEADERS env variable, like this:

```bash
export OTEL_EXPORTER_OTLP_TRACES_HEADERS=x-honeycomb-team=$HONEYCOMB_API_TOKEN
```

I've set this up in a project with a [sample test suite](https://github.com/njbennett/sample_test_suite) which has a set of bad tests that randomly fail.
