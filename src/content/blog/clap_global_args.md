---
title: Global args with clap
description: Setting up global arguments using clap.
pubDate: 2026-07-10
---

clap is one of those libraries that has a knob for everything, if you know where
to find it. I found a new one yesterday while building out a CLI for an example
todo service: the `global` attribute.

My goal was to expose two global flags for every command in the CLI: `url` and
`token`. You could already set those values in config files and using
environment variables, but I wanted the user to be able to override those values
on a per-request basis as well. This is the basic shape of the code:

```rust
/// A command line interface for the Checklist service.
#[derive(Debug, Parser)]
#[command(version, verbatim_doc_comment, max_term_width = 80)]
struct Cli {
    #[clap(flatten)]
    global_args: GlobalArgs,
    #[command(subcommand)]
    command: Command,
}

/// Global arguments.
#[derive(Debug, Args, Clone)]
struct GlobalArgs {
    /// The URL for the server.
    #[arg(long)]
    url: Option<String>,
    /// The token for the server.
    #[arg(long)]
    token: Option<String>,
}

#[derive(Debug, Subcommand)]
enum Command {
    CreateTodo(CreateTodoArgs),
    ...
}
```

This setup mostly works in the sense that it correctly parses global flags for
subcommands. So if I run something like `checklist create-todo --title hello
--url http://localhost:3000 --token 12345`, the global flags are available to
the create command. The one deficiency is that the flags don't show up in the
help text for the subcommand, so you have to run `checklist --help` to see
global flags and `checklist <command> --help` to see command-specific flags.

This is the problem that the `global` attribute solves. When you set it on a
flag (like so: `#[arg(long, global = true)]`), clap surfaces it in the top level
help text as well as subcommand help text, so you can see all your options in
one place:

```text
Creates a todo.

The todo is assigned a unique id on creation and begins in an incomplete state,
as one would expect of a todo.

Usage: checklist create-todo [OPTIONS] --title <TITLE> --description <DESCRIPTION>

Options:
      --title <TITLE>
          The title of the task

      --url <URL>
          The URL for the server

      --description <DESCRIPTION>
          The description of the task

      --token <TOKEN>
          The token for the server
```
