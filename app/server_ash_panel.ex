defmodule HologramSkeleton.ServerAshPanel do
  use Hologram.Component

  def init(_params, component, _server) do
    put_state(component, summary: HologramSkeleton.Catalog.resource_summary())
  end

  def template do
    ~HOLO"""
    <p id="ash-summary">Server Ash summary: {@summary}</p>
    """
  end
end
