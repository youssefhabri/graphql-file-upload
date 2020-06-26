defmodule FileUploadWeb.Plugs.UploadSpecPlug do
  # import Plug.Conn

  def init(options) do
    options
  end

  def call(conn, opts) do
    path = opts[:path] || "/graphql"

    if conn.request_path == path and Map.has_key?(conn.params, "operations") do
      operations = Jason.decode!(conn.params["operations"])

      # If there's a files map, map it to variables
      variables =
        if Map.has_key?(conn.params, "map") do
          Jason.decode!(conn.params["map"])
          |> map_to_variables()
        else
          %{}
        end

      operations = %{operations | "variables" => variables}

      params = Map.merge(conn.params, operations)
      body_params = Map.merge(conn.body_params, operations)

      %{conn | params: params, body_params: body_params}
    else
      conn
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
