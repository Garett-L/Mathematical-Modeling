% T2
clear;clc
load data.mat
x0=cell2mat(data2(:,[1:2,4:end]));
% 用斯皮尔曼相关系数挑选合适的指标
zb=[];zb_xishu=[];
x00=x0(x0(:,2)==0,:);
for m=1:14
    R=corr(x00(:,1) , x00(:,m+2) , 'type' , 'Spearman');
    if abs(R)>0.5
        t=[zb,m];zb=t;
        t=[zb_xishu,R];zb_xishu=t;
    end
end

% 分类规律1的可视化

% 箱线图（太丑了）
% x1=[x0(x0(:,1)==1 & x0(:,2)~=0,3)];
% x2=[x0(x0(:,1)==2 & x0(:,2)~=0,3)];
% x=[x1;x2];
% g1 = repmat({'铅钡玻璃'},length(x1),1);
% g2 = repmat({'高钾玻璃'},length(x2),1);
% g = [g1; g2];
% boxplot(x,g);

% 散点图
x=cell(1,2);y=cell(1,2);
for i=1:2
    y{i}=[x0(x0(:,1)==i & x0(:,2)~=0,3)];
    x{i}=linspace(i,i,length(y{i}));
end
axe1=axes; hold on; grid on
fig=gcf;
for i=1:2
    plot(x{i},y{i},'o')
    x{i}=linspace(i-1/8,i+1/8,100);
    y{i}=linspace(mean(y{i}),mean(y{i}),100);
    line(x{i},y{i},'Color','k')
    str=y{i}(end);
    text(x{i}(end),y{i}(end),num2str(str))
end
xlim([0.5,2.5]);
axe1.XTickLabel=[{' '} {'铅钡玻璃'} {' '} {'高钾玻璃'} {' '}];
fig.Position=[1209 257 402 676];
saveas(axe1,"pictrue\T2两类风化玻璃中二氧化硅含量的差异.png")

%% 多次动态聚类取最好的情况
tic
t_R=zeros(2,1);t_R_test=zeros(2,1);
% 用Kmeans法聚类
name1=[{"检测点"} {"亚类"} {"种类"} {"风化程度"} {"二氧化硅"} {"氧化纳"}...
    {"氧化钾"} {"氧化钙"} {"氧化镁"} {"氧化铝"} {"氧化铁"} ...
    {"氧化铜"} {"氧化铅"} {"氧化钡"} {"五氧化二磷"} {"氧化锶"} {"氧化锡"} {"二氧化硫"} ];
num=4; % 几类

for kk=1:1000

    center=zeros(2*num,length(zb));
    center_test=zeros(2*num,length(zb));
    julei=name1;julei_test=name1;
    for m=1:2
        a=x0(x0(:,1)==m & x0(:,2)==0,:);
        b=data2(x0(:,1)==m & x0(:,2)==0,3);

        [index_km,center(num*(m-1)+1:num*m,:)]=kmeans(a(:,zb+2),num);
        [B,I]=sort(index_km);
        t=[julei;[b(I) num2cell([B a(I,:)])]];
        julei=t;

        % 敏感性分析
        [la,~]=size(a);
        t=randperm(la);a=a(t,:);b=b(t,:);  % 打乱顺序
        a(end-5:end,:)=[];  % 去掉最后五个样本
        b(end-5:end,:)=[];
        [index_km_test,center_test(num*(m-1)+1:num*m,:)]=kmeans(a(:,zb+2),num);
        [B,I]=sort(index_km_test);
        t=[julei_test;[b(I) num2cell([B a(I,:)])]];
        julei_test=t;
    end
    % 全集和测试集之间的欧式距离（暂时没有用上）
%     d_test=zeros(2,num);
%     d_test(:,:)=inf;
%     for k=1:2
%         p=(k-1)*num;
%         for i=1:num
%             for j=1:num
%                 t=dist(center(p+i,:),center_test(p+j,:)');
%                 if d_test(k,i)>t;d_test(k,i)=t;end
%             end
%         end
%     end
%     d_test=sum(d_test,2);

    % 用轮廓系数检验全集
    t0=cell2mat(julei(2:end,2:end));
    S=zeros(2,num);
    a=zeros(1,num);
    b=linspace(inf,inf,num);
    for m=1:2  % 铅钡和高钾大类
        % 计算亚类内距离
        t1=t0(t0(:,2)==m,:);  %当前是哪一大类的玻璃
        for n=1:num  % 铅钡和高钾其中的亚类
            t2=t1(t1(:,1)==n,:);  % 当前亚类中的所有样本
            [t2l,~]=size(t2);

            for k=1:t2l  % 遍历每一个样本
                p=1:num;p(n)=[];  %去掉自身这个亚类
                for i=p  % 遍历其它亚类
                    t3=t1(t1(:,1)==i,:);  % 找出其他亚类中的所有样本
                    [t3l,~]=size(t3);
                    for j=1:t3l
                        d=dist(t2(k,zb+3),t3(j,zb+3)');
                        if b(i)>d;b(i)=d;end
                    end
                end
            end

            if t2l==1;a(i)=0;continue;end
            for i=1:t2l
                t3=t2;t3(i,:)=[];
                a0=0;
                for j=1:t2l-1
                    d=dist(t2(i,zb+3),t3(j,zb+3)');
                    a0=a0+d;
                end
                a(i)=sqrt(a0)/(t2l-1);
            end

        end
        for n=1:num
            S(m,n)=(b(n)-a(n))/max(a(n),b(n));
        end
    end

    % 测试集
    t0=cell2mat(julei_test(2:end,2:end));
    S_test=zeros(2,num);
    a_test=zeros(1,num);
    b_test=linspace(inf,inf,num);
    for m=1:2  % 铅钡和高钾大类
        % 计算亚类内距离
        t1=t0(t0(:,2)==m,:);  %当前是哪一大类的玻璃
        for n=1:num  % 铅钡和高钾其中的亚类
            t2=t1(t1(:,1)==n,:);  % 当前亚类中的所有样本
            [t2l,~]=size(t2);

            for k=1:t2l  % 遍历每一个样本
                p=1:num;p(n)=[];  %去掉自身这个亚类
                for i=p  % 遍历其它亚类
                    t3=t1(t1(:,1)==i,:);  % 找出其他亚类中的所有样本
                    [t3l,~]=size(t3);
                    for j=1:t3l
                        d=dist(t2(k,zb+3),t3(j,zb+3)');
                        if b_test(i)>d;b_test(i)=d;end
                    end
                end
            end

            if t2l==1;a_test(i)=0;continue;end
            for i=1:t2l
                t3=t2;t3(i,:)=[];
                a0=0;
                for j=1:t2l-1
                    d=dist(t2(i,zb+3),t3(j,zb+3)');
                    a0=a0+d;
                end
                a_test(i)=sqrt(a0)/(t2l-1);
            end

        end
        for n=1:num
            S_test(m,n)=(b_test(n)-a_test(n))/max(a_test(n),b_test(n));
        end
    end

    R=mean(S,2);  % 轮廓系数得分
    R_test=mean(S_test,2);

    if sum(R)>sum(t_R)
        t_center=center;
        t_R=R;
        t_julei=julei;
    end

    if sum(R_test)>sum(t_R_test)
        t_center_test=center_test;
        t_R_test=R_test;
        t_julei_test=julei_test;
    end

end

center=t_center;julei=t_julei;R=t_R;
center_test=t_center_test;julei_test=t_julei_test;R_test=t_R_test;

save data_center0.mat center zb num
writecell(julei,"result\T2聚类结果.xlsx")
disp("输出完成~")
toc