defmodule Admin do
  use GenServer

  @moduledoc """

    Documentation Admin Module

  """

  # Client API

  @doc """

    Boot the admin.

  """

  def start do
    room = Room.start(Node.self())

    state = %{
      rooms: [room],
      defaultRoom: room
    }

    GenServer.start_link(__MODULE__, state, name: {:global, Node.self()})
  end

  @doc """

    Get the default admin room.

    ## Parameters
      - admin: the admin from whom get the room.

  """

  def getDefaultRoom(admin \\ Node.self()) do
    GenServer.call({:global, admin}, {:getDefaultRoom})
  end

   @doc """

    Returns a random room with some free connection.

    ## Parameters
      - admin: the admin from whom get the room.

  """

  def getRandomRoom(admin \\ Node.self()) do
    GenServer.call({:global, admin}, {:getRandomRoom})
  end

  @doc """

    Add the room to the rooms that the admin knows.

    ## Parameters
      - admin: the admin to which is added the room.
      - room: the room to add.

  """

  def addRoom(admin \\ Node.self(), room) do
    GenServer.cast({:global, admin}, {:addRoom, room})
  end

  # Server API

  @impl true
  def init(state) do
    loop()
    {:ok, state}
  end

  @impl true
  def handle_info(:checkRooms, state) do
    newDoors = Enum.filter(state.rooms, fn room -> :global.whereis_name(room) != :undefined end)

    loop()
    {:noreply, %{state | rooms: newDoors}}
  end

  @impl true
  def handle_call({:getDefaultRoom}, _, state) do
    {:reply, state.defaultRoom, state}
  end

  def handle_call({:getRandomRoom}, _, state) do
    randomRoom = Enum.shuffle(state.rooms)
    |> Enum.find(fn room ->
      try do
        Room.getDoors(room) < 4
      catch
        :exit, _ -> false
      end
    end)
    
    {:reply, randomRoom, state}
  end

  @impl true
  def handle_cast({:addRoom, room}, state) do
    {:noreply, %{state | rooms: Enum.uniq([room | state.rooms])}}
  end

  # Private functions

  defp loop() do
    Process.send_after(self(), :checkRooms, 2000)
  end
end
