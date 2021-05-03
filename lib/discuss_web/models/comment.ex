
defmodule DiscussWeb.Comment do
    use DiscussWeb, :model
    use Ecto.Schema
    import Ecto.Repo
    schema "comment" do
      field :content, :string
      belongs_to(:users, DiscussWeb.User)
      belongs_to(:topic, DiscussWeb.Topic)
      timestamps()
    end

    @spec changeset(
            {map, map}
            | %{
                :__struct__ => atom | %{:__changeset__ => map, optional(any) => any},
                optional(atom) => any
              },
            :invalid | %{optional(:__struct__) => none, optional(atom | binary) => any}
          ) :: Ecto.Changeset.t()
    def changeset(struct, params \\ %{}) do
      struct
        |> cast(params, [:content])
        |> validate_required([:content])
    end
end
