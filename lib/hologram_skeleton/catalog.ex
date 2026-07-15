defmodule HologramSkeleton.Catalog do
  alias HologramSkeleton.Catalog.Brand
  alias HologramSkeleton.Catalog.Category
  alias HologramSkeleton.Catalog.Department
  alias HologramSkeleton.Catalog.Price
  alias HologramSkeleton.Catalog.Product
  alias HologramSkeleton.Catalog.Supplier
  alias HologramSkeleton.Catalog.Variant

  use Ash.Domain

  resources do
    resource(Product)
    resource(Category)
    resource(Department)
    resource(Brand)
    resource(Supplier)
    resource(Variant)
    resource(Price)
  end

  def resource_summary do
    relationships =
      Product
      |> Ash.Resource.Info.relationships()
      |> Enum.map_join(", ", &to_string(&1.name))

    "Root #{inspect(Product)} relationships: #{relationships}"
  end
end
