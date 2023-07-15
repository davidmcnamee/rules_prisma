.PHONY: test
test:
	bazel clean --expunge && bazel build //test:js_generator
	cd e2e && bazel clean --expunge && bazel build //:gen
