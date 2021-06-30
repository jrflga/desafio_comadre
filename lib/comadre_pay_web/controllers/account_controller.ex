defmodule ComadrePayWeb.AccountsController do
  use ComadrePayWeb, :controller

  alias ComadrePay.Account
  alias ComadrePay.Accounts.Transactions.Response, as: TransactionResponse

  action_fallback ComadrePayWeb.FallbackController

  def search(conn, params) do
    transactions = ComadrePay.list_transactions_by_datetime(params)
    render(conn, "search.json", transactions: transactions)
  end

  def deposit(conn, params) do
    with {:ok, %Account{} = account} <- ComadrePay.deposit(params) do
      conn
      |> put_status(:ok)
      |> render("update.json", account: account)
    end
  end

  def withdraw(conn, params) do
    with {:ok, %Account{} = account} <- ComadrePay.withdraw(params) do
      conn
      |> put_status(:ok)
      |> render("update.json", account: account)
    end
  end

  def transaction(conn, params) do
    with {:ok, %TransactionResponse{} = transaction} <- ComadrePay.transaction(params) do
      conn
      |> put_status(:ok)
      |> render("transaction.json", transaction: transaction)
    end
  end

  def revoke(conn, params) do
    with {:ok, %TransactionResponse{} = transaction} <- ComadrePay.revoke(params) do
      conn
      |> put_status(:ok)
      |> render("revoke.json", transaction: transaction)
    end
  end

  def revoke(conn, params) do
    with {:ok, %TransactionResponse{} = transaction} <- ComadrePay.revoke(params) do
      conn
      |> put_status(:ok)
      |> render("revoke.json", transaction: transaction)
    end
  end
end
