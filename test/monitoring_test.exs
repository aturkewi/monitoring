defmodule MonitoringTest do
  use ExUnit.Case
  doctest Monitoring

  test "greets the world" do
    assert Monitoring.hello() == :world
  end
end
