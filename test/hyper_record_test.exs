defmodule Repo do
  use Ecto.Repo, adapter: Ecto.Adapters.Postgres

  def url do
    "ecto://test:test@127.0.0.1/test"
  end
end

defmodule TestModel do
  use HyperRecord, repo: Repo

  attr_readable [:test]

  queryable "table" do
    field :test
  end

  validate _test, []
end

defmodule ModelTest do
  use ExUnit.Case
  import Mock

  test "create" do
    with_mock Repo,
      [create: fn(x) -> x end] do
        assert {:ok, TestModel.new} == TestModel.create
    end
  end

  test "find" do
    with_mock Repo,
      [get: fn(_m, id) -> TestModel.new(id: id) end] do
        assert TestModel.new(id: 1) == TestModel.find(1)
      end
  end

  test "destroy" do
    with_mock Repo,
      [delete: fn(_x) -> true end] do
        assert TestModel.destroy(TestModel.new)
    end
  end

  test "to_json" do
    model = TestModel.new(test: "working")
    assert TestModel.to_json(model) == "{\"id\":\"\",\"test\":\"working\"}"
  end
end
