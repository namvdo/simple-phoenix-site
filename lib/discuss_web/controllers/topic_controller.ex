defmodule DiscussWeb.TopicController do
  use DiscussWeb, :controller
  alias DiscussWeb.Topic
  alias DiscussWeb.Repo
  import Ecto

  plug DiscussWeb.Plugs.RequireAuth when action in [:new, :create, :edit, :update, :delete]
  plug :check_topic_owner when action in [:update, :edit, :delete]
  @spec new(Plug.Conn.t(), any) :: Plug.Conn.t()
  def new(conn, _params) do
    changeset = Topic.changeset(%Topic{}, %{})
    render conn, "new.html", changeset: changeset
  end

  def index(conn, _params) do
    topics = Repo.all(Topic)
    render conn, "index.html", topics: topics
  end

  def show(conn, %{"id" => topic_id}) do
    topic = Repo.get!(Topic, topic_id)
    render conn, "show.html", topic: topic
  end

  def create(conn, %{"topic" => topic}) do
    changeset = conn.assigns.user
      |> build_assoc(:topic)
      |> Topic.changeset(topic)


    case Repo.insert(changeset) do
      {:ok, _topic} ->
        conn
        |> put_flash(:info, "Topic Created")
        |> redirect(to: Routes.topic_path(conn, :index))
      {:error, changeset} -> render conn, "new.html", changeset: changeset
    end
  end

  def edit(conn, %{"id" => topic_id}) do
    topic = Repo.get(Topic, topic_id)
    changeset = Topic.changeset(topic)
    render conn, "edit.html", changeset: changeset, topic: topic
  end

  def update(conn, %{"id" => topic_id, "topic" => topic}) do
      old_topic = Repo.get(Topic, topic_id)
      changeset = Topic.changeset(old_topic, topic)
      case Repo.update(changeset) do
        {:ok, _topic} ->
          conn
          |> put_flash(:info, "Topic Updated")
          |> redirect(to: Routes.topic_path(conn, :index))
        {:error, _msg} ->
          render conn, "edit.html", changeset: changeset, topic: old_topic
      end
  end

  def delete(conn, %{"id" => topic_id}) do
    Repo.get!(Topic, topic_id)
        |> Repo.delete!
    conn
        |> put_flash(:info, "Topic deleted")
        |> redirect(to: Routes.topic_path(conn, :index))
  end

  def check_topic_owner(conn, _options) do
    %{params: %{"id" => topic_id}} = conn
    if (Repo.get(Topic, topic_id).user_id == conn.assigns.user.id) do
      conn
    else
      conn
        |> put_flash(:error, "You are not the owner of this topic")
        |> redirect(to: Routes.topic_path(conn, :index))
    end

  end
end
