defmodule FileUpload.Upload do
  use Ecto.Schema
  import Ecto.Changeset

  schema "uploads" do
    field :description, :string
    field :encoding, :string
    field :filename, :string
    field :content_type, :string
    field :title, :string
    field :views, :integer

    timestamps()
  end

  @doc false
  def changeset(upload, attrs) do
    upload
    |> cast(attrs, [:title, :description, :filename, :content_type, :encoding, :views])
    |> validate_required([:filename, :content_type])
  end
end
