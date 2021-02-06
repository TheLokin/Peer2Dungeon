defmodule PlayerCLI do
  @moduledoc """

    Documentation PlayerCLI Module
    
  """
  
  @name "
   _____             ___   _
  |  _  |___ ___ ___|_  |_| |_ _ ___ ___ ___ ___ ___
  |   __| -_| -_|  _|  _| . | | |   | . | -_| . |   |
  |__|  |___|___|_| |___|___|___|_|_|_  |___|___|_|_|
                                    |___|            "

  @game_over "
   _____                  _____             
  |   __|___ _____ ___   |     |_ _ ___ ___ 
  |  |  | · |     | -_|  |  |  | | | -_|  _|
  |_____|_|_|_|_|_|___|  |_____|\\_/|___|_|  "

  @commands [
    {"create", "Creates your own room"},
    {"up", "Move the player up"},
    {"down", "Move the player down"},
    {"left", "Move the player to the left"},
    {"right", "Move the player to the right"},
    {"quit", "Quits the game"}
  ]

  @doc """

    Boot the player's interface.

  """

  def main(_args) do
    IO.puts("\e[H\e[2J#{@name}\n")
    IO.puts("Welcome to the Peer 2 Dungeon! Enjoy your adventure :D\n")

    connectionState = Player.start()

    case connectionState do
      :error -> 
        IO.write("")
      :ok ->
        receiveCommand()
    end
  end

  defp printHelpMessage do
    IO.write("The game supports the following commands:\n\n")

    Enum.each(@commands, fn({command, description}) -> IO.puts("  #{command} - #{description}") end)
  end

  defp receiveCommand do
    IO.puts("\e[H\e[2J#{@name}\n")
    printHelpMessage()
    
    case Player.printRoom() do
      :ok ->
        IO.gets("\n> ")
        |> String.trim
        |> String.downcase
        |> executeCommand
      :error ->
        IO.puts("#{@game_over}\n")
    end
  end

  defp executeCommand("create") do
    case Player.createRoom() do
      :ok ->
        receiveCommand()
      :error ->
        IO.puts("\e[H\e[2J#{@name}\n")
        printHelpMessage()
        IO.puts("#{@game_over}\n")
    end
  end
  defp executeCommand("up") do
    case Player.move(:north) do
      :ok ->
        receiveCommand()
      :error ->
        IO.puts("\e[H\e[2J#{@name}\n")
        printHelpMessage()
        IO.puts("#{@game_over}\n")
    end
  end
  defp executeCommand("down") do
    case Player.move(:south) do
      :ok ->
        receiveCommand()
      :error ->
        IO.puts("\e[H\e[2J#{@name}\n")
        printHelpMessage()
        IO.puts("#{@game_over}\n")
    end
  end
  defp executeCommand("left") do
    case Player.move(:west) do
      :ok ->
        receiveCommand()
      :error ->
        IO.puts("\e[H\e[2J#{@name}\n")
        printHelpMessage()
        IO.puts("#{@game_over}\n")
    end
  end
  defp executeCommand("right") do
    case Player.move(:east) do
      :ok ->
        receiveCommand()
      :error ->
        IO.puts("\e[H\e[2J#{@name}\n")
        printHelpMessage()
        IO.puts("#{@game_over}\n")
    end
  end
  defp executeCommand("quit") do
  end
  defp executeCommand(_unknown) do
    receiveCommand()
  end
end