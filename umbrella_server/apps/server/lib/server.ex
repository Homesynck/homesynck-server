defmodule Server do
  @moduledoc """
  Documentation for `Server`.
  """

  defmodule State do
    defstruct port: 3000,
              mode: "ssl",
              host: "*",
              socket: nil
  end

  def start(port) do
    project_path = 'C:\\Users\\mr003\\Documents\\Work\\Courses\\2020-2021\\PJS4\\rt-sfs-sec-sync-server\\'

    :ssl.start()

    {:ok, listen_socket} = :ssl.listen(
      3000,
      [{:certfile, project_path ++ 'certificates\\test1\\ssl.crt'},
      {:keyfile, project_path ++ 'certificates\\test1\\ssl.key'}])

    {:ok, tls_transport_socket} = :ssl.transport_accept(listen_socket)

    {:ok, socket} = :ssl.handshake(tls_transport_socket)

    :ssl.send(socket, 'Mon super message\n')
  end
end
