% 2022.08.22

clear
now=readmatrix('../data/现有瓷砖的颜色及编号.xlsx','Range','B2:D23');
l0=length(now);save('../data/now.mat',"now")
nowlab=rgb2lab(now/255);
input=cell(1,2);inputlab=cell(1,2);l=zeros(1,2);output=cell(1,2);
input{1}=readmatrix('../data/附件2：图像1颜色列表.xlsx','Range','B2:D217');
input{2}=readmatrix('../data/附件3：图像2颜色列表.xlsx','Range','B2:D201');

for i=1:2
    figure
    inputlab{i}=rgb2lab(input{i}/255);
    l(i)=length(input{i});
    output{i}=cell(l(i)+1,1);
    for j=1:l(i)  % 遍历所有图像i中的所有颜色
        mindE=inf;
        for k=1:l0  % 遍历现有的瓷砖颜色
            dE=CA(inputlab{i}(j,:),nowlab(k,:));
            if dE<mindE  % 找出所有瓷砖颜色和此时图像颜色中色差最小的那一个编号
                mindE=dE;
                output{i}{j+1}=k;
            end
        end
        plot3(input{i}(j,1),input{i}(j,2),input{i}(j,3),'.','Color',input{i}(j,:)/255,'MarkerSize',24)
        hold on
    end
    axis padded;grid on;hold off;
    saveas(gcf,['../figure/图像',num2str(i),'在RGB空间中的颜色分布.png'])
end

for i=1:2   % 写成题目要求的格式
    output{i}{1}='序号,瓷砖颜色编号';
    for j=1:l(i)
        output{i}{j+1}=[num2str(j),',',num2str(output{i}{j+1})];
    end
end

for i=1:2
    s=fopen(['../data/result',num2str(i),'.txt'],'w');  % 输出txt文件
    for j=1:l(i)+1
        a = output{i}(j);
        a = cell2mat(a);
        fprintf(s,'%s\n',a);
    end
end

figure
for k=1:l0
    plot3(now(k,1),now(k,2),now(k,3),'.','Color',now(k,:)/255,'MarkerSize',24)
    hold on
end
axis padded;grid on;hold off;
saveas(gcf,'../figure/现有的瓷砖颜色在RGB空间中的颜色分布.png')

figure
for k=1:l0
    plot3(nowlab(k,2),nowlab(k,3),nowlab(k,1),'.','Color',now(k,:)/255,'MarkerSize',24)
    hold on
end
axis padded;grid on;hold off;
saveas(gcf,'../figure/现有的瓷砖颜色在Lab空间中的颜色分布.png')

for i=1:2
    figure
    for k=1:l(i)
        plot3(inputlab{i}(k,2),inputlab{i}(k,3),inputlab{i}(k,1),'.','Color',input{i}(k,:)/255,'MarkerSize',24)
        hold on
    end
    axis padded;grid on;hold off;
    saveas(gcf,['../figure/图像',num2str(i),'的颜色在Lab空间中的颜色分布.png'])
end
