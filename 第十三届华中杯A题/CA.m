% 输入两个CIELAB色彩空间下的颜色，返回它们的色差（CIEDE2000）
% 2022.08.22
function dE=CA(x1,x2)
kL=1;kC=1;kH=1;
Lr(1)=x1(1);ax(1)=x1(2);bx(1)=x1(3);
Lr(2)=x2(1);ax(2)=x2(2);bx(2)=x2(3);

Crb=(sqrt(ax(1)^2+bx(1)^2)+sqrt(ax(2)^2+bx(2)^2))/2;
G=0.5*(1-sqrt(Crb^7/(Crb^7+25^7)));
hp=zeros(1,2);Cp=zeros(1,2);
ap=zeros(1,2);bp=zeros(1,2);
for i=1:2
    ap(i)=(1+G)*ax(i);
    bp(i)=bx(i);
    Cp(i)=sqrt(ap(i)^2+bx(i)^2);
    if bp(i)==0 && ap(i)==0
        hp(i)=0;
    else 
        hp(i)=atan2(bp(i),ap(i));
    end
end

dLp=Lr(2)-Lr(1); % 明度差
dCp=Cp(2)-Cp(1); % 彩度差
if Cp(1)*Cp(2)==0
    dhp=0;
elseif abs(hp(2)-hp(1))<=pi
    dhp=hp(2)-hp(1);
elseif hp(2)-hp(1)>pi
    dhp=hp(2)-hp(1)-2*pi;
else
    dhp=hp(2)-hp(1)+2*pi;
end
dHp=2*sqrt(Cp(1)*Cp(2))*sin(dhp/2);  % 色相差

Lpb=(Lr(1)+Lr(2))/2;
Cpb=(Cp(1)+Cp(2))/2;
if Cp(1)*Cp(2)==0
    hpb=hp(2)+hp(1);
elseif abs(hp(1)-hp(2))<=pi
    hpb=(hp(2)+hp(1))/2;
elseif abs(hp(1)-hp(2))>pi && hp(1)-hp(2)<2*pi
    hpb=(hp(2)+hp(1)+2*pi)/2;
else
    hpb=(hp(2)+hp(1)-2*pi)/2;
end
T=1-0.17*cos(hpb-pi/6)+0.24*cos(2*hpb)+0.32*cos(3*hpb+pi/30)-0.2*cos(4*hpb-pi/180*63);
dth=30*exp((-1)*((hpb*180/pi-275)/25)^2);
RC=2*sqrt(Cpb^7/(Cpb^7+25^7));
SL=1+0.015*(Lpb-50)^2/sqrt(20+(Lpb-50)^2);
SC=1+0.045*Cpb;
SH=1+0.015*Cpb*T;
RT=-sin(2*dth)*RC;
dE=sqrt((dLp/kL/SL)^2+(dCp/kC/SC)^2+(dHp/kH/SH)^2+RT*(dCp/kC/SC)*(dHp/kH/SH));
end