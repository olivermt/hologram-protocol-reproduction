defmodule HologramSkeleton.Catalog.Product do
  alias HologramSkeleton.Catalog.Brand
  alias HologramSkeleton.Catalog.Category
  alias HologramSkeleton.Catalog.Variant

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

    attribute :sku, :string do
      public?(true)
    end
  end

  relationships do
    belongs_to :category, Category do
      public?(true)
    end

    belongs_to :brand, Brand do
      public?(true)
    end

    has_many :variants, Variant do
      destination_attribute(:product_id)
      public?(true)
    end
  end
end
