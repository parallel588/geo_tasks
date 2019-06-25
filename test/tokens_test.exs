defmodule ApiTasks.TokensTest do
  use ExUnit.Case
  alias ApiTasks.Tokens

  describe "fetch_role" do
    test "it returns role by token" do
      assert Tokens.fetch_role("npFjLbDy_3-njP4KLWTd5K64XqorAiwcMcfdKE1qgBecyeFZdT") == "manager"

      assert Tokens.fetch_role("r9AlnQyHM9D34iv-lvGPYa41InCvxMoGpYfBOwHvblc7uHz8Ez") == "driver"

      refute Tokens.fetch_role("")
    end
  end
end
