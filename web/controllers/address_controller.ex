defmodule EmbedChat.AddressController do
  use EmbedChat.Web, :controller

  alias EmbedChat.Address
  plug Guardian.Plug.EnsureAuthenticated, [handler: EmbedChat.AuthErrorHandler]

  def index(conn, params) do
    user = Guardian.Plug.current_resource(conn)

    # TODO user user current project
    room =
      user
      |> Ecto.assoc(:rooms)
      |> Repo.all
      |> Enum.at(0)
    addresses =
      Address
      |> Address.for_room_with_visitors(room.id)
      |> Repo.paginate(params)
    render(conn, "index.html", addresses: addresses)
  end

  def show(conn, %{"id" => id}) do
    user = Guardian.Plug.current_resource(conn)
    address =
      Address
      |> Address.get_by_master(user.id, id)
      |> Repo.one!()
    render(conn, "show.html", address: address)
  end
end
