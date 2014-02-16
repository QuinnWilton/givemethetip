defmodule ApplicationRouter do
  use Dynamo.Router
  use Amnesia
  use Database
  require Database.Tip
  require Exquisite

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

      events = Database.Tip.where(recipient_user_id == user_id).values
        |> Enum.map &({ &1.sender_user_id, &1.recipient_user_id, &1.amount })

      conn = conn.assign(:user_id, user_id)
      conn = conn.assign(:events, events)
      IO.puts inspect(events)

      render conn, "dashboard.html"
    end
  end

  post "/tip" do
    Amnesia.transaction do
      sender_user_id    = conn.params[:sender_user_id]
      recipient_user_id = conn.params[:recipient_user_id]
      amount            = conn.params[:amount]

      if User.read(sender_user_id) do
        Models.Users.create(sender_user_id, "")
        Models.Tips.create_unconditional("Shibe", sender_user_id, 10)
      end

      result = Models.Tips.create(sender_user_id, recipient_user_id, amount)
      cond do
          { :error, :insufficient_funds } = result -> conn.resp 422, "insufficient funds"
          { :ok, tip } = result -> conn.resp 200, JSONEX.encode(tip)
      end
    end
  end

  defp authenticate_user(conn) do
    unless get_session(conn, :user_id) do
      redirect! conn, to: "/"
    end
  end
end
