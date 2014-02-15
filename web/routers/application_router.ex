defmodule ApplicationRouter do
  use Dynamo.Router

  prepare do
    conn.fetch([:cookies, :params])
  end

  forward "/users", to: UsersRouter
  forward "/tips", to: TipsRouter

  get "/" do
    render conn, "index.html"
  end

  get "/dashboard" do
    render conn, "dashboard.html"
  end
end
