defmodule FileUploadWeb.Schema do
  use Absinthe.Schema

  alias FileUploadWeb.FileResolver

  import_types(Absinthe.Plug.Types)

  object :file do
    field :id, :id
    field :filename, :string
    field :content_type, :string

    field :url, :string do
      resolve(fn root, _args, _ ->
        IO.inspect(root)
        base_url = FileUploadWeb.Endpoint.static_url()
        url = "#{base_url}/uploads/#{root.id}-#{root.filename}"
        {:ok, url}
      end)
    end
  end

  query do
    field :files, list_of(:file) do
      resolve(&FileResolver.list_files/3)
    end
  end

  mutation do
    field :upload_file, :file do
      arg(:file_data, non_null(:upload))

      resolve(&FileResolver.upload_file/3)
    end
  end
end
