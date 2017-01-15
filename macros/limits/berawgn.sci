// Scilab Communication Toolbox
// (C) J.A. / contact: http://www.tsdconseil.fr 
//
// Ce logiciel est régi par la licence CeCILL-C soumise au droit français et
// respectant les principes de diffusion des logiciels libres. Vous pouvez
// utiliser, modifier et/ou redistribuer ce programme sous les conditions
// de la licence CeCILL-C telle que diffusée par le CEA, le CNRS et l'INRIA 
// sur le site "http://www.cecill.info".
//
// En contrepartie de l'accessibilité au code source et des droits de copie,
// de modification et de redistribution accordés par cette licence, il n'est
// offert aux utilisateurs qu'une garantie limitée.  Pour les mêmes raisons,
// seule une responsabilité restreinte pèse sur l'auteur du programme,  le
// titulaire des droits patrimoniaux et les concédants successifs.
//
// A cet égard  l'attention de l'utilisateur est attirée sur les risques
// associés au chargement,  à l'utilisation,  à la modification et/ou au
// développement et à la reproduction du logiciel par l'utilisateur étant 
// donné sa spécificité de logiciel libre, qui peut le rendre complexe à 
// manipuler et qui le réserve donc à des développeurs et des professionnels
// avertis possédant  des  connaissances  informatiques approfondies.  Les
// utilisateurs sont donc invités à charger  et  tester  l'adéquation  du
// logiciel à leurs besoins dans des conditions permettant d'assurer la
// sécurité de leurs systèmes et ou de leurs données et, plus généralement, 
// à l'utiliser et l'exploiter dans les mêmes conditions de sécurité. 
//
// Le fait que vous puissiez accéder à cet en-tête signifie que vous avez 
// pris connaissance de la licence CeCILL-C, et que vous en avez accepté les
// termes.

function ber=berawgn(mod,ebno,varargin)
// Computes Bit Error Rate (ber) for Additive White Gaussian Noise (AWGN) channel
//
// Calling Sequence
//   ber = berawgn(wf,ebno)
//   ber = berawgn(type,ebno[,M[,opt]])
//
// Parameters
// wf: Waveform object (see <link linkend="wf_init">wf_init</link>)
// ebno: Eb/No, in dB (a vector or a single value) 
// type: Waveform type ('ask','qam','psk','qpsk','dpsk','oqpsk','fsk',...)
// M: Number of symbols used in transmission (default is 2). It is integer power of 2 and one among 2,4,8,16,32
// opt: 'c' (coherent demodulation) or 'i' (incoherent)
// ber: Resulting Bit Error Rate vector (one value for each valeu of Eb/N0)
//
// Description
// When symbols are transmitted over communication channel having additive white gaussian noise then probability of error for the received symbols is given by this function. For case of 'fsk' correlation among the carriers and method used for detection at receiver which is coherent or noncoherent also needs to be specified. This function returns an array having same size as the size of array containing Eb/No values.  
//
// <refsection><title>Note</title></refsection>
// The original code for this function has been written by:
//  Vinayak Chandra Sharma (Department of Electrical Engineering, IIT Bombay),
//  guided by prof. Saravanan Vijayakumaran
//
// Examples
// ber = berawgn('psk',1:10,8) // 8-PSK 
// ber = berawgn('fsk',1:10,2,'c')  // 2-FSK, coherent demodulation
// ber = berawgn('fsk',1:10,2,'i')  // 2-FSK, incoherent demodulation
//
// See also
//  channel_capacity
//  wf_init
//
// Authors
//  Original code:
//  Vinayak Chandra Sharma (Department of Electrical Engineering, IIT Bombay),
//  Guided by prof. Saravanan Vijayakumaran
//
//  With modifications by J.A.
//
   
  [lhs,rhs]=argn();
  
  pulses = ['pam' 'nrz' 'srrc' 'rc']; 
  mods   = ['lin' 'fsk'];
 
 
  if(type(mod) == 17) // mlist
      ber = mod.ber(ebno);
      return;
  end;
  
