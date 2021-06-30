defmodule ComadrePayWeb.UserController do
  use ComadrePayWeb, :controller

  alias ComadrePay.User
  alias ComadrePay.Guardian

  action_fallback ComadrePayWeb.FallbackController

  def create(conn, params) do
    with {:ok, %User{} = user} <- ComadrePay.create_user(params),
          {:ok, token, _claims} <- Guardian.encode_and_sign(user) do
      conn
      |> put_status(:created)
      |> render("jwt.json", jwt: token)
    end
  end

  def login(conn, %{"email" => email, "password" => password}) do
    case ComadrePay.Users.Login.token_login(email, password) do
      {:ok, token, _claims} ->
        conn |> render("jwt.json", jwt: token)
      _ ->
        {:error, :unauthorized}
    end
  end

  def show(conn, _) do
    user = Guardian.Plug.current_resource(conn)
    conn |> render("show.json", user: user)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = ComadrePay.get_user!(id)

    with {:ok, %User{} = user} <- ComadrePay.update_user(user, user_params) do
      render(conn, "show.json", user: user)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = ComadrePay.get_user!(id)

    with {:ok, %User{}} <- ComadrePay.delete_user(user) do
      send_resp(conn, :no_content, "")
    end
  end
end
