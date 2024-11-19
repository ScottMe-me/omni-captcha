import Config

config :omni_captcha,
  adapter: OmniCaptcha.Adapter.Sandbox,
  timeout: 5000,
  site_key: System.get_env("OMNI_CAPTCHA_SITE_KEY"),
  secret_key: System.get_env("OMNI_CAPTCHA_SECRET_KEY")

config :omni_captcha, :json_library, Jason

config :tesla, :adapter, Tesla.Adapter.Mint

import_config "#{Mix.env()}.exs"
