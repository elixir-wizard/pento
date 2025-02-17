defmodule Pento.Catalog.Product do
  alias Pento.Catalog.Category
  use Ecto.Schema
  import Ecto.Changeset

  schema "products" do
    field :name, :string
    field :description, :string
    field :unit_price, :float
    field :sku, :integer

    belongs_to :category, Category

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(product, attrs) do
    product
    |> cast(attrs, [:name, :description, :unit_price, :sku, :category_id])
    |> validate_required([:name, :description, :unit_price, :sku, :category_id])
    |> unique_constraint(:sku)
  end
end
