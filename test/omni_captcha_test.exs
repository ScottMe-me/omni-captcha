defmodule OmniCaptchaTest do
  use ExUnit.Case, async: true

  @mock_client OmniCaptcha.Http.MockClient
  @secret Application.compile_env(:omni_captcha, :secret_key)
  @pass_secret "1x0000000000000000000000000000000AA"
  @fail_secret "2x0000000000000000000000000000000AA"

  test "When a passing test secret is provided, a success response is returned" do
    assert {:ok, %{challenge_ts: _, hostname: _}} =
             OmniCaptcha.verify("valid_response",
               http_client: @mock_client,
               secret: @pass_secret
             )
  end

  test "When a failing test secret is provided, an error response is returned" do
    assert {:error, [:invalid_input_response]} =
             OmniCaptcha.verify("invalid_response",
               http_client: @mock_client,
               secret: @fail_secret
             )
  end

  test "When a valid response is supplied, a success response is returned" do
    assert {:ok, %{challenge_ts: _, hostname: _}} =
             OmniCaptcha.verify("valid_response", http_client: @mock_client)
  end

  test "When a valid response is supplied, an error response is returned" do
    assert {:error, [:invalid_input_response]} =
             OmniCaptcha.verify("invalid_response", http_client: @mock_client)
  end

  test "When secret is not overridden the configured secret is used" do
    OmniCaptcha.verify("valid_response", http_client: @mock_client)

    assert_received {:request_verification,
                     "response=valid_response&secret=#{@secret}", _}
  end

  test "When the timeout is overridden that config is passed to verify/2 as an option" do
    OmniCaptcha.verify("valid_response",
      http_client: @mock_client,
      timeout: 25_000
    )

    assert_received {:request_verification, _, [timeout: 25_000]}
  end

  test "Remote IP is used in the request body when it is passed into verify/2 as an option" do
    OmniCaptcha.verify("valid_response",
      http_client: @mock_client,
      remoteip: "192.168.1.1"
    )

    assert_received {:request_verification,
                     "response=valid_response&secret=#{@secret}&remoteip=192.168.1.1",
                     _}
  end

  test "Adding unsupported options does not append them to the request body" do
    OmniCaptcha.verify("valid_response",
      http_client: @mock_client,
      unsupported_option: "not_valid"
    )

    assert_received {:request_verification,
                     "response=valid_response&secret=#{@secret}", _}
  end
end
