defmodule OmniCaptcha.Http do
  @moduledoc """
  Responsible for managing HTTP requests to the captcha APIs
  """

  alias OmniCaptcha.Adapter.Sandbox

  @adapter Application.compile_env!(:omni_captcha, :adapter)

  @doc """
  Sends an HTTP request to the specified adapters verify url.

  ## Options

    * `:adapter` - sets the adapter to use if using multiple captacha providers in the same project
    * `:timeout` - the timeout for the request (defaults to 5000ms)

  ## Example

    {:ok, %{
      "success" => success,
      "challenge_ts" => ts,
      "hostname" => host,
      "error-codes" => errors
    }} = OmniCaptcha.Http.request_verification(%{
      secret: "secret",
      response: "response",
      remoteip: "remoteip"
    })
  """
  @spec request_verification(binary, timeout: integer) ::
          {:ok, map} | {:error, [atom]}
  def request_verification(body, options \\ []) do
    adapter = options[:adapter] || @adapter

    if adapter == Sandbox do
      {:ok, %{"success" => true, "challenge_ts" => "", "hostname" => ""}}
    else
      url = adapter.verify_url()
      client = client(url)

      case Tesla.post(client, "", body) do
        {:ok, data} -> {:ok, data.body}
        {:error, :invalid} -> {:error, [:invalid_api_response]}
        {:error, {:invalid, _reason}} -> {:error, [:invalid_api_response]}
        {:error, %{reason: reason}} -> {:error, [reason]}
      end
    end
  end

  def client(base_url) do
    middleware = [
      {Tesla.Middleware.BaseUrl, base_url},
      {Tesla.Middleware.Headers,
       [
         {"Accept", "application/json"},
         {"user-agent", "Elixir-OmniCaptcha/#{version()}"}
       ]},
      Tesla.Middleware.EncodeFormUrlencoded,
      Tesla.Middleware.DecodeJson
    ]

    Tesla.client(middleware)
  end

  defp version do
    to_string(Application.spec(:omni_captcha, :vsn))
  end
end
