defmodule Monitoring.Stack do
  use GenServer#, restart: :transient

  def start_link(state \\ []) do
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  @impl true
  def init(stack \\ []) do
    ref = make_ref()
    IO.puts("starting a new stack")
    Monitoring.Watchman.watch_me(%{pid: self(), ref: ref})
    {:ok, %{stack: stack, ref: ref}}
  end

  @impl true
  def handle_call(:pop, _from, %{stack: [head | tail]} = state) do
    # {:reply, head, %{stack: tail, ref: ref}}
    {:reply, head, %{state | stack: tail}}
  end

  @impl true
  def handle_cast({:push, element}, %{stack: stack} = state) do
    # {:noreply, %{stack: [element | state], ref: ref}}
    {:noreply, %{state | stack: [element | stack]}}
  end

  @impl true
  def handle_cast(:boom, _state) do
    raise "boom"
  end

  @impl true
  def terminate(_reason, state) do
    IO.puts("I blew up with state and ref!<LOG THIS")
    IO.inspect(state)
  end

  def pop do
    GenServer.call(__MODULE__, :pop)
  end

  def push(elm) do
    GenServer.cast(__MODULE__, {:push, elm})
  end

  def boom do
    GenServer.cast(__MODULE__, :boom)
  end
end
