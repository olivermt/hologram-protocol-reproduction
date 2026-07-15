defmodule HologramSkeleton.Catalog.Category do
  alias HologramSkeleton.Catalog.Department
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

    attribute :name, :string do
      allow_nil?(false)
      public?(true)
    end
  end

  relationships do
    belongs_to :department, Department do
      public?(true)
    end

    has_many :products, Product do
      destination_attribute(:category_id)
      public?(true)
    end
  end
end
