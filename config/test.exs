import Config

config :omni_captcha,
  adapter: OmniCaptcha.Adapter.Turnstile,
  # http_client: OmniCaptcha.Http.MockClient,
  secret_key: "test_secret_key",
  site_key: "test_site_key"
