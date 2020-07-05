defmodule FileUploadWeb.Plugs.UploadSpecPlug do
  @moduledoc """
  This Plug is meant to map requests, that use the graphql
  multipart request spec to upload files, to Absinthe's upload format
  """

  def init(options) do
    Keyword.put_new(options, :path, "/graphql")
  end

  def call(conn, opts) do
    if is_graphql_request_with_operations(conn, opts) do
      operations = update_variables_in_operations(conn)

      merge_operations_into_params(conn, operations)
    else
      conn
    end
  end

  defp is_graphql_request_with_operations(conn, opts) do
    conn.request_path == opts[:path] and Map.has_key?(conn.params, "operations")
  end

  defp merge_operations_into_params(conn, {:ok, operations}) do
    params = Map.merge(conn.params, operations)
    body_params = Map.merge(conn.body_params, operations)

    %{conn | params: params, body_params: body_params}
  end

  defp merge_operations_into_params(conn, {:error, _}) do
    conn
  end

  defp update_variables_in_operations(conn) do
    variables = map_files_to_variables(conn)

    case Jason.decode(conn.params["operations"]) do
      {:ok, operations} -> {:ok, %{operations | "variables" => variables}}
      {:error, reason} -> {:error, reason}
    end
  end

  defp map_files_to_variables(conn) do
    if Map.has_key?(conn.params, "map") do
      case Jason.decode(conn.params["map"]) do
        {:ok, map} -> map_to_variables(map)
        {:error, _} -> %{}
      end
    else
      %{}
    end
  end

  defp map_to_variables(map) do
    map
    |> Enum.map(fn {k, v} ->
      name = String.replace_leading(Enum.at(v, 0), "variables.", "")
      %{name => k}
    end)
    |> Enum.reduce(fn x, y ->
      Map.merge(x, y, fn _k, v1, v2 -> v2 ++ v1 end)
    end)
  end
end
