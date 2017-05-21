defmodule Mix.Tasks.Compile.Cmake do
  @moduledoc "Compiles RingBuffer NIF"

  def run(_) do
    {result, _} = System.cmd("cmake", ["."], stderr_to_stdout: true)
    Mix.shell.info result
    {result, _} = System.cmd("make", ["all"], stderr_to_stdout: true)
    Mix.shell.info result
    :ok
  end
end

defmodule RingBuffer.Mixfile do
  use Mix.Project

  def project do
    [app: :ringbuffer,
     version: "0.1.0",
     elixir: "~> 1.4",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     compilers: [:cmake] ++ Mix.compilers,
     source_url: "https://github.com/brandonhamilton/elixir-ringbuffer",
     homepage_url: "https://github.com/brandonhamilton/elixir-ringbuffer",
     docs: [extras: ["README.md"]],
     deps: deps()]
  end

  def application do
    [extra_applications: [:logger]]
  end

  def package do
    [name: :ringbuffer,
     maintainers: ["Brandon Hamilton"],
     licenses: ["MIT"],
     links: %{"GitHub" => "https://github.com/brandonhamilton/elixir-ringbuffer",
              "Docs" => "https://hexdocs.pm/ringbuffer"}]
  end

  defp deps do
    [{:ex_doc, "~> 0.14", only: :dev, runtime: false}]
  end
end