//  if(rhs == 0) then
//      // Demo mode
//      ebno = -3:0.5:30;
//      ber1 = berawgn(ebno,'psk');
//      ber2 = berawgn(ebno,'pam');
//      ber3 = berawgn(ebno,'fsk');
//      clf();
//      plot(ebno, log10(ber1+1e-10), ebno, log10(ber2+1e-10), ebno, log10(ber3+1e-10));
//      legend(['BPSK','PAM','FSK']);
//      return;
//  end;
  
  
  ll=length(ebno);
  
  M = 2; // Default is binary
  if(rhs >= 3) then
      M = varargin(1);
  end;
  
  opt = 'c'; // Default is coherent
  if(rhs >= 4) then
      opt = varargin(2);
  end;
  
  ebno = ebno(:)'; // vecteur ligne
  ebnoD=10 .^ (ebno/10); // convert from decibels to base 10 number
  
  k=log2(M); // no of bits in each symbol
  
  if(mod~='pam' & mod~='qam' & mod~='qpsk' & mod~='oqpsk' & mod~='dpsk' & mod~='fsk' & mod~='psk' & mod~='ask')
    error('berawgn : please supply proper modulation type.');
  end
  if(size(ebno,1)~=1)
    error('berawgn : Eb/No values should be a vector');
  end
  mm=[2,4,8,16,32];
  if(~mtlb_any(mm==M))
    error('berawgn : M should be one among 2,4,8,16,32');
  end
  if(mod == 'fsk')
    Rho = 0;
    if(opt~='c' & opt~='i')
      error('berawgn : opt should be either ''c'' or           ''i'' for ''fsk''');
    end
  elseif(mod=='psk' | mod=='qpsk' | mod=='oqpsk'  ) then
    Rho = 0;
    if(opt~='c' & opt~='i')
      error('berawgn : opt should be either ''c'' or           ''i'' for ''psk''');
    end
  end
  if(mod =='qam' | mod =='pam' )
  Rho =0;// not used  
  end
  
  if(Rho<0 | Rho>1)
    error('berawgn : Rho should be bwtween 0 and 1')
  end
  
  if((mod=='nrz') | (mod=='pam') | (mod=='ask'))
    ber = (M-1) / M * erfc(sqrt(3 * log2(M) * ebnoD / (M*M - 1)))/k; // from 5.2.46 proakis
    
  elseif(mod=='psk')
    if((M>4) & (opt=='i'))
      error('berawgn: M should be no greater than 4 for differential encoded psk');
    end
    ber=erfc((sqrt(k*ebnoD))*sin((%pi)/M))/k //eq 5.2.61 from proakis
    if(M == 2)
      ber = ber / 2;
    end;
    if(opt=='i')
      ber=2*ber; // Differential modulation
    end    
    
  elseif((mod=='oqpsk')|(mod=='qpsk'))
    M=4;
    ber=erfc((sqrt(k*ebnoD))*sin((%pi)/M))/k; //eq 5.2.61 from proakis
    
  elseif(mod=='qam')
    tmp=(1-(1/sqrt(M)))*erfc(sqrt(3/2*k*ebnoD/(M-1)))// eq 5.2.79 from proakis
    for i=1:ll
      ber(i)=(1-(1-tmp(i))^2)/k;
    end

  elseif((mod=='fsk')&(opt=='c')&(Rho==0))// for fsk,coherent and orthogonal
    F=(2^(k-1))/((2^k)-1);
    for i=1:ll
      function [y]=fskcoherorth(q)
        A=sqrt(2*k*ebnoD(i)),
        B=q*q/2,
        C=0.5*erfc((-q-A)/sqrt(2)),
        y=(C^(M-1))/sqrt(2*(%pi))*exp(-B),
      endfunction
      Ps(i)=1-intg(-100,100,fskcoherorth);
      Pb(i)=F*Ps(i);
    end
    ber=Pb;
    
  elseif((mod=='fsk')&(opt=='c')&(Rho~=0))//for coherent non orthogonal
    A=ebnoD*(1-real(Rho));
    ber=0.5*erfc(sqrt(A/2));
    
  elseif((mod=='fsk')&(opt=='i')&(Rho==0))//for noncoherent orthogonal	
    for i=1:ll
      Ps(i)=0;
      for n=1:(M-1)
        tmp=(-1)^(n+1);
        tmp1=(nchoosek(M-1,n))/(n+1);
        tmp2=exp(-n/(n+1)*k*ebnoD(i));
        Ps(i)=Ps(i)+tmp*tmp1*tmp2;
      end
      ber(i)=0.5*M/(M-1)*Ps(i);
    end	
    
  elseif((mod=='fsk')&(opt=='i')&(Rho~=0))//for noncoherent nonorthogonal	
    tmp=sqrt(1-(abs(Rho))^2);
    for i=1:ll
      aa(i)=ebnoD(i)/2*(1-tmp);
      bb(i)=ebnoD(i)/2*(1+tmp);
      A=0.5*exp(-0.5*(aa(i)+bb(i)))*besseli(0,sqrt(aa(i)*bb(i)));
      B=marcumqq(sqrt(aa(i)),sqrt(bb(i)));
      ber(i)=B-A;
    end  
    
  elseif(mod=='dpsk')
    A=sin(%pi/M);
    B=cos(%pi/M);
    C=k*ebnoD;
    for i=1:ll
      function [y]=berdpsk(H)
        y=A/2/k/(%pi)*exp(-C(i)*(1-B*cos(H)))/(1-B*cos(H)),
      endfunction
      ber(i)=intg(-(%pi/2),(%pi/2),berdpsk);
    end
  else
    error('berawgn: Results not available for given combination...please refer to help page for allowed combinations');
  end
  ber = matrix(ber,size(ebno,1),size(ebno,2));
endfunction

// ----------------------nchoosek----------------


//finds combination aCb
function y=nchoosek(varargin)
  [lhs rhs]=argn(0);
  a=varargin(1);
  b=varargin(2);
  
    if(round(a)~=a | round(b)~=b)
      error('NCHOOSEK : argument should be integers !')
    elseif((a<0)|(b<0))
      error('NCHOOSEK : argument can not be negative here !')
    elseif(a>=0 & b==0)
      y=1;
    elseif(a<b)
      error('NCHOOSEK : first argument should be greater than or equal to second argument')
    else
      y = factorial(a)./factorial(b)./factorial(a-b);
    end
  endfunction

    

    
        
    

