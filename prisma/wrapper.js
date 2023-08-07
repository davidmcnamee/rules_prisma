const { execSync } = require("child_process")
const { readdirSync } = require("fs")
const path = require("path")

try {

    // find query engine from @prisma/engines dir
    const enginesDir = path.join(require.resolve("@prisma/engines"), "../..")
    const queryEngineLib = readdirSync(enginesDir).find(file => file.startsWith("libquery_engine"))
    if(queryEngineLib === undefined) {
        throw new Error("Could not find a query engine in directory " + enginesDir)
    }

    execSync(`node ${require.resolve("prisma")} ${process.argv.slice(2).join(" ")}`, {
        env: {
            ...process.env,
            PRISMA_QUERY_ENGINE_LIBRARY: path.join(enginesDir, queryEngineLib),
        },
        stdio: "inherit",
    })

} catch (e) {
    console.error(e)
    process.exit(1)
}
