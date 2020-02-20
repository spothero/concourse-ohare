# Concourse O'Hare

This is a reusable concourse task that keys off a "ohare.yaml" file to generate or compose
a pipeline.yaml file such that it can be uploaded to concourse. Powered by a bash script.

This enables dynamic pipelines via ytt templating. It also enables composing a separate
series of [ytt](https://get-ytt.io) templated pipelines together, with or without local pipelines.

For more information, see the [ohare.yaml](ohare.md) spec.

We use this at Spothero to use a monorepo to populate all our pipelines.

### `params`

  * `$SOURCE_DIRECTORY` (default `src`): location of all code, including pipes.
  * `$CONTEXT` (default <unset>): location of ohare.yaml file inside of the source directory

### `inputs`

Input your source directory. You can either input it as a path or set the SOURCE_DIRECTORY param.

```
  inputs:
  - name: my-source-repository
    path: src
```
or
```
  params:
    SOURCE_DIRECTORY: my-source-repository

  inputs:
  - name: my-source-repository
```

This will have an output in the `output` directory, where it will placed the generated `pipeline.yml` file.
