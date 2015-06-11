defmodule Nifty.Template do

  def elixir_nif(name) do
    """
  defmodule NIF do
      # When your move/rename this file (and you should) make sure
      # you also change the ERL_NIF_INIT call at the bottom of
      # c_src/#{name}_nif.c

      @on_load :init

      def init do
        :erlang.load_nif("./priv/lib/lib_#{name}", 0)
      end

      # A simple wrapper around the NIF call
      def hello do
        _hello
      end

      # This function will not be overwritten if the nif fails to load
      def _hello do
        "NIF library not loaded"
      end

  end

    """
  end

  def nif(name) do
      """
  #ifdef __GNUC__
  #  define UNUSED(x) UNUSED_ ## x __attribute__((__unused__))
  #else
  #  define UNUSED(x) UNUSED_ ## x
  #endif

  #include "erl_nif.h"

  #include <stdio.h>
  #include <strings.h>
  #include <unistd.h>


  static ERL_NIF_TERM _hello(ErlNifEnv* env, int UNUSED(arc), const ERL_NIF_TERM UNUSED(argv[]))
  {
        return enif_make_double(env, 0.0);
  }

  static ErlNifFunc nif_funcs[] =
  {
        {"_hello", 0, _hello, 0}
  };

  /* Change Elixir.NIF to the name you use in the project */
  ERL_NIF_INIT(Elixir.NIF,nif_funcs,NULL,NULL,NULL,NULL)

      """
  end

  def makefile(name) do
    """
ERLANG_PATH = $(shell erl -eval 'io:format("~s", [lists:concat([code:root_dir(), "/erts-", erlang:system_info(version), "/include"])])' -s init stop -noshell)
CFLAGS = -g -O3 -pedantic -Wall -Wextra -I$(ERLANG_PATH)

ifneq ($(OS),Windows_NT)
\tCFLAGS += -fPIC

\tifeq ($(shell uname),Darwin)
\t\tLDFLAGS += -dynamiclib -undefined dynamic_lookup
\tendif
endif

priv/lib/lib_#{name}.so: clean
\t@$(CC) $(CFLAGS) -shared $(LDFLAGS) -o $@ c_src/#{name}_nif.c

clean:
\t@$(RM) -r priv/lib/*

    """
  end

end