defmodule AuthServTest do
  use ExUnit.Case
  doctest AuthServ

  test "greets the world" do
    assert AuthServ.hello() == :world
  end
end
