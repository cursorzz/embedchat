defmodule EmbedChat.Address do
  use EmbedChat.Web, :model

  schema "addresses" do
    field :uuid, Ecto.UUID
    belongs_to :user, EmbedChat.User
    has_many :outgoing_messages, EmbedChat.Message, foreign_key: :from_id
    has_many :incoming_messages, EmbedChat.Message, foreign_key: :to_id

    timestamps
  end

  @required_fields ~w(uuid)
  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ %{}) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> unique_constraint(:uuid)
  end
end
