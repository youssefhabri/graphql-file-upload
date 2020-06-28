# FileUpload

#### Installation

- Install Elixir (following the [official installation guide](https://elixir-lang.org/install.html))
- Install Hex and Phoenix CLI:

```sh
$ mix local.hex
$ mix archive.install hex phx_new
```

*If you plan to edit the code and use the Eixir Language Server ([ElixirLS](https://github.com/elixir-lsp/elixir-ls)), make sure you have `esl-erlang` installed (or the appropriate package for your system), as ElixirLS might have issue if the Erlang platform is not fully installed.*



#### Setup and Usage

To start the `file-upload` server:

  * Install dependencies with `mix deps.get`
  * Edit the `config/dev.ex` file with the appropriate information
  * Create and migrate your database with `mix ecto.setup`
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

#### 

###### Built using:

  * Phoenix: https://www.phoenixframework.org/
  * Absinthe: https://github.com/absinthe-graphql/absinthe
