defmodule EmbedChat.MessageControllerTest do
  use EmbedChat.ConnCase

  alias EmbedChat.Message
  @valid_attrs %{body: "some content"}
  @invalid_attrs %{}

  setup %{conn: conn} do
    user = insert_user(username: "test")
    room = insert_room(user, %{})
    address = insert_address(user, room)
    conn = guardian_login(conn, user)
    {:ok, conn: conn, user: user, address: address}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, message_path(conn, :index)
    assert html_response(conn, 200) =~ "Message"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, message_path(conn, :new)
    assert html_response(conn, 200) =~ "New message"
  end

  test "creates resource and redirects when data is valid", %{conn: conn, address: from} do
    attr = Map.put(@valid_attrs, :from_id, from.id)
    conn = post conn, message_path(conn, :create), message: attr
    assert redirected_to(conn) == message_path(conn, :index)
    assert Repo.get_by(Message, attr)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, message_path(conn, :create), message: @invalid_attrs
    assert html_response(conn, 200) =~ "New message"
  end

  test "shows chosen resource", %{conn: conn, address: from} do
    message = Repo.insert! %Message{from_id: from.id}
    conn = get conn, message_path(conn, :show, message)
    assert html_response(conn, 200) =~ "Show message"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, message_path(conn, :show, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn, address: from} do
    message = Repo.insert! %Message{from_id: from.id}
    conn = get conn, message_path(conn, :edit, message)
    assert html_response(conn, 200) =~ "Edit message"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn, address: from} do
    message = Repo.insert! %Message{from_id: from.id}
    conn = put conn, message_path(conn, :update, message), message: @valid_attrs
    assert redirected_to(conn) == message_path(conn, :show, message)
    assert Repo.get_by(Message, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn, address: from} do
    message = Repo.insert! %Message{from_id: from.id}
    conn = put conn, message_path(conn, :update, message), message: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit message"
  end

  test "deletes chosen resource", %{conn: conn, address: from} do
    message = Repo.insert! %Message{from_id: from.id}
    conn = delete conn, message_path(conn, :delete, message)
    assert redirected_to(conn) == message_path(conn, :index)
    refute Repo.get(Message, message.id)
  end
end
