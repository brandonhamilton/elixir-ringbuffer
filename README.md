# RingBuffer

[Circular Buffer](https://en.wikipedia.org/wiki/Circular_buffer) data structure

## Installation

The package can be installed by adding `ringbuffer` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [{:ringbuffer, "~> 0.1.0"}]
end
```

## Configuration

To disable loading of the NIF and force the use of fallback, set `disable_nif` to `true` in the config:

    config :ringbuffer, disable_nif: true

Documentation is published at [https://hexdocs.pm/ringbuffer](https://hexdocs.pm/ringbuffer).


## License

MIT License

Copyright (c) 2017 Brandon Hamilton

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.