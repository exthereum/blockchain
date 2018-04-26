defmodule EthCommonTest.Harness do
  @moduledoc """
  Harness for running tests off of the Ethereum Common Test suite.
  """

  defmacro __using__(_opts) do
    quote do
      import EthCommonTest.Helpers
      import EthCommonTest.Harness, only: [eth_test: 4]
    end
  end

  defmacro eth_test(test_set, test_subset_filter, test_filter, fun) do
    test_subsets = if test_subset_filter == :all do
      EthCommonTest.Helpers.read_test_directory(test_set) |> Enum.map(&String.to_atom/1)
    else
      [test_subset_filter] |> List.flatten
    end

    tests = for test_subset <- test_subsets do
      tests = if tests_filter = :all do
        EthCommonTest.Helpers.read_test_subset_directory(test_set, test_subset)
      else
        [test_filter] |> List.flatten
      end

      for test_name <- tests do
          json = EthCommonTest.Helpers.read_test_file(test_set, test_subset, test_name)
            |> Poison.encode!()
        result = quote do
            test("#{unquote(test_set)} - #{unquote(test_subset)} - #{unquote(test_name)}", test_params) do
              test = unquote(json) |> Poison.decode!
              unquote(fun).(test, unquote(test_subset), unquote(test_name))
            end
          end

        result
      end
    end
  end
end
