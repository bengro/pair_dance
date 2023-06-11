defmodule PairDance.TestSupport.FakeGoogleAuth do
  use Ueberauth.Strategy

  def handle_request!(conn) do
    IO.puts("FakeGoogleAuth handle_request called")
    handle_callback!(conn)
  end

  def handle_callback!(conn) do
    IO.puts("FakeGoogleAuth authenticating fake user")

    auth = %Ueberauth.Auth{
      credentials: %Ueberauth.Auth.Credentials{
        expires: true,
        expires_at: 1_686_433_782,
        other: %{},
        refresh_token: nil,
        scopes: [
          "https://www.googleapis.com/auth/userinfo.profile https://www.googleapis.com/auth/userinfo.email openid"
        ],
        secret: nil,
        token: "xxx",
        token_type: "Bearer"
      },
      info: %Ueberauth.Auth.Info{
        birthday: nil,
        description: nil,
        email: "Joe Dough",
        first_name: "Joe",
        image:
          "https://lh3.googleusercontent.com/a/AAcHTtdKvB8nhNR8FhsrADRGpM4Pvohuu9KJg11gkjA5vAw=s96-c",
        last_name: "Dough",
        location: nil,
        name: "Joe Dough",
        nickname: nil,
        phone: nil,
        urls: %{profile: nil, website: nil}
      },
      provider: :google,
      strategy: Ueberauth.Strategy.Google,
      uid: "111"
    }

    assign(conn, :ueberauth_auth, auth)
  end

  def handle_cleanup!(conn) do
    assign(conn, :ueberauth_auth, nil)
  end
end
