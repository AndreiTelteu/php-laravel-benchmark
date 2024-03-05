
TODO: Rerun all tests on a real server


### Nginx | PHP-FPM 8.3 | Opcache precompiled and JIT

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

---

### Nginx UNIT | Opcache precompiled and JIT

```bash
./dc up -d nginx-unit-optimized
./dc exec nginx-unit-optimized composer install --no-dev -o
./dc exec nginx-unit-optimized php artisan optimize
./dc exec nginx-unit-optimized php artisan opcache:compile --force
# benchmark time !!!
plow -c 500 -d 2m http://localhost:3082/api/products
```

Results:
```
Summary:
  Elapsed       2m0s
  Count       382787
    2xx       382787
  RPS       3189.653
  Reads    1.095MB/s
  Writes   0.213MB/s

Statistics    Min      Mean      StdDev      Max   
  Latency   4.59ms   156.474ms  61.523ms  1.177472s
  RPS       2504.18   3189.44    252.55    3638.06 

Latency Percentile:
  P50           P75        P90       P95        P99       P99.9     P99.99  
  136.813ms  164.966ms  222.942ms  278.91ms  420.169ms  590.974ms  781.963ms

Latency Histogram:
  40.074ms      176   0.05%
  149.981ms  359442  93.90%
  232.192ms   18938   4.95%
  340.74ms     3211   0.84%
  449.64ms      803   0.21%
  563.338ms     179   0.05%
  689.246ms      34   0.01%
  812.699ms       4   0.00%
```

Sometimes it gets better results. Not concludent enough.

**Tips!** In `nginx-unit-optimized/config.json`, the `applications.php.processes` can be numeric for a static worker number, or `{ "max": 100, "spare": 20, "idle_timeout": 60 }` for dynamic. Static is way better in my testing

---

Let's get to the exciting part: Laravel Optane !

### PHP 8.3 | Opcache precompiled and JIT | Laravel Optane with Swoole

### PHP 8.3 | Opcache precompiled and JIT | Laravel Optane with OpenSwoole

### PHP 8.3 | Opcache precompiled and JIT | Laravel Optane with RoadRunner

### PHP 8.3 | Opcache precompiled and JIT | Laravel Optane with FrankenPHP
