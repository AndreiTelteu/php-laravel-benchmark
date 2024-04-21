
TODO: Rerun all tests on a real server

## Requirements

- Docker with docker compose
- Plow benchmark tool
  - method 1: install golang and then `go install github.com/six-ddc/plow@latest`
  - method 2: download binary from https://github.com/six-ddc/plow/releases

## Usage

To build and prepare all containers:
```bash
./dc prepare
```

### Nginx | PHP-FPM 8.3 | Opcache precompiled and JIT

```bash
./dc start nginx-fpm
./dc exec nginx-fpm composer install --no-dev -o
./dc exec nginx-fpm php artisan optimize
./dc exec nginx-fpm php artisan opcache:compile --force
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
./dc start nginx-unit
./dc exec nginx-unit composer install --no-dev -o
./dc exec nginx-unit php artisan optimize
./dc exec nginx-unit php artisan opcache:compile --force
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

**Tips!** In `nginx-unit/config.json`, the `applications.php.processes` can be numeric for a static worker number, or `{ "max": 100, "spare": 20, "idle_timeout": 60 }` for dynamic. Static is way better in my testing

---

Let's get to the exciting part: Laravel Optane !

### PHP 8.3 | Opcache precompiled and JIT | Laravel Optane with RoadRunner

```bash
./dc start roadrunner
./dc exec roadrunner php artisan opcache:compile --force
# benchmark time !!!
plow -c 500 -d 2m http://localhost:3083/api/products
```

Results:
```
Summary:
  Elapsed       2m0s
  Count       447494
    2xx       447494
  RPS       3729.106
  Reads    1.117MB/s
  Writes   0.249MB/s

Statistics    Min       Mean      StdDev      Max   
  Latency   11.713ms  133.995ms  54.605ms  1.767253s
  RPS        797.33    3729.71    964.94    5759.73 

Latency Percentile:
  P50           P75        P90        P95        P99      P99.9     P99.99  
  126.566ms  153.267ms  186.211ms  212.221ms  293.345ms  755.01ms  1.289689s

Latency Histogram:
  118.68ms   319106  71.31%
  165.945ms  118667  26.52%
  216.95ms     8390   1.87%
  367.861ms    1167   0.26%
  860.727ms     144   0.03%
  1.189624s      13   0.00%
  1.29938s        6   0.00%
  1.396608s       1   0.00%
```

### PHP 8.3 | Opcache precompiled and JIT | Laravel Optane with Swoole

```bash
./dc start swoole
./dc exec swoole php artisan opcache:compile --force
# benchmark time !!!
plow -c 500 -d 2m http://localhost:3084/api/products
```

Results:
```
Summary:
  Elapsed       2m0s
  Count       692514
    2xx       692514
  RPS       5770.934
  Reads    1.915MB/s
  Writes   0.386MB/s

Statistics    Min      Mean     StdDev      Max   
  Latency   1.348ms  86.566ms  92.347ms  1.797093s
  RPS       4052.05  5770.92    487.93    6937.56 

Latency Percentile:
  P50          P75        P90        P95        P99       P99.9     P99.99  
  52.705ms  131.057ms  209.694ms  261.631ms  383.652ms  741.687ms  1.262264s

Latency Histogram:
  73.458ms   624024  90.11%
  180.268ms   55231   7.98%
  275.549ms   10678   1.54%
  397.353ms    2045   0.30%
  683.897ms     468   0.07%
  968.23ms       41   0.01%
  1.255145s      15   0.00%
  1.567803s      12   0.00%
```

### PHP 8.3 | Opcache precompiled and JIT | Laravel Optane with OpenSwoole

```bash
./dc start openswoole
./dc exec openswoole php artisan opcache:compile --force
# benchmark time !!!
plow -c 500 -d 2m http://localhost:3085/api/products
```

Results:
```
Summary:
  Elapsed       2m0s
  Count       699522
    2xx       699522
  RPS       5829.338
  Reads    1.779MB/s
  Writes   0.389MB/s

