load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_file")

def _download_prisma_engines(ctx):
    http_file(
        name = "prisma_query_engine_darwin",
        sha256 = "eef5111d40bb7a9f31d80e96d4fe05622b85f9ee4111d3f8a237a4233f3dff99",
        url = "https://binaries.prisma.sh/all_commits/d9a4c5988f480fa576d43970d5a23641aa77bc9c/darwin-arm64/query-engine.gz",
    )
    http_file(
        name = "prisma_migration_engine_darwin",
        sha256 = "889c54c1eb75ca9b28b998ca4f9854c76632cff5e260a19e8b3190aa1aaf5658",
        url = "https://binaries.prisma.sh/all_commits/d9a4c5988f480fa576d43970d5a23641aa77bc9c/darwin-arm64/migration-engine.gz",
    )


download_prisma_engines = module_extension(
    implementation = _download_prisma_engines,
)
