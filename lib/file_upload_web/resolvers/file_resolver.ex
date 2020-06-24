defmodule FileUploadWeb.FileResolver do
  alias FileUpload.{Repo, Upload}

  def list_files(_root, _args, _) do
    files = Repo.all(Upload)

    {:ok, files}
  end

  def upload_file(_root, args, _) do
    file = args.file_data

    case File.exists?(file.path) do
      true ->
        case move_file(file) do
          {:ok, file} -> add_file(file)
          {:error, reason} -> {:error, reason}
        end

      false ->
        {:error, "Failed to upload file"}
    end
  end

  def add_file(file) do
    operation =
      Repo.insert(%Upload{
        filename: file.filename,
        content_type: file.content_type
      })

    case operation do
      {:ok, upload} -> {:ok, upload}
      {:error, _} -> {:error, "Failed to add the file to the database."}
    end
  end

  def move_file(file) do
    rand_id = Ecto.UUID.generate()
    filename = "#{rand_id}-#{file.filename}"

    dest_path =
      Path.join([
        File.cwd!(),
        "priv",
        "static",
        "uploads",
        filename
      ])

    case File.copy(file.path, dest_path) do
      {:ok, _bytes} ->
        {:ok, %{filename: filename, content_type: file.content_type}}

      {:error, reason} ->
        if Mix.env() in [:dev, :test] do
          {:error, "Failed to upload the file: #{reason}"}
        else
          {:error, "Failed to upload the file"}
        end
    end
  end
end
