defmodule DiscussWeb.CommentsChannel do
  use DiscussWeb, :channel
  alias DiscussWeb.{Topic, Repo, Comment}
  import Ecto
  def join("comments:" <> topic_id, _message, socket) do
    topic_id = String.to_integer(topic_id)
    topic = Repo.get(Topic, topic_id)
          |> Repo.preload(comments: [:user])
    {:ok, %{comments: topic.comments}, assign(socket, :topic, topic)}
  end

  @spec handle_in(
          any,
          map,
          atom
          | %{
              :assigns =>
                atom
                | %{:topic => %{:__struct__ => atom, optional(any) => any}, optional(any) => any},
              optional(any) => any
            }
        ) ::
          {:reply, :ok,
           atom
           | %{:assigns => atom | %{:topic => map, optional(any) => any}, optional(any) => any}}
  def handle_in(_name, %{"content" => content}, socket) do
    topic = socket.assigns.topic
    user_id = socket.assigns.topic.user_id
    changeset = topic
      |> build_assoc(:comments, user_id: user_id)
      |> Comment.changeset(%{content: content})
    case Repo.insert(changeset) do
      {:ok, comment} ->
        broadcast!(socket, "comments:#{socket.assigns.topic.id}:new", %{comment: Repo.preload(comment, :user)})
        {:reply, :ok, socket}
      {:error, reason} -> {:reply, %{errors: reason}, socket}
    end
    {:reply, :ok, socket}
  end
end
