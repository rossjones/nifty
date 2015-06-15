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


defmodule Mix.Tasks.Nifty.Gen do
  @shortdoc "Creates some boilerplate"


  def usage(error) do
    IO.puts """
      #{error}

        mix nifty.gen --library LIBNAME --module MODULENAME

      This will generate a NIF where the library file is called
      lib_LIBNAME and the module where the Elixir is written
      is called MODULENAME in a file called nif.ex

      For example:

        mix nifty.gen --library hello --module Nifty.Hello

      will create lib_hello.c and setup the Makefile to compile it.
      A NIF wrapper will be created in lib/nif.ex in a module called
      Nifty.Hello

      You may use -l instead of --library, and -m instead
      of --module
    """
    System.halt
  end


  def check_args({nil, nil}), do: usage("Error: You must specify library and module")
  def check_args({nil, _}), do: usage("Error: You must also specify the module name")
  def check_args({_, nil}), do: usage("Error: You must also specify library name")
  def check_args(_), do: ""

  @doc """
  Generates a sample makefile which is written to stdout
  """
  def run(args) do

    {options, _, _} = OptionParser.parse(args, aliases: [l: :library, m: :module])

    name = options[:library]
    mod  = options[:module]

    check_args({name, mod})

    ["c_src", "priv/lib"] |> Enum.each( &File.mkdir_p/1 )

    write_file_iff("c_src/#{name}_nif.c", Nifty.Template.nif(name, mod))
    write_file_iff("Makefile", Nifty.Template.makefile(name))
    write_file_iff("lib/nif.ex", Nifty.Template.elixir_nif(name, mod))

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