# library_symbols_demo
.a/.so/bin symbol relations

在开发过程中, 经常会混合使用**静态库**(`.a`) 和**动态库**(`.so`)进行编译

这里通过实例对各种混合情形进行展示说明. 

### Demo依赖关系
```
graph LR
math.a      -->|dynamic|   liblink.so
math.a      -->|static|    mul.o math.o
libgame.so  -->|static|    math.a
main        -->|dynamic|   libgame.so
bigmath.a   -->|static|    math.a
```
#### 执行`make`
```bash
gcc -o liblink.so -shared link.c -fPIC
gcc -o math.o -c math.c -fPIC
gcc -o mul.o -c mul.c -fPIC
ar rcs math.a math.o mul.o
gcc -o libgame.so -shared game.c math.a -L. -llink -fPIC -Wl,-rpath=.
gcc -o main main.c -L. -lgame
gcc -o bigmath.o -c bigmath.c
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
> 依赖`liblink.so`
```
math.a:
                 U _GLOBAL_OFFSET_TABLE_
                 U LINK_say_hi
0000000000000000 T MATH_add
0000000000000022 T MATH_sub_unused

mul.o:
0000000000000000 T MUL_mul
```
**静态库** 使用 **动态库**, 作为外部符号`U`


#### `nm bigmath.a`
> 依赖`math.a`
```
0000000000000000 T BIGMATH_add_3
                 U MATH_add
```
**静态库** 使用 **静态库**, 也作为外部符号`U`

#### `nm libgame.so`
> 依赖`math.a`, **这里没有导入`mul.a`中的符号**
 
```
0000000000000730 T GAME_do_calculate
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
