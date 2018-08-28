function [Tbl]=readtable_new(file,delimiter)
if nargin<2
    delimiter='\t';
end

fid = fopen(file, 'r');
str = fgetl(fid);
fclose(fid);
vars = regexp(str,delimiter, 'split');
if isempty(vars{end}) % delete any last empty cols
   vars(end)=[] ;
end
vars=matlab.lang.makeValidName(vars);
Tbl = readtable(file, 'delimiter', delimiter, 'headerlines', 1, 'readvariablenames', false);
while sum(isnan(Tbl{:,end}))==length(Tbl{:,end}) % delete any last empty cols
   Tbl(:,end)=[] ;
end
Tbl.Properties.VariableNames = vars;

end
