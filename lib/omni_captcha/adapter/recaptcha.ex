defmodule OmniCaptcha.Adapter.ReCaptcha do
  @moduledoc """
  Adapter for Google reCAPTCHA v2 integration https://developers.google.com/recaptcha/docs/display

  Test Keys

  Site Key: 6LeIxAcTAAAAAJcZVRqyHh71UMIEGNQ_MXjiZKhI

  Secret Key: 6LeIxAcTAAAAAGG-vFI1TnRWxMZNFuojJ4WifJWe

  Please refer to `OmniCaptcha.Template` for details on use of this adapter.
  """

  import Phoenix.Component

  def captcha(assigns) do
    ~H"""
      <div class="g-recaptcha" data-sitekey={"#{@site_key}"}></div>
    """
  end

  def script(assigns) do
    ~H"""
      <script src={"https://www.google.com/recaptcha/api.js#{@script_opts}"} async defer></script>
    """
  end

  def verify_url, do: "https://www.google.com/recaptcha/api/siteverify"
end
