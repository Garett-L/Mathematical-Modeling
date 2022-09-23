% 选择一个子代DNA成为父代
% 2022.08.22
function [chro,evenness]=choose0(progeny1,progeny2)

load('../data/now.mat','now')

% 第一种想法：在RGB空间中把两两点的距离都求一遍，把每个点与其他点距离最小的求和
x1=[progeny1;now];x2=[progeny2;now];
l=length(x1);s1=0;s2=0;
for i=1:l
    rmin1=inf;rmin2=inf;
    t1=x1;t1(i,:)=[];
    t2=x2;t2(i,:)=[];
    for j=1:l-1
        r1=(x1(i,1)-t1(j,1))^2+(x1(i,2)-t1(j,2))^2+(x1(i,3)-t1(j,3))^2;
        r2=(x2(i,1)-t2(j,1))^2+(x2(i,2)-t2(j,2))^2+(x2(i,3)-t2(j,3))^2;
        if r1<rmin1;rmin1=r1;end
        if r2<rmin2;rmin2=r2;end
    end
    s1=s1+rmin1;
    s2=s2+rmin2;
end

% 第二种想法：根据新增的颜色和原有颜色两两之间的色差之和越大越好的原则（效果很差）
% t1=rgb2lab([progeny1;now]/255);t2=rgb2lab([progeny2;now]/255);
% lprogeny=length(progeny1);lt=length(t1);
% s1=0;s2=0;
% for i=1:lprogeny
%     for j=i+1:lt
%         s1=s1+CA(t1(i,:),t1(j,:));
%         s2=s2+CA(t2(i,:),t2(j,:));
%     end
% end

% 第三种想法：在Lab空间中把两两点的距离都求一遍，把每个点与其他点距离最小的求和
% x1=rgb2lab([progeny1;now]/255);x2=rgb2lab([progeny2;now]/255);
% l=length(x1);s1=0;s2=0;
% for i=1:l
%     rmin1=inf;rmin2=inf;
%     t1=x1;t1(i,:)=[];
%     t2=x2;t2(i,:)=[];
%     for j=1:l-1
%         r1=(x1(i,1)-t1(j,1))^2+(x1(i,2)-t1(j,2))^2+(x1(i,3)-t1(j,3))^2;
%         r2=(x2(i,1)-t2(j,1))^2+(x2(i,2)-t2(j,2))^2+(x2(i,3)-t2(j,3))^2;
%         if r1<rmin1;rmin1=r1;end
%         if r2<rmin2;rmin2=r2;end
%     end
%     s1=s1+rmin1;
%     s2=s2+rmin2;
% end

if s1>s2
    chro=progeny1;
    evenness=s1;
else
    chro=progeny2;
    evenness=s2;
end

end