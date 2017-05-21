defmodule RingBuffer do
  @moduledoc ~S"""
  [Circular Buffer](https://en.wikipedia.org/wiki/Circular_buffer) data structure
  """

  @on_load :init

  app = Mix.Project.config[:app]

  @doc false
  # Load NIF with fallback
  def init do
    unquote(app) |> :code.priv_dir |> :filename.join('ringbuffer') |> :erlang.load_nif(0)
  end

  @spec nif_loaded? :: true | false
  def nif_loaded?, do: false

end
