defmodule ApiTasks.GeoTasks.ChangesetTest do
  use ExUnit.Case
  use ApiTasks.DataCase

  import ApiTasks.Factory
  alias ApiTasks.GeoTasks.Changeset

  describe "create_task" do
    test "it returns valid changeset" do
      pickup = %{"lat" => "36.174968", "long" => "-115.137222"}
      dropoff = %{"lat" => "36.124642", "long" => "-115.171137"}
      assert %Ecto.Changeset{valid?: true} = Changeset.create(pickup, dropoff)
    end

    test "it returns invalid changeset" do
      assert %Ecto.Changeset{
               valid?: false,
               errors: errors
             } = Changeset.create(%{}, %{})

      assert errors == [
               pickup_point: {"can't be blank", [validation: :required]},
               dropoff_point: {"can't be blank", [validation: :required]}
             ]
    end
  end

  describe "update_status" do
    test "it returns valid changeset" do
      task = insert(:task)

      assert %Ecto.Changeset{
               valid?: true,
               changes: %{status: 2}
             } = Changeset.update_status(task, "done")
    end

    test "it returns invalid changeset" do
      task = insert(:task)

      assert %Ecto.Changeset{
               valid?: false,
               errors: [status: {"can't be blank", [validation: :required]}]
             } = Changeset.update_status(task, "unfillfiled")
    end
  end
end
