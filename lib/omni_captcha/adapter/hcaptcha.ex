defmodule OmniCaptcha.Adapter.HCaptcha do
  @moduledoc """
  Adapter for HCaptcha integration
  https://docs.hcaptcha.com/

  Test Keys: https://docs.hcaptcha.com/#integration-testing-test-keys

  Please refer to `OmniCaptcha.Template` for details on use of this adapter.
  """

  import Phoenix.Component

  def captcha(assigns) do
    ~H"""
      <div class="h-captcha" data-sitekey={"#{@site_key}"}></div>
    """
  end

  def script(assigns) do
    ~H"""
      <script src={"https://js.hcaptcha.com/1/api.js#{@script_opts}"} async defer></script>
    """
  end

  def verify_url, do: "https://hcaptcha.com/siteverify"
end
