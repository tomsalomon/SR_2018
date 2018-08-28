clear all

okscan=[0 1 2];
test_comp=input('Are you scanning? 2 Toms_iMac, 1 MRI, 0 if testooom: ');
while isempty(test_comp) || sum(okscan==test_comp)~=1
    disp('ERROR: input must be 0,1 or 2. Please try again.');
    test_comp=input('Are you scanning? 2 Toms_iMac, 1 MRI, 0 if testooom: ');
end



if test_comp==0
    outpath='~/Documents/Boost_Israel/Output/';
elseif test_comp==2
    outpath='/Users/tomtom/Dropbox/Documents/Trained_Inhibition/Boost_Israel/Output/';
end


subjects=  [100 101 102 103 104 105 106 107 108 110 112 113 114 115 116];

%exclude:

choices=zeros(length(subjects),8);
choicesRT=zeros(length(subjects),8);
choicesNot=zeros(length(subjects),8);
choicesNotRT=zeros(length(subjects),8);





for subjInd=1:length(subjects)
      %outpath='~/Dropbox/Documents/Trained_Inhibition/Boost_Short/Output/';
    
      
      Ladder1alls=[];
Ladder2alls=[];
    
   clear Ladder1 Ladder2 respInTime respTime  
    
%    if subjects(subjInd)<100
%    
%    filename=strcat(outpath,sprintf('BM2_0%d',subjects(subjInd)));
%    
%    else
   filename=strcat(outpath,sprintf('ISF_%d',subjects(subjInd)));
 %  end
   
   logs=dir(strcat(filename, '_boostprobe','*.txt')) ;
    mats=dir(strcat(filename, '_boostprobe','*.mat')) ;
    mats_train=dir(strcat(filename, '_boost','*.mat')) ;
      load (strcat(outpath,mats(1).name));
order_probe(subjInd,1)=order;
 outpath='~/Dropbox/Documents/Trained_Inhibition/Boost_Israel/Output/';
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
    
     fclose(fid);
    end % run across subject

     
    
       average_chiocesRT=choicesRT./choices ;
    average_choicesNotRT=choicesNotRT./choicesNot;
    
    [h,p]=ttest(choices(:,1)+choices(:,5),16);
    [h,p]=ttest(choices(:,2)+choices(:,6),16);
    
    
    highs=choices(:,1)+choices(:,5);
    lows=choices(:,2)+choices(:,6);
    highs_go=choices(:,3)+choices(:,7)
highs_stop=choices(:,4)+choices(:,8)
    
highs_ratio=highs./(choices(:,1)+choices(:,5)+choicesNot(:,1)+choicesNot(:,5))
lows_ratio=lows./(choices(:,2)+choices(:,6)+choicesNot(:,2)+choicesNot(:,6))


 %   mean(lows(find(highs>16)))
 %   mean(highs(find(lows>16)))
    
    
(highs_go-mean(highs_go))/sqrt(var(highs_go));
(highs_stop-mean(highs_stop))/sqrt(var(highs_stop));


[h,p]=ttest2(lows_ratio(find(order_probe(:,1)==2)),lows_ratio(find(order_probe(:,1)==1)))
[h,p]=ttest2(highs_ratio(find(order_probe(:,1)==2)),highs_ratio(find(order_probe(:,1)==1)))
[h,p]=ttest(highs_ratio(find(order_probe(:,1)==2)),0.5)
[h,p]=ttest(highs_ratio(find(order_probe(:,1)==1)),0.5)
[h,p]=ttest(highs_ratio,0.5)
[h,p]=ttest(lows_ratio,0.5)
[h,p]=ttest(lows_ratio(find(order_probe(:,1)==2)),0.5)
[h,p]=ttest(lows_ratio(find(order_probe(:,1)==1)),0.5)    



    
   


