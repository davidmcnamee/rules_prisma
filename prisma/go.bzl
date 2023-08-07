load("@bazel_skylib//lib:paths.bzl", "paths")
load("//prisma:base.bzl", "prisma_generate_base")
load("@io_bazel_rules_go//go:def.bzl", "go_library")

def prisma_generate_go(
    name,
    schema,
    generator_name,
    generator_output,
    importpath,
    env = {},
    visibility = None,
):
    env = {k: v for k, v in env.items()}
    env["PRISMA_CLIENT_GO"] = "../../../$(location @com_github_steebchen_prisma_client_go//:prisma-client-go)"
    if "HOME" not in env:
        env["HOME"] = "dummyhomedir"
    
    prisma_generate_base(
        name = name,
        schema = schema,
        generator_name = generator_name,
        generator_srcs = ["@com_github_steebchen_prisma_client_go//:prisma-client-go"],
        outs = [
            paths.join(generator_output, "query-engine-darwin-arm64_gen.go"),
            paths.join(generator_output, "db_gen.go"),
            # paths.join(generator_output, "query-engine-linux_gen.go"),
        ],
        env = env,
        visibility = visibility,
    )
    go_library(
        name = name,
        srcs = [
            paths.join(generator_output, "query-engine-darwin-arm64_gen.go"),
            paths.join(generator_output, "db_gen.go"),
            # paths.join(generator_output, "query-engine-linux_gen.go"),
        ],
        importpath = importpath,
        deps = [
            "@com_github_steebchen_prisma_client_go//binaries/unpack",
            "@com_github_steebchen_prisma_client_go//engine",
            "@com_github_steebchen_prisma_client_go//engine/mock",
            "@com_github_steebchen_prisma_client_go//runtime/builder",
            "@com_github_steebchen_prisma_client_go//runtime/lifecycle",
            "@com_github_steebchen_prisma_client_go//runtime/raw",
            "@com_github_steebchen_prisma_client_go//runtime/transaction",
            "@com_github_steebchen_prisma_client_go//runtime/types",
            "@com_github_steebchen_prisma_client_go//runtime/types/raw",
            "@com_github_iancoleman_strcase//:go_default_library",
            "@com_github_takuoki_gocase//:go_default_library",
            "@org_golang_x_text//cases",
            "@com_github_joho_godotenv//:go_default_library",
            "@com_github_shopspring_decimal//:go_default_library",
        ],
    )
