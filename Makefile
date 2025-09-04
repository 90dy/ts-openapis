.PHONY: generate publish publish-all
generate: $(foreach dir,$(shell ls -d ./apis/*),$(dir)/mod.ts $(dir)/deno.json) 

# Generate deno.json for each API directory
apis/%/deno.json: apis/%/schema.json
	mkdir -p $(dir $@)
	deno run -A generate.ts

# Generate OpenAPI client for each API directory
apis/%/client: apis/%/schema.json
	mkdir -p $(dir $@)
	deno run -A npm:@hey-api/openapi-ts --client @hey-api/client-fetch --input $< --output $@

apis/%/mod.ts: apis/%/client
	echo "export * from './client/index.ts'" > $@

# Publish a specific API to JSR
publish-%: apis/%/deno.json apis/%/mod.ts
	@echo "Publishing @openapis/$* to JSR"
	cd apis/$* && deno publish --allow-dirty --unstable-sloppy-imports --allow-slow-types

# Publish all APIs to JSR
publish-all:
	deno publish --allow-dirty --unstable-sloppy-imports --allow-slow-types
# 	@for dir in $$(ls -d ./apis/*/); do \
# 		api=$$(basename $$dir); \
# 		$(MAKE) publish-$$api; \
# 	done
