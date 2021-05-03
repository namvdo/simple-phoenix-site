defmodule DiscussWeb.CommentsChannel do
  use DiscussWeb, :channel


  def join(comment, _message, socket) do
    {:ok, %{}, socket}
  end

  def handle_in() do

  end
end
