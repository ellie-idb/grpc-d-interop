# grpc-d-interop
## Info
This package serves to enable better interop between gRPC Core and D. Thus,
the bindings are automatically generated from versions of gRPC (using dpp).

## Re-generating built bindings
```
dub run dpp -- --preprocess-only --source-output-path . --ignore-macros headers.dpp
mv headers.d source/interop/headers.d
```

The built bindings will require some minor modification in order to work, however (e.g. add module decl, fix import, etc)