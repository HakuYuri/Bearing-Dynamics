function [fx, fy]=MagPull(t, Displacement, IAS)
%发电机参数
% global If 
N=200;
If=100;
Fr=N*If;
Fs=0.5*Fr;
phi=6*pi/18;                %内功角定义为60°
F1=sqrt(Fs^2*cos(phi)*cos(phi)+(Fr-Fs*sin(phi))*(Fr-Fs*sin(phi)));%(何_式2-2)
L=0.1551;                    %定子长度
R=0.059;                     %转子半径
u=4*pi*10^-7;                %真空磁导率 
g0=0.003;                    %正常气隙长度
a0=u/g0;                     %正常磁导 (何_式2-2)
IAS=2*pi*25;                    %角频率
%基波合成磁势与转子磁势夹角B (何_式2-3)
ab=Fs*cos(phi);             %磁势图上ab长度
bo=Fr-Fs*sin(phi);          %磁势图上bo长度
B=atan(ab/bo);              %求解反正切,得到基波合成磁势与转子磁势夹角

% 动偏心
delta_d = sqrt(Displacement.x^2 + Displacement.y^2);


%偏心故障对应的磁导 （故障程度不同，系数不同）
as=0*g0;                  %静偏心对应的磁导
ad=0.0161*delta_d*g0;                  %动偏心对应的磁导

%转子所受不平衡磁拉力 (何_式3-5)
fx=L*R*F1^2*pi*(2*a0*as+2*a0*ad*cos(IAS*t)+a0*ad*cos(IAS*t-2*B)+a0*as*cos(2*IAS*t-2*B))/(4*u);
fy=L*R*F1^2*pi*(2*a0*ad*sin(IAS*t)+a0*ad*sin(IAS*t-2*B)+a0*as*sin(2*IAS*t-2*B))/(4*u);
end