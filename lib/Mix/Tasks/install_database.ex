defmodule Mix.Tasks.InstallDatabase do
	use Mix.Task
	use Database

	def run(_) do
		Amnesia.Schema.create
		Amnesia.start
		Database.create(disk: [node])
		Database.wait

    Amnesia.transaction do
      Models.Users.create("Shibe", "Shibe")
    end

		Amnesia.stop
	end
end