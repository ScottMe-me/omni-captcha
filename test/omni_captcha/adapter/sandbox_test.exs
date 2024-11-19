defmodule OmniCaptcha.SandboxTest do
  import Phoenix.{Component, LiveViewTest}
  use ExUnit.Case, async: true

  @adapter OmniCaptcha.Adapter.Sandbox

  test "captcha" do
    assigns = %{adapter: @adapter}

    html =
      rendered_to_string(~H"""
      <OmniCaptcha.Template.captcha adapter={@adapter} site_key="asdf" />
      """)

    assert html == ""
  end

  test "script" do
    assigns = %{adapter: @adapter}

    html =
      rendered_to_string(~H"""
      <OmniCaptcha.Template.script adapter={@adapter} />
      """)

    assert html == ""
  end

  describe "verify" do
    test "pass" do
      {:ok, resp} =
        OmniCaptcha.verify("asdf",
          adapter: @adapter,
          secret: "fdsa"
        )

      assert resp.challenge_ts == ""
      assert resp.hostname == ""
    end

    test "empty URL" do
      assert @adapter.verify_url == ""
    end
  end
end
