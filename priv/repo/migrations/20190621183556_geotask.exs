defmodule ApiTasks.Repo.Migrations.Geotask do
  use Ecto.Migration

  def change do
    create table(:geo_tasks) do
      add :dropoff_point,         :geometry, null: false
      add :pickup_point,          :geometry, null: false
      add :status,                :integer, default: 0
    end
  end
end
