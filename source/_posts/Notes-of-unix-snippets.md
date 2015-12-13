title: Notes of unix snippets
date: 2015-12-12 14:58:19
tags:
- unix
- bash
- bash programming
---

##### Read from in a streaming way

```
while read line; do ${CMD}; done
```

##### Tokenize a csv

```
for i in $(cat $1); do
    IFS=',' read -a array <<< "$i";
    echo ${array[0]} ${array[1]} ${array[2]};
done
```

##### Redirection

###### Bidirectional

```
exec 4<>(command)
command <&4 >&4
```

###### Named Pipe

```
cd /tmp
mkfifo fifo
exec < fifo
```

