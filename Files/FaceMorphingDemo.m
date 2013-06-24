function varargout = FaceMorphingDemo(varargin)
% FACEMORPHINGDEMO MATLAB code for FaceMorphingDemo.fig
%      FACEMORPHINGDEMO, by itself, creates a new FACEMORPHINGDEMO or raises the existing
%      singleton*.
%
%      H = FACEMORPHINGDEMO returns the handle to a new FACEMORPHINGDEMO or the handle to
%      the existing singleton*.
%
%      FACEMORPHINGDEMO('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FACEMORPHINGDEMO.M with the given input arguments.
%
%      FACEMORPHINGDEMO('Property','Value',...) creates a new FACEMORPHINGDEMO or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before FaceMorphingDemo_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to FaceMorphingDemo_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help FaceMorphingDemo

% Last Modified by GUIDE v2.5 22-May-2013 15:46:55

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @FaceMorphingDemo_OpeningFcn, ...
                   'gui_OutputFcn',  @FaceMorphingDemo_OutputFcn, ...
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


% --- Executes just before FaceMorphingDemo is made visible.
function FaceMorphingDemo_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to FaceMorphingDemo (see VARARGIN)

% Choose default command line output for FaceMorphingDemo
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes FaceMorphingDemo wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = FaceMorphingDemo_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

function FileMenu_Callback(hObject, eventdata, handles)
% hObject    handle to FileMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% --------------------------------------------------------------------

% --- Executes on button press in OpenFace1.
function OpenFace1_Callback(hObject, eventdata, handles)
% hObject    handle to OpenFace1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clc;
[filename ,pathname]=uigetfile({'*.jpg';'*.bmp';'*.tif';'*.gif'},'Choose Image');
if filename==0
    return;
else
    str=[pathname filename];
    Im=imread(str);
    global Face1;
    Face1=Im;
    axes(handles.axes1);
    cla;
    imshow(Face1);
end

% --- Executes on button press in OpenFace2.
function OpenFace2_Callback(hObject, eventdata, handles)
% hObject    handle to OpenFace2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clc;
[filename ,pathname]=uigetfile({'*.jpg';'*.bmp';'*.tif';'*.gif'},'Choose Image');
if filename==0
    return;
else
    str=[pathname filename];
    Im=imread(str);
    global Face2;
    Face2=Im;
    axes(handles.axes2);
    cla;
    imshow(Face2);
end

% --- Executes on button press in DetectFace.
function DetectFace_Callback(hObject, eventdata, handles)
% hObject    handle to DetectFace (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clc;
global Face1;
global Face2;
[M1,N1,P] = size(Face1);
[M2,N2,P] = size(Face2);
M = min([M1,M2]);
N = min([N1,N2]);
M = 320;
N = 240;
global Face1;
Face1 = imresize(Face1,[M,N]);
global Face2;
Face2 = imresize(Face2,[M,N]);
global f1_eye1 f1_eye2 f1_mouth;
[f1_eye1,f1_eye2,f1_mouth,f1show] = EyeMouthD(Face1);
global f2_eye1 f2_eye2 f2_mouth;
[f2_eye1,f2_eye2,f2_mouth,f2show] = EyeMouthD(Face2);
axes(handles.axes3);
cla;
global Face1Handle;
Face1Handle = imshow(f1show,[]);
axes(handles.axes4);
cla;
global Face2Handle;
Face2Handle = imshow(f2show,[]);


% --- Executes on button press in Morphing.
function Morphing_Callback(hObject, eventdata, handles)
% hObject    handle to Morphing (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clc;
global Face1;
global Face2;
global f1_eye1 f1_eye2 f1_mouth; 
global f2_eye1 f2_eye2 f2_mouth;
alpha = str2double(get(handles.alpha,'String'));
interf_eye1 = alpha*f1_eye1+(1-alpha)*f2_eye1;
interf_eye2 = alpha*f1_eye2+(1-alpha)*f2_eye2;
interf_mouth = alpha*f1_mouth+(1-alpha)*f2_mouth;
face1t = CoTrans(double(Face1),[f1_eye1;f1_eye2;f1_mouth],[interf_eye1;interf_eye2;interf_mouth]);
face2t = CoTrans(double(Face2),[f2_eye1;f2_eye2;f2_mouth],[interf_eye1;interf_eye2;interf_mouth]);
im = face1t*alpha+(1-alpha)*face2t;
axes(handles.axes5);
cla;
imshow(im,[]);

% --- Executes on button press in ShowVideo.
function ShowVideo_Callback(hObject, eventdata, handles)
% hObject    handle to ShowVideo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clc;
global Face1;
global Face2;
global f1_eye1 f1_eye2 f1_mouth; 
global f2_eye1 f2_eye2 f2_mouth;
open('Video.fig');
h = guihandles;
vidObj = VideoWriter('FaceMorphing.avi');
% filename = 'FaceMorphing.gif';
% i = 1;
open(vidObj);
% for alpha = 0:0.1:1
for alpha = 0:0.05:1
    interf_eye1 = alpha*f1_eye1+(1-alpha)*f2_eye1;
    interf_eye2 = alpha*f1_eye2+(1-alpha)*f2_eye2;
    interf_mouth = alpha*f1_mouth+(1-alpha)*f2_mouth;
    face1t = CoTrans(double(Face1),[f1_eye1;f1_eye2;f1_mouth],[interf_eye1;interf_eye2;interf_mouth]);
    face2t = CoTrans(double(Face2),[f2_eye1;f2_eye2;f2_mouth],[interf_eye1;interf_eye2;interf_mouth]);
    im = face1t*alpha+(1-alpha)*face2t;
    axes(h.axes1);
    imshow(im,[]);
%     pause(0.05);
    currFrame = getframe;
%     im = frame2im(currFrame);
%     [imind,cm] = rgb2ind(im,256);
%     if i == 1
%         imwrite(imind,cm,filename,'gif', 'Loopcount',inf);
%     else
%         imwrite(imind,cm,filename,'gif','WriteMode','append');
%     end
%     i = i+1;
    for j=1:5
        writeVideo(vidObj,currFrame);
    end
end
close(vidObj);

% --------------------------------------------------------------------
function Help_Callback(hObject, eventdata, handles)
% hObject    handle to Help (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
msgbox({'This Demo is developed by Yinjie Huang from University of Central Florida Machine Learning Lab.';'';...
    'This Demo is used to show a simple Face Morphing algorithm.';'';...
    'First open two images Face 1 & Face 2. Click the button to automatically detect eyes and mouth. '
    'Sometimes the detection algorithm fails because of glasses or shadow, you could fix the eyes and mouth for each face. For example, click Left Eye button, then use mouse click the center of left eye in the image, then click Left Eye button again.'
    'After you manually select the eyes or mouth click Done button to see the detection results.';'';...
    'Set the alpha value and click Morphing button you will see the face morphing result';'';...
    'You could also click Show Video button to watch the morphing results from one face to another. Video is saved as AVI format.'});


% --- Executes on button press in Face1LeftEye.
function Face1LeftEye_Callback(hObject, eventdata, handles)
% hObject    handle to Face1LeftEye (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clc;
global Face1Handle;
global coordinates;
set(Face1Handle,'ButtonDownFcn',@ImageClickCallback);
global f1_eye1 f1_eye2 f1_mouth;
f1_eye1(1) = round(coordinates(2));
f1_eye1(2) = round(coordinates(1));

% --- Executes on button press in Face1RughtEye.
function Face1RughtEye_Callback(hObject, eventdata, handles)
% hObject    handle to Face1RughtEye (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clc;
global Face1Handle;
global coordinates;
set(Face1Handle,'ButtonDownFcn',@ImageClickCallback);
global f1_eye1 f1_eye2 f1_mouth;
f1_eye2(1) = round(coordinates(2));
f1_eye2(2) = round(coordinates(1));

% --- Executes on button press in Face1Mouth.
function Face1Mouth_Callback(hObject, eventdata, handles)
% hObject    handle to Face1Mouth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clc;
global Face1Handle;
global coordinates;
set(Face1Handle,'ButtonDownFcn',@ImageClickCallback);
global f1_eye1 f1_eye2 f1_mouth;
f1_mouth(1) = round(coordinates(2));
f1_mouth(2) = round(coordinates(1));

% --- Executes on button press in Face2LeftEye.
function Face2LeftEye_Callback(hObject, eventdata, handles)
% hObject    handle to Face2LeftEye (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clc;
global Face2Handle;
global coordinates;
set(Face2Handle,'ButtonDownFcn',@ImageClickCallback);
global f2_eye1 f2_eye2 f2_mouth;
f2_eye1(1) = round(coordinates(2));
f2_eye1(2) = round(coordinates(1));

% --- Executes on button press in Face2RightEye.
function Face2RightEye_Callback(hObject, eventdata, handles)
% hObject    handle to Face2RightEye (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clc;
global Face2Handle;
global coordinates;
set(Face2Handle,'ButtonDownFcn',@ImageClickCallback);
global f2_eye1 f2_eye2 f2_mouth;
f2_eye2(1) = round(coordinates(2));
f2_eye2(2) = round(coordinates(1));

% --- Executes on button press in Face2Mouth.
function Face2Mouth_Callback(hObject, eventdata, handles)
% hObject    handle to Face2Mouth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clc;
global Face2Handle;
global coordinates;
set(Face2Handle,'ButtonDownFcn',@ImageClickCallback);
global f2_eye1 f2_eye2 f2_mouth;
f2_mouth(1) = round(coordinates(2));
f2_mouth(2) = round(coordinates(1));

% --- Executes on button press in Face1Done.
function Face1Done_Callback(hObject, eventdata, handles)
% hObject    handle to Face1Done (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clc;
global Face1;
[M,N,P] = size(Face1);
global f1_eye1 f1_eye2 f1_mouth;

theta = atan((f1_eye1(1)-f1_eye2(1))/(f1_eye2(2)-f1_eye1(2)));
halfl = round(N/9);
halfw = round(N/18);
luc = [f1_eye1(1)-halfw,f1_eye1(2)-halfl];
ruc = [f1_eye1(1)-halfw,f1_eye1(2)+halfl];
llc = [f1_eye1(1)+halfw,f1_eye1(2)-halfl];
rlc = [f1_eye1(1)+halfw,f1_eye1(2)+halfl];
global Face1;
showim = Face1;
showim = makegreen(showim,luc,ruc,llc,rlc,theta);
luc = [f1_eye2(1)-halfw,f1_eye2(2)-halfl];
ruc = [f1_eye2(1)-halfw,f1_eye2(2)+halfl];
llc = [f1_eye2(1)+halfw,f1_eye2(2)-halfl];
rlc = [f1_eye2(1)+halfw,f1_eye2(2)+halfl];
showim = makegreen(showim,luc,ruc,llc,rlc,theta);
halfw = round(1.2*halfw);
halfl = round(1.8*halfl);
luc = [f1_mouth(1)-halfw,f1_mouth(2)-halfl];
ruc = [f1_mouth(1)-halfw,f1_mouth(2)+halfl];
llc = [f1_mouth(1)+halfw,f1_mouth(2)-halfl];
rlc = [f1_mouth(1)+halfw,f1_mouth(2)+halfl];
showim = makegreen(showim,luc,ruc,llc,rlc,theta);
axes(handles.axes3);
cla;
global Face1Handle;
Face1Handle = imshow(showim,[]);

% --- Executes on button press in Face2Done.
function Face2Done_Callback(hObject, eventdata, handles)
% hObject    handle to Face2Done (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clc;
global Face2;
[M,N,P] = size(Face2);
global f2_eye1 f2_eye2 f2_mouth;

theta = atan((f2_eye1(1)-f2_eye2(1))/(f2_eye2(2)-f2_eye1(2)));
halfl = round(N/9);
halfw = round(N/18);
luc = [f2_eye1(1)-halfw,f2_eye1(2)-halfl];
ruc = [f2_eye1(1)-halfw,f2_eye1(2)+halfl];
llc = [f2_eye1(1)+halfw,f2_eye1(2)-halfl];
rlc = [f2_eye1(1)+halfw,f2_eye1(2)+halfl];
global Face2;
showim = Face2;
showim = makegreen(showim,luc,ruc,llc,rlc,theta);
luc = [f2_eye2(1)-halfw,f2_eye2(2)-halfl];
ruc = [f2_eye2(1)-halfw,f2_eye2(2)+halfl];
llc = [f2_eye2(1)+halfw,f2_eye2(2)-halfl];
rlc = [f2_eye2(1)+halfw,f2_eye2(2)+halfl];
showim = makegreen(showim,luc,ruc,llc,rlc,theta);
halfw = round(1.2*halfw);
halfl = round(1.8*halfl);
luc = [f2_mouth(1)-halfw,f2_mouth(2)-halfl];
ruc = [f2_mouth(1)-halfw,f2_mouth(2)+halfl];
llc = [f2_mouth(1)+halfw,f2_mouth(2)-halfl];
rlc = [f2_mouth(1)+halfw,f2_mouth(2)+halfl];
showim = makegreen(showim,luc,ruc,llc,rlc,theta);
axes(handles.axes4);
cla;
global Face2Handle;
Face2Handle = imshow(showim,[]);

function alpha_Callback(hObject, eventdata, handles)
% hObject    handle to alpha (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of alpha as text
%        str2double(get(hObject,'String')) returns contents of alpha as a double


% --- Executes during object creation, after setting all properties.
function alpha_CreateFcn(hObject, eventdata, handles)
% hObject    handle to alpha (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
