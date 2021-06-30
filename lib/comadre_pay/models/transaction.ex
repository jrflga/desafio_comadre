defmodule ComadrePay.Transaction do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  @required_params [:balance, :revoked?]

  schema "transactions" do
    belongs_to :from, :binary_id
    belongs_to :to, :binary_id
    field :balance, :decimal
    field :revoked?, :boolean

    timestamps()
  end

  def changeset(struct \\ %__MODULE__{}, params) do
    struct
    |> cast(params, @required_params)
    |> validate_required(@required_params)
  end
end
