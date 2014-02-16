defmodule Mix.Tasks.InstallDatabase do
	use Mix.Task
	use Database

	def run(_) do
		Amnesia.Schema.create
		Amnesia.start
		Database.create(disk: [node])
		Database.wait

    Amnesia.transaction do
      Models.Users.create("Shibe", "shane.wilton@gmail.com", "DPj89Wps6dcLJN1RLXFq5TKZZvCVTc4S35")
    end

		Amnesia.stop
	end
end