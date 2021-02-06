defmodule Player do
  use GenServer

  @moduledoc """

    Documentation Player Module
    
  """

  # Client API

  @doc """

    Establish a new connection with the dungeon with the name given by the user.


  """

  def start() do
    try do
      IO.puts("")

      # Get player and admin name
      player = createPlayer()
      admin = getAdminName()

      # Connect to admin
      case connectToAdmin(admin, 2) do
        :unavailable ->
          IO.puts("\nSorry but the local node doesn't exist.")
          :error
        :refused ->
          IO.puts("\nSorry but the node refused the connection, try again later.")
          :error
        :accepted ->
          # Wait a bit to establish the connection
          :timer.sleep 200
          
          room = Admin.getDefaultRoom(admin)
          Room.addPlayer(room, player)

          state = %{
            player: player,
            admin: admin,
            room: room,
            playerRoom: nil
          }
          
          GenServer.start_link(__MODULE__, state, name: :player)
          :ok
      end
    catch
      :exit, _ ->
        IO.puts("\nSorry but the node is taking a nap.")
        :error
    end
  end

  @doc """

    Create the user's room.

  """

  def createRoom do
    state = GenServer.call(:player, {:getState})

    try do
      if state.playerRoom == nil do
        room = Room.start(state.player, Admin.getRandomRoom(state.admin))
        Admin.addRoom(state.admin, room)
        GenServer.cast(:player, {:setPlayerRoom, room})
        Room.addPlayer(room, state.player)
      end
      :ok
    catch
      :exit, _ ->
        :error
    end
  end

  @doc """

    Move the user inside the room in the given direction.

    ## Parameters
      - direction: the direction in which to move the user.

  """

  def move(direction) do
    state = GenServer.call(:player, {:getState})

    try do
      GenServer.cast(:player, {:setRoom, Room.movePlayer(state.room, state.player, direction)})
      :ok
    catch
      :exit, _ ->
        try do
          room = Admin.getDefaultRoom(getAdminName())
          Room.addPlayer(room, state.player)

          GenServer.cast(:player, {:setRoom, room})
          :ok
        catch
          :exit, _ ->
            :error
        end
    end
  end

  @doc """

    Print the room.

  """

  def printRoom do
    state = GenServer.call(:player, {:getState})
    
    try do
      map = Room.getMap(state.room, state.player)
      coins = Room.getCoins(state.room, state.player)

      IO.puts("\n  Coins #{coins}")
      Enum.each(map, fn row ->
        IO.write("  ")
        Enum.each(row, fn val ->
          case val do
            "D" ->
              IO.write("  ")
            "-" ->
              IO.write("  ")
            _ ->
              IO.write(val<>" ")
          end
        end)
        IO.puts("")
      end)
      :ok
    catch
      :exit, _ ->
        try do
          room = Admin.getDefaultRoom(getAdminName())
          Room.addPlayer(room, state.player)

          GenServer.cast(:player, {:setRoom, room})
          printRoom()
        catch
          :exit, _ ->
            :error
        end
    end
  end

  # Server API

  @impl true
  def init(state) do
    {:ok, state}
  end

  @impl true
  def handle_call({:getState}, _, state) do
    {:reply, state, state}
  end

  @impl true
  def handle_cast({:setRoom, room}, state) do
    newState = %{state | room: room}
    {:noreply, newState}
  end

  @impl true
  def handle_cast({:setPlayerRoom, room}, state) do
    newState = %{state | room: room, playerRoom: room}
    {:noreply, newState}
  end

  # Private functions

  defp createPlayer do
    playerName = String.trim(IO.gets("What name do you want to have? > "))
    
    cond do
      playerName == "admin" ->
        IO.write("\nYour name can't be 'admin', try again. ")
        createPlayer()
      Regex.match?(~r{.*\s}, playerName) == true ->
        IO.write("\nYour name can't have withespaces, try again. ")
        createPlayer()
      Regex.match?(~r{^\d}, playerName) == true ->
        IO.write("\nYour name can't start by a digit, try again. ")
        createPlayer()
      playerName == "" ->
        IO.write("\nYour name can't be empty, try again. ")
        createPlayer()
      String.length(playerName) > 25 ->
        IO.write("\nYour name is too long, try again. ")
        createPlayer()
      true ->
        player = String.to_atom(playerName)
        
        case Node.start(player, :shortnames) do
          {:ok, _} ->
            player
          {:error, _} ->
            IO.write("\nVery slow gunslinger, someone has taken it before. ")
            createPlayer()
        end
    end
  end

  defp getAdminName do
    {:ok, hostName} = :inet.gethostname
    String.to_atom("admin@#{hostName}")
  end

  defp connectToAdmin(_admin, tries) when tries == 0 do
    :refused
  end
  defp connectToAdmin(admin, tries) do
    case Node.connect(admin) do
      true ->
        :accepted
      false ->
        IO.write("\nThe node is taking a nap, trying again. ")
        :timer.sleep 2000
        connectToAdmin(admin, tries-1)
      :ignored ->
        :unavailable
    end
  end
end