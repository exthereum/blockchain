defmodule Blockchain.Mixfile do
  use Mix.Project

  def project do
    [
      app: :blockchain,
      version: "0.1.8",
      elixir: "~> 1.6",
      description: "Ethereum's Blockchain Manager",
      package: [
        maintainers: ["Geoffrey Hayes", "Ayrat Badykov", "Mason Forest"],
        licenses: ["MIT"],
        links: %{"GitHub" => "https://github.com/exthereum/blockchain"}
      ],
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    # Specify extra applications you'll use from Erlang/Elixir
    [extra_applications: [:logger], mod: {Blockchain.Application, []}]
  end

  # Dependencies can be Hex packages:
  #
  #   {:my_dep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:my_dep, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
  #
  # To depend on another app inside the umbrella:
  #
  #   {:my_app, in_umbrella: true}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [
      {:libsecp256k1, "~> 0.1.10"},
      {:keccakf1600, "~> 2.0.0", hex: :keccakf1600_orig},
      {:credo, "~>  1.4.0", only: [:dev, :test], runtime: false},
      {:ex_doc, "~> 0.22.1", only: :dev, runtime: false},
      {:merkle_patricia_tree, "~> 0.2.8"},
      {:dialyxir, "~> 1.0.0", only: [:dev], runtime: false},
      {:ex_rlp, "~> 0.5.3"},
      {:evm, "~> 0.1.14"},
      {:poison, "~> 4.0.1"}
    ]
  end
end
