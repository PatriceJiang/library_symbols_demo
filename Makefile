
targets=math.a libgame.so main liblink.so bigmath.a

all: $(targets)

liblink.so: link.c
	gcc -o $@ -shared link.c -fPIC

math.a: math.c liblink.so mul.c
	gcc -o math.o -c math.c -fPIC 
	gcc -o mul.o -c mul.c -fPIC
	ar rcs $@ math.o mul.o

libgame.so: game.c liblink.so math.a 
	gcc -o $@ -shared game.c math.a -L. -llink -fPIC -Wl,-rpath=.

bigmath.a: math.a bigmath.c
	gcc -o bigmath.o -c bigmath.c 
	ar rcs $@ bigmath.o 


main: main.c
	gcc -o $@ main.c -L. -lgame

clean:
	rm -rf $(targets)


#-Wl,--gc-sections #-fvisibility=hidden 	 -ffunction-sections 
