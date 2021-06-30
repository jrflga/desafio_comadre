defmodule ComadrePay.Accounts.Transaction do
  alias Ecto.Multi
  alias ComadrePay.{Accounts.Operation, Transaction, Repo}
  alias ComadrePay.Accounts.Transactions.Response, as: TransactionResponse

  import Ecto.Query, only: [from: 2]

  def call(%{"from" => from_id, "to" => to_id, "amount" => amount}) do
    withdraw_params = build_params(from_id, amount)
    deposit_params = build_params(to_id, amount)

    transaction_params = build_params(from_id, to_id, amount)

    Multi.new()
    |> Multi.merge(fn _changes -> Operation.call(withdraw_params, :withdraw) end)
    |> Multi.merge(fn _changes -> Operation.call(deposit_params, :deposit) end)
    |> Multi.insert(:create_transaction, Transaction.changeset(transaction_params))
    |> run_transaction()
  end

  def revoke(%{"id" => id}) do
    transaction = Repo.get!(Transaction, id)
    transaction_params = can_be_revoked?(transaction)

    withdraw_params = build_params(transaction_params.from, transaction_params.amount)
    deposit_params = build_params(transaction_params.to, transaction_params.amount)

    changeset = Ecto.Changeset.change(transaction, revoked?: true) |> IO.inspect()

    Multi.new()
    |> Multi.merge(fn _changes -> Operation.call(withdraw_params, :withdraw) end)
    |> Multi.merge(fn _changes -> Operation.call(deposit_params, :deposit) end)
    |> Multi.update(:update_transaction, changeset)
    |> run_transaction()
  end

  def list_by_datetime(%{"start_datetime" => start_datetime, "end_datetime" => end_datetime}) do
    {:ok, naive_start_datetime} = NaiveDateTime.from_iso8601(start_datetime)
    {:ok, naive_end_datetime} = NaiveDateTime.from_iso8601(end_datetime)

    query = from t in Transaction,
            where: t.inserted_at >= ^naive_start_datetime and
                  t.inserted_at <= ^naive_end_datetime

    Repo.all(query)
  end

  defp can_be_revoked?(%Transaction{} = transaction) when transaction.revoked?, do: :nothing

  defp can_be_revoked?(%Transaction{} = transaction), do: %{from: transaction.to, to: transaction.from, amount: transaction.amount}

  defp build_params(from, to, amount), do: %{"from" => from, "to" => to, "amount" => amount}

  defp build_params(id, amount), do: %{"id" => id, "amount" => amount}

  defp run_transaction(multi) do
    case Repo.transaction(multi) do
      {:error, _operation, reason, _changes} -> {:error, reason}
      {:ok, %{deposit: to_account, withdraw: from_account}} ->
        {:ok, TransactionResponse.build(from_account, to_account)}
    end
  end
end
