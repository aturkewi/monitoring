defmodule Monitoring.WatchmanSupervisor do
  @moduledoc """
  DynamicSupervisor for spinning up UnsentInvoiceNotifier GenServers
  """

  use DynamicSupervisor

  def start_link(_) do
    DynamicSupervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  @impl true
  def init(_init_arg) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end
end
