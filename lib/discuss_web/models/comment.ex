
defmodule DiscussWeb.Comment do
    use DiscussWeb, :model
    use Ecto.Schema
    import Ecto.Repo
    schema "comments" do
      field :content, :string
      belongs_to(:user, DiscussWeb.User)
      belongs_to(:topic, DiscussWeb.Topic)
      timestamps()
    end

    def changeset(struct, params \\ %{}) do
      struct
        |> cast(params, [:content])
        |> validate_required([:content])
    end
end
