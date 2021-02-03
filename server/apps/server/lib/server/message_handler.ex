defmodule MessageHandler do
  defmacro __using__(_opts) do
    quote do
      use Supervisor


    end
  end
end
