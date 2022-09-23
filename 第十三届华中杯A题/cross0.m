% 变异两个子代DNA
% 2022.08.23
function [progeny1,progeny2]=cross0(chro,chronew)
lchro=size(chro);
progeny1=chro;
progeny2=chronew;

t1=[floor(chro*rand(1,1)),255-chro];
t2=[floor(chronew*rand(1,1)),255-chronew];
for i=1:lchro(1)
    ind=randperm(6);
    progeny1(i,:)=t1(i,ind(1:3));
    progeny2(i,:)=t2(i,ind(1:3));
end

% 不同的基因换位，发现效果不太好
% if round(rand(1,1))
%     l=randperm(lchro(1));
%     lt=ceil(l/2);
%     for i=1:lt
%         tmp=progeny1(lt(i),:);
%         progeny1(lt(i),:)=progeny2(lt(i),:);
%         progeny2(lt(i),:)=tmp;
%     end
% end
end