defmodule ComadrePayWeb.AccountsView do
  alias ComadrePay.Account
  alias ComadrePay.Accounts.Transactions.Response, as: TransactionResponse

  def render("update.json", %{account: %Account{id: account_id, balance: balance}}) do
    %{
      message: "Update done successfully",
      account: %{
        id: account_id,
        balance: balance,
      }
    }
  end

  def render("transaction.json", %{transaction:
    %TransactionResponse{
      to_account: to_account,
      from_account: from_account
    }
  }) do
    %{
      message: "Transaction done successfully",
      transaction: %{
        from_account: %{
          id: from_account.id,
          balance: from_account.balance,
        },
        to_account: %{
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
    message: "Revoke done successfully",
    transaction: %{
      from_account: %{
        id: from_account.id,
        balance: from_account.balance,
      },
      to_account: %{
        id: to_account.id,
        balance: to_account.balance,
      }
    }
  }
end
end
