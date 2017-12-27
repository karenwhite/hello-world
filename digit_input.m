function varargout = digit_input(varargin)
% DIGIT_INPUT MATLAB code for digit_input.fig
%      DIGIT_INPUT, by itself, creates a new DIGIT_INPUT or raises the existing
%      singleton*.
%
%      H = DIGIT_INPUT returns the handle to a new DIGIT_INPUT or the handle to
%      the existing singleton*.
%
%      DIGIT_INPUT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DIGIT_INPUT.M with the given input arguments.
%
%      DIGIT_INPUT('Property','Value',...) creates a new DIGIT_INPUT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before digit_input_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to digit_input_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help digit_input

% Last Modified by GUIDE v2.5 26-Nov-2016 22:47:01

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @digit_input_OpeningFcn, ...
                   'gui_OutputFcn',  @digit_input_OutputFcn, ...
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


% --- Executes just before digit_input is made visible.
function digit_input_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to digit_input (see VARARGIN)

% Choose default command line output for digit_input
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes digit_input wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = digit_input_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on mouse press over figure background, over a disabled or
% --- inactive control, or over an axes background.
function figure1_WindowButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global draw_enable;
global x;
global y;
draw_enable=1;
if draw_enable
    position=get(gca,'currentpoint');
    x(1)=position(1,1);
    y(1)=position(1,2);
end

% --- Executes on button press in pushbutton_Clear.
function pushbutton_Clear_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_Clear (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes(handles.axes1);
cla;
s='';
set(handles.edit_Name,'String',s);

% --- Executes on button press in pushbutton_Save.
function pushbutton_Save_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_Save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
h=getframe(handles.axes1);
str = get(handles.edit_Name,'String');
imwrite(h.cdata,str,'bmp');
cla(handles.axes1);


function edit_Name_Callback(hObject, eventdata, handles)
% hObject    handle to edit_Name (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_Name as text
%        str2double(get(hObject,'String')) returns contents of edit_Name as a double


% --- Executes during object creation, after setting all properties.
function edit_Name_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_Name (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on mouse motion over figure - except title and menu.
function figure1_WindowButtonMotionFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global draw_enable;
global x ;
global y ;
if draw_enable
   position=get(gca,'currentpoint');
   x(2)=position(1,1);
   y(2)=position(1,2);
   animatedline(x,y,'Color','b','LineWidth',10);
   % line(x,y,'EraseMode','xor','LineWidth',5,'color','b');
    x(1)=x(2);
    y(1)=y(2);
end

% --- Executes on mouse press over figure background, over a disabled or
% --- inactive control, or over an axes background.
function figure1_WindowButtonUpFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global draw_enable
draw_enable=0;


% --- Executes on button press in pushbutton_Training.
function pushbutton_Training_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_Training (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global ntestdata test_data test_label net;
%% 读取图像
root='.\data';
img=read_train(root);
%% 提取特征
img_feature=feature_lattice(img);
%% 构造标签
class=10;
numberpclass=500;
ann_label=zeros(class,numberpclass*class);
ann_data=img_feature;
for i=1:class
 for j=numberpclass*(i-1)+1:numberpclass*i
     ann_label(i,j)=1;
 end
end
%% 选定训练集和测试集
k=rand(1,numberpclass*class);  
[m,n]=sort(k);  
ntraindata=4500;
ntestdata=500;
train_data=ann_data(:,n(1:ntraindata));
test_data=ann_data(:,n(ntraindata+1:numberpclass*class));
train_label=ann_label(:,n(1:ntraindata));
test_label=ann_label(:,n(ntraindata+1:numberpclass*class));
%% BP神经网络创建，训练和测试
net=network_train(train_data,train_label);

% --- Executes on button press in pushbutton_Test.
function pushbutton_Test_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_Test (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global net test_data predict_label;
predict_label=network_test(test_data,net);

% --- Executes on button press in pushbutton_Caculate.
function pushbutton_Caculate_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_Caculate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global test_label predict_label;
[u,v]=find(test_label==1);
label=u';
error=label-predict_label;
accuracy=size(find(error==0),2)/size(label,2);
set(handles.edit_Accuracy,'String',accuracy);

function edit_Accuracy_Callback(hObject, eventdata, handles)
% hObject    handle to edit_Accuracy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_Accuracy as text
%        str2double(get(hObject,'String')) returns contents of edit_Accuracy as a double


% --- Executes during object creation, after setting all properties.
function edit_Accuracy_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_Accuracy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_Recognition.
function pushbutton_Recognition_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_Recognition (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global net;
axes(handles.axes2);
str = get(handles.edit_RName,'String');
img = imread(str);
img2 = HoughProcess(img);
image = cut(img2);
bw_7050=imresize(image,[70,50]);
imshow(bw_7050);
for cnt=1:7
    for cnt2=1:5
        Atemp=sum(bw_7050(((cnt*10-9):(cnt*10)),((cnt2*10-9):(cnt2*10))));%10*10box
        lett((cnt-1)*5+cnt2)=sum(Atemp);
    end
end
lett=((100-lett)/100);
lett=lett';
feature=lett;
an=sim(net,feature);
out = find(an==max(an));
set(handles.edit_Result,'String',out-1);


function edit_RName_Callback(hObject, eventdata, handles)
% hObject    handle to edit_RName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_RName as text
%        str2double(get(hObject,'String')) returns contents of edit_RName as a double


% --- Executes during object creation, after setting all properties.
function edit_RName_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_RName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit_Result_Callback(hObject, eventdata, handles)
% hObject    handle to edit_Result (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_Result as text
%        str2double(get(hObject,'String')) returns contents of edit_Result as a double



% --- Executes during object creation, after setting all properties.
function edit_Result_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_Result (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_Recognition1.
function pushbutton_Recognition1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_Recognition1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global net;
axes(handles.axes2);
str = get(handles.edit_RName,'String');
img = imread(str);
%img2 = HoughProcess(img); 
%img2 = im2bw(img,graythresh(img));
image= cut(img);
bw_7050=imresize(image,[70,50]);
imshow(bw_7050);
for cnt=1:7
    for cnt2=1:5
        Atemp=sum(bw_7050(((cnt*10-9):(cnt*10)),((cnt2*10-9):(cnt2*10))));%10*10box
        lett((cnt-1)*5+cnt2)=sum(Atemp);
    end
end
lett=((100-lett)/100);
lett=lett';
feature=lett;
an=sim(net,feature);
out = find(an==max(an));
set(handles.edit_Result,'String',out-1);
