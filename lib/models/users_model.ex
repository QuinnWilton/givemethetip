defmodule UsersModel do
  use Amnesia
  use Database

  def create(user_id, name) do
    Amnesia.transaction do
      wallet = DogeAPI.get_new_address(System.get_env("DOGE_API_KEY"), user_id).body
      User[
        user_id: user_id,
        name: name,
        balance: 10,
        wallet: wallet,
        deposited: 0
      ].write
    end
  end
end