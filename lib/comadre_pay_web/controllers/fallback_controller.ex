defmodule ComadrePayWeb.FallbackController do
  use ComadrePayWeb, :controller

  def call(conn, {:error, result}) do
    conn
    |> put_status(:bad_request)
    |> put_view(ComadrePayWeb.ErrorView)
    |> render("400.json", result: result)
  end
end
