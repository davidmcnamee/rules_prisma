load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_file")
load("@bazel_skylib//lib:selects.bzl", "selects")

OS_CPU_MAPPING = {
    ("macos", "x86_64"): "darwin",
    ("macos", "arm64"): "darwin-arm64",
    ("windows", "x86_64"): "windows",
    ("windows", "arm64"): "windows", # not sure if this one actually works?
    ("linux", "x86_64"): "debian-openssl-3.0.x",  # only works on debian/ubuntu}
    ("linux", "arm64"): "linux-arm64-openssl-3.0.x", # doesn't work on alpine}
}

# only ever called from prisma/BUILD.bazel
def create_config_chains():
    for (os, cpu) in OS_CPU_MAPPING:
        selects.config_setting_group(
            name = "{}_and_{}".format(os, cpu),
            match_all = ["@platforms//os:"+os, "@platforms//cpu:"+cpu],
        )

select_query_engine = select({
    "//prisma:{}_and_{}".format(os, cpu): "@prisma_query_engine_{}//file".format(engine)
    for (os, cpu), engine in OS_CPU_MAPPING.items()
})

def _download_prisma_engines(ctx):
    http_file(
        name = "prisma_query_engine_darwin",
        url = "https://binaries.prisma.sh/all_commits/d9a4c5988f480fa576d43970d5a23641aa77bc9c/darwin/query-engine.gz"
    )
    http_file(
        name = "prisma_query_engine_darwin-arm64",
        url = "https://binaries.prisma.sh/all_commits/d9a4c5988f480fa576d43970d5a23641aa77bc9c/darwin-arm64/query-engine.gz"
    )
    http_file(
        name = "prisma_query_engine_windows",
        url = "https://binaries.prisma.sh/all_commits/d9a4c5988f480fa576d43970d5a23641aa77bc9c/windows/query-engine.gz"
    )
    http_file(
        name = "prisma_query_engine_debian-openssl-3.0.x",
        url = "https://binaries.prisma.sh/all_commits/d9a4c5988f480fa576d43970d5a23641aa77bc9c/debian-openssl-3.0.x/query-engine.gz"
    )
    http_file(
        name = "prisma_query_engine_linux-arm64-openssl-3.0.x",
        url = "https://binaries.prisma.sh/all_commits/d9a4c5988f480fa576d43970d5a23641aa77bc9c/linux-arm64-openssl-3.0.x/query-engine.gz"
    )
    # migration engine
    http_file(
        name = "prisma_migration_engine_darwin",
        url = "https://binaries.prisma.sh/all_commits/d9a4c5988f480fa576d43970d5a23641aa77bc9c/darwin/migration-engine.gz"
    )
    http_file(
        name = "prisma_migration_engine_darwin-arm64",
        url = "https://binaries.prisma.sh/all_commits/d9a4c5988f480fa576d43970d5a23641aa77bc9c/darwin-arm64/migration-engine.gz"
    )
    http_file(
        name = "prisma_migration_engine_windows",
        url = "https://binaries.prisma.sh/all_commits/d9a4c5988f480fa576d43970d5a23641aa77bc9c/windows/migration-engine.gz"
    )
    http_file(
        name = "prisma_migration_engine_debian-openssl-3_0_x",
        url = "https://binaries.prisma.sh/all_commits/d9a4c5988f480fa576d43970d5a23641aa77bc9c/debian-openssl-3_0_x/migration-engine.gz"
    )
    http_file(
        name = "prisma_migration_engine_linux-arm64-openssl-3_0_x",
        url = "https://binaries.prisma.sh/all_commits/d9a4c5988f480fa576d43970d5a23641aa77bc9c/linux-arm64-openssl-3_0_x/migration-engine.gz"
    )


download_prisma_engines = module_extension(
    implementation = _download_prisma_engines,
)
