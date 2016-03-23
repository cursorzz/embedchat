defmodule EmbedChat.Message do
  use EmbedChat.Web, :model

  schema "messages" do
    field :message_type, :string
    field :subject, :string
    field :body, :string
    belongs_to :from, EmbedChat.Address
    belongs_to :to, EmbedChat.Address
    has_one :from_user, through: [:from, :user]

    timestamps
  end

  @required_fields ~w(message_type body)
  @optional_fields ~w(subject)

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end
end
