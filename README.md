Nifty
=====

Helpers for getting started when I need a NIF setup for a project.

## Install 

```elixir 
git clone git@github.com:rossjones/nifty.git
cd nifty 
mix do archive.build, archive.install
```

## Commands

```elixir 
# Run make using the Makefile in the current directory
mix make
```

```elixir 
# Run make clean using the Makefile in the current directory
mix make.clean
```

```elixir 
# Creates a skeleton Makefile, c source and Elxiir module.
mix make.gen NAME
```