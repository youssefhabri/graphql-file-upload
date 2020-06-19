defmodule FileUpload.Repo.Migrations.CreateUploads do
  use Ecto.Migration

  def change do
    create table(:uploads) do
      add :title, :string
      add :description, :string
      add :filename, :string
      add :content_type, :string
      add :encoding, :string
      add :views, :integer, default: 0

      timestamps()
    end
  end
end
