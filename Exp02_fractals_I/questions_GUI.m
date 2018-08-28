function varargout = questions_GUI(varargin)
% QUESTIONS_GUI MATLAB code for questions_GUI.fig
%      QUESTIONS_GUI, by itself, creates a new QUESTIONS_GUI or raises the existing
%      singleton*.
%
%      H = QUESTIONS_GUI returns the handle to a new QUESTIONS_GUI or the handle to
%      the existing singleton*.
%
%      QUESTIONS_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in QUESTIONS_GUI.M with the given input arguments.
%
%      QUESTIONS_GUI('Property','Value',...) creates a new QUESTIONS_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before questions_GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to questions_GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help questions_GUI

% Last Modified by GUIDE v2.5 18-May-2015 15:36:36

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @questions_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @questions_GUI_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before questions_GUI is made visible.
function questions_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to questions_GUI (see VARARGIN)

% Choose default command line output for questions_GUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
Answers = cell(10,1)
% UIWAIT makes questions_GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = questions_GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes when selected object is changed in Q1.
function Q1_SelectionChangedFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in Q1 
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Answers{1}=get(eventdata.NewValue,'Tag')
