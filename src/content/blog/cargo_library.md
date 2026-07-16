---
title: A library for cargo
description: Creating a better interface for cargo.
pubDate: 2026-07-16
---

I'm working on an interface definition language called Lockstep, and as part of
the code generation pipeline for Rust targets, I compile the generated artifacts
to make sure everything checks out.

Naturally, I wanted to use `cargo` to compile the generated code, but to my
surprise, there is no way to kick off a build in-memory, or at least not an
officially sanctioned way. There is a cargo
[library](https://github.com/rust-lang/cargo), but it has an unstable API and is
"not intended for external use."

At that point, I had basically two choices: rewrite the logic myself, or shell
out to the binary and accept the runtime dependency. The first option can
sometimes make sense, if the scope is small enough, or if you are willing to
invest in the library. This is the case with things like `libgit2` and
`gitoxide` where the core features of the original binary `git` are
reimplemented from the ground up.

I chose not to do that, in this case, for obvious reasons. Reimplementing
`cargo` is a monumental side quest and not one I would likely do well enough to
suffice, at least in a reasonable timeline. The other thing is that
reimplementing `cargo` is not sufficient; if I want to avoid the runtime
dependency, I have to reimplement `rustc` as well, since it handles the actual
compilation, which is beyond the pale.

So I took the second path, which was to assume the presence of `cargo` (and
`rustc`) in the host environment and shell out to it from the codegen pipeline.
I don't love taking on the runtime dependency, but it feels like the lesser
evil. In any event, it is trivial to install the Rust toolchain, so I felt okay
putting that small burden on the end user and left it at that.

That still left me with the question of how to call `cargo` from my code. You
can cobble together the `Command` on the spot, which is what I did initially:

```rust
Command::new("cargo")
    .arg("build")
    .args(["--manifest-path", manifest_path])
    .output()
```

The bit I don't love about this approach is that all of the args are stringly
typed, so it is easy to get wrong, and you have to keep referring back to `cargo
--help` or the docs to figure out what flags are available and what they do.

I ended up wrapping the command construction in a small fluent builder that
documents the fields that I care about and exposes them using a type-safe
interface. There is a library called
[escargot](https://docs.rs/escargot/latest/escargot/) that has the same idea,
but it is collecting dust and does not support `cargo fmt`, which I needed as
well, so I rolled it myself:

```rust
use std::process::Command;

/// Creates a builder for the `cargo build` command.
pub fn build() -> CargoBuild {
    CargoBuild::new()
}

/// A builder for the `cargo build` command.
pub struct CargoBuild {
    /// The inner command.
    command: Command,
}

impl CargoBuild {
    /// Creates a new builder.
    fn new() -> Self {
        let mut command = Command::new("cargo");
        command.arg("build");
        Self { command }
    }

    /// Sets the path to the manifest (Cargo.toml) of the package to build.
    pub fn manifest_path(mut self, path: impl AsRef<str>) -> Self {
        self.command.args(["--manifest-path", path.as_ref()]);
        self
    }

    /// Returns the underlying [`Command`][std::process::Command], consuming the
    /// builder in the process.
    pub fn into_command(self) -> Command {
        self.command
    }
}
```

It works by creating a command under the hood and appending arguments to it in a
more structured way. It reads more naturally at the call site, which I quite
like. It also has the benefit that once you take the initial effort to document
the relevant flags, that documentation shows up in your editor thereafter. This
is what it looks like in use:

```rust
cargo::build()
    .manifest_path(manifest_path)
    .into_command()
    .output()
```

I admit this is only half of the abstraction that could exist. It provides an
in-memory experience for constructing the input, but the raw command invocation
and output machinery is still exposed at the tail end. There is a world where
those parts are wrapped up in a neat structured return type, and indeed
`escargot` does something like that.

For my purposes, it would be a step too far and too soon. I don't do any
semantic analysis of the build logs; I just capture them and print them out if
the build command fails (or drop them if the build succeeds). For the format
pass, I do even less; I just call it and let the stdout and stderr streams pass
through to the end user unadulterated. I also don't have enough use cases right
now to have a good sense for what the output abstraction should look like, so I
passed on that piece.
