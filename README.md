# library_symbols_demo
.a/.so/bin symbol relations

在开发过程中, 经常会混合使用**静态库**(`.a`) 和**动态库**(`.so`)进行编译

这里通过实例对各种混合情形进行展示说明. 

### Demo依赖关系
```
graph LR
math.a      -->|dynamic|   liblink.so
libgame.so  -->|static|    math.a
main        -->|dynamic|   libgame.so
bigmath.a   -->|static|    math.a
```
#### 执行`make`
```bash
gcc -shared -o liblink.so link.c -fPIC
gcc -c -o math.o math.c -fPIC
ar rcs math.a math.o
gcc -shared -o libgame.so game.c math.a -L. -llink -fPIC -Wl,-rpath=. 
gcc -o main main.c -L. -lgame
gcc -c -o bigmath.o bigmath.c
ar rcs bigmath.a bigmath.o
```

### 总结

target|depends|symbols of depends in target
------|-------|-----
`.a`|`.so`|`U`
`.a`|`.a`|`U`
`.so`|`.a`|`T`
`.so`|`.so`|`U`

### 符号查询结果

#### `nm liblink.so`
```
00000000000006a0 T LINK_say_hi
```

#### `nm math.a`
```
                 U LINK_say_hi
0000000000000000 T MATH_add
0000000000000022 T MATH_sub_unused
```
**静态库** 使用 **动态库**, 作为外部符号`U`


#### `nm bigmath.a`
```
0000000000000000 T BIGMATH_add_3
                 U MATH_add
```
**静态库** 使用 **静态库**, 也作为外部符号`U`

#### `nm libgame.so`
```
0000000000000730 T GAME_do_calculate
....
                 U LINK_say_hi
0000000000000760 T MATH_add
0000000000000782 T MATH_sub_unused
```
**动态库** 使用 **静态库**,  会将代码导入 使用`T`

#### `nm main`
```
00000000004006d6 T main
                 U MATH_sub_unused
```
