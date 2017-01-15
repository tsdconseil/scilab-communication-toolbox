cdir = get_absolute_file_path("polyphase_test.tst");
exec(cdir + "../../macros/loadall.sce");

///////////////////////////////////////// 
//  Vérification décimation polyphase  //
/////////////////////////////////////////

ntapss = [3 4 5 32 33 127 128 200]
Rs = [2 3 4 5 6 7 10 4]

n = 50;

for i = 1:length(ntapss)
  ntaps = ntapss(i); R = Rs(i);
  
  printf("Test ntaps = %d, R = %d...\n", ntaps, R);
  //h = eqfir(ntaps,[0 .2;.3 .5],[1 0],[1 1]);
  h = rand(ntaps,1);
  x = rand(n,1);

  x1 = polyphase_decimation(x,h,R);
  x2 = convol(h,x);
  x2 = x2(1:R:$)';
  
  if(length(x1) > length(x2))
      x1($) = [];
  end;

//  clf();
//  plot(x1,'b-');
//  plot(x2,'g-');
  assert_checkalmostequal(x1,x2,1e-7);
end

