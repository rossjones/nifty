defmodule Mix.Tasks.Clean.Make do
  @shortdoc "Executes make clean"

  @doc """
  Executes the 'make clean' task in the Makefile present in the
  current directory
  """
  def run(_) do
    {result, _error_code} = System.cmd("make", ["clean"], stderr_to_stdout: true)
    Mix.shell.info result
    :ok
  end
end
