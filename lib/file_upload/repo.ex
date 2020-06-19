defmodule FileUpload.Repo do
  use Ecto.Repo,
    otp_app: :file_upload,
    adapter: Ecto.Adapters.Postgres
end
