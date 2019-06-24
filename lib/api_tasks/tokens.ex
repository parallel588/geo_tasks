defmodule ApiTasks.Tokens do
  @role_driver "driver"
  @role_manager "manager"
  @tokens %{
    # Manager tokens
    "npFjLbDy_3-njP4KLWTd5K64XqorAiwcMcfdKE1qgBecyeFZdT" => @role_manager,
    "fov2GEHSzHq9aTXWjEK3eXthQ7qUpsguuwqEH23T2WTbhDY3kU" => @role_manager,
    "iV0tmGOUMsRoOki0WhvDbHIACVhGr25w3B6mRpw9KssETxxODT" => @role_manager,
    "W7VryAcP1c-CqrrCf54qVpv7JRcf_Ob0aczgUL1wPvSf05jdR1" => @role_manager,
    "h0_qEVLxgyh74GfgTd65qg3OiAKYK88hBU5NdrlomdicKJLSvo" => @role_manager,
    "KED3a98qSW5X7DZpIgSqS4JPyHlBk4ayzMtr6VM_U6MemG8Xob" => @role_manager,
    "UvyRB5cymcHBruwrrq1UAJQhnqBRqLXMZl0hYqwz3xQL5UTEvq" => @role_manager,
    "CJWo5pjtzontz9eAUl5X9WWu2-ZbiSuEqf3TWtEX7AovhICE_R" => @role_manager,

    # Driver tokens
    "r9AlnQyHM9D34iv-lvGPYa41InCvxMoGpYfBOwHvblc7uHz8Ez" => @role_driver,
    "YsHdxmoKXdCg67TczEiF_C1k59KeDfP_v5m0k1MnoRlZ5GbrVi" => @role_driver,
    "XEy0--ETHmUzgzUWmpggD2ROGQ-QlCpwOn5vVzmrqLWpBXJwQV" => @role_driver,
    "1L7dUSbzIMU0xIqDezSwak8H3ID4LRtahX2MU1OamFjhZYO22o" => @role_driver,
    "TXDcbdhRsbsm29r6PMMtrlKezGii6lj_fxKB-VG20VbhRU0Bc2" => @role_driver,
    "cLPsgB0Yi_CguktXn5wX_8AMiVd7w5Uo5jRsfyN3K73EYOGpOz" => @role_driver,
    "g77MJzn1gQuqn0Rda_bqhocVujZWatouk_85kXjkv4EJMsYc-z" => @role_driver
  }

  def fetch_role(token) when is_binary(token) do
    @tokens[token]
  end

  def fetch_role(_), do: nil
end
