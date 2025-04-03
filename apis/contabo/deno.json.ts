import schema from "./schema.json" with { type: "json" };

const json = String.raw

export default json`
{
	"name": "@openapis/contabo",
	"version": "${schema.info.version}",
	"exports": "./mod.ts",
	"license": "MIT"
}
`