defmodule EmbedChat.Attempt do
  use EmbedChat.Web, :model

  schema "attempts" do
    field :email, :string
    field :url, :string

    timestamps
  end

  @required_fields ~w(url)
  @optional_fields ~w(email)

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ %{}) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end
end
