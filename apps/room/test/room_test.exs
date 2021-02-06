defmodule RoomTest do
  use ExUnit.Case, async: true
  use PropCheck
  use PropCheck.StateM

  doctest Room

  @players [:p1, :p2, :p3, :p4, :p5]

  property "the players move correctly" do
    kill_rooms()

    room1 = Room.start(:p1)
    Room.addPlayer(room1, :p1)
    :timer.sleep 2000
    
    assert validate_position(room1, :p1, {6, 3}), "the player not spawned in the center of the room"
    assert validate_coins(room1, :p1, 0), "the number of coins for the player is incorrect"

    assert validate_room(room1, :p1, :north), "the player has changed the room when he shouldn't"
    assert validate_position(room1, :p1, {6, 2}), "the player is badly positioned inside the room"
    assert validate_coins(room1, :p1, 0), "the number of coins for the player is incorrect"

    assert validate_room(room1, :p1, :north), "the player has changed the room when he shouldn't"
    assert validate_position(room1, :p1, {6, 1}), "the player is badly positioned inside the room"
    assert validate_coins(room1, :p1, 0), "the number of coins for the player is incorrect"

    assert validate_room(room1, :p1, :north), "the player has changed the room when he shouldn't"
    assert validate_position(room1, :p1, {6, 1}), "the player is badly positioned inside the room"
    assert validate_coins(room1, :p1, 0), "the number of coins for the player is incorrect"

    assert validate_room(room1, :p1, :east), "the player has changed the room when he shouldn't"
    assert validate_position(room1, :p1, {7, 1}), "the player is badly positioned inside the room"
    assert validate_coins(room1, :p1, 0), "the number of coins for the player is incorrect"

    assert validate_room(room1, :p1, :east), "the player has changed the room when he shouldn't"
    assert validate_position(room1, :p1, {8, 1}), "the player is badly positioned inside the room"
    assert validate_coins(room1, :p1, 0), "the number of coins for the player is incorrect"

    assert validate_room(room1, :p1, :east), "the player has changed the room when he shouldn't"
    assert validate_position(room1, :p1, {9, 1}), "the player is badly positioned inside the room"
    assert validate_coins(room1, :p1, 0), "the number of coins for the player is incorrect"

    assert validate_room(room1, :p1, :south), "the player has changed the room when he shouldn't"
    assert validate_position(room1, :p1, {9, 2}), "the player is badly positioned inside the room"
    assert validate_coins(room1, :p1, 1), "the number of coins for the player is incorrect"

    assert validate_room(room1, :p1, :south), "the player has changed the room when he shouldn't"
    assert validate_position(room1, :p1, {9, 3}), "the player is badly positioned inside the room"
    assert validate_coins(room1, :p1, 1), "the number of coins for the player is incorrect"

    assert validate_room(room1, :p1, :south), "the player has changed the room when he shouldn't"
    assert validate_position(room1, :p1, {9, 4}), "the player is badly positioned inside the room"
    assert validate_coins(room1, :p1, 2), "the number of coins for the player is incorrect"

    assert validate_room(room1, :p1, :west), "the player has changed the room when he shouldn't"
    assert validate_position(room1, :p1, {8, 4}), "the player is badly positioned inside the room"
    assert validate_coins(room1, :p1, 2), "the number of coins for the player is incorrect"

    assert validate_room(room1, :p1, :west), "the player has changed the room when he shouldn't"
    assert validate_position(room1, :p1, {7, 4}), "the player is badly positioned inside the room"
    assert validate_coins(room1, :p1, 2), "the number of coins for the player is incorrect"

    assert validate_room(room1, :p1, :west), "the player has changed the room when he shouldn't"
    assert validate_position(room1, :p1, {6, 4}), "the player is badly positioned inside the room"
    assert validate_coins(room1, :p1, 2), "the number of coins for the player is incorrect"

    assert validate_room(room1, :p1, :west), "the player has changed the room when he shouldn't"
    assert validate_position(room1, :p1, {5, 4}), "the player is badly positioned inside the room"
    assert validate_coins(room1, :p1, 2), "the number of coins for the player is incorrect"

    assert validate_room(room1, :p1, :west), "the player has changed the room when he shouldn't"
    assert validate_position(room1, :p1, {4, 4}), "the player is badly positioned inside the room"
    assert validate_coins(room1, :p1, 2), "the number of coins for the player is incorrect"

    assert validate_room(room1, :p1, :west), "the player has changed the room when he shouldn't"
    assert validate_position(room1, :p1, {3, 4}), "the player is badly positioned inside the room"
    assert validate_coins(room1, :p1, 3), "the number of coins for the player is incorrect"

    assert validate_room(room1, :p1, :north), "the player has changed the room when he shouldn't"
    assert validate_position(room1, :p1, {3, 3}), "the player is badly positioned inside the room"
    assert validate_coins(room1, :p1, 3), "the number of coins for the player is incorrect"

    assert validate_room(room1, :p1, :north), "the player has changed the room when he shouldn't"
    assert validate_position(room1, :p1, {3, 2}), "the player is badly positioned inside the room"
    assert validate_coins(room1, :p1, 4), "the number of coins for the player is incorrect"

    room2 = Room.start(:p2, room1)
    Room.addPlayer(room2, :p2)

    assert validate_position(room2, :p2, {6, 3}), "the player not spawned in the center of the room"
    assert validate_coins(room2, :p2, 0), "the number of coins for the player is incorrect"

    assert validate_room(room2, :p2, :north), "the player has changed the room when he shouldn't"
    assert validate_position(room2, :p2, {6, 2}), "the player is badly positioned inside the room"
    assert validate_coins(room2, :p2, 0), "the number of coins for the player is incorrect"

    assert validate_room(room2, :p2, :east), "the player has changed the room when he shouldn't"
    assert validate_position(room2, :p2, {7, 2}), "the player is badly positioned inside the room"
    assert validate_coins(room2, :p2, 0), "the number of coins for the player is incorrect"

    assert validate_room(room2, :p2, :east), "the player has changed the room when he shouldn't"
    assert validate_position(room2, :p2, {8, 2}), "the player is badly positioned inside the room"
    assert validate_coins(room2, :p2, 0), "the number of coins for the player is incorrect"

    assert validate_room(room2, :p2, :east), "the player has changed the room when he shouldn't"
    assert validate_position(room2, :p2, {9, 2}), "the player is badly positioned inside the room"
    assert validate_coins(room2, :p2, 1), "the number of coins for the player is incorrect"

    Room.addPlayer(room1, :p2)
    assert validate_position(room1, :p2, {6, 3}), "the player not spawned in the center of the room"
    assert validate_coins(room1, :p2, 1), "the number of coins for the player is incorrect"
  end

  property "the rooms are connected correctly", [:verbose] do
    forall cmds in commands(__MODULE__) do
      trap_exit do
        kill_rooms()
        {history, state, result} = run_commands(__MODULE__, cmds)

        (result == :ok)
        |> when_fail(
          IO.puts("""
          History: #{inspect(history, pretty: true)}
          State: #{inspect(state, pretty: true)}
          Result: #{inspect(result, pretty: true)}
          """)
        )
        |> aggregate(command_names(cmds))
      end
    end
  end

  # Helpers

  defp kill_rooms do
    Enum.map(@players, fn player -> String.to_atom("room_" <> Atom.to_string(player)) end)
    |> Enum.each(fn room ->
      pid = :global.whereis_name(room)

      if is_pid(pid) do
        try do
          Process.exit(pid, :kill)
        catch
          _, _ -> :already_killed
        end
      end
    end)
  end

  defp validate_room(room, player, direction) do
    new_room = Room.movePlayer(room, player, direction)
    
    new_room == room
  end

  defp validate_position(room, player, {x, y}) do
    Room.getMap(room, player)
    |> List.flatten
    |> Enum.at(x+y*13) == "@"
  end

  defp validate_coins(room, player, coins) do
    Room.getCoins(room,player) == coins
  end

  defp player do
    oneof(@players)
  end

  defp room(state) do
    oneof(Map.keys(state))
  end

  defp direction do
    oneof([:north, :south, :east, :west])
  end

  # State machine

  def command({:stopped, _state}) do
    {:call, Room, :start, [player()]}
  end
  def command({:started, state}) do
    oneof([
      {:call, Room, :start, [player(), room(state)]},
      {:call, Room, :getDoors, [room(state)]},
      {:call, Room, :addPlayer, [room(state), player()]},
      {:call, Room, :movePlayer, [room(state), player(), direction()]},
      {:call, Room, :getMap, [room(state), player()]}
    ])
  end

  def initial_state, do: {:stopped, %{}}

  def next_state({:stopped, state}, room, {:call, Room, :start, [owner]}) do
    {:started, Map.put(state, room, {owner, [], %{}})}
  end
  def next_state({:started, state}, room, {:call, Room, :start, [owner, connection]}) do
    {_, state} = Map.get_and_update(state, connection, fn {owner, connections, players} ->
      {{owner, connections, players}, {owner, [room | connections], players}}
    end)

    {:started, Map.put(state, room, {owner, [connection], %{}})}
  end
  def next_state({:started, state}, _, {:call, Room, :addPlayer, [room, player]}) do
    {_, state} = Map.get_and_update(state, room, fn {owner, connections, players} ->
      {{owner, connections, players}, {owner, connections, Map.put(players, player, {6, 3})}}
    end)

    {:started, state}
  end
  def next_state({:started, state}, _, {:call, Room, :movePlayer, [room, player, direction]}) do
    {_, state} = Map.get_and_update(state, room, fn {owner, connections, players} ->
      {x, y} = Map.get(players, player)
      new_players = case direction do
        :north ->
          Map.put(players, player, {x, max(y-1, 1)})
        :south ->
          Map.put(players, player, {x, min(y+1, 6)})
        :east ->
          Map.put(players, player, {min(x+1, 12), y})
        :west ->
          Map.put(players, player, {max(x-1, 1), y})
      end
      
      {{owner, connections, players}, {owner, connections, new_players}}
    end)

    {:started, state}
  end
  def next_state(state, _, _), do: state

  def precondition({:started, state}, {:call, Room, :start, [owner, connection]}) do
    Map.values(state)
    |> Enum.map(fn {owner, _, _} -> owner end)
    |> Enum.all?(fn o -> o != owner end) &&
    4 > case Map.get(state, connection) do
      nil ->
        0
      {_, connections, _} ->
        length(connections)
    end
  end
  def precondition({:started, state}, {:call, Room, :addPlayer, [_room, player]}) do
    Map.values(state)
    |> Enum.map(fn {_, _, players} -> Map.keys(players) end)
    |> List.flatten
    |> Enum.all?(fn p -> p != player end)
  end
  def precondition({:started, state}, {:call, Room, :movePlayer, [room, player, direction]}) do
    {_, _, players} = Map.get(state, room)
    case Map.has_key?(players, player) do
      true ->
        case Map.get(players, player) do
          {6, 5} ->
            :south != direction
          {6, 1} ->
            :north != direction
          {1, 3} ->
            :west != direction
          {11, 3} ->
            :east != direction
          _ ->
            true
        end
      false ->
        false
    end
  end
  def precondition({:started, state}, {:call, Room, :getMap, [room, player]}) do
    {_, _, players} = Map.get(state, room)
    Map.has_key?(players, player)
  end
  def precondition(_, _), do: true

  def postcondition({:started, state}, {:call, Room, :getDoors, [room]}, result) do
    result == case Map.get(state, room) do
      nil ->
        0
      {_, connections, _} ->
        length(connections)
    end
  end
  def postcondition({:started, state}, {:call, Room, :getMap, [room, player]}, result) do
    map = List.flatten(result)
    
    {_, connections, players} = Map.get(state, room)
    {x, y} = Map.get(players, player)

    Enum.count(map, fn char ->
      case char do
        "D" ->
          true
        _ ->
          false
      end
    end) == length(connections) && Enum.at(map, x+y*13) == "@"
  end
  def postcondition(_, _, _), do: true
end