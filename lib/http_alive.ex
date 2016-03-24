defmodule AlivePlug do
  import Plug.Conn

  def init(opts) do
    opts
  end

  def call(conn, _opts) do
    conn = put_resp_header(conn, "Connection", "keep-alive")
    conn = put_resp_header(conn, "Keep-Alive", "max=15, timeout=20")
    conn = send_chunked(conn, 200)
    chunk(conn, "Init")
    pid = start_thread
    1..5
    |> Enum.each(fn num -> 
      send pid, {conn, num}
    end)

    # send End as a symbol of last chunk
    chunk(conn, "End")
    conn
  end

  defp start_thread, do: spawn_link(fn -> thread_listener end)
  defp thread_listener do
    receive do
      {conn, num} ->
        :timer.sleep(2000)
        #IO.inspect :timer.tc(fn -> IO.puts "hey" end)
        {status, conn} = chunk(conn, "hey")
        IO.inspect status
        thread_listener
      _ -> 
        thread_listener
    end
  end
end
