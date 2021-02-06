defmodule Room do
  use GenServer

  @moduledoc """

    Documentation Room Module

  """

  # Client API

  @doc """

    Start a new room for the owner connected to the indicated room and
    return his name. By default, it doesn't connect to any room.

    ## Parameters
      - owner: the room owner.
      - connection: the room to which it connects.

  """

  def start(owner, connection \\ nil)
  def start(owner, nil) do
    room = getRoomName(owner)

    state = %{
      room: room,
      connections: %{},
      map: loadMap(%{}),
      players: %{}
    }

    GenServer.start_link(__MODULE__, state, name: {:global, room})

    room
  end
  def start(owner, connection) do
    room = getRoomName(owner)

    direction = GenServer.call({:global, connection}, {:getFreeDirection})
    connections = %{reverseDirection(direction) => connection}

    state = %{
      room: room,
      connections: connections,
      map: loadMap(connections),
      players: %{}
    }

    GenServer.start_link(__MODULE__, state, name: {:global, room})

    GenServer.cast({:global, connection}, {:addRoom, room, direction})

    room
  end

  @doc """

    Returns the number of doors that the room has, that is, the number of
    rooms to which it's connected.

    ## Parameters
      - room: the room to check.

  """

  def getDoors(room) do
    GenServer.call({:global, room}, {:getDoors})
  end

  @doc """

    Add the player to the room.

    ## Parameters
      - room: the room to which the player is added.
      - player: the player to add.

  """

  def addPlayer(room, player) do
    GenServer.cast({:global, room}, {:addPlayer, player, {6, 3}})
  end

  @doc """

    Move the player in the indicated direction.

    ## Parameters
      - room: the room in which to move the player.
      - player: the player to move.
      - direction: the direction in which to move the player.

  """

  def movePlayer(room, player, direction) do
    GenServer.call({:global, room}, {:movePlayer, player, direction})
  end

  @doc """

    Returns the room map for the indicated player.

    ## Parameters
      - room: the room from which get the map.
      - player: the player to search.

  """

  def getMap(room, player) do
    Matrix.to_list(GenServer.call({:global, room}, {:getMap, player}))
  end

  @doc """

    Returns all the coins that the player has collected from the
    rooms that are still active.

    ## Parameters
      - room: the room from which start the search.
      - player: the player to search.

  """

  def getCoins(room, player) do
    GenServer.call({:global, room}, {:getCoins, player, :all})
  end

  # Server API

  @impl true
  def init(state) do
    loop()
    {:ok, state}
  end

  @impl true
  def handle_info(:checkDoors, state) do
    newConections = Enum.filter(state.connections, fn {_, connection} ->
      :global.whereis_name(connection) != :undefined
    end)
    |> Enum.reduce(%{}, fn {direction, connection}, acc ->
      Map.put(acc, direction, connection)
    end)

    loop()
    {:noreply, %{state | connections: newConections, map: loadMap(newConections)}}
  end

  @impl true
  def handle_call({:getFreeDirection}, _, state) do
    {:reply, findFreeDirection(state.connections, Enum.shuffle([:north, :south, :east, :west])), state}
  end

  @impl true
  def handle_call({:getDoors}, _, state) do
    {:reply, map_size(state.connections), state}
  end

  @impl true
  def handle_call({:getMap, player}, _, state) do
    case Map.get(state.players, player) do
      {{x, y}, {c1, c2, c3, c4}} ->
        map = state.map
        map = if c1 do put_in(map[2][3], "-") else map end
        map = if c2 do put_in(map[2][9], "-") else map end
        map = if c3 do put_in(map[4][9], "-") else map end
        map = if c4 do put_in(map[4][3], "-") else map end
        map = put_in(map[y][x], "@")

        {:reply, map, state}
      _ ->
        raise RoomException, message: "The player isn't in the room"
    end
  end

  @impl true
  def handle_call({:movePlayer, player, dir}, _, state) do
    case Map.get(state.players, player) do
      {{x, y}, {c1, c2, c3, c4}} ->
        {{new_x, new_y}, door} = getDirectionData(dir, {x, y})

        map = state.map
        case map[new_y][new_x] do
          "-" ->
            newState = %{state | players: Map.put(state.players, player, {{new_x, new_y}, {c1, c2, c3, c4}})}

            {:reply, state.room, newState}
          "*" ->
            {{xc1, yc1}, {xc2, yc2}, {xc3, yc3}, {xc4, yc4}} = getCoinsPositions(dir)

            newState = cond do
              x == xc1 && y == yc1 ->
                %{state | players: Map.put(state.players, player, {{new_x, new_y}, {true, c2, c3, c4}})}
              x == xc2 && y == yc2 ->
                %{state | players: Map.put(state.players, player, {{new_x, new_y}, {c1, true, c3, c4}})}
              x == xc3 && y == yc3 ->
                %{state | players: Map.put(state.players, player, {{new_x, new_y}, {c1, c2, true, c4}})}
              x == xc4 && y == yc4 ->
                %{state | players: Map.put(state.players, player, {{new_x, new_y}, {c1, c2, c3, true}})}
              true ->
                raise RoomException, message: "Wrong position of some coin in the room map"
            end

            {:reply, state.room, newState}
          "D" ->
            case Map.get(state.connections, dir) do
              nil ->
                raise RoomException, message: "Room not connected in the following direction " <> Atom.to_string(dir)
              room ->
                GenServer.cast({:global, room}, {:addPlayer, player, door})

                {:reply, room, state}
            end
          "#" ->
            {:reply, state.room, state}
          _ ->
            raise RoomException, message: "Unexpected character in the room map"
        end
      _ ->
        raise RoomException, message: "The player isn't in the room"
    end
  end

  @impl true
  def handle_call({:getCoins, player, dir}, _, state) do
    coins = case Map.get(state.players, player) do
      {_, {c1, c2, c3, c4}} ->
        coins = if c1 do 1 else 0 end
        coins = if c2 do coins+1 else coins end
        coins = if c3 do coins+1 else coins end
        coins = if c4 do coins+1 else coins end
        coins
      _ ->
        0
    end
    coins = coins+(getOtherDirections(dir)
    |> Enum.map(fn dir ->
      Task.async(fn ->
        case Map.get(state.connections, dir) do
          nil -> 0
          room -> GenServer.call({:global, room}, {:getCoins, player, dir})
        end
      end)
    end)
    |> Enum.map(fn task -> Task.await(task) end)
    |> Enum.sum)

    {:reply, coins, state}
  end

  @impl true
  def handle_cast({:addRoom, connection, direction}, state) do
    connections = Map.put(state.connections, direction, connection)

    {:noreply, %{state | connections: connections, map: loadMap(connections)}}
  end

  @impl true
  def handle_cast({:addPlayer, player, position}, state) do
    {_, players} = Map.get_and_update(state.players, player, fn current_value ->
      case current_value do
        {_, coins} ->
          {current_value, {position, coins}}
        _ ->
          {current_value, {position, {false, false, false, false}}}
      end
    end)

    {:noreply, %{state | players: players}}
  end

  # Private functions

  defp loop() do
    Process.send_after(self(), :checkDoors, 2000)
  end

  defp getRoomName(owner) do
    String.to_atom("room_" <> Atom.to_string(owner))
  end

  defp loadMap(connections) do
    codeNorth = if Map.has_key?(connections, :north) do "1" else "0" end
    codeEast = if Map.has_key?(connections, :east) do "1" else "0" end
    codeSouth = if Map.has_key?(connections, :south) do "1" else "0" end
    codeWest = if Map.has_key?(connections, :west) do "1" else "0" end

    case File.read(Path.expand("../room/maps/map#{codeNorth}#{codeEast}#{codeSouth}#{codeWest}.txt")) do
      {:ok, text} ->
        Matrix.from_list(Enum.map(String.split(text, "\n"), fn list -> String.split(list, " ") end))
      {:error, _} ->
        raise RoomException, message: "Room map not available"
    end
  end

  defp findFreeDirection(_connections, []) do
    raise RoomException, message: "Room connected in all directions"
  end
  defp findFreeDirection(connections, [h | t]) do
    if Map.has_key?(connections, h) do
      findFreeDirection(connections, t)
    else
      h
    end
  end

  defp reverseDirection(:north) do
    :south
  end
  defp reverseDirection(:south) do
    :north
  end
  defp reverseDirection(:east) do
    :west
  end
  defp reverseDirection(:west) do
    :east
  end

  defp getDirectionData(:north, {x, y}) do
    {{x, y-1}, {6, 5}}
  end
  defp getDirectionData(:south, {x, y}) do
    {{x, y+1}, {6, 1}}
  end
  defp getDirectionData(:east, {x, y}) do
    {{x+1, y}, {1, 3}}
  end
  defp getDirectionData(:west, {x, y}) do
    {{x-1, y}, {11, 3}}
  end

  defp getCoinsPositions(:north) do
    {{3, 3}, {9, 3}, {9, 5}, {3, 5}}
  end
  defp getCoinsPositions(:south) do
    {{3, 1}, {9, 1}, {9, 3}, {3, 3}}
  end
  defp getCoinsPositions(:east) do
    {{2, 2}, {8, 2}, {8, 4}, {2, 4}}
  end
  defp getCoinsPositions(:west) do
    {{4, 2}, {10, 2}, {10, 4}, {4, 4}}
  end

  defp getOtherDirections(:all) do
    [:north, :south, :east, :west]
  end
  defp getOtherDirections(:north) do
    [:nouth, :east, :west]
  end
  defp getOtherDirections(:east) do
    [:north, :south, :east]
  end
  defp getOtherDirections(:south) do
    [:south, :east, :west]
  end
  defp getOtherDirections(:west) do
    [:north, :south, :west]
  end
end
