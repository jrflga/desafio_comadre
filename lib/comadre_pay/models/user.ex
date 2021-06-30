defmodule ComadrePay.User do
  use Ecto.Schema
  import Ecto.Changeset

  alias ComadrePay.Account
  alias Ecto.Changeset

  @fields_that_can_be_changed [
    :name,
    :last_name,
    :cpf,
    :email,
    :password
  ]

  @required_fields [
    :name,
    :last_name,
    :cpf,
    :email,
    :password
  ]

  @primary_key {:id, :binary_id, autogenerate: true}

  schema "users" do
    field :name, :string
    field :last_name, :string
    field :cpf, :string
    field :email, :string
    field :password, :string, virtual: true
    field :password_hash, :string
    has_one :account, Account

    timestamps()
  end

  def changeset(%{} = params) do
    %__MODULE__{}
    |> cast(params, @fields_that_can_be_changed)
    |> validate_required(@required_fields)
    |> validate_length(:password, min: 6)
    |> validate_length(:cpf, is: 11)
    |> validate_format(:email, ~r/@/)
    |> unique_constraint(:email)
    |> unique_constraint(:cpf)
    |> put_password_hash()
  end

  defp put_password_hash(%Changeset{valid?: true, changes: %{password: password}} = changeset) do
    put_change(changeset, :password_hash, Comeonin.Bcrypt.hashpwsalt(password))
  end

  defp put_password_hash(changeset), do: changeset
end
