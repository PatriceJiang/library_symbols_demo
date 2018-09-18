
targets=math.a libgame.so main liblink.so bigmath.a

all: $(targets)

liblink.so: link.c
	gcc -shared -o $@ link.c -fPIC

math.a: math.c liblink.so mul.c
	gcc -c -o math.o math.c -fPIC 
	gcc -c -o mul.o mul.c -fPIC
	ar rcs $@ math.o mul.o

libgame.so: game.c liblink.so math.a 
	gcc -shared -o $@ game.c math.a -L. -llink -fPIC -Wl,-rpath=.

bigmath.a: math.a bigmath.c
	gcc -c -o bigmath.o bigmath.c 
	ar rcs $@ bigmath.o 


main: main.c
	gcc -o $@ main.c -L. -lgame

clean:
	rm -rf $(targets)


#-Wl,--gc-sections #-fvisibility=hidden 	 -ffunction-sections 
