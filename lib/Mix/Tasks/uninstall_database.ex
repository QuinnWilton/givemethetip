defmodule Mix.Tasks.UninstallDatabase do
	use Mix.Task
	use Database

	def run(_) do
		Amnesia.start
		Database.destroy
		Amnesia.stop
		Amnesia.Schema.destroy
	end
end