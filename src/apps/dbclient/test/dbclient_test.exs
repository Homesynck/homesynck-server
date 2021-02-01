defmodule DbclientTest do
  use ExUnit.Case
  doctest Dbclient

  test "greets the world" do
    assert Dbclient.hello() == :world
  end
end
