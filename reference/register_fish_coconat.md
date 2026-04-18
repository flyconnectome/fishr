# Register fish2 dataset for coconatfly

Register fish2 dataset adapters for use with
[coconatfly](https://natverse.org/coconatfly).

## Usage

``` r
register_fish_coconat(showerror = TRUE)
```

## Arguments

- showerror:

  Logical; when `FALSE`, return invisibly if dependencies are missing.

## Value

Invisible `NULL`.

## See also

Other data-queries:
[`fish_connection_table()`](https://flyconnectome.github.io/fishr/reference/fish_connection_table.md),
[`fish_ids()`](https://flyconnectome.github.io/fishr/reference/fish_ids.md),
[`fish_neuprint_meta()`](https://flyconnectome.github.io/fishr/reference/fish_neuprint_meta.md)

## Examples

``` r
if (FALSE) { # \dontrun{
register_fish_coconat()
coconatfly::cf_meta(coconatfly::cf_ids(fish2 = "RGC"))
} # }
```
