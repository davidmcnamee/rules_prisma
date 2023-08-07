
# `rules_prisma` (pre-release version)

Got a project that uses multiple programming languages? Want an ORM that works across multiple programming languages? You've come to the right place!

## What the heck is *Prisma*? What the heck is *Bazel*?

[**Prisma**](https://www.prisma.io/) is a "Next-generation Node.js and Typescript ORM" ... which in my opinion is really underselling its value. Prisma models your data in a [simple and concise DSL](https://www.prisma.io/docs/concepts/components/prisma-schema#example), and then it [generates database migrations](https://www.prisma.io/docs/concepts/components/prisma-migrate/get-started) for whichever DBMS you choose (including Postgres, MySQL, and MongoDB). It then [generates a client library](https://www.prisma.io/docs/concepts/components/prisma-client#3-use-prisma-client-to-send-queries-to-your-database) for your programming language of choice (including community-maintained [Go](https://github.com/steebchen/prisma-client-go), [Python](https://prisma-client-py.readthedocs.io/en/stable/), and [Rust](https://github.com/Brendonovich/prisma-client-rust) implementations). Some open-source developers even use this DSL to auto-generate [an entire GraphQL api layer](https://prisma.typegraphql.com/). **Think of it as the Protobuf for database interfaces.**

[**Bazel**](https://bazel.build/) is the Google-built open-source build system that helps you define an explicit dependency graph of your project's files and then orchestrates your compilers and build tools to build your project in the most efficient way possible. It uses [sandboxing techniques](https://bazel.build/docs/sandboxing#sandboxing-reasons) to make sure it builds the same on every machine, it heavily [caches build artifacts](https://bazel.build/remote/caching), and it's compatible with [every popular programming language](https://docs-legacy.aspect.build/). **Think of it as the Makefile for the 21st century.**

By default, these two tools are *very much incompatible* (mainly because of sandboxing). I'm working on putting these two tools together in the most seamless way possible. If we can have language-agnostic database interfaces, why not use it in our language-agnostic build systems?

## Current state of the project

**It's working! (kinda)**

* The project currently supports Javascript and Typescript
* Go will very soon be supported (Sep 2023)
* Python and Rust are on the roadmap (Nov/Dec 2023)
* I currently model each "rule" as a bazel macro, but I believe this would be an appropriate time to start writing a proper bazel rule implementation (which *may* cut down on build time and overhead)
* I only support Bzlmod right now, not sure if I'll ever support `WORKSPACE` files (because they're "legacy")
* This is still in pre-release, things will probably break

## Setup

### Prerequisites
* Follow [this tutorial](https://www.prisma.io/docs/getting-started/setup-prisma/start-from-scratch/relational-databases-typescript-postgresql) to set up a regular Prisma project
* Install [bazelisk](https://github.com/bazelbuild/bazelisk)
* Add `common --enable_bzlmod` to a `.bazelrc` file in your root directory
* Install the appropriate bazel module for your language: [rules_ts](https://github.com/aspect-build/rules_ts) (typescript), [rules_js](https://github.com/aspect-build/rules_js) (javascript)

### Installation

Add this to the `MODULE.bazel` file in the root of your project:

```py
bazel_dep(name = "rules_prisma", version = "0.1.0")
```

### Usage

Add a new generator block to your `schema.prisma` file:

```prisma
generator client { // <-- set the name to whatever you want
  provider = "prisma-client-js"
  output   = "gen/client" // <-- set 'output' to whatever you want
}
```

And in that package's `BUILD.bazel` file, add the following:

```py
# BUILD.bazel
load("@rules_prisma//prisma:js.bzl", "prisma_generate_js")

prisma_generate_js(
    name = "my_js_prisma_client",
    schema = "schema.prisma",
    generator_name = "client", # should match schema.prisma
    generator_output = "gen/client", # should match schema.prisma
    visibility = ["//visibility:public"],
)
```

Now you should be able to use the bazel target `:my_js_prisma_client` just like any other `js_library` rule. E.g.:

```py
load("@aspect_rules_js//js:defs.bzl", "js_binary")

js_binary(
  name = "main",
  entry_point = "main.js",
  data = [
      ":my_js_prisma_client",
  ],
)
```

When you import it from a file, use `require('./relative/path/to/gen/client')`. E.g.:

```js
// main.js
const { PrismaClient } = require('./gen/client')
const prisma = new PrismaClient()

async function main() {
  const newUser = await prisma.user.create({
    data: {
      name: 'Alice',
      email: 'alice@prisma.io',
    },
  })

  const users = await prisma.user.findMany()
}

main()
```

