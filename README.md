
### Nginx | PHP-FPM | Opcache precompiled and JIT

```bash
./dc up -d nginx-fpm-optimized
./dc exec nginx-fpm-optimized composer install --no-dev -o
./dc exec nginx-fpm-optimized php artisan optimize
./dc exec nginx-fpm-optimized php artisan opcache:compile --force
# benchmark time !!!
plow -c 500 -d 2m http://localhost:3081/api/products
```

Results:
```
Summary:
  Elapsed       2m0s
  Count       375916
    2xx       375916
  RPS       3132.627
  Reads    1.709MB/s
  Writes   0.209MB/s

Statistics    Min       Mean     StdDev      Max   
  Latency   13.775ms  159.242ms  91.02ms  1.097678s
  RPS       1813.19    3129.26   331.02    3764.18 

Latency Percentile:
  P50           P75        P90        P95        P99       P99.9     P99.99  
  132.739ms  159.276ms  230.056ms  327.824ms  613.796ms  813.502ms  996.113ms

Latency Histogram:
  135.545ms  311520  82.87%
  195.954ms   44055  11.72%
  338.78ms    11780   3.13%
  515.423ms    5175   1.38%
  656.805ms    2290   0.61%
  751.524ms     973   0.26%
  837.149ms      67   0.02%
  969.69ms       56   0.01%
```

## New laravel project

```
./dc up
./dc php "composer create-project laravel/laravel=10.* laravel"
sh -c "rm -rf laravel/README.md ; mv laravel/* . ; mv laravel/.e* . ; mv laravel/.g* . ; rm -rf rm -rf laravel;"
./dc a migrate
```
