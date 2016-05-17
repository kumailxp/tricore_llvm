long long charfoo(long long a,long long b, long long c) {
   
   a = a + b;
   a = a + c;
   return a;
 }

void ptrfunc ( int *a,
               int *b,
               int *c,
               int *d,
               int *e ) {

    int f = *a + *b + *c + *d + *e;

}


long long  foo() {

//  long long x = 1;
//  long long z = 2;
//  long long y = 3;
  int a = 8;
  ptrfunc(&a, &a, &a, &a, &a); 
  return 0;
//  return charfoo(x,z,y) + 1;
}



























































