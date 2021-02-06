defmodule AdminTest do
  use ExUnit.Case, async: true

  doctest Admin

  test "start and already started Admin" do
    assert {:ok, pid1} = Admin.start()
    assert {:error, {:already_started,pid2}} = Admin.start()
  end

  test "getDefaultRoom Admin" do
    Admin.start()
    :timer.sleep 2000
    assert :room_nonode@nohost = Admin.getDefaultRoom()
  end

  test "addRoom Admin" do
    Admin.start()
    room = Room.start(Node.self())
    Admin.addRoom(room)
    assert room = Admin.getRandomRoom

  end

  test "getRandomRoom Admin" do
    Admin.start()
    assert :room_nonode@nohost = Admin.getRandomRoom()
  end
end
