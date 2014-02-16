defmodule ApplicationRouter do
  use Dynamo.Router
  use Amnesia
  use Database

  prepare do
    conn.fetch([:session, :params])
  end

  forward "/users", to: UsersRouter
  forward "/tips", to: TipsRouter

  get "/" do
    render conn, "index.html"
  end

  get "/login" do
    user_id = conn.params[:user_id]
    name    = conn.params[:name]
    user = Amnesia.transaction do
      user = Database.User.read(user_id)
      if user == nil do
        wallet = DogeAPI.get_new_address(System.get_env("DOGE_API_KEY"), user_id).body
        User[
          user_id: user_id,
          name: name,
          balance: 10,
          wallet: wallet,
          deposited: 0
        ].write
      end
      Database.User.read(user_id)
    end
    conn = put_session(conn, :user_id, user.user_id)
    redirect conn, to: "/dashboard"
  end

  get "/logout" do
    delete_session(conn, :user_id)
    redirect conn, to: "/"
  end

  @prepare :authenticate_user
  get "/dashboard" do
    user = Amnesia.transaction do
      user_id = get_session(conn, :user_id)
      User.read(user_id)
    end
    conn = conn.assign(:balance, user.balance)
    conn = conn.assign(:wallet, user.wallet)
    render conn, "dashboard.html"
  end

  defp authenticate_user(conn) do
    unless get_session(conn, :user_id) do
      redirect! conn, to: "/"
    end
  end
end
