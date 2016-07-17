defmodule EmbedChat.Message do
  use EmbedChat.Web, :model

  schema "messages" do
    field :body, :string
    belongs_to :from, EmbedChat.Address
    belongs_to :to, EmbedChat.Address
    belongs_to :room, EmbedChat.Room
    has_one :from_user, through: [:from, :user]
    has_one :to_user, through: [:to, :user]

    timestamps
  end

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:body, :from_id, :to_id])
    |> validate_required([:body])
  end
end
