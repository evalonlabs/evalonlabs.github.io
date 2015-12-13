title: Simple XOR Encryption in JS
date: 2015-12-10 09:45:25
categories:
- javascript
- security
- encryption
tags:
- encryption
- javascript
- security
- xor
---

```
function xorConvert (text, key) {
    var kL = key.length;

    return Array.prototype
        .slice.call(text)
        .map(function (c, index) {
            return String.fromCharCode(c.charCodeAt(0) ^ key[index % kL].charCodeAt(0));
        }).join('');
}

var key = "RandomPassKey";
var txt = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz!@£#$%^&*()[]{};:'\",.<>/\\";
var cipherText = xorConvert(txt, key);

assert(xorConvert(cipherText, key) === txt);
```
