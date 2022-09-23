% 2022.08.23
%% 获得数据
clear

N=15;
xdata=(0:N)';lx=length(xdata);
evennessmax=zeros(lx,1);

for n=0:lx-1
    chro=zeros(n,3);   % chro代表NDA,其中的元素是基因
    lchro=size(chro);
    for i=1:lchro(1)
        for j=1:lchro(2)
            chro(i,j)=floor(rand(1,1)*255);
        end
    end

    i=1;
    while i<10000
        chronew=copy0(chro);  % DNA复制并变异,产生新的一个DNA，这两个DNA合称父代染色体
        [progeny1,progeny2]=cross0(chro,chronew);  % 父代DNA多个基因进行交叉互换，产生两个子代DNA
        [chro0,evenness0]=choose0(chro,chronew);
        [chro,evenness]=choose0(progeny1,progeny2);  % 选择一个子代DNA成为父代
        if evenness0>evenness;chro=chro0;end
        evennessmax(n+1)=max(evenness,evenness0);
        plot(i,evennessmax(n+1),'.','Color','b');hold on
        i=i+1;
    end
    axis padded;grid on;hold off;
end

evennessmax=evennessmax/evennessmax(1);
ydata=evennessmax;
save(['../data/xydata',num2str(N),'.mat'],"xdata","ydata")
%% 
% 分析数据
clear
N=20;
load(['../data/xydata',num2str(N),'.mat'],"xdata","ydata")
xdata=xdata*124335;ydata=ydata*124335;
xdata=mapminmax(xdata',0,1);ydata=mapminmax(ydata',0,1);
fun = @(x,xdata)(x(1)*xdata+x(2))./(x(3)*xdata+x(4));
x0 = [1,1,1,1];
x=lsqcurvefit(fun,x0,xdata,ydata);
R2=sum((fun(x,xdata)-mean(ydata)).^2)/sum((ydata-mean(ydata)).^2);
%plot(xdata,ydata,'or',xdata,fun(x,xdata),'-b')
%legend('实际值','拟合值','Location','southeast')
%axis padded;grid on;
%saveas(gcf,'../figure/拟合情况图.png')

% 熵权法计算权重(失败了)
% clear
% load('../data/xydata20.mat',"xdata","ydata")
% R=[xdata(2:end),ydata(2:end)];
% Rsize=size(R);k=1/log(Rsize(1));
% p=zeros(Rsize);e=zeros(1,Rsize(2));
% for j=1:Rsize(2)
%     p(:,j)=R(:,j)/sum(R(:,j));
%     e(j)=-k*sum(p(:,j).*log(p(:,j)));
% end
% w=(1-e)/sum(1-e);

% CRITIC法计算权重
xraw=[xdata;ydata]';
xrawsize=size(xraw);
for i=1:xrawsize(1)
    xraw(i,1)=(max(xdata)-xraw(i,1))/(max(xdata)-min(xdata));
    xraw(i,2)=(xraw(i,2)-max(ydata))/(max(ydata)-min(ydata));
end
xmean=zeros(1,2);S=zeros(1,2);
for j=1:2
    xmean(j)=mean(xraw(:,j));
    S(j)=sqrt(1/(xrawsize(1)-1)*sum((xraw(:,j)-xmean(j))).^2);% 计算指标变异性
end
corr =sum(1- corrcoef(xraw));  % 计算冲突性
xstd = std(xraw);              % 计算⽅差
C = xstd .* corr;           % 计算信息量
w = C/sum(C);               % 计算权重

% 按算出的权重将成本和表现效果相加，以这个和最大为规划目标
S=-w(1)*xdata+w(2)*fun(x,xdata);
[B,I]=max(S);

% 画图
p=polyfit(0:N,S,2);
plot(linspace(0,N),polyval(p,linspace(0,N)))
hold on
