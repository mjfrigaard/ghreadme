# Stack Overflow Reputation Badge

Stack Overflow Reputation Badge

## Usage

``` r
so_rep(username, user_id)
```

## Arguments

- username:

  SO username

- user_id:

  SO userID

## Value

HTML for badge

## Examples

``` r
so_rep(username = "martin-frigaard", user_id = "4926446")
#> <a href='https://stackoverflow.com/users/4926446/martin-frigaard' target='_blank'>
#> <img alt='StackOverflow'
#> src='https://stackoverflow-badge.vercel.app/?userID=4926446' />
#> </a>
```
