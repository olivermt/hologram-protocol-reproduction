defmodule HologramSkeleton.Catalog.Department do
  alias HologramSkeleton.Catalog.Category

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
    has_many :categories, Category do
      destination_attribute(:department_id)
      public?(true)
    end
  end
end
