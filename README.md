# OmniCaptcha

![Hex.pm Version](https://img.shields.io/hexpm/v/omni_captcha)
[![Documentation](https://img.shields.io/badge/documentation-gray)](https://hexdocs.pm/omni_captcha)
[![pipeline
status](https://gitlab.com/scott-codes-things/omni-captcha/badges/master/pipeline.svg)](https://gitlab.com/scott-codes-things/omni-captcha/-/commits/master)
[![coverage report](https://gitlab.com/scott-codes-things/omni-captcha/badges/master/coverage.svg)](https://gitlab.com/scott-codes-things/omni-captcha/-/commits/master)

The package is fork of the [hcaptcha] package that has been modified to be adaptable.

[hcaptcha]: https://github.com/sebastiangrebe/hcaptcha

### Important Notice

The repo works for me but is not tested that all configuration options or callbacks given by captcha providers are processed correctly. Feel free to open PRs to resolve issues that you may experience.

## Installation

1. Add omni_captcha to your `mix.exs` dependencies

```elixir
  defp deps do
    [
      {:omni_captcha, "~> 0.0.3"},
    ]
  end
```

2. List `:omni_captcha` as an application dependency

```elixir
  def application do
    [ extra_applications: [:omni_captcha] ]
  end
```

3. Run `mix do deps.get, compile`

## Config

Specify the adapter to have a default adapter to be used across the project.

The following adapters currently available in the project include:

- `OmniCaptcha.Adapter.HCaptcha`
- `OmniCaptcha.Adapter.ReCaptcha`
- `OmniCaptcha.Adapter.Turnstile`
- `OmniCaptcha.Adapter.Sandbox`

By default the public and private keys are loaded via the `OMNI_CAPTCHA_PUBLIC_KEY` and `OMNI_CAPTCHA_PRIVATE_KEY` environment variables.

```elixir
  config :omni_captcha,
    adapter: OmniCaptcha.Adapter.Turnstile,
    site_key: System.fetch_env!("OMNI_CAPTCHA_SITE_KEY"),
    secret_key: System.fetch_env!("OMNI_CAPTCHA_SECRET_KEY")
```

## JSON Decoding

By default `omni_captcha` will use `Jason` to decode JSON responses, this can be changed as such:

```elixir
  config :omni_captcha, :json_library, Poison
```

## Load the Script

Render the omni_captcha script in the head block.

```elixir
<head>
  <OmniCaptcha.Template.script />
</head>
```

| Option        | Action                                               | Default |
| :------------ | :--------------------------------------------------- | :------ |
| `adapter`     | Sets the default adapter to use for captcha provider | sandbox |
| `script_opts` | Configurable script options for the selected script  | ""      |

## Render the Widget

Render the embed inside the form.

```elixir
<%= form_for ... %>
  <OmniCaptcha.Template.captcha />
<% end %>
```

| Option     | Action                                               | Default                       |
| :--------- | :--------------------------------------------------- | :---------------------------- |
| `adapter`  | Sets the default adapter to use for captcha provider | sandbox                       |
| `site_key` | Site key to render with the Captcha widget           | Site key from the config file |

## Verify API

OmniCaptcha provides the `verify/2` method. Below is an example using a Phoenix controller action:

Turnstile

```elixir
  def create(conn, params) do
    case OmniCaptcha.verify(params["cf-turnstile-response"]) do
      {:ok, response} -> do_something
      {:error, errors} -> handle_error
    end
  end
```

reCAPTCHA

```elixir
  def create(conn, params) do
    case OmniCaptcha.verify(params["g-recaptcha-response"]) do
      {:ok, response} -> do_something
      {:error, errors} -> handle_error
    end
  end
```

hCaptcha

```elixir
  def create(conn, params) do
    case OmniCaptcha.verify(params["h-captcha-response"]) do
      {:ok, response} -> do_something
      {:error, errors} -> handle_error
    end
  end
```

`verify` method sends a `POST` request to the omni_captcha API and returns 2 possible values:

`{:ok, %OmniCaptcha.Response{challenge_ts: timestamp, hostname: host}}` -> The captcha is valid, see the [documentation](https://developers.google.com/turnstile/docs/verify#api-response) for more details.

`{:error, errors}` -> `errors` contains atomised versions of the errors returned by the API, See the error documentation for more details. Errors caused by timeouts in HTTPoison or Jason encoding are also returned as atoms. If the turnstile request succeeds but the challenge is failed, a `:challenge_failed` error is returned.

(turnstile)[https://developers.cloudflare.com/turnstile/get-started/server-side-validation/#error-codes]
(reCAPTCHA)[https://developers.google.com/recaptcha/docs/verify#error-code-reference]
(hCaptcha)[https://docs.hcaptcha.com/configuration#error-codes]

`verify` method also accepts a keyword list as the third parameter with the following options:

| Option        | Action                                                | Default                          |
| :------------ | :---------------------------------------------------- | :------------------------------- |
| `adapter`     | Sets the default adapter to use for captcha provider  | sandbox                          |
| `http_client` | Sets the default HTTP adapter in the package          | OmniCaptcha.Http                 |
| `secret`      | Private key to send as a parameter of the API request | Private key from the config file |
| `timeout`     | Time to wait before timeout                           | 5000 (ms)                        |
| `remote_ip`   | Optional. The user's IP address, used by omni_captcha | no default                       |

## Running multiple captchas

This package allows for using more than one captcha at once if necessary.

Custom modules are also supported if the validation API responds in a similar format.

```elixir
conn
|> assign(adapter: OmniCaptcha.Adapter.HCaptcha)
|> assign(site_key: "asdf1234")
```

```elixir
<head>
  <OmniCaptcha.Template.script adapter={@adapter} />
</head>
```

```elixir
<%= form_for ... %>
  <OmniCaptcha.Template.captcha adapter={@adapter} site_key={@site_key} />
<% end %>
```

```elixir
OmniCaptcha.verify(
  params["captcha-response"],
  adapter: OmniCaptcha.Adapter.HCaptcha,
  secret: "4321fdsa"
)
```

## Testing

To recieve only valid responses from the live Turnstile API use the following config.

```elixir
config :omni_captcha,
  secret_key: "1x0000000000000000000000000000000cAA"
```

To recieve only invalid responses from the live Turnstile API use the following config.

```elixir
config :omni_captcha,
  secret_key: "2x0000000000000000000000000000000AA"
```

Setting up tests without network access can be done also. When configured as such a positive or negative result can be generated locally.

```elixir
config :omni_captcha,
  http_client: OmniCaptcha.Http.MockClient,
  secret_key: "test_secret_key"


  {:ok, _details} = OmniCaptcha.verify("valid_response")

  {:error, _details} = OmniCaptcha.verify("invalid_response")

```

## License

[MIT License](http://www.opensource.org/licenses/MIT).
