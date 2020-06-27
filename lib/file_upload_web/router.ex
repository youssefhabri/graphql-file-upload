defmodule FileUploadWeb.Router do
  use FileUploadWeb, :router

  graphql_path = "/graphql"

  pipeline :api do
    plug :accepts, ["json"]
    plug FileUploadWeb.Plugs.UploadSpecPlug, path: graphql_path

    if Mix.env() in [:dev, :test] do
      plug :introspect
    end
  end

  scope "/" do
    pipe_through :api

    forward graphql_path, Absinthe.Plug, schema: FileUploadWeb.Schema

    forward "/graphiql", Absinthe.Plug.GraphiQL,
      schema: FileUploadWeb.Schema,
      interface: :simple,
      context: %{pubsub: FileUploadWeb.Endpoint}
  end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through [:fetch_session, :protect_from_forgery]
      live_dashboard "/dashboard", metrics: FileUploadWeb.Telemetry
    end

    def introspect(conn, _opts) do
      IO.puts("""
      Verb: #{inspect(conn.method)}
      Host: #{inspect(conn.host)}
      Headers: #{inspect(conn.req_headers)}
      """)

      conn
    end
  end
end
