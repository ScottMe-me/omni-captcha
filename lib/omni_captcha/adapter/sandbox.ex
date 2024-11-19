defmodule OmniCaptcha.Adapter.Sandbox do
  @moduledoc """
  Adapter for development or testing with **no** captcha

  Please refer to `OmniCaptcha.Template` for details on use of this adapter.
  """

  import Phoenix.Component

  def captcha(assigns), do: ~H""
  def script(assigns), do: ~H""
  def verify_url, do: ""
end
