defmodule UsersRouter do
  use Dynamo.Router
  use Amnesia
  use Database

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
end