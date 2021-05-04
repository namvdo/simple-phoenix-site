defmodule DiscussWeb.CommentsChannel do
  use DiscussWeb, :channel
  alias DiscussWeb.{Topic, Repo, Comment}
  import Ecto
  def join("comments:" <> topic_id, _message, socket) do
    topic_id = String.to_integer(topic_id)
    topic = Repo.get(Topic, topic_id)
          |> Repo.preload(:comments)
    {:ok, %{comments: topic.comments}, assign(socket, :topic, topic)}
  end

  def handle_in(_name, %{"content" => content}, socket) do
    topic = socket.assigns.topic
    changeset = topic
      |> build_assoc(:comments)
      |> Comment.changeset(%{content: content})
    case Repo.insert(changeset) do
      {:ok, _comment} ->
        {:reply, :ok, socket}
      {:error, reason} -> {:reply, %{errors: reason}, socket}
    end
    {:reply, :ok, socket}
  end
end
