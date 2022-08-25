defmodule DiscussWeb.AuthController do
  use DiscussWeb, :controller
  alias Discuss.Accounts
  plug Ueberauth

  # alias Discuss.Accounts.User

  def callback(%{assigns: %{ueberauth_auth: auth}}=conn, _params) do
    user_params = %{token: auth.credentials.token, email: auth.info.email, provider: "github"}
    IO.inspect(user_params)
    # changeset = User.changeset(%User{}, user_params)
    # IO.inspect(changeset)
    IO.puts("+++++++++++++++++++++++++++")
    signin(conn, user_params)
    # conn
    # |> put_flash(:info, "Github Authenticate?")
    # |> redirect(to: Routes.topic_path(conn, :index))
  end

  def signout(conn, _params) do
    conn
    |> configure_session(drop: true)
    |> redirect(to: Routes.topic_path(conn, :index))
  end

  defp signin(conn, user_params) do
    case insert_or_update(user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Welcome back!")
        |> put_session("user_id", user.id)
        |> redirect(to: Routes.topic_path(conn, :index))
      {:error, _reason} ->
        conn
        |> put_flash(:error, "Error signing in")
        |> redirect(to: Routes.topic_path(conn, :index))
    end
  end

  defp insert_or_update(user_params) do
    case Accounts.get_by(user_params.email) do
      nil ->
        Accounts.create_user(user_params)
      user ->
        {:ok, user}
    end
    # IO.puts("res: ")
    # IO.inspect(res)
  end
end
