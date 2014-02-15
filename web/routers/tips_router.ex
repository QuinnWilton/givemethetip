defmodule TipsRouter do
	use Dynamo.Router

	get "/" do
		conn.resp 200, "Get tips"
	end

	get "/:tip_id" do
		conn.resp 200, "Get tip #{tip_id}"
	end

	post "/" do
		conn.resp 200, "Post tips"
	end

	put "/:tip_id" do
		conn.resp 200, "Update tip #{tip_id}"
	end

	patch "/:tip_id" do
		conn.resp 200, "Patch tip #{tip_id}"
	end

	delete "/:tip_id" do
		conn.resp 200, "Delete tip #{tip_id}"
	end
end