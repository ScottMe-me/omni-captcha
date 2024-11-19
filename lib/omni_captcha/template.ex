defmodule OmniCaptcha.Template do
  @moduledoc """
    Responsible for rendering boilerplate OmniCaptcha HTML code, supports noscript fallback.

    In future this module may be separated out into a Phoenix specific library.
  """

  import Phoenix.Component

  @adapter Application.compile_env!(:omni_captcha, :adapter)
  @script_opts Application.compile_env(:omni_captcha, :script_opts, "")
  @site_key Application.compile_env!(:omni_captcha, :site_key)

  @doc """
  Renders the captcha widget.

  ## Options
    
    * `:adapter` - sets the adapter that is used to load related configuration for the provider. (defaults to `OmniCaptcha.Adapter.Sandbox`)
    * `:site_key` - sets the site key used by the provider captcha widget. (defaults to the site_key provided in the application config)
  """
  def captcha(assigns) do
    adapter = assigns[:adapter] || @adapter
    site_key = assigns[:site_key] || @site_key

    assigns =
      assign(
        assigns,
        :site_key,
        site_key
      )

    adapter.captcha(assigns)
  end

  @doc """
  Renders the captcha script.

  ## Options
    
    * `:adapter` - sets the adapter that is used to load related configuration for the provider. (defaults to `OmniCaptcha.Adapter.Sandbox`)
    * `:script_opts` - optional script options can be set for callbacks or other configuration (defaults to application configuration or "" if not provided)
  """
  def script(assigns) do
    adapter = assigns[:adapter] || @adapter
    script_opts = assigns[:script_opts] || @script_opts

    assigns =
      assign(
        assigns,
        :script_opts,
        script_opts
      )

    adapter.script(assigns)
  end
end
