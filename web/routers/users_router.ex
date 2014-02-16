defmodule UsersRouter do
  use Dynamo.Router
  use Amnesia
  use Database

  get "/:user_id" do
    user = Amnesia.transaction do
      binary_to_integer(user_id) |> User.read
    end

    { :ok, json } = JSEX.encode user
    conn.resp 200, json
  end

  put "/:user_id/deposit" do
    user = Amnesia.transaction do
      user = binary_to_integer(user_id) |> User.read
      deposited = DogeAPI.get_address_received(System.get_env("DOGE_API_KEY"), user.wallet).body
      user.balance(user.balance + deposited - user.deposited).deposited(deposited).write
    end

    { :ok, json } = JSEX.encode user
    conn.resp 200, json
  end

  put "/:user_id/withdraw" do
    amount = binary_to_integer(conn.params[:amount])
    target_wallet = conn.params[:target_wallet]
    result = Amnesia.transaction do
      user = binary_to_integer(user_id) |> User.read
      if user.balance >= amount and amount >= 5 do
        DogeAPI.withdraw(System.get_env("DOGE_API_KEY"), amount, target_wallet)
        user.balance(user.balance - amount).write
      else
        { :error, :insufficient_funds}
      end
    end

    cond do
      result == { :error, :insufficient_funds } -> conn.resp 422, "insufficient funds"
      true ->
        { :ok, json } = JSEX.encode result
        conn.resp 200, json
    end
  end

  post "/" do
    user = Amnesia.transaction do
      wallet = DogeAPI.get_new_address(System.get_env("DOGE_API_KEY"), conn.params[:facebook_userid]).body
      User[
        user_id: conn.params[:user_id],
        name: conn.params[:name],
        balance: 0,
        wallet: wallet,
        deposited: 0
      ].write
    end

    { :ok, json } = JSEX.encode user
    conn.resp 200, json
  end

  post "/:user_id/tips" do
    user_id      = binary_to_integer(user_id)
    recipient_id = binary_to_integer(conn.params[:recipient_userid])
    amount       = binary_to_integer(conn.params[:amount])

    result = Amnesia.transaction do
      user      = User.read(user_id)
      recipient = User.read(recipient_id)

      if user.balance >= amount and amount >= 0 do
        user.balance(user.balance - amount).write
        recipient.balance(recipient.balance + amount).write
        Tip[sender_userid: user_id, recipient_userid: recipient_id, amount: amount].write
      else
        { :error, :insufficient_funds}
      end
    end

    cond do
      result == { :error, :insufficient_funds } -> conn.resp 422, "insufficient funds"
      true ->
        { :ok, json } = JSEX.encode result
        conn.resp 200, json
    end
  end
end