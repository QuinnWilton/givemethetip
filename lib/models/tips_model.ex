defmodule Models.Tips do

  def create(sender_user_id, recipient_user_id, amount) do
    cond do
      Models.Users.balance(sender_user_id) < amount ->
        { :error, :insufficient_funds }
      true ->
        create_unconditional(sender_user_id, recipient_user_id, amount)
    end
  end

  def create_unconditional(sender_user_id, recipient_user_id, amount) do
    result = Database.Tip[
      sender_user_id: sender_user_id,
      recipient_user_id: recipient_user_id,
      amount: amount
    ].write

    { :ok, result }
  end
end