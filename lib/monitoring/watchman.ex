defmodule Monitoring.Watchman do
  use GenServer, restart: :transient

  def watch_me(process_info) do
    DynamicSupervisor.start_child(Monitoring.WatchmanSupervisor, {__MODULE__, process_info})
  end

  def start_link(process_info) do
    GenServer.start_link(
      __MODULE__,
      process_info
    )
  end

  def init(%{pid: pid, ref: ref} = state) do
    Process.monitor(pid)
    {:ok, state}
  end

  def handle_info({:DOWN, _thing, :process, _pid, reason}, state) do
    # How to pass along the state of the process that blew up?
    IO.puts("THINGS HAVE GONE WRONG. I'M TELLING MOM!!!!")
    IO.puts("<insert call to airbrake here>")
    IO.puts("Exception:")
    IO.inspect(reason)
    IO.puts("PROCESS INFO:")
    IO.inspect(state)
    {:stop, :normal, state}
  end
end
