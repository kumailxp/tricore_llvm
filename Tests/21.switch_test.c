int foo() {

  int b=20,c=10;
  int a = 0;


  a = 22 + b + c;

  switch(a) {
  case 10:
    b=34;
    break;
  case 23:
    a= a+2;
    break;
  default:
    b=100;
  }

return 1;
}
