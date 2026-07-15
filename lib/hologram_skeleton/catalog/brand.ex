defmodule HologramSkeleton.Catalog.Brand do
  alias HologramSkeleton.Catalog.Product
  alias HologramSkeleton.Catalog.Supplier

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
    belongs_to :supplier, Supplier do
      public?(true)
    end

    has_many :products, Product do
      destination_attribute(:brand_id)
      public?(true)
    end
  end
end
