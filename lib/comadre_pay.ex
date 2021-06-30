defmodule ComadrePay do
  alias ComadrePay.Users.Create, as: UserCreate
  alias ComadrePay.Users.Get, as: UserGet
  alias ComadrePay.Accounts.{Deposit, Transaction, Withdraw}

  defdelegate create_user(params), to: UserCreate, as: :call
  defdelegate get_user!(id), to: UserGet, as: :call

  defdelegate deposit(params), to: Deposit, as: :call
  defdelegate withdraw(params), to: Withdraw, as: :call

  defdelegate transaction(params), to: Transaction, as: :call
  defdelegate revoke(params), to: Transaction, as: :revoke
end
