defmodule Givemethetip.Mixfile do
  use Mix.Project

  def project do
    [ app: :givemethetip,
      version: "0.0.1",
      build_per_environment: true,
      dynamos: [Givemethetip.Dynamo],
      compilers: [:elixir, :dynamo, :app],
      deps: deps ]
  end

  # Configuration for the OTP application
  def application do
    [ applications: [:cowboy, :dynamo, :dogeapi, :amnesia],
      mod: { Givemethetip, [] } ]
  end

  defp deps do
    [
      { :cowboy, github: "extend/cowboy" },
      { :dynamo, "~> 0.1.0-dev", github: "elixir-lang/dynamo" },
      { :dogeapi, github: "ShaneWilton/dogeapi-elixir" },
      { :amnesia, github: "meh/amnesia" },
      { :jsex, github: "talentdeficit/jsex" }
    ]
  end
end
