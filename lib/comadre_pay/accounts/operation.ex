defmodule ComadrePay.Accounts.Operation do
  alias Ecto.Multi

  alias ComadrePay.Account

  def call(%{"id" => id, "amount" => amount}, operation) do
    operation_name = account_operation_name(operation)

    Multi.new()
    |> Multi.run(operation_name, fn repo, _changes ->
      get_account(repo, id)
    end)
    |> Multi.run(operation, fn repo, changes ->
      account = Map.get(changes, operation_name)

      update_balance(repo, account, amount, operation)
    end)
  end

  defp get_account(repo, id) do
    case repo.get(Account, id) do
      nil -> {:error, "Account not found!"}
      account -> {:ok, account}
    end
  end

  defp update_balance(repo, account, amount, operation) do
    account
    |> operation(amount, operation)
    |> update_account(repo, account)
  end

  defp operation(%Account{balance: balance}, amount, operation) do
    amount
    |> Decimal.cast()
    |> handle_cast(balance, operation)
  end

  defp handle_cast({:ok, amount}, balance, :deposit), do: Decimal.add(balance, amount)
  defp handle_cast({:ok, amount}, balance, :withdraw), do: Decimal.sub(balance, amount)
  defp handle_cast(:error, _balance, _operation), do: {:error, "Invalid deposit amount!"}

  defp update_account({:error, _reason} = error, _repo, _account), do: error
  defp update_account(amount, repo, account) do
    params = %{balance: amount}

    account
    |> Account.changeset(params)
    |> repo.update()
  end

  defp account_operation_name(operation) do
    "account_#{Atom.to_string(operation)}" |> String.to_atom()
  end
end
