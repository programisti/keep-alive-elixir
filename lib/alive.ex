defmodule Alive do
  use Application

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec, warn: false
    Plug.Adapters.Cowboy.http AlivePlug, [timeout: 100500]

    # path independent request handler this handle all of the requests
    children = [
      # Define workers and child supervisors to be supervised
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Alive.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
