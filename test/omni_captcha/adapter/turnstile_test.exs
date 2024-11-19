defmodule OmniCaptcha.TurnstileTest do
  import Phoenix.{Component, LiveViewTest}
  use ExUnit.Case, async: true

  @adapter OmniCaptcha.Adapter.Turnstile

  test "captcha" do
    assigns = %{adapter: @adapter}

    html =
      rendered_to_string(~H"""
      <OmniCaptcha.Template.captcha adapter={@adapter} site_key="asdf" />
      """)

    assert html =~ "cf-turnstile"
    assert html =~ "data-sitekey=\"asdf\""
  end

  test "script" do
    assigns = %{adapter: @adapter}

    html =
      rendered_to_string(~H"""
      <OmniCaptcha.Template.script adapter={@adapter} />
      """)

    assert html =~ "challenges.cloudflare.com"
  end

  describe "verify" do
    test "pass" do
      {:ok, resp} =
        OmniCaptcha.verify("asdf",
          adapter: @adapter,
          secret: "1x0000000000000000000000000000000AA"
        )

      assert resp.hostname == "example.com"
    end

    test "fail" do
      {:error, resp} =
        OmniCaptcha.verify("asdf",
          adapter: @adapter,
          secret: "2x0000000000000000000000000000000AA"
        )

      assert resp == [:invalid_input_response]
    end

    test "token already spent" do
      {:error, resp} =
        OmniCaptcha.verify("asdf",
          adapter: @adapter,
          secret: "3x0000000000000000000000000000000AA"
        )

      assert resp == [:timeout_or_duplicate]
    end
  end
end
