# Specimen

A better (sane) default factory implementation  

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `specimen` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:specimen, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/specimen](https://hexdocs.pm/specimen).

## Basic Usage

Define a factory file with configuration and optional states:

```elixir
defmodule UserFactory do
  use Specimen.Factory, User

  def build(specimen) do
    Specimen.with(specimen, :name, "John")
  end

  def state(:surname, %User{} = user) do
    Map.put(user, :surname, "Doe")
  end

  def after_making(%User{} = user) do
    Map.put(user, :age, 42)
  end  
end
```

And then:

```elixir
# Make just one user
%User{} = UserFactory.make_one()

# Make the specified amount of users
users = UserFactory.make_many(10)

# Make users by including specific states
%User{surname: "Doe"} = UserFactory.make_one([:surname])
```

Call it directly from your struct/ schema modules:

```elixir
defmodule User do
  use Specimen.HasFactory, UserFactory
  defstruct [:name, :surname, :age]
end
```

```elixir
user = User.make_one()
users = User.make_many(10)
```
