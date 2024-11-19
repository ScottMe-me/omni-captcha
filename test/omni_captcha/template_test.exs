defmodule OmniCaptcha.TemplateTest do
  use ExUnit.Case, async: true

  import Phoenix.LiveViewTest

  @site_key Application.compile_env(:omni_captcha, :site_key)

  test "display cf-turnstile dif from captcha/1" do
    resp = render_component(&OmniCaptcha.Template.captcha/1)
    assert resp =~ "cf-turnstile"
    assert resp =~ @site_key
  end

  test "supplying options to script/1 renders the script block" do
    resp = render_component(&OmniCaptcha.Template.script/1)
    assert resp =~ "challenges.cloudflare.com"
  end
end
