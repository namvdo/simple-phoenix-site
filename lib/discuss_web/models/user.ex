defmodule DiscussWeb.User do
  use DiscussWeb, :model
  use Ecto.Schema
  import Ecto.Changeset
  schema "users" do
    field :email, :string
    field :token, :string
    field :provider, :string
    has_many(:topic, DiscussWeb.Topic)
    has_many(:comments, DiscussWeb.Comment)
    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
      |> cast(params, [:email, :provider, :token])
      |> validate_required([:email, :provider, :token])
  end
end
