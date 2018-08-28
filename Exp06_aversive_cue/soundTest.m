function [] = soundTest()

%



% set the random generator
rng shuffle

%---------------------------------------------------------
%%  'SCRIPT VERSION'
%---------------------------------------------------------
% notes = ('Design developed by Schonberg, Bakkour and Poldrack, inspired by Boynton');
script_name = 'Boost_behavioral_Israel';
script_version='1';
revision_date='05-13-2015';
fprintf('%s %s (revised %s)\n',script_name,script_version,revision_date);

%---------------------------------------------------------------
%%   'GLOBAL VARIABLES'
%---------------------------------------------------------------

% outputPath = [mainPath '/Output'];

% about timing
c = clock;
hr = sprintf('%02d', c(4));
minutes = sprintf('%02d', c(5));
timestamp = [date,'_',hr,'h',minutes,'m'];

% about ladders
Step = 50;

% about timing
image_duration = 1; %because stim duration is 1.5 secs in opt_stop
baseline_fixation = 1;
afterrunfixation = 1;

% ladders
if nargin < 8
    Ladder1IN = 750;
    Ladder2IN = 750;
end




WaitSecs(1);
HideCursor;

% -------------------------------------------------------
%% 'Sound settings'
%%---------------------------------------------------------------

load('Misc/soundfile.mat');

wave = cot(1:0.25:7541);
freq = 100544;
nrchannels = size(wave,1);

deviceID = -1;
% Audio = audioplayer(wave,freq);

reqlatencyclass = 2; % class 2 empirically the best, 3 & 4 == 2

% Initialize driver, request low-latency preinit:
InitializePsychSound(1);

% % Open audio device for low-latency output:
pahandle = PsychPortAudio('Open', deviceID, [], reqlatencyclass, freq, nrchannels);
PsychPortAudio('RunMode', pahandle, 1);

%Play the sound
% play(Audio);
PsychPortAudio('FillBuffer', pahandle, wave);
PsychPortAudio('Start', pahandle, 1, 0, 0);
WaitSecs(1.5);

% Close the sound and open a new port for the next sound with low latency

% % PsychPortAudio('Stop', pahandle);
PsychPortAudio('Close', pahandle);
pahandle = PsychPortAudio('Open', deviceID, [], reqlatencyclass, freq, nrchannels);
PsychPortAudio('RunMode', pahandle, 1);
PsychPortAudio('FillBuffer', pahandle, wave);

PsychPortAudio('Start', pahandle, 1, 0, 0);
WaitSecs(1.5);

PsychPortAudio('Close', pahandle);
pahandle = PsychPortAudio('Open', deviceID, [], reqlatencyclass, freq, nrchannels);
PsychPortAudio('RunMode', pahandle, 1);
PsychPortAudio('FillBuffer', pahandle, wave);

PsychPortAudio('Start', pahandle, 1, 0, 0);
WaitSecs(1.5);

PsychPortAudio('Close', pahandle);

end