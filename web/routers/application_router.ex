defmodule ApplicationRouter do
  use Dynamo.Router

  prepare do
    conn.fetch([:cookies, :params])
  end

  forward "/users", to: UsersRouter
  forward "/tips", to: TipsRouter

  get "/" do
    conn = conn.assign(:title, "Welcome to Dynamo!")
    render conn, "index.html"
  end
end
