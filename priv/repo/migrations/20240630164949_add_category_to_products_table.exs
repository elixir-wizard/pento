defmodule Pento.Repo.Migrations.AddCategoryToProductsTable do
  use Ecto.Migration

  def change do
    alter table(:products) do
      add :category_id, references(:categories, on_delete: :delete_all)
    end
  end
end
