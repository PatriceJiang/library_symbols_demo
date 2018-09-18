
all: math.a libgame.so main liblink.so bigmath.a

liblink.so: link.c
	gcc -shared -o $@ link.c -fPIC

math.a: math.c liblink.so
	gcc -c -o math.o math.c -fPIC 
	ar rcs $@ math.o

libgame.so: math.a game.c liblink.so
	gcc -shared -o $@ game.c math.a -L. -llink -fPIC -Wl,-rpath=.
bigmath.a: math.a bigmath.c
	gcc -c -o bigmath.o bigmath.c 
	ar rcs $@ bigmath.o 


main: main.c
	gcc -o $@ main.c -L. -lgame

clean:
	rm -rf math.a libgame.so game.o math.o liblink.so


#-Wl,--gc-sections #-fvisibility=hidden 	 -ffunction-sections 
