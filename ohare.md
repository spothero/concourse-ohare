# ohare

This documents the datafile ohare.yaml and how the pipeline-generator script consumes it.

## ohare.yaml

Field Name        | Type             | Description
------------------|:----------------:|--------------------------------------------------
ohare             | ohare object    | Contains a ohare specification. Top level, allows future embedding.

### ohare object

All values are optional. All paths are relative to the current working directory, which is wherever the ohare.yaml
is.

Field Name      | Type             | Description
----------------|:----------------:|--------------------------------------------------
templater       | `string`         | One of `static`, `ytt`, or `aviator` (deprecated). Determines how to build your pipeline.
static.path     | `string`         | Active if templater = `static`, expects relative path from the ohare.yaml file, runs `cat "${path}/*.yaml" > pipeline.yml`
ytt.args        | `string`         | Active if templater = `ytt`, runs `ytt ${ytt_args} > pipeline.yml`
before_hooks    | `[]string`       | Array of strings to be executed before running the templater.
after_hooks     | `[]string`       | Array of strings to be executed after running the templater.
pipes           | []pipe object    | Specifies a list of Pipes to be generated, and merged together with your existing pipeline.

Hooks are really dumb. They are executed inline of the pipeline-generator script, in the current working directory, inside the dockerfile
described [here](https://github.com/spothero/mdw/blob/master/task-pipeline-generator/Dockerfile) and [here](https://github.com/spothero/mdw/blob/master/baseline/Dockerfile).

They are an escape hatch. IE, if you set:

```
ohare:
  before_hooks:
    - curl -fsSL https://your.janky.gist/script.sh | bash
```

We will run exactly that line before generation. This lets you do pretty much anything.

We use it in the [ord repository](https://github.com/spothero/ord/blob/master/ohare.yaml) to generate the current directories
we need to run pipeline-generator on, via [this dumb script.](https://github.com/spothero/ord/blob/master/factory/generate_pipes)

### pipe object

A "pipe" is a reusable chunk of a concourse pipeline. We currently have them for things like chart deployments, PR checks, docker builds.
We do this by taking the `vars` tree of data, annotating it as #@data/values per `ytt`'s documentation, and then passing it to a `ytt` run
on the directory specified in `path`.

You can see `ytt` using data values [here.](https://get-ytt.io/#example:example-load-data-values)

Field Name      | Type             | Description
----------------|:----------------:|--------------------------------------------------
path            | `string`         | relative path to a directory capable of being generated with ytt
vars            | `hash`           | key-values set in vars are passed untouched as data/values to the ytt templated directory
