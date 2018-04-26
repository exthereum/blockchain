defmodule EthCommonTest.Helpers do
  @moduledoc """
  Helper functions that will be generally available to test cases
  when they use `EthCommonTest`.
  """

  require Integer

  @spec load_integer(String.t) :: integer() | nil
  def load_integer(""), do: 0
  def load_integer("x" <> data), do: maybe_hex(data, :integer)
  def load_integer("0x" <> data), do: maybe_hex(data, :integer)
  def load_integer(data), do: maybe_dec(data)

  @spec maybe_hex(String.t | nil) :: binary() | nil
  def maybe_address(hex_data), do: maybe_hex(hex_data)

  @spec maybe_hex(String.t | nil) :: binary() | nil
  def maybe_hex(hex_data, type \\ :raw)
  def maybe_hex(hex_data, _) when not is_binary(hex_data), do: hex_data
  def maybe_hex(nil, _), do: nil
  def maybe_hex(hex_data, :raw), do: load_raw_hex(hex_data)
  def maybe_hex(hex_data, :integer), do: load_hex(hex_data)

  @spec maybe_dec(String.t | nil) :: integer() | nil
  def maybe_dec(nil), do: nil
  def maybe_dec(els), do: load_decimal(els)

  @spec load_decimal(String.t) :: integer()
  def load_decimal(dec_data) do
    {res, ""} = Integer.parse(dec_data)

    res
  end

  @spec load_raw_hex(String.t) :: binary()
  def load_raw_hex("0x" <> hex_data), do: load_raw_hex(hex_data)
  def load_raw_hex(hex_data) when Integer.is_odd(byte_size(hex_data)), do: load_raw_hex("0" <> hex_data)
  def load_raw_hex(hex_data) do
    Base.decode16!(hex_data, case: :mixed)
  end

  @spec load_hex(String.t) :: integer()
  def load_hex(hex_data), do: hex_data |> load_raw_hex |> :binary.decode_unsigned

  @spec read_test_directory(atom()) :: any()
  def read_test_directory(test_set) do
    {:ok, test_subsets} = File.ls(test_directory_name(test_set))

    test_subsets
  end

  @spec read_test_subset_directory(atom(), atom()) :: any()
  def read_test_subset_directory(test_set, test_subset) do
    # IO.inspect File.ls(test_subset_directory_name(test_set, test_subset))
    # IO.inspect test_set
    # IO.inspect test_subset
    {:ok, tests} = File.ls(test_subset_directory_name(test_set, test_subset))

    tests
      |> Enum.map(&String.trim_trailing(&1, ".json"))
  end

  @spec read_test_file(atom(), atom(), atom()) :: any()
  def read_test_file(test_set, test_subset, test) do
    # This is pretty terrible, but the JSON is just messed up in a number
    # of these tests (it contains duplicate keys with very strange values)
    body =
      File.read!(test_file_name(test_set, test_subset, test))
      |> String.split("\n")
      |> Enum.filter(fn x -> not (x |> String.contains?("secretkey ")) end)
      |> Enum.join("\n")

    Poison.decode!(body)
  end

  @spec test_directory_name(atom()) :: String.t
  def test_directory_name(test_set) do
    "test/support/ethereum_common_tests/#{test_set}"
  end

  @spec test_subset_directory_name(atom(), atom()) :: String.t
  def test_subset_directory_name(test_set, test_subset) do
    "test/support/ethereum_common_tests/#{test_set}/#{test_subset}"
  end

  @spec test_file_name(atom(), atom(), atom()) :: String.t
  def test_file_name(test_set, test_subset, test) do
    "test/support/ethereum_common_tests/#{test_set}/#{to_string(test_subset)}/#{test}.json"
  end
end
