defmodule ApplicationRouter do
  use Dynamo.Router
  use Amnesia
  use Database

  prepare do
    conn.fetch([:session, :params])
  end

  get "/" do
    render conn, "index.html"
  end

  get "/login" do
    Amnesia.transaction do
      user_id = conn.params[:user_id]
      name    = conn.params[:name]
      unless User.read(user_id) do
        Models.Users.create(user_id, name)
        Models.Tips.create_unconditional("Shibe", user_id, 10)
      end
      User.read(user_id).name(name).write
      conn = put_session(conn, :user_id, user_id)
      redirect conn, to: "/dashboard"
    end
  end

  @prepare :authenticate_user
  get "/dashboard" do
    Amnesia.transaction do
      user_id = get_session(conn, :user_id)
      user = User.read(user_id)
      conn = conn.assign(:balance, Models.Users.balance(user_id))
      conn = conn.assign(:wallet, user.wallet)
      render conn, "dashboard.html"
    end
  end

  defp authenticate_user(conn) do
    unless get_session(conn, :user_id) do
      redirect! conn, to: "/"
    end
  end
end
