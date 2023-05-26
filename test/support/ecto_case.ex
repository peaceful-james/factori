defmodule Factori.EctoCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      def create_table!(name, columns), do: do_table!(:create, name, columns)
      def alter_table!(name, columns), do: do_table!(:alter, name, columns)

      defp do_table!(operation, name, columns) do
        table = %Ecto.Migration.Table{name: name, prefix: :public}

        Ecto.Adapters.Postgres.Connection.execute_ddl({operation, table, columns})
        |> IO.iodata_to_binary()
        |> Factori.TestRepo.query!()
      end

      def query!(query) do
        Factori.TestRepo.query!(query).rows
      end
    end
  end

  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Factori.TestRepo)
    Ecto.Adapters.SQL.Sandbox.mode(Factori.TestRepo, :manual)
  end
end
