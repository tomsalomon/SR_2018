clear all

okscan=[0 1 2];
test_comp=input('Are you scanning? 2 Toms_iMac, 1 MRI, 0 if testooom: ');
while isempty(test_comp) || sum(okscan==test_comp)~=1
    disp('ERROR: input must be 0,1 or 2. Please try again.');
    test_comp=input('Are you scanning? 2 Toms_iMac, 1 MRI, 0 if testooom: ');
end



if test_comp==0
    outpath='~/Documents/Boost/Output/';
elseif test_comp==2
    outpath='~/Dropbox/Documents/Trained_Inhibition/Boost/Output/';
end

% 3 and 4 are good only from subject 148 but potential problem with 149.

% messed up probe until 136
%subjects=[132 133 134 135 138 139 140 142 143]
%subjects= [ 140 142 143 146 147 148 149 150 151 152 153 154] %messed up probe 3/4 until 148
%subjects= [  148 149 150 151 152 153 154  156 157 158 159 160 161 162 163 177 178 179 180 181 182 183 184 185] %messed up probe until 148. 155 didn't understand instructions of probe
subjects = [190 191];
%subjects= {'132', '133', '134', '135', '138', '139', '140', '142', 'JP_test1', 'HL_test1'} ; % % messed up probe until 136

%[58    65    67    68    69    70    71    80    81    89    92    93    94    96    98   101   102   103   105   111   112   113   114]
%subjects=  [58 59 60 65 66 67 68 69 70 71 72 75 77 78 80 81 83 84 85 87 88 89 91 92 93 94 95 96 97 98 99 100 101 102 103 104 105 106 107 108 109 110 111 112 113 114] ; % many zeros 61, many 1000 62 63. 79 - didn't stop. 82 is 40. 
%subjects=  [58 59 60 65 66 68 69 70 71 72 75 77 78 80 81 83 84 87 88 89 91 92 93 94 95 96 97 98 99 101] ; % many zeros 61, many 1000 62 63. 79 - didn't stop. 82 is 40. 

%exclude 74, 76 90 ?- negative SSRT %%%% subjects 58,59,60 - maybe bidIndex is not flipped
choices=zeros(length(subjects),8);
choicesRT=zeros(length(subjects),8);
choicesNot=zeros(length(subjects),8);
choicesNotRT=zeros(length(subjects),8);





for subjInd=1:length(subjects)
      outpath='~/Dropbox/Documents/Trained_Inhibition/Boost/Output/';
    Ladder1alls=[];
Ladder2alls=[];
    
   clear Ladder1 Ladder2 respInTime respTime  
    
%    if subjects(subjInd)<100
%    
%    filename=strcat(outpath,sprintf('BM2_0%d',subjects(subjInd)));
%    
%    else
   filename=strcat(outpath,sprintf('BM2_%d',subjects(subjInd)));
 %  end
   
   logs=dir(strcat(filename, '_boostprobe','*.txt'))
    mats=dir(strcat(filename, '_boostprobe','*.mat'))
    mats_train=dir(strcat(filename, '_antiboost','*.mat'))
   
    fid=fopen(strcat(outpath,logs(1).name));
   % load(strcat(outpath,mats_train(1).name));
    
    
