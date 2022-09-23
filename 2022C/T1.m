% T1
clear;clc;close all
load data.mat


% 单因素方差分析（由于很多指标不属于同一个正态总体，失败了）
% A=[32/(28+32) 16/(46+16) 16/(78+16) 16/(40+16) 16/(24+16) 16*3/(27*2+16*3) 16*3/(56*2+16*3)...
%     16/(63.5+16) 16/(207+16) 16/(137+16) 16*5/(31*2+16*5) 16/(88+16) 32/(119+32) 32/(32+32)];
% ys=zeros(67,15);
% for i=1:67
%     for j=2:15
%         ys(i,1)=ys(i,1)+data2{i,j+2}*A(j-1);
%         ys(i,j)=data2{i,j+2}*(1-A(j-1));
%     end
% end
% 
% ys=[cell2mat(data2(:,2)) ys];
% for i=2:16
%     n=i;
%     t1=ys(ys(:,1)==0 & ys(:,i)~=0,n)';
%     t2=ys(ys(:,1)~=0 & ys(:,i)~=0,n)';
%     group=[ones(1,length(t1)),2*ones(1,length(t2))];
%     [p,gca]=anova1([t1 t2],group);
%     if p>=0.05;disp(i);end
% end
% disp('-----')
% hhw=[cell2mat(data2(:,2)) cell2mat(data2(:,4:end))];
% for i=2:15
%     n=i;
%     t1=hhw(hhw(:,1)==0 & hhw(:,i)~=0,n)';
%     t2=hhw(hhw(:,1)~=0 & hhw(:,i)~=0,n)';
%     group=[ones(1,length(t1)),2*ones(1,length(t2))];
%     [p,gca]=anova1([t1 t2],group);
%     if p>=0.05;disp(i);end
% end

% 斯皮尔曼相关系数

% 第一问(定性和定性之间不适合这种方法，不采用)
% name1=[{"纹饰"} {"种类"} {"颜色"}];
% for i=1:3
%     t=[cell2mat(data1(:,i)) cell2mat(data1(:,4))];
%     R=corr(t(:,1) , t(:,2) , 'type' , 'Spearman');
%     fprintf("%s\t与风化程度之间的斯皮尔曼相关系数为%f\n",name1{i},R)
% end
% disp(' ')

%
% 第二问
name1=[{"二氧化硅"} {"氧化纳"} {"氧化钾"} {"氧化钙"} {"氧化镁"} {"氧化铝"} {"氧化铁"} ...
    {"氧化铜"} {"氧化铅"} {"氧化钡"} {"五氧化二磷"} {"氧化锶"} {"氧化锡"} {"二氧化硫"} ];
name2=[{"铅钡玻璃"} {"高钾玻璃"}];
p1=[0.63 0.7];xg=zeros(2,5);wg=zeros(2,5);
for i=1:2
    p2=zeros(1,2);
    t1=cell2mat(data2(:,[1:2,4:end]));
    t1=t1(t1(:,1)==i,:);
    fprintf("\t---%s---\n",name2{i});
    for j=3:16
        t=[t1(:,2) t1(:,j)];
        t(t(:,2)==0,:)=[];
        R=corr(t(:,1) , t(:,2) , 'type' , 'Spearman');
        if abs(R)>p1(i)
            p2(1)=p2(1)+1; xg(i,p2(1))=j-2;
            fprintf("%s\t与风化程度之间的斯皮尔曼相关系数为%f\n",name1{j-2},R)
        else
            p2(2)=p2(2)+1; wg(i,p2(2))=j-2;
        end
    end
    disp(' ')
end

% 风化样本占比饼图
col(1,1:3)=[0.9020    0.2980    0.2118];
col(2,1:3)=[0.3020    0.7333    0.8353];
for i=1:2
    X=sum(data1(:,2)==i & data1(:,4)~=0)/sum(data1(:,2)==i)*100;
    subplot(1,2,i)
    str=[{['风化',num2str(round(X,2)),'%']},{['未风化',num2str(round(100-X,2)),'%']}];
    axe=pie([X,100-X],str);
    for j=1:2
    axe(j*2-1).EdgeColor="none";
    axe(j*2-1).FaceColor=col(j,:);
    end
    title(name2{i})
end
fig=gcf;
fig.Position=[493 529 902 420];
saveas(fig,"pictrue\T1风化样本占比饼图.png")

% 铅钡、高钾的箱线图
t0=cell2mat(data2(:,[1:2,4:end]));

