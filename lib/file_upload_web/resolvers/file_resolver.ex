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
        case add_file(args) do
          {:ok, upload} -> move_file(file.path, upload)
          {:error, reason} -> {:error, reason}
        end

      false ->
        {:error, "Failed to upload file"}
    end
  end

  def add_file(args) do
    operation =
      Repo.insert(%Upload{
        filename: args.file_data.filename,
        content_type: args.file_data.content_type
      })

    case operation do
      {:ok, upload} -> {:ok, upload}
      {:error, _} -> {:error, "Failed to upload the file."}
    end
  end

  def move_file(source, upload) do
    dest_path =
      Path.join([
        File.cwd!(),
        "priv",
        "static",
        "uploads",
        "#{upload.id}-#{upload.filename}"
      ])

    case File.rename(source, dest_path) do
      :ok -> {:ok, upload}
      {:error, _} -> {:error, "Failed to upload the file"}
    end
  end
end
