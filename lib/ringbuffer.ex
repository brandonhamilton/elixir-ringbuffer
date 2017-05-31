defmodule RingBuffer do
  @moduledoc ~S"""
  [Circular Buffer](https://en.wikipedia.org/wiki/Circular_buffer) data structure
  """
  alias RingBuffer.Internals

  @opaque t :: %__MODULE__{
    size: non_neg_integer,
    default: any,
    internal: Internals.t
  }

  defstruct size: 0, internal: nil, default: :undefined

  @spec new(pos_integer(), [atom: any()]) :: {:ok, Internals.t} | {:error, String.t}
  @doc """
  Create a new circular buffer with a fixed size
  """
  def new(capacity, default \\ :undefined)
  def new(capacity, default) when is_number(capacity) do
    {:ok, %__MODULE__{size: capacity, internal: Internals.new(capacity, default)}}
  end
  def new(_, _), do: {:error, "Invalid parameters"}

  @spec set(Internals.t, non_neg_integer(), any()) :: {:ok, Internals.t} | {:error, String.t}
  @doc """
  Store a value at the specified index

  ## Examples

      iex> {:ok, b} = RingBuffer.new(2)
      ...> {:ok, b} = RingBuffer.set(b, 1, :item)
      ...> RingBuffer.get(b, 1)
      {:ok, :item}

  """
  def set(%{size: size, internal: buffer} = b, index, value) when is_number(index) and index >= 0 and index < size do
    {:ok, %{b | internal: Internals.set(buffer, index, value)}}
  end
  def set(_, _, _), do: {:error, "Invalid index"}

  @spec get(Internals.t, non_neg_integer()) :: {:ok, any()} | {:error, String.t}
  @doc """
  Return the value at the specified index

  ## Examples

      iex> {:ok, b} = RingBuffer.new(2)
      iex> RingBuffer.get(b, 0)
      {:ok, :undefined}

  """
  def get(%{size: size, internal: buffer}, index) when is_number(index) and index >= 0 and index < size do
    {:ok, Internals.get(buffer, index)}
  end
  def get(_, _), do: {:error, "Invalid index"}

  @spec reset(Internals.t, non_neg_integer()) :: {:ok, Internals.t}
  @doc """
  Reset the value at the specified index to the default value
  
  ## Examples

      iex> {:ok, b} = RingBuffer.new(2)
      ...> {:ok, b} = RingBuffer.set(b, 0, :ok)
      ...> {:ok, b} = RingBuffer.reset(b, 0)
      ...> RingBuffer.get(b, 0)
      {:ok, :undefined}

  """
  def reset(%{size: size, internal: buffer} = b, index) when is_number(index) and index >= 0 and index < size do
    {:ok, %{b | internal: Internals.reset(buffer, index)}}
  end
  def reset(_, _), do: {:error, "Invalid index"}

  @spec clear(Internals.t) :: {:ok, Internals.t} | {:error, String.t}
  @doc """
  Clear the whole buffer

  ## Examples

      iex> {:ok, b} = RingBuffer.new(2)
      ...> {:ok, b} = RingBuffer.set(b, 0, :ok)
      ...> {:ok, b} = RingBuffer.clear(b)
      ...> RingBuffer.get(b, 0)
      {:ok, :undefined}
  """
  def clear(%{internal: buffer} = b) do
    {:ok, %{b | internal: Internals.clear(buffer)}}
  end

  @spec to_list(Internals.t) :: [any]
  @doc """
  Convert a ring buffer to a list

  ## Examples

      iex> {:ok, b} = RingBuffer.new(4)
      ...> {:ok, b} = RingBuffer.set(b, 0, :ok)
      ...> {:ok, b} = RingBuffer.set(b, 2, :ok)
      ...> RingBuffer.to_list(b)
      [:ok, :undefined, :ok, :undefined]

  """
  def to_list(%{internal: buffer}) do
    Internals.to_list(buffer)
  end

  @spec from_list([any], any) :: {:ok, Internals.t} | {:error, String.t}
  @doc """
  Create a ring buffer from a list
  ## Examples

      iex> {:ok, b} = RingBuffer.from_list([:first, :second, :third])
      ...> RingBuffer.get(b, 0)
      {:ok, :first}
      iex> RingBuffer.get(b, 1)
      {:ok, :second}
      iex> RingBuffer.get(b, 2)
      {:ok, :third}

  """
  def from_list(lst, default \\ :undefined)
  def from_list(lst, default) when is_list(lst) do
    {:ok, %__MODULE__{size: length(lst), internal: Internals.from_list(lst, default)}}
  end
  def from_list(_, _), do: {:error, "Expecting a list"}

  @spec nif_loaded? :: true | false
  defdelegate nif_loaded?, to: Internals

  defimpl Inspect do
    import Inspect.Algebra

    def inspect(%{size: s, default: d}, _opts) do
      concat ["#RingBuffer<#{s},#{d}>"]
    end
  end

end
