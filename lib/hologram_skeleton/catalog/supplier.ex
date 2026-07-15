defmodule HologramSkeleton.Catalog.Supplier do
  alias HologramSkeleton.Catalog.Brand

  use Ash.Resource,
    domain: HologramSkeleton.Catalog,
    data_layer: Ash.DataLayer.Ets

  ets do
    private?(true)
  end

  actions do
    defaults([:read, :destroy, create: :*, update: :*])
  end

  attributes do
    uuid_primary_key(:id)

    attribute :name, :string do
      allow_nil?(false)
      public?(true)
    end
  end

  relationships do
    has_many :brands, Brand do
      destination_attribute(:supplier_id)
      public?(true)
    end
  end
end
