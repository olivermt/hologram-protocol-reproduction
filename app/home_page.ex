defmodule HologramSkeleton.HomePage do
  use Hologram.Page

  alias HologramSkeleton.ServerAshPanel

  route "/"

  layout HologramSkeleton.DefaultLayout

  def init(_params, component, _server) do
    put_state(component, count: 0)
  end

  def template do
    ~HOLO"""
    <main>
      <h1>Hologram Ash reflection reproduction</h1>
      <ServerAshPanel cid="server-ash-panel" />
      <p id="count">Count: {@count}</p>
      <button id="increment" $click="increment">Increment</button>
    </main>
    """
  end

  def action(:increment, _params, component) do
    put_state(component, :count, component.state.count + 1)
  end
end
