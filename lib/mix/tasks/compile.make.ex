defmodule Mix.Tasks.Compile.Make do
  @shortdoc "Runs make to execute the Makefile in the current directory"

  @doc """
  Executes the default make task in the Makefile present in the
  current directory
  """
  def run(_) do
    {result, _error_code} = System.cmd("make", [], stderr_to_stdout: true)
    Mix.shell.info result
    :ok
  end
end
