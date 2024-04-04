This project tries to build liblzma without autotools, just with a single
`Makefile`.

The motivation behind this project is that the [XZ backdoor][1] was only
possible thanks to autotools's complexity.

For now this project will not contain any code, you should get the `xz-5.6.1`
code from [somewhere else][2], and then you can do:

```sh
./import $xz/src/liblzma
make
```

The resulting `liblzma.so.5` library should be compatible with the one in
upstream.

[1]: https://en.wikipedia.org/wiki/XZ_Utils_backdoor
[2]: https://git.tukaani.org/?p=xz.git