Statistics    Min      Mean     StdDev      Max   
  Latency   1.369ms  85.601ms  89.939ms  1.614704s
  RPS       4209.08  5832.81    466.26    6944.04 

Latency Percentile:
  P50          P75        P90        P95        P99      P99.9     P99.99  
  52.634ms  131.021ms  206.616ms  255.554ms  370.139ms  674.81ms  1.145932s

Latency Histogram:
  74.731ms   651113  93.08%
  213.376ms   43250   6.18%
  353.318ms    4577   0.65%
  576.972ms     491   0.07%
  881.024ms      59   0.01%
  1.203931s      23   0.00%
  1.328023s       4   0.00%
  1.503421s       5   0.00%
```

### PHP 8.3 | Opcache precompiled and JIT | Laravel Optane with FrankenPHP

```bash
./dc start franken
./dc exec franken php artisan opcache:compile --force
# benchmark time !!!
plow -c 500 -d 2m http://localhost:3086/api/products
```

Results:
```
Summary:
  Elapsed       2m0s
  Count       875126
    2xx       875126
  RPS       7292.712
  Reads    2.337MB/s
  Writes   0.487MB/s

Statistics    Min      Mean     StdDev      Max   
  Latency   8.628ms  68.537ms  16.314ms  483.863ms
  RPS       4742.75  7291.82    617.4     8442.85 

Latency Percentile:
  P50        P75       P90       P95        P99       P99.9     P99.99  
  66.26ms  75.132ms  85.666ms  93.949ms  115.869ms  158.916ms  434.998ms

Latency Histogram:
  45.094ms    40726   4.65%
  68.026ms   765772  87.50%
  82.84ms     53118   6.07%
  102.738ms   13324   1.52%
  123.36ms     1676   0.19%
  142.932ms     463   0.05%
  160.225ms      45   0.01%
  179.663ms       2   0.00%
```

---

Just for fun let's compare with NestJS

### NestJS v10 on BunJS v1.0.30

```
./dc start nest
# benchmark time !!!
plow -c 500 -d 2m http://localhost:3080/products
```

Results:
```
Summary:
  Elapsed       2m0s
  Count      1864757
    2xx      1864757
  RPS      15539.615
  Reads    3.631MB/s
  Writes   0.978MB/s

Statistics    Min       Mean    StdDev     Max   
  Latency   1.166ms   32.144ms  4.956ms  217.34ms
  RPS       13567.31  15539.41  657.71   16684.97

Latency Percentile:
  P50        P75       P90       P95       P99      P99.9     P99.99  
  32.03ms  34.419ms  36.822ms  38.669ms  45.823ms  68.985ms  126.434ms

Latency Histogram:
  15.759ms     3176   0.17%
  31.4ms    1546566  82.94%
  35.186ms   278951  14.96%
  38.877ms    28469   1.53%
  50.337ms     6179   0.33%
  67.137ms     1276   0.07%
  73.381ms      128   0.01%
  78.494ms       12   0.00%
```

---

What about GO ?

### Goravel with Fiber webserver

```
./dc start goravel
# benchmark time !!!
plow -c 500 -d 2m http://localhost:3090/products
```

Results:
```
Summary:
  Elapsed        2m0s
  Count       7657565
    2xx       7657565
  RPS       63812.983
  Reads    16.796MB/s
  Writes    4.017MB/s

Statistics    Min       Mean    StdDev      Max   
  Latency    134µs    7.827ms   4.501ms  310.761ms
  RPS       45360.35  63788.38  4521.64   70813.2 

Latency Percentile:
  P50        P75      P90       P95       P99      P99.9     P99.99 
  7.126ms  9.936ms  13.178ms  15.619ms  21.455ms  31.122ms  47.799ms

Latency Histogram:
  7.192ms   6758955  88.27%
  11.029ms   646688   8.45%
  15.759ms   215278   2.81%
  20.456ms    28501   0.37%
  25.985ms     6683   0.09%
  33.715ms     1413   0.02%
  38.922ms       46   0.00%
  44.468ms        1   0.00%
```
