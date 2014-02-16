defmodule Models.Users do
  require Database.Tip
  require Exquisite

  def create(user_id, email) do
    wallet = DogeAPI.get_new_address(System.get_env("DOGE_API_KEY"), user_id).body
    result = Database.User[
      user_id: user_id,
      email: email,
      wallet: wallet
    ].write

    { :ok, result }
  end

  def balance(user_id) do
    wallet    = Database.User.read(user_id).wallet
    deposited = DogeAPI.get_address_received(System.get_env("DOGE_API_KEY"), wallet).body

    outgoing  = Database.Tip.where(sender_user_id == user_id, select: amount)
    if outgoing do
      outgoing = Enum.reduce outgoing.values, 0, &(&1 + &2)
    else
      outgoing = 0
    end

    incoming  = Database.Tip.where(recipient_user_id == user_id, select: amount)
    if incoming do
      incoming = Enum.reduce incoming.values, 0, &(&1 + &2)
    else
      incoming = 0
    end

    deposited + incoming - outgoing
  end
end