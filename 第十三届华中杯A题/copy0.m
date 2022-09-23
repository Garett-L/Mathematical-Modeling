% 复制并模拟基因突变变异父代DNA，产生两个子代DNA
% 2022.08.23
function chronew=copy0(chro)
lchro=size(chro);
chronew=zeros(lchro(1),3);
for i=1:lchro(1)
    for j=1:3
        t=dec2bin(chro(1,1));
        lt=length(t);
        for k=1:lt
            if rand(1,1)*3<2
                if t(k)=='1'
                    t(k)='0';
                else
                    t(k)='1';
                end
            end
        end
        chronew(i,j)=bin2dec(t);
%         t=chro(i,j)+floor(rand(1,1)*50-25);
%         if t>255
%             chronew(i,j)=255;
%         elseif t<0
%             chronew(i,j)=0;
%         else
%             chronew(i,j)=t;
%         end
    end
end

end