function [MHWS] = diag_term_new(MHW,tend,year_beg)
%diag_term_new Get the start and end time of MHWs by Bian's study.
% different from Hobday(2016), but for MHW growing and decaying phase
% based on Physical drivers work period. 
% Input: 
%   MHW : MHW teble get from 'detect_new' 
%   tend: Diagnostics from Heat Budget Equation. 'tend' is the anomalous of
%   the diagnostic term by Bian Method.
% Output:
%   MHWS.r_ta: contribution the term during the growing phase 
%   MHWS.d_ta: contribution the term during the decaying phase

name = {'r_ta','d_ta'}; 
for term = 1:length(name)
    eval(['MHW.',name{term},'=zeros(size(MHW,1),1);'])
end
xloc=MHW.xloc; yloc=MHW.yloc;
MHWS=MHW(:,11:15);
period=nan(size(MHWS));
for issue=1:size(MHWS,1)
    if isnan(MHW.t2(issue)); continue; end
    ts = datenum(num2str(MHW{issue,1}),'yyyymmdd')-datenum(year_beg,1,1)+1;
    te = datenum(num2str(MHW{issue,2}),'yyyymmdd')-datenum(year_beg,1,1)+1; 
    tm=MHW.maxloc(issue);
    
    data=squeeze(tend(xloc(issue),yloc(issue),:));
    ta=3600*24*cumsum(data(ts:te)); 

    MHWS.r_ta(issue)=ta(tm);
    MHWS.d_ta(issue)=ta(end)-ta(tm);           
 end    

end
  
  



