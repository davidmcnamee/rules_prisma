load("@bazel_skylib//lib:paths.bzl", "paths")
load("@aspect_rules_js//js:defs.bzl", "js_library")
load("//prisma:base.bzl", "prisma_generate_base")

def prisma_generate_js(
    name,
    schema,
    generator_name,
    generator_output,
    env = {},
    visibility = None,
):
    prisma_generate_base(
        name = name,
        schema = schema,
        generator_name = generator_name,
        generator_srcs = [],
        outs = [
            paths.join(generator_output, "schema.prisma"),
            paths.join(generator_output, "runtime/binary.js"),
            paths.join(generator_output, "runtime/binary.d.ts"),
            paths.join(generator_output, "runtime/index-browser.js"),
            paths.join(generator_output, "runtime/index-browser.d.ts"),
            paths.join(generator_output, "index.js"),
            paths.join(generator_output, "index-browser.js"),
            paths.join(generator_output, "package.json"),
            paths.join(generator_output, "index.d.ts"),
        ],
        env = env,
        visibility = visibility,
    )
    js_library(
        name = name,
        srcs = [
            paths.join(generator_output, "runtime/binary.js"),
            paths.join(generator_output, "runtime/index-browser.js"),
            paths.join(generator_output, "index.js"),
            paths.join(generator_output, "index-browser.js"),
        ],
        data = [
            paths.join(generator_output, "schema.prisma"),
            paths.join(generator_output, "runtime/binary.d.ts"),
            paths.join(generator_output, "runtime/index-browser.d.ts"),
            paths.join(generator_output, "package.json"),
            paths.join(generator_output, "index.d.ts"),
        ],
    )
