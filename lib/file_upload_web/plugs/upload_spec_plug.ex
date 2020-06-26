defmodule FileUploadWeb.Plugs.UploadSpecPlug do
  # import Plug.Conn

  def init(options) do
    options
  end

  def call(conn, opts) do
    path = if opts[:path] != nil, do: opts[:path], else: "/graphql"

    if conn.request_path == path and Map.has_key?(conn.params, "operations") do
      operations = Jason.decode!(conn.params["operations"])

      # If there's a files map, map it to variables
      variables =
        case Map.has_key?(conn.params, "map") do
          true ->
            Jason.decode!(conn.params["map"])
            |> map_to_variabes()

          false ->
            %{}
        end

      operations = %{operations | "variables" => variables}

      conn = %{
        conn
        | params: Map.merge(conn.params, operations),
          body_params: Map.merge(conn.body_params, operations)
      }

      conn
    else
      conn
    end
  end

  defp map_to_variabes(map) do
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
