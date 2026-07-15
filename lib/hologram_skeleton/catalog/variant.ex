defmodule HologramSkeleton.Catalog.Variant do
  alias HologramSkeleton.Catalog.Price
  alias HologramSkeleton.Catalog.Product

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

    attribute :code, :string do
      allow_nil?(false)
      public?(true)
    end
  end

  relationships do
    belongs_to :product, Product do
      public?(true)
    end

    has_many :prices, Price do
      destination_attribute(:variant_id)
      public?(true)
    end
  end
end
