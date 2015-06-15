defmodule Nifty.Template do
  require EEx

  EEx.function_from_string :def, :elixir_nif, "priv/templates/nif.ex.eex", [:name]
  EEx.function_from_string :def, :nif, "priv/templates/nif.c.eex", [:name]
  EEx.function_from_string :def, :makefile, "priv/templates/makefile.eex", [:name]

end