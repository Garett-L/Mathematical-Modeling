% T3
clear;clc;
load data.mat
load data_center0.mat
load data_predict.mat

[data3l,~]=size(data3);
data3=[data3(:,1:2),zeros(data3l,2),data3(:,3:16)];
data3_test=data3;

n=20220918;
[t1,t2]=size(data3_test);
for i=1:t1
    % 产生一组和为扰动值的随机数
    s = RandStream("mcg16807","Seed",n+i);
    sum0 = 5;  % 指定的和
    N = sum(data3_test(i,5:18)~=0);     % 随机数个数
    r = zeros(1, N);   % 生成的随机数
    sum0temp = sum0/N;   % 每生成一个随机数后，剩余的和
    for j=1:(N-1)
        r(j) = sum0temp.*rand(s);
        sum0temp = (sum0 - r(j))/(N-j);
    end
    r(N) = sum0 - sum(r(1:N-1));


    % 增加扰动
    p=0;
    for j=5:t2
        if data3_test(i,j)~=0
            p=p+1;
            data3_test(i,j)=data3_test(i,j)+r(p);
            if data3_test(i,j)<0;data3_test(i,j)=0.01;end
        end
    end
end


% 判断该玻璃属于铅钡玻璃还是高钾玻璃

% 玻璃处分类（法1）欧氏距离(太粗暴了，不选用)
% t0=cell2mat(data2(:,[1:2,4:end]));
% standard=zeros(2,14);
% for i=1:2
%     for j=zb
%         standard(i,j)=mean(t0(t0(:,1)==i & t0(:,2)==0,j+2));
%     end
% end
% % 检验模型
% n=10; % 检验数量
% test=t0(floor(rand(n,1)*(length(t0)-1)+1),:);
% d=zeros(1,2);p=0;
% for i=1:n
%     for j=1:2
%         d(j)=dist(test(i,zb+2),standard(j,zb)');
%     end
%     [~,I]=min(d);
%     % fprintf("结果值：%d\t真实值：%d\n",I,test(i,1))
%     if I==test(i,1);p=p+1;end
% end
% fprintf("大类分类的正确率为%f\n",p/n);
% for i=1:data3l  % 判断属于铅钡（1）还是高钾（2）玻璃
%     for j=1:2
%         d(j)=dist(data3(i,zb+4),standard(j,zb)');
%     end
%     [~,I]=min(d);
%     data3(i,3)=I;
% end

% 玻璃初分类（法2）未风化的用logit回归，风化的用二氧化硅欧式距离
t0=cell2mat(data2(:,[1:2,4:end]));
xishu =glmfit(t0(t0(:,2)==0,zb+2),t0(t0(:,2)==0,1)-1, 'binomial');
fit = glmval(xishu,data3(:,zb+2), 'logit');
fit_test = glmval(xishu,data3_test(:,zb+2), 'logit');

t(1)=mean(t0((t0(:,1)==1 & t0(:,2)~=0),3));
t(2)=mean(t0((t0(:,1)==2 & t0(:,2)~=0),3));
for i=1:data3l
    if data3(i,2)==0
        data3(i,3)=(fit(i)>0.5)+1;
    else
        [~,I]=min(abs(t-data3(i,5)));
        data3(i,3)=I;
    end

    if data3_test(i,2)==0
        data3_test(i,3)=(fit_test(i)>0.5)+1;
    else
        [~,I]=min(abs(t-data3_test(i,5)));
        data3_test(i,3)=I;
    end
end

% 将风化变回未风化
for i=1:data3l
    if data3(i,2)~=0
        m=data3(i,3);  % 找出这是哪一类的玻璃
        t1=data3(i,:);
        data3(i,5:18)=0;
        data3(i,5:18)=t1(5:18).*roc(t1(3),:);
        w=t1(roc(m,:)==0)./sum(t1(roc(m,:)==0));
        t2=logical(linspace(0,0,4));
        data3(i,[t2,roc(m,:)==0])=(100-sum(data3(5:18))).*w;
    end

    if data3_test(i,2)~=0
        m=data3_test(i,3);  % 找出这是哪一类的玻璃
        t1=data3_test(i,:);
        data3_test(i,5:18)=0;
        data3_test(i,5:18)=t1(5:18).*roc(t1(3),:);
        w=t1(roc(m,:)==0)./sum(t1(roc(m,:)==0));
        t2=logical(linspace(0,0,4));
        data3_test(i,[t2,roc(m,:)==0])=(100-sum(data3_test(5:18))).*w;
    end
end

% 判断样本属于哪一亚类
d=zeros(1,4);
for i=1:data3l
    p=(data3(i,3)~=1)*4;
    for j=1:4
        d(j)=dist(data3(i,5:18),center(p+j));
    end
    [~,I]=min(d);
    data3(i,4)=I;

    p=(data3_test(i,3)~=1)*4;
    for j=1:4
        d(j)=dist(data3_test(i,5:18),center(p+j));
    end
    [~,I]=min(d);
    data3_test(i,4)=I;
end


name1=[{"样本编号"} {"风化程度"} {"种类"} {"亚类"} {"二氧化硅"} {"氧化纳"}...
    {"氧化钾"} {"氧化钙"} {"氧化镁"} {"氧化铝"} {"氧化铁"} ...
    {"氧化铜"} {"氧化铅"} {"氧化钡"} {"五氧化二磷"} {"氧化锶"} {"氧化锡"} {"二氧化硫"} ];

out=[[{'无随机扰动'},cell(1,17)];name1;num2cell(data3);...
    [{'增加随机扰动后'},cell(1,17)];name1;num2cell(data3_test)];

writecell(out,"result\T3分类结果.xlsx")
disp("输出完成~")