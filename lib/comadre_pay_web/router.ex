defmodule ComadrePayWeb.Router do
  use ComadrePayWeb, :router

  alias ComadrePay.Guardian

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :jwt_authenticated do
    plug Guardian.AuthPipeline
  end

  scope "/api", ComadrePayWeb do
    pipe_through :api

    post "/user/register", UserController, :create
    post "/user/login", UserController, :login
  end

  scope "/api", ComadrePayWeb do
    pipe_through [:api, :jwt_authenticated]

    get "/user", UserController, :show
    post "/account/deposit/:id", AccountsController, :deposit
    post "/account/withdraw/:id", AccountsController, :withdraw
    post "/account/transaction", AccountsController, :transaction
    post "/account/transaction/revoke/:id", AccountsController, :revoke
  end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through [:fetch_session, :protect_from_forgery]
      live_dashboard "/dashboard", metrics: ComadrePayWeb.Telemetry
    end
  end
end
