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

defmodule Mix.Tasks.Clean.Make do
  @shortdoc "Executes make clean"

  @doc """
  Executes the 'make clean' task in the Makefile present in the
  current directory
  """
  def run(_) do
    {result, _error_code} = System.cmd("make", ['clean'], stderr_to_stdout: true)
    Mix.shell.info result
    :ok
  end
end


defmodule Mix.Tasks.Make.Gen do
  @shortdoc "Generates a sample Makefile"

  @doc """
  Generates a sample makefile which is written to stdout
  """
  def run(args) do
    name = hd(args)
    ["c_src", "priv/lib"] |> Enum.each( &File.mkdir_p/1 )

    write_file_iff("c_src/#{name}_nif.c", Nifty.Template.nif(name))
    write_file_iff("Makefile", Nifty.Template.makefile(name))
    write_file_iff("lib/nif.ex", Nifty.Template.elixir_nif(name))

    Mix.Tasks.Compile.Make.run("")

    IO.puts """
      Don't forget to add the following to your mix.exs

        defp aliases do
          [clean: ["clean", "clean.make"]]
        end

        # Add to your project function
        compilers: [:make, :elixir, :app],
        aliases: aliases,
    """

    :ok
  end

  def write_file_iff(filename, contents) do
    case File.exists?(filename) do
      true ->
        IO.puts "Skipping creation of #{filename} as it already exists"
      false ->
        {:ok, file} = File.open filename, [:write]
        IO.binwrite file, contents
        File.close file
    end
  end
end