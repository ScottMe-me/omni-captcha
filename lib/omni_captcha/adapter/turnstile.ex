defmodule OmniCaptcha.Adapter.Turnstile do
  @moduledoc """
  Adapter for Cloudflare Turnstile integration
  https://developers.cloudflare.com/turnstile/

  Test Keys: https://developers.cloudflare.com/turnstile/reference/testing/

  Please refer to `OmniCaptcha.Template` for details on use of this adapter.
  """

  import Phoenix.Component

  def captcha(assigns) do
    ~H"""
      <div class="cf-turnstile" data-sitekey={"#{@site_key}"}></div>
    """
  end

  def script(assigns) do
    ~H"""
      <script src={"https://challenges.cloudflare.com/turnstile/v0/api.js#{@script_opts}"} defer />
    """
  end

  def verify_url,
    do: "https://challenges.cloudflare.com/turnstile/v0/siteverify"
end
