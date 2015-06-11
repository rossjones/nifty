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
# Creates a skeleton Makefile, c source and Elxiir module.
mix make.gen NAME
```

The compile and clean tasks should happen when your normal ```mix compile``` and ```mix clean``` calls happen.
