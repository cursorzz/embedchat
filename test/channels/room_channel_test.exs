defmodule EmbedChat.RoomChannelTest do
  use EmbedChat.ChannelCase

  alias EmbedChat.RoomChannel

  setup do
    {:ok, _, socket} =
      socket("user_id", %{distinct_id: "id"})
    |> subscribe_and_join(RoomChannel, "rooms:1")

    {:ok, socket: socket}
  end

  setup %{socket: socket} = config do
    if username = config[:login_as] do
      {:ok, socket: socket}
    else
      {:ok, socket: socket}
    end
  end

  test "ping replies with status ok", %{socket: socket} do
    ref = push socket, "ping", %{"hello" => "there"}
    assert_reply ref, :ok, %{"hello" => "there"}
  end

  test "shout broadcasts to rooms:lobby", %{socket: socket} do
    push socket, "shout", %{"hello" => "all"}
    assert_broadcast "shout", %{"hello" => "all"}
  end

  test "broadcasts are pushed to the client", %{socket: socket} do
    broadcast_from! socket, "broadcast", %{"some" => "data"}
    assert_push "broadcast", %{"some" => "data"}
  end
end
