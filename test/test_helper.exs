Dynamo.under_test(Givemethetip.Dynamo)
Dynamo.Loader.enable
ExUnit.start

defmodule Givemethetip.TestCase do
  use ExUnit.CaseTemplate

  # Enable code reloading on test cases
  setup do
    Dynamo.Loader.enable
    :ok
  end
end
