defmodule BlitzyTest do
  use ExUnit.Case
  doctest Blitzy

  test "greets the world" do
    assert Blitzy.hello() == :world
  end
end
