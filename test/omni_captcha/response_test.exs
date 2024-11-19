defmodule OmniCaptcha.ResponseTest do
  use ExUnit.Case, async: true

  alias OmniCaptcha.Response

  test "supplying options to display/1 renders them in the g-hcaptcha div" do
    map = %{challenge_ts: "timestamp", hostname: "localhost"}
    proper_struct = %Response{challenge_ts: "timestamp", hostname: "localhost"}
    typed_struct = struct(Response, map)

    assert proper_struct == typed_struct
  end
end
