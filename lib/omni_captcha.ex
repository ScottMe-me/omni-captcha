defmodule OmniCaptcha do
  @moduledoc """
    A module for verifying captcha response strings.
  """

  alias OmniCaptcha.{Http, Response}

  @http_client Application.compile_env(:omni_captcha, :http_client, Http)

  @doc """
  Verifies a response string.

  ## Options

    * `:adapter` - sets the adapter that is used to load related configuration for the provider (defaults to `OmniCaptcha.Adapter.Sandbox`)
    * `:http_client` - sets the HTTP client used for the verification request (defaults to `OmniCaptcha.Http`)
    * `:timeout` - the timeout for the request (defaults to 5000ms)
    * `:secret`  - the secret key used by :omni_captcha (defaults to the secret
      provided in application config)
    * `:remoteip` - the IP address of the user (optional and not set by default)

  ## Example

  iex> {:ok, api_response} = OmniCaptcha.verify("response_string")
  """
  @spec verify(String.t(), Keyword.t()) ::
          {:ok, Response.t()} | {:error, [atom]}
  def verify(response, options \\ []) do
    http_client = options[:http_client] || @http_client

    verification =
      http_client.request_verification(
        request_body(response, options),
        Keyword.take(options, [:adapter, :timeout])
      )

    case verification do
      {:error, errors} ->
        {:error, errors}

      {:ok, %{"success" => false, "error-codes" => errors}} ->
        {:error, Enum.map(errors, &atomise_api_error/1)}

      {:ok,
       %{"success" => true, "challenge_ts" => timestamp, "hostname" => host}} ->
        {:ok, %Response{challenge_ts: timestamp, hostname: host}}

      {:ok,
       %{"success" => false, "challenge_ts" => _timestamp, "hostname" => _host}} ->
        {:error, [:challenge_failed]}
    end
  end

  defp request_body(response, options) do
    body_options = Keyword.take(options, [:remoteip, :secret])

    application_options = [
      secret: Application.get_env(:omni_captcha, :secret_key)
    ]

    # override application secret with options secret if it exists
    application_options
    |> Keyword.merge(body_options)
    |> Keyword.put(:response, response)
    |> URI.encode_query()
  end

  defp atomise_api_error(error) do
    # See why we are using `to_atom` here:
    # https://github.com/samueljseay/recaptcha/pull/28#issuecomment-313604733
    error
    |> String.replace("-", "_")
    |> String.to_atom()
  end
end
