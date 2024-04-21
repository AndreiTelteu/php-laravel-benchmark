
All tests are run on a MiniPC with AMD Ryzen 5 PRO 2400GE, virtualized with Proxmox and kvm, the VM has 8 cores, 10GB RAM, and 512GB NVMe SSD with Ubuntu 22.04.4

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
./dc stop nginx-fpm
```

Results:
```
Summary:
  Elapsed       2m0s
  Count       138415
    2xx       138415
  RPS       1153.445
  Reads    0.629MB/s
  Writes   0.077MB/s

Statistics    Min       Mean      StdDev       Max
  Latency   80.234ms  432.616ms  124.708ms  1.799811s
  RPS       1033.48    1153.59     30.78     1279.48

Latency Percentile:
  P50           P75        P90        P95        P99       P99.9     P99.99
  406.559ms  458.449ms  540.773ms  627.808ms  976.794ms  1.479556s  1.58037s

Latency Histogram:
  132.155ms     95   0.07%
  351.756ms  43370  31.33%
  401.569ms  37572  27.14%
  475.412ms  42252  30.53%
  593.485ms  12166   8.79%
  738.385ms   2735   1.98%
  877.426ms    223   0.16%
  1.014977s      2   0.00%
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
./dc stop nginx-unit
```

Results:
```
Summary:
  Elapsed       2m0s
  Count       145677
    2xx       145677
  RPS       1213.960
  Reads    0.417MB/s
  Writes   0.081MB/s

Statistics    Min       Mean      StdDev      Max
  Latency   26.856ms  411.015ms  52.805ms  1.082429s
  RPS       1150.65    1213.92    32.62     1324.18

Latency Percentile:
  P50           P75        P90       P95        P99       P99.9     P99.99
  410.436ms  439.617ms  480.745ms  506.31ms  554.098ms  637.201ms  865.642ms

Latency Histogram:
  58.296ms       11   0.01%
  135.25ms      154   0.11%
  229.264ms     209   0.14%
  410.185ms  142270  97.66%
  475.933ms    2916   2.00%
  513.953ms      93   0.06%
  549.784ms      20   0.01%
  602.163ms       4   0.00%
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
./dc stop roadrunner
```

Results:
```
```

### PHP 8.3 | Opcache precompiled and JIT | Laravel Optane with Swoole

```bash
./dc start swoole
./dc exec swoole php artisan optimize
./dc exec swoole php artisan opcache:compile --force
# benchmark time !!!
plow -c 500 -d 2m http://localhost:3084/api/products
./dc stop swoole
```

Results:
```
```

### PHP 8.3 | Opcache precompiled and JIT | Laravel Optane with OpenSwoole

```bash
./dc start openswoole
./dc exec openswoole php artisan opcache:compile --force
# benchmark time !!!
plow -c 500 -d 2m http://localhost:3085/api/products
./dc stop openswoole
```

Results:
```
```

### PHP 8.3 | Opcache precompiled and JIT | Laravel Optane with FrankenPHP

```bash
./dc start franken
./dc exec franken php artisan opcache:compile --force
# benchmark time !!!
plow -c 500 -d 2m http://localhost:3086/api/products
./dc stop franken
```

Results:
```
```

---

Just for fun let's compare with NestJS

### NestJS v10 on BunJS v1.0.30

```bash
./dc start nest
# benchmark time !!!
plow -c 500 -d 2m http://localhost:3080/products
./dc stop nest
```

Results:
```
```

---

What about GO ?

### Goravel with Fiber webserver

```bash
./dc start goravel
# benchmark time !!!
plow -c 500 -d 2m http://localhost:3090/products
./dc stop goravel
```

Results:
```
```
