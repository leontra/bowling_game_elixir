defmodule BowlingGameTest do
  use ExUnit.Case

  test "can roll" do
    game = spawn_link(Game, :start, [])
    send(game, {:roll, 0, 1})
  end

  test "gutter game" do
    game_pid = spawn_link(Game, :start, [])
    send(game_pid, {:roll, 0, 20})
    send(game_pid, {:score, self()})
    assert_receive {:score, 0}
  end

  test "all ones" do
    game = spawn_link(Game, :start, [])
    send(game, {:roll, 1, 20})
    send(game, {:score, self()})
    assert_receive {:score, 20}
  end

  test "one spare" do
    game = spawn_link(Game, :start, [])
    send(game, {:roll, 5, 2})
    send(game, {:roll, 3, 1})
    send(game, {:roll, 0, 17})
    send(game, {:score, self()})
    assert_receive {:score, 16}
  end

  test "one strike" do
    game = spawn_link(Game, :start, [])
    send(game, {:roll, 10, 1})
    send(game, {:roll, 3, 1})
    send(game, {:roll, 4, 1})
    send(game, {:roll, 0, 16})
    send(game, {:score, self()})
    assert_receive {:score, 24}
  end
  
  test "perfect game" do
    game = spawn_link(Game, :start, [])
    send(game, {:roll, 10, 12})
    send(game, {:score, self()})
    assert_receive {:score, 300}
  end

end
