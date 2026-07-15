defmodule HologramSkeleton.Catalog.Price do
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

    attribute :currency, :string do
      allow_nil?(false)
      public?(true)
    end

    attribute :amount_cents, :integer do
      allow_nil?(false)
      public?(true)
    end
  end

  relationships do
    belongs_to :variant, Variant do
      public?(true)
    end
  end
end
