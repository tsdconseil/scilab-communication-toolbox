
for i = 1:7
  b = prbs(i*5);
  x = symmap(b,i);
  b2 = symdemap(x,i);
  assert_checkequal(b,b2);
end






