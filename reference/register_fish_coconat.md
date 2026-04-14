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

## Examples

``` r
if (FALSE) { # \dontrun{
register_fish_coconat()
coconatfly::cf_meta(coconatfly::cf_ids(fish2 = "RGC"))
} # }
```
