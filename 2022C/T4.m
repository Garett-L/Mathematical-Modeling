% T4
clear;clc;close all
load data.mat
load data_center0.mat

% 关联规则分析
t0=cell2mat(data2(:,[1:2,4:end]));
t=cell(1,2);
for m=1:2
    t{m}=t0(t0(:,1)==m & t0(:,2)==0,3:16);
    for j=1:14
        for i=1:size(t{m},1)
            if t{m}(i,j)>0
                t{m}(i,j)=1;
            end
        end
    end
    %guanlian(t{m})
end

% 对大类的关联分析
t0=cell2mat(data2(:,[1:2,4:end]));
R1=ones(2*14,14);R2=zeros(2*14,14);
for m=1:2
    k=(m-1)*14;
    R2(k+1:k+14,:)=corrcoef(t0(t0(:,1)==m,3:end));
%     灰色关联预测（不够准，失败了）
%     p=0.1;  % 设置分辨系数
%     k=(m-1)*14;
%     t1=t0(t0(:,1)==m,3:end);  % 选择哪一大类的玻璃  
%     [~,t1l]=size(t1);
%     for n=1:t1l  % 遍历所有指标
%         t2=t1;t2(:,n)=[];  % 除去这一列
%         A=abs(t2-t1(:,n));
%         Amin=min(A,[],'all'); Amax=max(A,[],'all');
%         B=(Amin+p*Amax)./(A+p*Amax);
%         
%         R1(k+n,[1:n-1,n+1:end])=mean(B);
%     end
end
name1=[{"二氧化硅"} {"氧化纳"} {"氧化钾"} {"氧化钙"} {"氧化镁"} {"氧化铝"} {"氧化铁"} ...
    {"氧化铜"} {"氧化铅"} {"氧化钡"} {"五氧化二磷"} {"氧化锶"} {"氧化锡"} {"二氧化硫"} ];
name2=[{"铅钡玻璃"} {"高钾玻璃"}];
out=cell(31,15);
out(1,2:15)=name1; out(2:15,1)=name1'; out(2:15,2:15)=num2cell(R2(1:14,:));
out(17,2:15)=name1; out(18:31,1)=name1'; out(18:31,2:15)=num2cell(R2(15:28,:));
writecell(out,"result\T4相关系数矩阵.xlsx")
disp("输出成功~")

% 热力图
xiangguan1=abs(R2(1:14,:));
xiangguan2=abs(R2(15:end,:));
x_name={'SiO_2','Na_2O','K_2O','CaO','MgO','Al_2O_3','Fe_2O_3',...
    'CuO','PbO','BaO','P_2O_5','SrO','SnO_2','SO_2'};
y_name=x_name;
for i=1:2
fig=figure;
fig.Position=[128 562 1112 416];
H = heatmap(x_name,y_name,xiangguan1,'FontSize',12, 'FontName','微软雅黑');
H.Title = append(name2{i},'各组分的皮尔逊相关系数'); 
saveas(fig,append("pictrue\T4",name2{i},"各组分相关系数热力图.png"))
end

% 提取上三角
R2l=width(R2);
n=(1+R2l)*R2l/2-14;
x=1:n;
t=zeros(2,n);
p=0;
for m=1:2
    k=(m-1)*14;
    for i=1:R2l
        for j=i+1:14
            p=p+1;
            t(m,p)=R2(k+i,j);
        end
    end
end

% 分别找出两类玻璃中关联程度前三的指标，并画图
y=zeros(2,n);
y(1,:)=abs(t(1,1:n));
y(2,:)=abs(t(2,n+1:end))*(-1);
t1=abs(y);
t2=1:n;
[~,I1]=sort(t1(1,:),'descend');
[~,I2]=sort(t1(2,:),'descend');
p(1,1:n)=t2(I1);
p(2,1:n)=t2(I2);
out=[[{"铅钡"};{"高钾"}] num2cell(p(:,1:3))];
disp(out)

fig = figure;
h1 = gca;
bar(x,y(1,:),'EdgeColor','w','FaceColor',[0.3843 0.7098 0.9608])
hold on
bar(x,y(2,:),'EdgeColor','w','FaceColor',[0.9569 0.5647 0.4627])
ylim([-1.25,1])
legend('铅钡玻璃','高钾玻璃','Location','north');
h1.XTick=[];h1.YTick=[];
fig.Position= [117 370 1652 607];
text(p(1,1)-0.2,y(1,p(1,1))+0.05,"\downarrow SiO_2 and PbO",'Color','r')
text(p(1,2)-0.2,y(1,p(1,2))+0.05,"\downarrow BaO and CuO",'Color','r')
text(p(1,3)-0.2,y(1,p(1,3))+0.05,"\downarrow BaO and SO_2",'Color','r')

text(p(2,1)-0.3,y(2,p(2,1))-0.165,"\uparrow SiO_2 and K_2O",'Color','b')
text(p(2,2)-0.3,y(2,p(2,2))-0.125,"\uparrow SiO_2 and CaO",'Color','b')
text(p(2,3)-0.3,y(2,p(2,3))-0.045,"\uparrow SiO_2 and Al_2O_3",'Color','b')

saveas(fig,"pictrue\T4不同类别之间的化学成分关联关系的差异性分析.png")

