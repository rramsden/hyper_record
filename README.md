# HyperRecord

ActiveRecord-like syntax around Elixir's Ecto database wrapper

## Usage

    defmodule User do
      use HyperRecord

      queryable "users" do
        field :username, :string
      end
    end

    iex> [user] = User.where(username: "foobar")
    iex> User.to_json(user)
    "{\"id\":\"1\",\"username\":\"foobar\"}"

