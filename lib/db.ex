use Amnesia

defdatabase Database do
	deftable Tip, [:sender_userid, :recipient_userid, :amount], type: :bag, index: [:recipient_userid] do
    @type t :: Tip[sender_userid: integer, recipient_userid: integer, amount: integer]

    def sender(self) do
      Database.User.read(self.sender_userid)
    end

    def recipient(self) do
      Database.User.read(self.recipient_userid)
    end
	end

  deftable User, [:user_id, :name, :balance, :wallet, :deposited] do
    require Database.Tip

    @type t :: User[user_id: String.t, name: String.t, balance: integer, wallet: String.t, deposited: integer]

    def tips_sent(self) do
      Database.Tip.read(self.id)
    end

    def tips_received(self) do
      Database.Tip.where(recipient_userid == self.id).values
    end
  end
end