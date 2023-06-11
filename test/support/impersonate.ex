defmodule PairDanceWeb.Impersonate do
  @session_opts [
    store: :cookie,
    key: "foobar",
    encryption_salt: "encrypted cookie salt",
    signing_salt: "signing salt",
    log: false,
    encrypt: false
  ]

  @spec impersonate(Conn.t(), User.t()) :: Conn.t()
  def impersonate(conn, user) do
    conn
    |> Plug.Session.call(Plug.Session.init(@session_opts))
    |> Plug.Conn.fetch_session()
    |> Plug.Conn.put_session(:current_user, user)
  end
end
