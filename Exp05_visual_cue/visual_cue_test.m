                                                                                                                          % Clear the workspace
close all;
clear all;
sca;
 
% Here we call some default settings for setting up Psychtoolbox
PsychDefaultSetup(2);
 
% Get the screen numbers
screens = Screen('Screens');
 
% Skip sync tests for demos purposes only
Screen('Preference', 'SkipSyncTests', 2);
 
% Draw to the external screen if avaliable
screenNumber = max(screens);
 
% Define black and white
white = WhiteIndex(screenNumber);
black = BlackIndex(screenNumber);
grey = white / 2;
inc = white - grey;
 
% Open an on screen window
[w, windowRect] = Screen  ('OpenWindow', screenNumber,[],[]);

black = BlackIndex(w); % Should equal 0.
white = WhiteIndex(w); % Should equal 255.
Green = [0 255 0];

Screen('FillRect', w, black);  % NB: only need to do this once!
Screen('Flip', w);

% Get the size of the on screen window
[screenXpixels, screenYpixels] = Screen('WindowSize', w);
 
% Query the frame duration
ifi = Screen('GetFlipInterval', w);
 
% Get the centre coordinate of the window
[xCenter, yCenter] = RectCenter(windowRect);
 
% Set up alpha-blending
Screen('BlendFunction', w, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');
 
% Load background image
images=dir(['./stim/*.bmp']);
 
% Load cue image
CueImageLocation = ['./Misc/gabor_cue.png'];
[CueImage, ~, CueImageAlpha] = imread(CueImageLocation);

%Go over all the images - present the image and then present the same
%image with a cue
for i=1:length(images)   
    % load the image
backImageLocation = ['./stim/' images(i).name];
theImage = imread(backImageLocation);

% Place the transparency layer of the foreground image into the 4th (alpha) 
% image plane. This is the bit which is needed, else the tranparent
% background will be non-transparent
transparencyFactor=0.7  ;  %change this factor to manipulate cue's transparency
CueImage(:, :, 4) = CueImageAlpha*transparencyFactor    ;
  
% Get the size of the Cue
[s1, s2, s3] = size(CueImage);
 
% Scale the destination rectangle up to make the foreground image bigger 
% (the key image is small, so we scale it here else it is hard to see)
scaleFactor = 1.4    ; %change this factor to manipulate cue's size
dstRect = CenterRectOnPointd([0 0 s2 s1] .* scaleFactor,...
    screenXpixels / 2, screenYpixels / 2);
 
% Make the image into a texture
imageTexture = Screen('MakeTexture', w, theImage);
imageTextureCue = Screen('MakeTexture', w, CueImage);
 
% Draw the background image
Screen('DrawTextures', w, imageTexture, [], [], 0);
  
% Flip to the screen
Screen('Flip', w);
 
% Wait for a keypress
KbStrokeWait;  

% Draw the background image
Screen('DrawTextures', w, imageTexture, [], [], 0);
 
% Draw the Cue image
Screen('DrawTextures', w, imageTextureCue, [], dstRect, 0);
 
% Flip to the screen
Screen('Flip', w);
 
% Wait for a keypress
KbStrokeWait;
end
 
 
% Clear the screen
sca;