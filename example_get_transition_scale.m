%% An example about how to get Transition Scale
% writer: Ce Bian
% Date: 2023.12.24

%% Step1: get MHWs in differnt spatial scale
% input data:
year_beg=1982; year_end=2021;
year0=1980:4:2020;

for year=1982:2021

    % daily OSST
    file=['sst.day.mean.',num2str(year),'.nc'];
    data=double(ncread(file,'sst'));
    data(abs(data)>1000)=nan;	
    
    % get SST variation in different spatial scales
    data=smooth2a_3D(data,2,2); % scale by 1X1 for example
    % data at the same point
    data=data(2:4:end,2:4:end,:);
    
    % sst time seri
    if year==year_beg
        temp=data;
    else
        temp=cat(3,temp,data);
    end
    
end

% detect MHWs
[MHW,mclim,m90,mhw_ts]=detect_new(temp,...
    datenum(year_beg,1,1):datenum(year_end,12,31),...
    datenum(year_beg,1,1),datenum(year_end,12,31),...
    datenum(year_beg,1,1),datenum(year_end,12,31));


%% Step2: Diagnostics of MHWs by Heat Budget analysis
% contributions of ADV to MHW growing and decaynig phase 
ADV=diag_term_new(MHW,p_ADV,year_beg); 

% following the upmentioned method we get the diagnostics of MHWs with
% different spatial scales and stored in file figure3&4


%% Step3: Get transitoin scale
grids={'01X01','1X1','2X2','3X3','4X4','5X5','6X6','7X7'}; 
ng=length(grids); 

for ik=1:ng
    
    A=load(['MHW_map_',grids{ik},'.mat']);
    
    % growing phase
    air_r(:,:,ik)=A.Ekadv(:,:,1)+A.Qair(:,:,1);
    ocean_r(:,:,ik)=A.Goadv(:,:,1)+A.Qocean(:,:,1);
    
    % decaying phase
    air_d(:,:,ik)=A.Ekadv(:,:,2)+A.Qair(:,:,2);
    ocean_d(:,:,ik)=A.Goadv(:,:,2)+A.Qocean(:,:,2);
    
end

% transition scale during the Growing Phase
trans_r = Transition_Scale(cat(4,air_r,ocean_r));   
% transition scale during the Decaying Phase
trans_d = Transition_Scale(cat(4,air_d,ocean_d)); 

trans=cat(2,trans_r,trans_d);
save MHW_transition_scale trans

