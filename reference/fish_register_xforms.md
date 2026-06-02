# Register fish2 bridging / mirroring transforms

`fish_register_xforms` adds the package's mirroring registration (see
[`fish2_mirror_reg`](https://flyconnectome.github.io/fishr/reference/mirror_fish.md))
to the `nat.templatebrains` registry so that
[`xform_brain`](https://natverse.org/nat.templatebrains/reference/xform_brain.html)
can move points between `"fish2"` and `"fish2_mirror"`. It is called
automatically when the package is loaded.

## Usage

``` r
fish_register_xforms()
```

## Value

Invisibly returns `TRUE` when the registration is added, `FALSE`
otherwise (e.g. if `nat.templatebrains` is unavailable).

## Examples

``` r
if (FALSE) { # \dontrun{
fish_register_xforms()
} # }
```
