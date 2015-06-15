defmodule Nifty.Template do
  require EEx

  EEx.function_from_file :def, :elixir_nif, "priv/templates/nif.ex.eex", [:name, :mod]
  EEx.function_from_file :def, :nif, "priv/templates/nif.c.eex", [:name, :mod]
  EEx.function_from_file :def, :makefile, "priv/templates/makefile.eex", [:name]

end