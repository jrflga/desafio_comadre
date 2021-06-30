defmodule ComadrePay.Repo.Migrations.CreateTransactionsTable do
  use Ecto.Migration

  def change do

    create table :transactions do
      add :from, :binary_id
      add :to, :binary_id
      add :amount, :decimal
      add :revoked?, :boolean

      timestamps()
    end
  end
end
