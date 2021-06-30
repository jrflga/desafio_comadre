defmodule ComadrePayWeb.AccountsView do
  use ComadrePayWeb, :view

  alias ComadrePay.Account
  alias ComadrePay.Accounts.Transactions.Response, as: TransactionResponse
  alias ComadrePayWeb.AccountsView

  def render("search.json", %{transactions: transactions}) do
    render_many(transactions, __MODULE__, "show.json", as: :transaction)
  end

  def render("update.json", %{account: %Account{id: account_id, balance: balance}}) do
    %{
      account: %{
        id: account_id,
        balance: balance,
      }
    }
  end

  def render("show.json", %{transaction: transaction}) do
    %{
      id: transaction.id,
      from: transaction.from,
      to: transaction.to,
      amount: transaction.amount,
      revoked?: transaction.revoked?
    }
  end

  def render("transaction.json", %{transaction:
    %TransactionResponse{
      to_account: to_account,
      from_account: from_account
    }
  }) do
    %{
      transaction: %{
        from: %{
          id: from_account.id,
          balance: from_account.balance,
        },
        to: %{
          id: to_account.id,
          balance: to_account.balance,
        }
      }
    }
  end

  def render("revoke.json", %{transaction:
  %TransactionResponse{
    to_account: to_account,
    from_account: from_account
  }
}) do
  %{
    transaction: %{
      from: %{
        id: from_account.id,
        balance: from_account.balance,
      },
      to: %{
        id: to_account.id,
        balance: to_account.balance,
      }
    }
  }
end
end
