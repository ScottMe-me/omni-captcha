defmodule OmniCaptcha.HCaptchaTest do
  import Phoenix.{Component, LiveViewTest}
  use ExUnit.Case, async: true

  @adapter OmniCaptcha.Adapter.HCaptcha
  @secret "0x0000000000000000000000000000000000000000"

  test "captcha" do
    assigns = %{adapter: @adapter}

    html =
      rendered_to_string(~H"""
      <OmniCaptcha.Template.captcha adapter={@adapter} site_key="asdf" />
      """)

    assert html =~ "h-captcha"
    assert html =~ "data-sitekey=\"asdf\""
  end

  test "script" do
    assigns = %{adapter: @adapter}

    html =
      rendered_to_string(~H"""
      <OmniCaptcha.Template.script adapter={@adapter} />
      """)

    assert html =~ "js.hcaptcha.com"
  end

  describe "verify" do
    test "Publisher or Pro Account" do
      {:ok, resp} =
        OmniCaptcha.verify("10000000-aaaa-bbbb-cccc-000000000001",
          adapter: @adapter,
          secret: @secret
        )

      assert resp.hostname == "dummy-key-pass"
    end

    test "Enterprise Safe End User" do
      {:ok, resp} =
        OmniCaptcha.verify("20000000-aaaa-bbbb-cccc-000000000002",
          adapter: @adapter,
          secret: @secret
        )

      assert resp.hostname == "dummy-key-pass"
    end

    test "Enterprise Bot Detected" do
      {:ok, resp} =
        OmniCaptcha.verify("30000000-aaaa-bbbb-cccc-000000000003",
          adapter: @adapter,
          secret: @secret
        )

      assert resp.hostname == "dummy-key-pass"
    end
  end
end
