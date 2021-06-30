defmodule ComadrePayWeb.UserView do
  use ComadrePayWeb, :view
  alias ComadrePayWeb.UserView

  def render("show.json", %{user: user}) do
    %{
      id: user.id,
      name: user.name,
      last_name: user.last_name,
      email: user.email,
      account: %{
        balance: user.account.balance,
        id: user.account.id,
      },
    }
  end

  def render("jwt.json", %{jwt: jwt}) do
    %{jwt: jwt}
  end
end
