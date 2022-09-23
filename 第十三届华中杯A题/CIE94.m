function DE94=CIE94(Lab1,Lab2,K)
if nargin>2
   if length(K)>2
      kL=K(1);kC=K(2);kH=K(3);
   end
else
   kL=1;kC=1;kH=1;
end
Lref=Lab1(:,1);aref=Lab1(:,2);bref=Lab1(:,3);
Cref=(aref.^2+bref.^2).^0.5;
L=Lab2(:,1);a=Lab2(:,2);b=Lab2(:,3);
C=(a.^2+b.^2).^0.5;
% Sc=1+0.045*(Cref+C)/2;
Sc=1+0.045*(Cref*C)^0.5;
% Sh=1+0.015*(Cref+C)/2;
Sh=1+0.015*(Cref*C)^0.5;
DC=abs(Cref-C);
DL=abs(Lref-L);
DE=(DL.^2+(aref-a).^2+(bref-b).^2).^0.5;
DH=real((DE.^2-DL.^2-DC.^2).^0.5);
DE94=((DL/kL).^2+(DC./(kC*Sc)).^2+(DH./(kH*Sh)).^2).^0.5;