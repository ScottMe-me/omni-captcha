defmodule OmniCaptcha.Response do
  @moduledoc """
    A struct representing the successful OmniCaptcha response from the Cloudflare OmniCaptcha API.
  """
  defstruct challenge_ts: "", hostname: ""

  @type t :: %__MODULE__{challenge_ts: String.t(), hostname: String.t()}
end
