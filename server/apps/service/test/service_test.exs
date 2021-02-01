defmodule ServiceTest do
  use ExUnit.Case
  doctest Service

  test "greets the world" do
    assert Service.hello() == :world
  end
end
