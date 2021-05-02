defmodule DiscussWeb.Topic do
  use DiscussWeb, :model
  use Ecto.Schema
  import Ecto.Changeset

  schema "topic" do
    field :title, :string
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:title])
    |> validate_required([:title])
  end
end
