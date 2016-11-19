defmodule ApiTest.Repo.Migrations.CreateEvent do
  use Ecto.Migration

  def change do
    create table(:events) do
      add :title, :string
      add :start_at, :datetime
      add :end_at, :datetime
      add :duration, :integer

      timestamps()
    end

  end
end
