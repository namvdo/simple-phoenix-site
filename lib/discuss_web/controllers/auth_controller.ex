defmodule DiscussWeb.AuthController do
  use DiscussWeb, :controller
  alias DiscussWeb.User
  alias DiscussWeb.Repo
  plug Ueberauth

  @spec callback(Plug.Conn.t(), nil | maybe_improper_list | map) :: Plug.Conn.t()
  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, params) do
    user_params = %{token: auth.credentials.token, email: auth.extra.raw_info.user["email"], provider: params["provider"]}
    Map.put(user_params, "provider", params["provider"])
    changeset = User.changeset(%User{}, user_params)
    signin(conn, changeset)
  end

  defp signin(conn, changeset) do
    case insert_or_update_user(changeset) do
      {:ok, user} ->
        conn
          |> put_session(:user_id, user.id)
          |> put_flash(:info, "Successfully sign in")
          |> redirect(to: Routes.topic_path(conn, :index))
      {:error, _changeset}  ->
        conn
          |> put_flash(:error, "Error while sign in")
          |> redirect(to: Routes.topic_path(conn, :index))
    end
  end

  def signout(conn, _params) do
    conn
    |> configure_session(drop: true)
    |> redirect(to: Routes.topic_path(conn, :index))
  end
  defp insert_or_update_user(changeset) do
    case Repo.get_by(User, email: changeset.changes.email) do
      nil -> IO.inspect(Repo.insert(changeset))
      user -> {:ok, user}
    end
  end
end