% for i=1:runnum
% Ladder2alls=[Ladder2alls; Ladder2{i}];
% Ladder1alls=[Ladder1alls; Ladder1{i}];
% stops1(subjInd,i)=size(find(respInTime{i}==1),1);
% stops2(subjInd,i)=size(find(respInTime{i}==2),1);
% mean_RT_HL1(subjInd,i)=mean(respTime{i}(find(respInTime{i}==12)));
% mean_RT_HL2(subjInd,i)=mean(respTime{i}(find(respInTime{i}==24)));
% median_RT_HL1(subjInd,i)=median(respTime{i}(find(respInTime{i}==12)));
% median_RT_HL2(subjInd,i)=median(respTime{i}(find(respInTime{i}==24)));
% median_Ladders_HL1(subjInd,i)=median(Ladder1{i});
% median_Ladders_HL2(subjInd,i)=median(Ladder2{i});
% length_Ladders_HL1(subjInd,i)=length(Ladder1{i});
% length_Ladders_HL2(subjInd,i)=length(Ladder2{i});
% end
% 
% 
% Ladders1AllSubs(subjInd,:)=Ladder1alls';
% Ladders2AllSubs(subjInd,:)=Ladder2alls';
% figure 
% plot(Ladder1alls,'-')
% hold on
% plot(Ladder2alls,'r-')
% 
%     
%     
    
    
    P=textscan(fid, '%s%d%d%d%d%d%s%s%d%d%d%s%d%d%.2f%.2f%.2f' , 'HeaderLines', 1);     %read in probe output file into P ;
    
        
        
        
    for trialnum=1:length(P{12})
        
     
        
        switch P{13}(trialnum) %these are trial types
            case 1
                if strcmp(P{12}(trialnum),'u') % chose the left image
                    if P{3}(trialnum)==1 %order 1 or 2
                        choices(subjInd,P{13}(trialnum)+(P{4}(trialnum)-1)*4)=choices(subjInd,P{13}(trialnum)+(P{4}(trialnum)-1)*4)+sum(P{9}(trialnum)==[8 11 12 15]); %sum only choices of stop items
                        choicesRT(subjInd,P{13}(trialnum)+(P{4}(trialnum)-1)*4)=choicesRT(subjInd,P{13}(trialnum)+(P{4}(trialnum)-1)*4)+sum(P{9}(trialnum)==[8 11 12 15])*P{15}(trialnum)/1000; %sum only choices of stop items
            
                        choicesNot(subjInd,P{13}(trialnum)+(P{4}(trialnum)-1)*4)=choicesNot(subjInd,P{13}(trialnum)+(P{4}(trialnum)-1)*4)+sum(P{9}(trialnum)==[9 10 13 14]); %sum only choice
                        choicesNotRT(subjInd,P{13}(trialnum)+(P{4}(trialnum)-1)*4)=choicesNotRT(subjInd,P{13}(trialnum)+(P{4}(trialnum)-1)*4)+sum(P{9}(trialnum)==[9 10 13 14])*P{15}(trialnum)/1000;
                        
                    else % if order==2
                        choices(subjInd,P{13}(trialnum)+(P{4}(trialnum)-1)*4)=choices(subjInd,P{13}(trialnum)+(P{4}(trialnum)-1)*4)+sum(P{9}(trialnum)==[9 10 13 14]);
                        choicesRT(subjInd,P{13}(trialnum)+(P{4}(trialnum)-1)*4)=choicesRT(subjInd,P{13}(trialnum)+(P{4}(trialnum)-1)*4)+sum(P{9}(trialnum)==[9 10 13 14])*P{15}(trialnum)/1000;
                        
                        choicesNot(subjInd,P{13}(trialnum)+(P{4}(trialnum)-1)*4)=choicesNot(subjInd,P{13}(trialnum)+(P{4}(trialnum)-1)*4)+sum(P{9}(trialnum)==[8 11 12 15]); %sum only choice
                        choicesNotRT(subjInd,P{13}(trialnum)+(P{4}(trialnum)-1)*4)=choicesNotRT(subjInd,P{13}(trialnum)+(P{4}(trialnum)-1)*4)+sum(P{9}(trialnum)==[8 11 12 15])*P{15}(trialnum)/1000; %sum only choice
                        
                    end
                    
                 elseif strcmp(P{12}(trialnum),'i') % chose the right image
                    if P{3}(trialnum)==1 %order 1 or 2
                        choices(subjInd,P{13}(trialnum)+(P{4}(trialnum)-1)*4)=  choices(subjInd,P{13}(trialnum)+(P{4}(trialnum)-1)*4)+sum(P{10}(trialnum)==[8 11 12 15]);
                        choicesRT(subjInd,P{13}(trialnum)+(P{4}(trialnum)-1)*4)=  choicesRT(subjInd,P{13}(trialnum)+(P{4}(trialnum)-1)*4)+sum(P{10}(trialnum)==[8 11 12 15])*P{15}(trialnum)/1000;
                        
                        choicesNot(subjInd,P{13}(trialnum)+(P{4}(trialnum)-1)*4)=choicesNot(subjInd,P{13}(trialnum)+(P{4}(trialnum)-1)*4)+sum(P{10}(trialnum)==[9 10 13 14]); %sum only choice
                        choicesNotRT(subjInd,P{13}(trialnum)+(P{4}(trialnum)-1)*4)=choicesNotRT(subjInd,P{13}(trialnum)+(P{4}(trialnum)-1)*4)+sum(P{10}(trialnum)==[9 10 13 14])*P{15}(trialnum)/1000; %sum only choice
                        
                    else
                        choices(subjInd,P{13}(trialnum)+(P{4}(trialnum)-1)*4)=  choices(subjInd,P{13}(trialnum)+(P{4}(trialnum)-1)*4)+sum(P{10}(trialnum)==[9 10 13 14]);
                        choicesRT(subjInd,P{13}(trialnum)+(P{4}(trialnum)-1)*4)=  choicesRT(subjInd,P{13}(trialnum)+(P{4}(trialnum)-1)*4)+sum(P{10}(trialnum)==[9 11 13 15])*P{15}(trialnum)/1000;
                        
                        choicesNot(subjInd,P{13}(trialnum)+(P{4}(trialnum)-1)*4)=choicesNot(subjInd,P{13}(trialnum)+(P{4}(trialnum)-1)*4)+sum(P{10}(trialnum)==[8 11 12 15]); %sum only choice
                        choicesNotRT(subjInd,P{13}(trialnum)+(P{4}(trialnum)-1)*4)=choicesNotRT(subjInd,P{13}(trialnum)+(P{4}(trialnum)-1)*4)+sum(P{10}(trialnum)==[8 11 12 15])*P{15}(trialnum)/1000; %sum only choice
                        
                    end
                end
                
            case 2
                
      
                
                
                if strcmp(P{12}(trialnum),'u') % chose the left image
                    if P{3}(trialnum)==1 %order 1 or 2
                        choices(subjInd,P{13}(trialnum)+(P{4}(trialnum)-1)*4)=choices(subjInd,P{13}(trialnum)+(P{4}(trialnum)-1)*4)+sum(P{9}(trialnum)==[46 49 50 53]); %sum only choices of stop items
                        choicesRT(subjInd,P{13}(trialnum)+(P{4}(trialnum)-1)*4)=choicesRT(subjInd,P{13}(trialnum)+(P{4}(trialnum)-1)*4)+sum(P{9}(trialnum)==[46 49 50 53])*P{15}(trialnum)/1000; %sum only choices of stop items
                        
                        choicesNot(subjInd,P{13}(trialnum)+(P{4}(trialnum)-1)*4)=choicesNot(subjInd,P{13}(trialnum)+(P{4}(trialnum)-1)*4)+sum(P{9}(trialnum)==[47 48 51 52]); %sum only choice
                        choicesNotRT(subjInd,P{13}(trialnum)+(P{4}(trialnum)-1)*4)=choicesNotRT(subjInd,P{13}(trialnum)+(P{4}(trialnum)-1)*4)+sum(P{9}(trialnum)==[47 48 51 52])*P{15}(trialnum)/1000; %sum only choice
                        
                    else % if order==2
                        choices(subjInd,P{13}(trialnum)+(P{4}(trialnum)-1)*4)=choices(subjInd,P{13}(trialnum)+(P{4}(trialnum)-1)*4)+sum(P{9}(trialnum)==[47 48 51 52]);
                        choicesRT(subjInd,P{13}(trialnum)+(P{4}(trialnum)-1)*4)=choicesRT(subjInd,P{13}(trialnum)+(P{4}(trialnum)-1)*4)+sum(P{9}(trialnum)==[47 48 51 52])*P{15}(trialnum)/1000;
                        
                        choicesNot(subjInd,P{13}(trialnum)+(P{4}(trialnum)-1)*4)=choicesNot(subjInd,P{13}(trialnum)+(P{4}(trialnum)-1)*4)+sum(P{9}(trialnum)==[46 49 50 53]); %sum only choice
                        choicesNotRT(subjInd,P{13}(trialnum)+(P{4}(trialnum)-1)*4)=choicesNotRT(subjInd,P{13}(trialnum)+(P{4}(trialnum)-1)*4)+sum(P{9}(trialnum)==[46 49 50 53])*P{15}(trialnum)/1000; %sum only choice
                        
                    end
                    
                elseif strcmp(P{12}(trialnum),'i') % chose the right image
                    if P{3}(trialnum)==1 %order 1 or 2
                        choices(subjInd,P{13}(trialnum)+(P{4}(trialnum)-1)*4)=  choices(subjInd,P{13}(trialnum)+(P{4}(trialnum)-1)*4)+sum(P{10}(trialnum)==[46 49 50 53]);
                        choicesRT(subjInd,P{13}(trialnum)+(P{4}(trialnum)-1)*4)=  choicesRT(subjInd,P{13}(trialnum)+(P{4}(trialnum)-1)*4)+sum(P{10}(trialnum)==[46 49 50 53])*P{15}(trialnum)/1000;
                        
                        choicesNot(subjInd,P{13}(trialnum)+(P{4}(trialnum)-1)*4)=choicesNot(subjInd,P{13}(trialnum)+(P{4}(trialnum)-1)*4)+sum(P{10}(trialnum)==[47 48 51 52]); %sum only choice
                        choicesNotRT(subjInd,P{13}(trialnum)+(P{4}(trialnum)-1)*4)=choicesNotRT(subjInd,P{13}(trialnum)+(P{4}(trialnum)-1)*4)+sum(P{10}(trialnum)==[47 48 51 52])*P{15}(trialnum)/1000; %sum only choice
                        
                    else
                        choices(subjInd,P{13}(trialnum)+(P{4}(trialnum)-1)*4)=  choices(subjInd,P{13}(trialnum)+(P{4}(trialnum)-1)*4)+sum(P{10}(trialnum)==[47 48 51 52]);
                        choicesRT(subjInd,P{13}(trialnum)+(P{4}(trialnum)-1)*4)=  choicesRT(subjInd,P{13}(trialnum)+(P{4}(trialnum)-1)*4)+sum(P{10}(trialnum)==[47 48 51 52])*P{15}(trialnum)/1000;
                        
                        choicesNot(subjInd,P{13}(trialnum)+(P{4}(trialnum)-1)*4)=choicesNot(subjInd,P{13}(trialnum)+(P{4}(trialnum)-1)*4)+sum(P{10}(trialnum)==[46 49 50 53]); %sum only choice
                        choicesNotRT(subjInd,P{13}(trialnum)+(P{4}(trialnum)-1)*4)=choicesNotRT(subjInd,P{13}(trialnum)+(P{4}(trialnum)-1)*4)+sum(P{10}(trialnum)==[46 49 50 53])*P{15}(trialnum)/1000; %sum only choice
                        
                    end
                end
                
                
       
                
                
            case 3
                if strcmp(P{12}(trialnum),'u') % chose the left image
                    if P{3}(trialnum)==1 %order 1 or 2
                        choices(subjInd,P{13}(trialnum)+(P{4}(trialnum)-1)*4)=choices(subjInd,P{13}(trialnum)+(P{4}(trialnum)-1)*4)+sum(P{9}(trialnum)==[16 19 20 23]); %sum only choices of stop items
                        choicesRT(subjInd,P{13}(trialnum)+(P{4}(trialnum)-1)*4)=choicesRT(subjInd,P{13}(trialnum)+(P{4}(trialnum)-1)*4)+sum(P{9}(trialnum)==[16 19 20 23])*P{15}(trialnum)/1000; %sum only choices of stop items
                        
                        choicesNot(subjInd,P{13}(trialnum)+(P{4}(trialnum)-1)*4)=choicesNot(subjInd,P{13}(trialnum)+(P{4}(trialnum)-1)*4)+sum(P{9}(trialnum)==[38 41 42 45]); %sum only choice
                        choicesNotRT(subjInd,P{13}(trialnum)+(P{4}(trialnum)-1)*4)=choicesNotRT(subjInd,P{13}(trialnum)+(P{4}(trialnum)-1)*4)+sum(P{9}(trialnum)==[38 41 42 45])*P{15}(trialnum)/1000; %sum only choice
                        
                    else % if order==2
                        choices(subjInd,P{13}(trialnum)+(P{4}(trialnum)-1)*4)=choices(subjInd,P{13}(trialnum)+(P{4}(trialnum)-1)*4)+sum(P{9}(trialnum)==[17 18 21 22]);
                        choicesRT(subjInd,P{13}(trialnum)+(P{4}(trialnum)-1)*4)=choicesRT(subjInd,P{13}(trialnum)+(P{4}(trialnum)-1)*4)+sum(P{9}(trialnum)==[17 18 21 22])*P{15}(trialnum)/1000;
                        
                        choicesNot(subjInd,P{13}(trialnum)+(P{4}(trialnum)-1)*4)=choicesNot(subjInd,P{13}(trialnum)+(P{4}(trialnum)-1)*4)+sum(P{9}(trialnum)==[39 40 43 44]); %sum only choice
                        choicesNotRT(subjInd,P{13}(trialnum)+(P{4}(trialnum)-1)*4)=choicesNotRT(subjInd,P{13}(trialnum)+(P{4}(trialnum)-1)*4)+sum(P{9}(trialnum)==[39 40 43 44])*P{15}(trialnum)/1000; %sum only choice
                        
                    end
                    
                    
                 elseif strcmp(P{12}(trialnum),'i')  % chose the right image
                    if P{3}(trialnum)==1 %order 1 or 2
                        choices(subjInd,P{13}(trialnum)+(P{4}(trialnum)-1)*4)=  choices(subjInd,P{13}(trialnum)+(P{4}(trialnum)-1)*4)+sum(P{10}(trialnum)==[16 19 20 23]);
                        choicesRT(subjInd,P{13}(trialnum)+(P{4}(trialnum)-1)*4)=  choicesRT(subjInd,P{13}(trialnum)+(P{4}(trialnum)-1)*4)+sum(P{10}(trialnum)==[16 19 20 23])*P{15}(trialnum)/1000;
                        
                        choicesNot(subjInd,P{13}(trialnum)+(P{4}(trialnum)-1)*4)=choicesNot(subjInd,P{13}(trialnum)+(P{4}(trialnum)-1)*4)+sum(P{10}(trialnum)==[38 41 42 45]); %sum only choice
                        choicesNotRT(subjInd,P{13}(trialnum)+(P{4}(trialnum)-1)*4)=choicesNotRT(subjInd,P{13}(trialnum)+(P{4}(trialnum)-1)*4)+sum(P{10}(trialnum)==[38 41 42 45])*P{15}(trialnum)/1000; %sum only choice
                        
                    else
                        choices(subjInd,P{13}(trialnum)+(P{4}(trialnum)-1)*4)=  choices(subjInd,P{13}(trialnum)+(P{4}(trialnum)-1)*4)+sum(P{10}(trialnum)==[17 18 21 22]);
                        choicesRT(subjInd,P{13}(trialnum)+(P{4}(trialnum)-1)*4)=  choicesRT(subjInd,P{13}(trialnum)+(P{4}(trialnum)-1)*4)+sum(P{10}(trialnum)==[17 18 21 22])*P{15}(trialnum)/1000;
                        
                        choicesNot(subjInd,P{13}(trialnum)+(P{4}(trialnum)-1)*4)=choicesNot(subjInd,P{13}(trialnum)+(P{4}(trialnum)-1)*4)+sum(P{10}(trialnum)==[39 40 43 44]); %sum only choice
                        choicesNotRT(subjInd,P{13}(trialnum)+(P{4}(trialnum)-1)*4)=choicesNotRT(subjInd,P{13}(trialnum)+(P{4}(trialnum)-1)*4)+sum(P{10}(trialnum)==[39 40 43 44])*P{15}(trialnum)/1000; %sum only choice
                        
                    end
                end
                
            case 4
                if strcmp(P{12}(trialnum),'u') % chose the left image
                    if P{3}(trialnum)==1 %order 1 or 2
                        choices(subjInd,P{13}(trialnum)+(P{4}(trialnum)-1)*4)=choices(subjInd,P{13}(trialnum)+(P{4}(trialnum)-1)*4)+sum(P{9}(trialnum)==[17 18 21 22]); %sum only choices of stop items
                        choicesRT(subjInd,P{13}(trialnum)+(P{4}(trialnum)-1)*4)=choicesRT(subjInd,P{13}(trialnum)+(P{4}(trialnum)-1)*4)+sum(P{9}(trialnum)==[17 18 21 22])*P{15}(trialnum)/1000; %sum only choices of stop items
                        
                        choicesNot(subjInd,P{13}(trialnum)+(P{4}(trialnum)-1)*4)=choicesNot(subjInd,P{13}(trialnum)+(P{4}(trialnum)-1)*4)+sum(P{9}(trialnum)==[39 40 43 44]); %sum only choice
                        choicesNotRT(subjInd,P{13}(trialnum)+(P{4}(trialnum)-1)*4)=choicesNotRT(subjInd,P{13}(trialnum)+(P{4}(trialnum)-1)*4)+sum(P{9}(trialnum)==[39 40 43 44])*P{15}(trialnum)/1000; %sum only choice
                    else % if order==2
                        choices(subjInd,P{13}(trialnum)+(P{4}(trialnum)-1)*4)=choices(subjInd,P{13}(trialnum)+(P{4}(trialnum)-1)*4)+sum(P{9}(trialnum)==[16 19 20 23]);
                        choicesRT(subjInd,P{13}(trialnum)+(P{4}(trialnum)-1)*4)=choicesRT(subjInd,P{13}(trialnum)+(P{4}(trialnum)-1)*4)+sum(P{9}(trialnum)==[16 19 20 23])*P{15}(trialnum)/1000;
                        
                        choicesNot(subjInd,P{13}(trialnum)+(P{4}(trialnum)-1)*4)=choicesNot(subjInd,P{13}(trialnum)+(P{4}(trialnum)-1)*4)+sum(P{9}(trialnum)==[38 41 42 45]); %sum only choice
                        choicesNotRT(subjInd,P{13}(trialnum)+(P{4}(trialnum)-1)*4)=choicesNotRT(subjInd,P{13}(trialnum)+(P{4}(trialnum)-1)*4)+sum(P{9}(trialnum)==[38 41 42 45])*P{15}(trialnum)/1000; %sum only choice
                    end
                    
                elseif strcmp(P{12}(trialnum),'i') % chose the right image
                    if P{3}(trialnum)==1 %order 1 or 2
                        choices(subjInd,P{13}(trialnum)+(P{4}(trialnum)-1)*4)=  choices(subjInd,P{13}(trialnum)+(P{4}(trialnum)-1)*4)+sum(P{10}(trialnum)==[17 18 21 22]);
                        choicesRT(subjInd,P{13}(trialnum)+(P{4}(trialnum)-1)*4)=  choicesRT(subjInd,P{13}(trialnum)+(P{4}(trialnum)-1)*4)+sum(P{10}(trialnum)==[17 18 21 22])*P{15}(trialnum)/1000;
                        
                        choicesNot(subjInd,P{13}(trialnum)+(P{4}(trialnum)-1)*4)=choicesNot(subjInd,P{13}(trialnum)+(P{4}(trialnum)-1)*4)+sum(P{10}(trialnum)==[39 40 43 44]); %sum only choice
                        choicesNotRT(subjInd,P{13}(trialnum)+(P{4}(trialnum)-1)*4)=choicesNotRT(subjInd,P{13}(trialnum)+(P{4}(trialnum)-1)*4)+sum(P{10}(trialnum)==[39 40 43 44])*P{15}(trialnum)/1000; %sum only choice
                        
                    else
                        choices(subjInd,P{13}(trialnum)+(P{4}(trialnum)-1)*4)=  choices(subjInd,P{13}(trialnum)+(P{4}(trialnum)-1)*4)+sum(P{10}(trialnum)==[16 19 20 23]);
                        choicesRT(subjInd,P{13}(trialnum)+(P{4}(trialnum)-1)*4)=  choicesRT(subjInd,P{13}(trialnum)+(P{4}(trialnum)-1)*4)+sum(P{10}(trialnum)==[16 19 20 23])*P{15}(trialnum)/1000;
                        
                        choicesNot(subjInd,P{13}(trialnum)+(P{4}(trialnum)-1)*4)=choicesNot(subjInd,P{13}(trialnum)+(P{4}(trialnum)-1)*4)+sum(P{10}(trialnum)==[38 41 42 45]); %sum only choice
                        choicesNotRT(subjInd,P{13}(trialnum)+(P{4}(trialnum)-1)*4)=choicesNotRT(subjInd,P{13}(trialnum)+(P{4}(trialnum)-1)*4)+sum(P{10}(trialnum)==[38 41 42 45])*P{15}(trialnum)/1000; %sum only choice
                    end
                end
                
                
                
                
                
                
                
        end % end switch trialtype
        
    end % end run across all trials
    
    
    end % run across subject

    average_chiocesRT=choicesRT./choices ;
    average_choicesNotRT=choicesNotRT./choicesNot;
    
    [h,p]=ttest(choices(:,1)+choices(:,5),16)
    [h,p]=ttest(choices(:,2)+choices(:,6),16)
    
    %    choicesNot(:,1)+choicesNot(:,5)+choicesNot(:,9)+choicesNot(:,13)+choicesNot(:,17)
    
    fclose(fid);


