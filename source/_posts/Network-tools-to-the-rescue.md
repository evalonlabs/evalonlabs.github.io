title: Network tools to the rescue
date: 2015-12-13 22:55:41
tags:
- unix
- network
---

##### Benchmark with apache benchmark tool

```
ab -n 99999 -c 1000 http://127.0.0.1:9687/
```

##### Port channels & scan

```
cat > /dev/tcp/localhost/1234
cat < /dev/tcp/localhost/1234 | grep 1234
nc -vzt host port
```

##### Trace a process

```
sudo strace -t -p 13262 -f -e trace=network -s 10000

strace -t -e trace=open,close,read,write df
sudo ltrace -t -p 13262

sudo strace -t $(pidof "nginx" | sed 's/\([0-9]*\)/-p \1/g') -f -e trace=network,open,close,read,write -s 10000

function straceall {
  strace $(pidof "${1}" | sed 's/\([0-9]*\)/-p \1/g')
}
```

##### Trace a network log

```
ngrep -qt 'REGEX ' 'port 80'
```
