% 2022.08.22
clear

for n=9%1:10
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
        plot(i,max(evenness,evenness0),'.','Color','b');hold on
        i=i+1;
    end
    axis padded;grid on;hold off;
    saveas(gcf,['../figure/新增',num2str(n),'种颜色时的遗传算法迭代结果示意图.png'])

    load('../data/now.mat','now')
    now0=[chro;now];figure
    now0lab=rgb2lab([chro;now]/255);

    l2=length(now0lab);
    for k=1:lchro(1)
        plot3(now0lab(k,2),now0lab(k,3),now0lab(k,1),'.','Color',now0(k,:)/255,'MarkerSize',48)
        hold on
    end
    for k=lchro(1)+1:l2
        plot3(now0lab(k,2),now0lab(k,3),now0lab(k,1),'.','Color',now0(k,:)/255,'MarkerSize',24)
        hold on
    end
    axis padded;grid on;hold off;
    saveas(gcf,['../figure/新增',num2str(n),'种颜色后的瓷砖颜色在Lab空间中的颜色分布.png'])
   
    l2=length(now0);
    for k=1:lchro(1)
        plot3(now0(k,1),now0(k,2),now0(k,3),'.','Color',now0(k,:)/255,'MarkerSize',48)
        hold on
    end
    for k=lchro(1)+1:l2
        plot3(now0(k,1),now0(k,2),now0(k,3),'.','Color',now0(k,:)/255,'MarkerSize',24)
        hold on
    end
    axis padded;grid on;hold off;
    saveas(gcf,['../figure/新增',num2str(n),'种颜色后的瓷砖颜色在RGB空间中的颜色分布.png'])

end
