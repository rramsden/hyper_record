defmodule HyperRecord.Mixfile do
  use Mix.Project

  def project do
    [ app: :hyper_record,
      version: "0.0.1",
      elixir: "~> 0.11.2-dev",
      deps: deps ]
  end

  # Configuration for the OTP application
  def application do
    []
  end

  # Returns the list of dependencies in the format:
  # { :foobar, git: "https://github.com/elixir-lang/foobar.git", tag: "0.1" }
  #
  # To specify particular versions, regardless of the tag, do:
  # { :barbat, "~> 0.1", github: "elixir-lang/barbat.git" }
  defp deps do
    [
      { :postgrex, "~> 0.2.0", [git: "git://github.com/ericmj/postgrex.git", optional: true]},
      { :ecto, github: "elixir-lang/ecto" },
      { :jsex, github: "talentdeficit/jsex" },
      { :amrita, github: "josephwilk/amrita" }
    ]
  end
end
