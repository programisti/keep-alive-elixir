defmodule AlivePlug do
  import Plug.Conn

  def init(opts) do
    opts
  end

  def call(conn, _opts) do
    conn = send_chunked(conn, 200)
    chunk(conn, "Start")

    core_pid = spawn_link(fn -> core_listener(conn) end)
    thread = spawn_link(fn -> thread_listener end)
    1..10 |> Enum.each(fn i -> send thread, {core_pid, i} end)

    chunk(conn, "End")
    conn
  end

  defp core_listener(conn) do
    receive do
      {status, i} ->
        _conn = chunk(conn, Integer.to_string(i))
        core_listener(conn)
    end
  end

  defp thread_listener do
    receive do
      {core_pid, i} ->
        send core_pid, {:ok, i}
        thread_listener
      _ ->
        thread_listener
    end
  end
end
