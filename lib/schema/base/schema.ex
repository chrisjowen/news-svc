defmodule NewsService.Schema do
  defmacro __using__(ops \\ []) do
    quote do
      use Ecto.Schema
      import Ecto.Changeset

      use Ecto.Schema.Callbacks

      after_insert(:schema_updated_worker)
      after_update(:schema_updated_worker)

      def schema_updated_worker(changeset) do
        if changeset.valid? do
          Que.add(NewsService.Worker.SchemaUpdatedWorker, [changeset])
        end
      end
    end
  end
end
