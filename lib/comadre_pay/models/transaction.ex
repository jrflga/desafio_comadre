defmodule ComadrePay.Transaction do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  @required_params [:from, :to, :amount]

  schema "transactions" do
    field :from, :binary_id
    field :to, :binary_id
    field :amount, :decimal
    field :revoked?, :boolean, default: false

    timestamps()
  end

  def changeset(struct \\ %__MODULE__{}, params) do
    struct
    |> cast(params, @required_params)
    |> validate_required(@required_params)
  end
end
