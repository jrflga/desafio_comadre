defmodule ComadrePay.Users.Get do
  alias ComadrePay.{Account, User}

  alias Ecto.Repo
  alias ComadrePay.{Account, User, Repo}

  def call(id) do
    Repo.get!(User, id)
    |> Repo.preload([:account])
  end
end
