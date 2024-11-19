defmodule OmniCaptcha.Http.MockClient do
  @moduledoc """
    A mock HTTP client used for testing.
  """
  alias OmniCaptcha.Http

  @secret "test_secret_key"

  def request_verification(body, options \\ [])

  def request_verification(
        "response=valid_response&secret=#{@secret}" = body,
        options
      ) do
    send(self(), {:request_verification, body, options})

    {:ok,
     %{
       "success" => true,
       "challenge_ts" => "timestamp",
       "hostname" => "localhost"
     }}
  end

  def request_verification(
        "response=invalid_response&secret=#{@secret}" = body,
        options
      ) do
    send(self(), {:request_verification, body, options})
    {:error, [:invalid_input_response]}
  end

  # every other match is a pass through to the real client
  def request_verification(body, options) do
    send(self(), {:request_verification, body, options})
    Http.request_verification(body, options)
  end
end
