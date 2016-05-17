unsigned add32carry(signed int sum, signed int x) {
 signed z = sum + x;
 if (sum + x >= x)
     z++;
 return z;
}
