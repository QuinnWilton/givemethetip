defmodule Mix.Tasks.InstallDatabase do
	use Mix.Task
	use Database

	def run(_) do
		Amnesia.Schema.create
		Amnesia.start
		Database.create(disk: [node])
		Database.wait

    Amnesia.transaction do
      Models.Users.create("Shibe", "shane.wilton@gmail.com")
    end

		Amnesia.stop
	end
end