defmodule OmniCaptcha.Mixfile do
  use Mix.Project

  @version String.trim(File.read!("VERSION"))

  def project do
    [
      app: :omni_captcha,
      compilers: Mix.compilers(),
      name: "Omni Captcha",
      source_url: "https://gitlab.com/scott-codes-things/omni-captcha",
      version: @version,
      elixir: "~> 1.13",
      description: description(),
      deps: deps(),
      dialyzer: dialyzer(),
      docs: docs(),
      package: package(),
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      test_coverage: test_coverage(),
      dialyzer: [
        plt_add_deps: :apps_direct,
        plt_add_apps: [:jason]
      ]
    ]
  end

  def application do
    [extra_applications: [:logger, :eex]]
  end

  defp description do
    """
    A simple Captcha package for Elixir applications, provides verification and templates for rendering forms with the reCAPTCHA, hCaptcha, and Cloudflare Turnstile widgets
    """
  end

  defp deps do
    [
      {:castore, "~> 1.0"},
      {:credo, "~> 1.0", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.3", only: [:dev], runtime: false},
      {:ex_doc, "~> 0.27", only: [:dev], runtime: false},
      {:jason, "~> 1.4"},
      {:mint, "~> 1.5"},
      {:phoenix_live_view, "~> 0.19"},
      {:tesla, "~> 1.8"}
    ]
  end

  defp dialyzer do
    [
      plt_file: {:no_warn, "priv/plts/dialyzer.plt"}
    ]
  end

  defp docs do
    [
      extras: ["README.md"],
      groups_for_modules: groups_for_modules(),
      main: "readme",
      source_ref: "master"
    ]
  end

  defp groups_for_modules do
    [
      Adapters: [
        OmniCaptcha.Adapter.HCaptcha,
        OmniCaptcha.Adapter.ReCaptcha,
        OmniCaptcha.Adapter.Sandbox,
        OmniCaptcha.Adapter.Turnstile
      ],
      Http: [
        OmniCaptcha.Http,
        OmniCaptcha.Http.MockClient
      ]
    ]
  end

  defp package do
    [
      files: [
        "lib",
        "mix.exs",
        "README*",
        "LICENSE*",
        "VERSION",
        ".formatter.exs"
      ],
      maintainers: ["Scott"],
      licenses: ["MIT"],
      links: %{
        "GitLab" => "https://gitlab.com/scott-codes-things/omni-captcha"
      }
    ]
  end

  defp test_coverage do
    [
      ignore_modules: [],
      summary: [threshold: 70]
    ]
  end
end
