defmodule Homesynck.Auth.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :email, :string
    field :name, :string
    field :password_hashed, :string
    field :password, :string, virtual: true
    field :login_hash, :string

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :password])
    |> validate_required([:name, :password])
    |> unique_email()
    |> validate_password(:password)
    |> put_pass_hash()
  end

  def update_password_changeset(user, attrs) do
    user
    |> cast(attrs, [:password])
    |> validate_required([:password])
    |> validate_password(:password)
    |> put_pass_hash()
  end

  def token_changeset(struct, attrs) do
    struct
    |> changeset(attrs)
    |> cast(attrs, [:login_token])
    |> hash_login_token()
  end

  defp unique_email(changeset) do
    changeset
    |> validate_format(
      :email,
      ~r/^[a-zA-Z0-9.!#$%&'*+\/=?^_`{|}~-]+@[a-zA-Z0-9-\.]+\.[a-zA-Z]{2,}$/
    )
    |> validate_length(:email, max: 255)
    |> unique_constraint(:email)
  end

  # defp unique_name(changeset) do
  #   changeset
  #   |> validate_length(:name, min: 2, max: 64)
  #   |> unique_constraint(:name)
  # end

  defp validate_password(changeset, field, options \\ []) do
    validate_change(changeset, field, fn _, password ->
      case strong_password?(password) do
        {:ok, _} -> []
        {:error, msg} -> [{field, options[:message] || msg}]
      end
    end)
  end

  def generate_login_token do
    :crypto.strong_rand_bytes(40) |> Base.url_decode64()
  end

  defp hash_login_token(
         %Ecto.Changeset{valid?: true, changes: %{login_token: login_token}} = changeset
       ) do
    change(changeset, Argon2.add_hash(login_token, [{:hash_key, :login_hash}]))
  end

  defp hash_login_token(changeset), do: changeset

  defp put_pass_hash(%Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset) do
    change(changeset, Argon2.add_hash(password, [{:hash_key, :password_hashed}]))
  end

  defp put_pass_hash(changeset), do: changeset

  defp strong_password?(password) when byte_size(password) > 7 do
    {:ok, password}
  end

  defp strong_password?(_), do: {:error, "The password is too short"}
end
