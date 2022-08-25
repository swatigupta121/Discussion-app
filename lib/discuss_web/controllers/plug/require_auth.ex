defmodule DiscussWeb.Plug.RequireAuth do
  use DiscussWeb, :controller
  import Plug.Conn
  import Phoenix.Controller
  # alias Discuss.Router.Helpers

  def init(_params) do
  end

  def call(conn, _params) do
    if conn.assigns[:user] do
      conn
    else
      conn
      |> put_flash(:error, "You must be logged in")
      |> redirect(to: Routes.topic_path(conn, :index))
      |> halt()
    end
  end
end
