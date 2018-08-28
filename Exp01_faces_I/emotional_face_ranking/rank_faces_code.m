
%this function is for the ranking of the emotional level of different faces
%the function needs to have all the faces is a file called 'faces'
%the function creates an output of a mat file in which the first coloumn is
%the stimuli's numircal name, whilst the second is the randing of emotion
%from 1 (very positive) to 5 (very negative)

c = clock;
hr = sprintf('%02d', c(4));
min = sprintf('%02d', c(5));
timestamp=[date,'_',hr,'h',min,'m'];
%direct to the correct folder
faces = dir ([pwd,'\faces\*.TIF']);
Answerer_name = input ('what is your name: ', 's');
outputname=['output\Emotional_ranking_',Answerer_name, '_',timestamp,'.mat'];
% find the image file (dir function: *.TIF)
response=zeros(length(faces),2);

for i=1:length(faces)
    imshow ([pwd,'\faces\',faces(i).name]);    % show the image (imshow)
    % get response (menu function)
    response(i,1)=str2double(faces(i).name(1:3));
    response(i,2)= menu('Please rate the following face for: ','vary positive', 'positive','neutral', 'negative', 'very negative');
    close all;
end
% save the response vector - either as txt, or as mat file with timstamp, so not to run over previous results.
save (outputname,'response');
disp('Thank you!');