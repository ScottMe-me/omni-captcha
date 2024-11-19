defmodule OmniCaptcha.ReCaptchaTest do
  import Phoenix.{Component, LiveViewTest}
  use ExUnit.Case, async: true

  @adapter OmniCaptcha.Adapter.ReCaptcha

  test "captcha" do
    assigns = %{adapter: @adapter}

    html =
      rendered_to_string(~H"""
      <OmniCaptcha.Template.captcha adapter={@adapter} site_key="asdf" />
      """)

    assert html =~ "g-recaptcha"
    assert html =~ "data-sitekey=\"asdf\""
  end

  test "script" do
    assigns = %{adapter: @adapter}

    html =
      rendered_to_string(~H"""
      <OmniCaptcha.Template.script adapter={@adapter} />
      """)

    assert html =~ "google.com/recaptcha"
  end

  test "verify" do
    {:ok, resp} =
      OmniCaptcha.verify("some_response",
        adapter: @adapter,
        secret: "6LeIxAcTAAAAAGG-vFI1TnRWxMZNFuojJ4WifJWe"
      )

    assert resp.hostname == "testkey.google.com"
  end
end
