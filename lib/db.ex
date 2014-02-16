use Amnesia

defdatabase Database do
	deftable Tip, [{ :id, autoincrement }, :sender_user_id, :recipient_user_id, :amount], type: :ordered_set do
  @type t :: Tip[
      id: non_neg_integer,
      sender_user_id: String.t,
      recipient_user_id: String.t,
      amount: non_neg_integer
    ]
	end

  deftable User, [:user_id, :email, :wallet] do
    @type t :: User[
      user_id: String.t,
      email: String.t,
      wallet: String.t
    ]
  end
end
