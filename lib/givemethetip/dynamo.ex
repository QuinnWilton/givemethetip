defmodule Givemethetip.Dynamo do
  use Dynamo

  config :dynamo,
    # The environment this Dynamo runs on
    env: Mix.env,

    # The OTP application associated with this Dynamo
    otp_app: :givemethetip,

    # The endpoint to dispatch requests to
    endpoint: ApplicationRouter,

    # The route from which static assets are served
    # You can turn off static assets by setting it to false
    static_route: "/static"

  # I realize these shouldn't be hardcoded in version control
  # It's a hackathon. Hack us if you want.
  config :dynamo,
    session_store: Session.CookieStore,
    session_options:
      [ key: "_givemethetip_session",
        secret: "ZJ2qKb/ZJvVtWbegN9ITdvxdGHcsYy4/8Jb8HIPpjGEwInaeGcAWTrkH0A4kj0DS"]

  # Default functionality available in templates
  templates do
    use Dynamo.Helpers
  end
end
