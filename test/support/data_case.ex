defmodule ApiTasks.DataCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      alias ApiTasks.Repo

      import Ecto
      import Ecto.Changeset
      import Ecto.Query
      import ApiTasks.DataCase
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(ApiTasks.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(ApiTasks.Repo, {:shared, self()})
    end

    :ok
  end
end
