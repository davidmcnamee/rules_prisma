load("@aspect_rules_js//js:defs.bzl", "js_run_binary")
load("@aspect_bazel_lib//lib:copy_file.bzl", "copy_file")
load("//prisma:engines.bzl", "select_query_engine")

def prisma_generate_base(
    name,
    schema,
    generator_name,
    generator_srcs,
    outs,
    env,
    visibility,
):
    env = {k:v for k,v in env.items()}

    query_engine = "%s_query_engine" % name
    env["PRISMA_QUERY_ENGINE_BINARY"] = "../../../$(location :%s)" % query_engine
    env["PRISMA_CLI_QUERY_ENGINE_TYPE"] = "binary"
    env["PRISMA_CLIENT_ENGINE_TYPE"] = "binary"
    # env["DEBUG"] = "*"
    copy_file(
        name = query_engine,
        src = select_query_engine,
        out = "%s_bin" % query_engine,
    )

    js_run_binary(
        name = "%s_generator" % name,
        tool = "@rules_prisma//prisma:prisma_binary",
        srcs = [
            schema,
            ":" + query_engine,
        ] + generator_srcs,
        env = env,
        args = [
            "generate",
            "--generator",
            generator_name,
            "--schema",
            "$(location %s)" % schema,
        ],
        outs = outs,
        visibility = visibility,
    )
