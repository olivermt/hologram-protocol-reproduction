defmodule HologramSkeleton.HomePage do
  use Hologram.Page

  route "/"

  layout HologramSkeleton.DefaultLayout

  def init(_params, component, _server) do
    put_state(component, count: 0, server_value: HologramSkeleton.ServerValue.load())
  end

  def template do
    ~HOLO"""
    <main>
      <h1>Hologram protocol reproduction</h1>
      <p id="server-value">Server value: {@server_value}</p>
      <p id="count">Count: {@count}</p>
      <button id="increment" $click="increment">Increment</button>
    </main>
    """
  end

  def action(:increment, _params, component) do
    put_state(component, :count, component.state.count + 1)
  end
end
