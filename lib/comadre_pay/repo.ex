defmodule ComadrePay.Repo do
  use Ecto.Repo,
    otp_app: :comadre_pay,
    adapter: Ecto.Adapters.Postgres
end
