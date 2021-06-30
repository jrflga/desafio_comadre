defmodule ComadrePay.Accounts.Transaction do
  alias Ecto.Multi

  alias ComadrePay.{Accounts.Operation, Repo}
  alias ComadrePay.Accounts.Transactions.Response, as: TransactionResponse

  def call(%{"from" => from_id, "to" => to_id, "amount" => amount}) do
    withdraw_params = build_params(from_id, amount)
    deposit_params = build_params(to_id, amount)

    Multi.new()
    |> Multi.merge(fn _changes -> Operation.call(withdraw_params, :withdraw) end)
    |> Multi.merge(fn _changes -> Operation.call(deposit_params, :deposit) end)
    |> run_transaction()
  end

  defp build_params(id, amount), do: %{"id" => id, "amount" => amount}

  defp run_transaction(multi) do
    case Repo.transaction(multi) do
      {:error, _operation, reason, _changes} -> {:error, reason}
      {:ok, %{deposit: to_account, withdraw: from_account}} ->
        {:ok, TransactionResponse.build(from_account, to_account)}
    end
  end
end
