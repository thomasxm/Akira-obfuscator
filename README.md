# Akira
Another llvm based obfuscator based on [goron](https://github.com/amimo/goron).

## Current Supported Features:
- Correlation between obfuscation processes.
- Indirect jumps, encrypting the jump targets (`-mllvm -irobf-indbr`).
- Indirect function calls, encrypting the target function addresses (`-mllvm -irobf-icall`).
- Indirect global variable references, encrypting the variable addresses (`-mllvm -irobf-indgv`).
- C string encryption (`-mllvm -irobf-cse`).
- Procedure-related control flow flattening obfuscation (`-mllvm -irobf-cff`).
- Comprehensive application of all the above features (`-mllvm -irobf-indbr -mllvm -irobf-icall -mllvm -irobf-indgv -mllvm -irobf-cse -mllvm -irobf-cff`).


## Improvements Over Goron:
- Following the original author's announcement of no further updates for the foreseeable future, this version was initiated ([goron issue #29](https://github.com/amimo/goron/issues/29)).
- Updated LLVM version.
- Filename output during compilation to address organisational needs.
- Fixed several known bugs:
  - SEH explosions post-obfuscation.
  - Loss of `__impl` prefix in dll-imported global variables due to obfuscation.
  - Compilation issues when combined with llvm2019 (2022) plugin due to redundant argument addition.
  - Stack corruption during x86 indirect calls.
    
## Compilation Instructions:

 - Windows:
install ninja in your PATH
run x64(86) Native Tools Command Prompt for VS 2022(xx)
run:
```
mkdir build_ninja
cd build_ninja
cmake -DCMAKE_CXX_FLAGS="/utf-8" -DCMAKE_BUILD_TYPE=Release -DLLVM_ENABLE_ASSERTIONS=ON -DLLVM_ENABLE_PROJECTS="clang;clang-tools-extra;lld;lldb" -G "Ninja" ../llvm
ninja
```

## Usage:

Similar to OLLVM-obfuscator, enable specific obfuscations through compilation options. For example, to enable indirect jump obfuscation:

```
path_to_the/build/bin/clang -mllvm -irobf -mllvm --irobf-indbr test.c
```
For projects using autotools:
```
CC=path_to_the/build/bin/clang or CXX=path_to_the/build/bin/clang
CFLAGS+="-mllvm -irobf -mllvm --irobf-indbr" or CXXFLAGS+="-mllvm -irobf -mllvm --irobf-indbr" (or any other obfuscation-related flags)
./configure
make
```
## Compiliation error:
utf-8 is for compiliation on Windows, if compiling the project on Linux, use the following cmake instead:
```
cmake -DCMAKE_BUILD_TYPE=Release -DLLVM_ENABLE_ASSERTIONS=ON -DLLVM_ENABLE_PROJECTS="clang;clang-tools-extra;lld;lldb" -G "Ninja" ../llvm
```

If compiling the project on Linux with gcc and encountered erros like so: 
```
/home/kali/akira/llvm/lib/Transforms/Obfuscation/CryptoUtils.cpp:679:26: error: variable ‘std::ifstream devrandom’ has initializer but incomplete type
  679 |   std::ifstream devrandom("/dev/urandom");
      |                          ^
/home/kali/akira/llvm/lib/Transforms/Obfuscation/CryptoUtils.cpp: In member function ‘int llvm::CryptoUtils::sha256_process(sha256_state*, const unsigned char*, long unsigned int)’:
/home/kali/akira/llvm/lib/Transforms/Obfuscation/CryptoUtils.cpp:939:38: warning: cast from type ‘const unsigned char*’ to type ‘unsigned char*’ casts away qualifiers [-Wcast-qual]
  939 |       if ((err = sha256_compress(md, (unsigned char *)in)) != 0) {
      |                                      ^~~~~~~~~~~~~~~~~~~
[977/6616] Building CXX object lib/Transforms/CFGuard/CMakeFiles/LLVMCFGuard.dir/CFGuard.cpp.o
ninja: build stopped: subcommand failed.
```
add ```#include <fstream> // Add this line if it's missing``` to: 
```
/akira/llvm/lib/Transforms/Obfuscation/CryptoUtils.cpp
```

## Reference:
+ [Goron](https://github.com/amimo/goron)
+ [Hikari](https://github.com/HikariObfuscator/Hikari)
+ [ollvm](https://github.com/obfuscator-llvm/obfuscator)
