defmodule ComadrePay.Guardian.AuthPipeline do
  use Guardian.Plug.Pipeline, otp_app: :ComadrePay,
  module: ComadrePay.Guardian,
  error_handler: ComadrePay.AuthErrorHandler

  plug Guardian.Plug.VerifyHeader, realm: "Bearer"
  plug Guardian.Plug.EnsureAuthenticated
  plug Guardian.Plug.LoadResource
end
