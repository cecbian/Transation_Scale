function [trans] = Transition_Scale(data)
%Transition_Scale: get transition scale
%   Writer: Ce Bian
%   Date: 2023/12/24

[~,p]=max(data,[],4);
[nx,ny,nc]=size(p); 

trans=nan(nx,ny);
for j=1:ny
    for i=1:nx
        pp=squeeze(p(i,j,:));
        if isnan(pp(1)) 
            continue
        else
            ppp=pp(2:end)-pp(1:end-1);
            trans(i,j)=find(ppp==1,1,'first')+1; % transition scale           
        end
    end
end
end

