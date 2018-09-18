# library_symbols_demo
.a/.so/bin symbol relations

### 依赖关系
```
graph LR
main        -->|dynamic|   libgame.so
libgame.so  -->|static|    math.a
math.a      -->|dynamic|   liblink.so
```

### 符号查询结果

`nm liblink.so`
```
00000000000006a0 T LINK_say_hi
```

`nm math.a`
```
                 U LINK_say_hi
0000000000000000 T MATH_add
0000000000000022 T MATH_sub_unused
```
> **静态库** 使用 **动态库**, 作为外部符号`U`


`nm bigmath.a`
```
0000000000000000 T BIGMATH_add_3
                 U MATH_add
```
> **静态库** 使用 **静态库**, 也作为外部符号`U`

`nm libgame.so`
```
0000000000000730 T GAME_do_calculate
....
                 U LINK_say_hi
0000000000000760 T MATH_add
0000000000000782 T MATH_sub_unused
```
> **动态库** 使用 **静态库**,  会将代码导入 使用`T`

`nm main`
```
00000000004006d6 T main
                 U MATH_sub_unused
```
