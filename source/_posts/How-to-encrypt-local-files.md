title: How to encrypt local files
date: 2015-12-07 21:42:37
categories:
- security
- openssl
- encryption
tags:
- encryption
- openssl
- security
- local files
---

Securing local files, it's a problem solved by a variaty of aps. Though each app are falling 
into the falacy of providing their own way to encrypt and package the outputed file.
Now imagine the app developer deciding to discontinue the development and support of the app,
or even worse a known vulnerability of the app goes public (or worse, it never goes public).
Then you data are as unprotective as they were in their raw form. Why shouldn't be an eay way
to make use of a trusted way? I guess the first solution that pops to our mind is `openssl`,
right? So why not using just `openssl` to do the heavy ligting?

**TL;DR;** [evancrypt.sh](https://gist.github.com/epappas/2c929665bb994251e771)

### Using the force of `openssl`

#### Encrypting

So all you need is;

```
openssl aes-256-cbc -salt -in raw.file -out encrypted.aes
```

Done, you can now delete your `raw.file` and store your `encrypted.aes` file into an untrusted store!

Wait, a file? what about a whole directory? Well a file is all we can do, if only we could point
to a directory like it was a file?

`tar` ladies and getlemen, to the rescue! We can `tar -cf` our directory and pass the the .tar file to
be encrypted.

Yes you can pipe! So;

```
tar -cf - raw.file.or.directory | openssl aes-256-cbc -salt -out encrypted.aes
```

Done! With the command above you can securly generate an encrypted file, and being agnostic whether you are
tranforming a file or a dir, as all `openssl` get is a stream generated from the `tar` command.

#### Decrypting

Well an encrypted file, with no way of return has no better value than a deleted file, unless you are trying
to generate some randomnes, in that case all you need is;

```
cat /dev/urandom | head -c 10
```

and you'll have your first 10 random bytes.

If on the other hand though, you intend to reuse your files, you are required to decrypt the file, by using
the same Cipher and salt.

```
openssl aes-256-cbc -d -salt -in encrypted.aes -out raw.file
```

But again, a tar file, has no better value as well, so why not piping the outcome to `tar` in order to magically
have our file;

```
openssl aes-256-cbc -d -salt -in encrypted.aes | tar -x -f -
```

The above command should generate back, whatever was passed as input.

### Further thoughs

Piping to `openssl` seems like a super skill that is freely available. Hacking with it can make your saturday evening
more fun than spending it on a sundbed near a tropical beach. Some ideas to get you into the rabbit hole;

#### Secure one-directional text service

```
#server
while true; do nc -lp 4445 | openssl aes-256-cbc -d -salt -k proxyPass | openssl aes-256-cbc -d -salt -k realPass | base64 --decode | cat; done

#proxy
while true; do nc -lp 4444 | openssl aes-256-cbc -salt -k proxyPass | nc localhost 4445; done

#client
while true; do cat /dev/urandom | head -c 10 | base64 | openssl aes-256-cbc -salt -k realPass | nc localhost 4444; done
```
Done! With the code above, a client can send a text to the server, by passing it first to a proxy. The only job that proxy has
is to double encrypt the message, acting as a "carrier" signal.

Well having a whole setup to only send randomness from one node to an other makes no sense, so please don't use the code above
as it is.

