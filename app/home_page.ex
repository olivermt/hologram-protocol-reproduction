defmodule HologramSkeleton.HomePage do
  use Hologram.Page

  route "/"

  layout HologramSkeleton.DefaultLayout

  def init(_params, component, _server) do
    source_code = """
    <script type="application/json">
      {"nested": true}
    </script>
    """

    put_state(component, :source_code, source_code)
  end

  def template do
    ~HOLO"""
    <main>
      <h1>Serialized &lt;/script&gt; reproduction</h1>

      <p>
        This source-code string is stored in the initial page state:
      </p>

      <pre id="source-code">{@source_code}</pre>

      <p id="mount-success">
        If there is no syntax error in the console, the initial page mount
        completed successfully.
      </p>
    </main>
    """
  end
end