for m=1:2
    t11=t0(t0(:,1)==m & t0(:,2)==0,3:end);
    t12=t0(t0(:,1)==m & t0(:,2)~=0,3:end);

    x1=[]; x2=[];
    g1=[]; g2=[];
    for i=1:14
        
        t21=t11(t11(:,i)~=0,i);
        %t21=mapminmax(t21,0,1);
        t=[x1;t21]; x1=t;
        lt21=length(t21);
        tg1=repmat(name1(i),lt21,1);
        t=[g1;tg1]; g1=t;

        t22=t12(t12(:,i)~=0,i);
        %t22=mapminmax(t22,0,1);
        t=[x2;t22]; x2=t;
        lt22=length(t22);
        tg2=repmat(name1(i),lt22,1);
        t=[g2;tg2]; g2=t;
    end
    fig=figure;
    fig.Position=[441 536 997 420];
    subplot(1,2,1); axe=gca;
    t=axe.Position;
    boxplot(x1,g1,"Colors",[0.3843 0.7098 0.9608])
    ylim([0,100]); xlabel("a)未风化的样本各化合物数据箱形图");
    ylabel(name2{m})
    subplot(1,2,2); axe=gca;
    axe.Position=[t(1)+0.4 t(2:4)];
    boxplot(x2,g2,"Colors",[0.9569 0.5647 0.4627])
    ylim([0,100]); xlabel("b)风化的样本各化合物数据箱形图");
    str=append('pictrue\T1',name2{m},'的各数据的箱形图.png');
    saveas(fig,str)
end

% 第三问 预测

% 用随机森林算法进行预测(组别不好分，失败了)
% for i=1:2
%     t=[cell2mat(data2(:,1:2)) cell2mat(data2(:,4:end))];
%     t=t(t1==i,:);
%     % 以固定种子构建随机数
%     s=RandStream('mt19937ar','Seed',15);
%     t_choose=randperm(s,length(t));
%     % 构建训练数据
%     data_train = t(t_choose(1:50),[3,4,9,11,16]);
%     data_test = t(t_choose(51:end),[3,4,9,11,16]);
%     % 第一列为分类标签
%     label_train = t(t_choose(1:50),1);
%     label_test = t(t_choose(51:end),1);
%     ntree = 100;
%     % III. 创建随机森林分类器
%     Model = TreeBagger(ntree,data_train,label_train,'Method','regression');
%     % IV. 仿真测试
%     predict_label= predict(Model, data_test);
%     errors_nn=sum(abs(predict_label-label_test)./label_test/length(label_test));
%     figure(1);hold on
%     color=[111,168,86;128,199,252;112,138,248;184,84,246]/255;
%     plot(predict_label,'o','Color',color(2,:))
%     plot(label_test,'*','Color',color(1,:))
%     legend("预测","实际")
%     title(['随机森林预测','   误差为：',num2str(errors_nn)])
% end

% 用均值比均值（结果有负数，失败了）

t1=cell2mat(data2(:,[1:2,4:end]));
roc=zeros(2,14);yc=[];
for i=1:2
    yct=[];
    t=t1(t1(:,1)==i,:);
    for j=xg(i,:)
        a=mean(t(t(:,2)==0,j+2));
        b=mean(t(t(:,2)~=0,j+2));
        roc(i,j)=a/b;
        if roc(i,j)==inf;roc(i,j)=0;end
    end
    k=(t1(:,1)==i & t1(:,2)~=0);
    yct(:,xg(i,:))=t1(k,xg(i,:)+2).*roc(i,xg(i,:));
    w=t1(t1(k,2)~=0,wg(i,:)+2)./sum(t1(t1(k,2)~=0,wg(i,:)+2),2);
    t=100+(sum(yct,2)>100)*5;
    yct(:,wg(i,:))=(t-sum(yct,2)).*w;
    yct=[data2(k,3) num2cell(yct)];
    t=[yc;yct]; yc=t; 
end

% 
% for i=1:2
%     t1=t0(t0(:,1)==i,:);  % 哪一大类的玻璃
%     wfh_mean=(t1(t1(:,1)==0,3));  % 未风化的二氧化硅均值
%     t2=t1(t1(:,1)~=0,:);  % 风化了的玻璃
%     [~,t2l]=size(t2);
%     for j=1:t2l
%         t2
%     end
% end
yc=[[{"检测点"},name1];yc];
save data_predict.mat roc xg
writecell(yc,"result\T1预测结果.xlsx")
disp("输出完成~")