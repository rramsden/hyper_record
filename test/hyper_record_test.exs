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
  use Amrita.Sweet

  fact "create" do
    provided [Repo.create(_) |> TestModel.new] do
      {:ok, TestModel.new} |> equals(TestModel.create)
    end
  end

  fact "find" do
    provided [Repo.get(_, _) |> TestModel.new(id: 1)] do
      TestModel.new(id: 1) |> equals(TestModel.find(1))
    end
  end

  fact "destroy" do
    provided [Repo.delete(_) |> true] do
      TestModel.destroy(TestModel.new) |> truthy
    end
  end

  fact "to_json" do
    model = TestModel.new(test: "working")
    TestModel.to_json(model) |> equals("{\"id\":\"\",\"test\":\"working\"}")
  end
end
