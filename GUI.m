function varargout = GUI(varargin)
% GUI MATLAB code for GUI.fig
%      GUI, by itself, creates a new GUI or raises the existing
%      singleton*.
%
%      H = GUI returns the handle to a new GUI or the handle to
%      the existing singleton*.
%
%      GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI.M with the given input arguments.
%
%      GUI('Property','Value',...) creates a new GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUI

% Last Modified by GUIDE v2.5 27-Jun-2016 19:56:00

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @GUI_OpeningFcn, ...
    'gui_OutputFcn',  @GUI_OutputFcn, ...
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


% --- Executes just before GUI is made visible.
function GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUI (see VARARGIN)

% Choose default command line output for GUI
handles.output = hObject;

%Setting Initial cnditions of GUI

handles.checkbox_list = 0;
handles.checkbox_macros = 0;
handles.sliderstepval = 1;
handles.scan_ok = false;
set (handles.radiobutton3, 'Value', 1);
set (handles.radiobutton4, 'Value', 0);
set (handles.Plot,'Enable','off');
set (handles.Add_to_report,'Enable','off');
set (handles.Report,'Enable','off');

set (handles.text3,'Enable','off');
set (handles.text8,'Enable','off');
set (handles.text3,'Enable','on');
set (handles.text3,'string','Click "Import EgoData.csv" to import 1st CSV files');
set (handles.text3,'BackgroundColor','0.73, 0.83, 0.96');
set (handles.text21,'BackgroundColor','0.73, 0.83, 0.96');
set (handles.text18,'BackgroundColor','0.73, 0.83, 0.96');
set (handles.text24,'BackgroundColor','0.73, 0.83, 0.96');
set (handles.text22,'Enable','off');
set (handles.text28,'Enable','off');
set (handles.text29,'Enable','off');

set (handles.slider1, 'Enable', 'off');
set (handles.slider1, 'Visible', 'off');
set (handles.sliderstep, 'string', '');
set (handles.Importcsv, 'String', 'Import EgoData.csv');
set (handles.axes, 'Visible', 'off');
handles.csvlist = '';
handles.rptname = '';
handles.EgoData_received = 0;
handles.EPMAfterRx_received = 0;
handles.EPMListAfterRotation_received = 0;
handles.snap_count = 0;

% Update handles structure
guidata(hObject, handles);



% UIWAIT makes GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = GUI_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% Push Button of IMPORT CSV
% --- Executes on button press in Importcsv.
function Importcsv_Callback(hObject, eventdata, handles)
% hObject    handle to Importcsv (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%setting initial conditions
set (handles.Plot, 'Enable', 'off');
set (handles.Report, 'Enable', 'off');
set (handles.Add_to_report,'Enable','off');
set (handles.slider1, 'Enable', 'off');
set (handles.slider1, 'Visible', 'off');
set (handles.text22,'string','');
set (handles.text28,'string','');
set (handles.text29,'string','');
handles.sliderstepval = 1;
set (handles.sliderstep,'string','');
handles.scan_ok = false;
cla;
legend (handles.axes,'hide');
set (handles.axes, 'Visible', 'off');
set (handles.text8,'Enable','of');
set (handles.text8,'string','');
set (handles.text8,'BackgroundColor','0.94, 0.94, 0.94');
set (handles.text9,'Enable','of');
set (handles.text9,'string','');
set (handles.text9,'BackgroundColor','0.94, 0.94, 0.94');
set (handles.text10,'Enable','of');
set (handles.text10,'string','');
set (handles.text10,'BackgroundColor','0.94, 0.94, 0.94');
set (handles.text15,'Enable','of');
set (handles.text15,'string','');
set (handles.text15,'BackgroundColor','0.94, 0.94, 0.94');

%checking how many csv files scanned so far, and setting next required
if length(handles.csvlist)== 0
    csv_file = 'EgoData.csv';
elseif length(handles.csvlist)== 1
    csv_file = 'EPMAfterRx.csv';
elseif length(handles.csvlist) == 2
    csv_file = 'EPMListAfterRotation.csv';
elseif length(handles.csvlist) == 3
    csv_file = 'Startover';
end

%if EgoData is required...
switch (csv_file)
    case char('EgoData.csv')
        
        set (handles.text3, 'String', 'Import EgoData.csv file');
        %calling EgoData scan function
        EgoData_scan(hObject, eventdata, handles);
        %getting updated handles... as EgoData Scan has updated some
        %handles....
        handles = guidata(gcbo);
        
        % to scan EPM AfterRx.csv...
    case char('EPMAfterRx.csv')
        %askign user to scan EPM AfterRx...
        [filename ,pathname] = uigetfile({'*.CSV'},'Select "EPMAfterRx.csv" File');
        %If user scans correct file or no... checking
        if strcmp(filename , 'EPMAfterRx.csv') == 1
            %storing the full path of selected CSV
            fullpathname = strcat(pathname, filename);
            %stroing first CSV in string
            handles.csvlist{2} = filename;
            %displying in listbox
            set (handles.text26, 'string' , filename);
            %clearing the 3rd file name
            set (handles.text27,'string','');
            %setting up flag
            handles.EPMAfterRx_received=1;
            %extracting table from selected CSV file
            T2 = readtable('EPMAfterRx.csv');
            %extracting first row of CSV file in Cell format. That have names of all parameters
            z2 = T2.Properties.VariableNames;
            %Converting cell into string
            s2 = cellstr(z2);
            %taking count accorrding to length of string
            count2 = length(s2);
            
            %extracting timestamp values and count
            handles.sliderrtextaftrx = 'LeoOrigin_fReferenceTimestamp';
            handles.sliderraftrx = T2.(handles.sliderrtextaftrx);
            handles.countaftrx = length(handles.sliderraftrx);
            
            %storing into handles
            handles.s2 = s2;
            handles.count2 = count2;
            handles.T2 = T2;
            handles.z2 = z2;
            set (handles.Importcsv, 'String', 'Import EPMListAfterRotation.csv');
            set (handles.text3, 'String', 'Import EPMListAfterRotation.csv now');
            
        else
            set (handles.text3, 'String', 'Imported CSV file is not "EPMAfterRx.csv". Please Import again');
        end
        
        %to scan EPMListAfterRotation...
    case char('EPMListAfterRotation.csv')
        %askign user to scan 3rd CSV
        [filename ,pathname] = uigetfile({'*.CSV'},'Select "EPMListAfterRotation.csv" File');
        % if selected file is EPMListAfterRotation... or No... Checking
        if strcmp(filename , 'EPMListAfterRotation.csv') == 1
            %storing the full path of selected CSV
            fullpathname = strcat(pathname, filename);
            %stroing first CSV in string
            handles.csvlist{3} = filename;
            %displying in listbox
            set (handles.text27, 'string' , filename);
            %setting up flag
            handles.EPMListAfterRotation_received=1;
            %extracting table from selected CSV file
            T3 = readtable('EPMListAfterRotation.csv');
            %extracting first row of CSV file in Cell format. That have names of all parameters
            z3 = T3.Properties.VariableNames;
            %Converting cell into string
            s3 = cellstr(z3);
            %taking count accorrding to length of string
            count3 = length(s3);
            
            %extracting timestamp values and count
            handles.sliderrtextaftro = 'LeoOrigin_fReferenceTimestamp';
            handles.sliderraftro = T3.(handles.sliderrtextaftro);
            handles.countaftro = length(handles.sliderraftro);
            
            %storing into handles
            handles.s3 = s3;
            handles.count3 = count3;
            handles.T3 = T3;
            handles.z3 = z3;
            set (handles.Importcsv, 'String', 'Import EgoData.csv');
        else
            set (handles.text3, 'String', 'Imported CSV file is not "EPMListAfterRotation.csv". Please Import again');
        end
        
        % scanning the EgoData.csv again, when user wants to start over again
    case char('Startover')
        %setting initial conditions.
        set (handles.text25, 'string' , '');
        set (handles.text26, 'string' , '');
        set (handles.text27, 'string' , '');
        set (handles.text25,'BackgroundColor','0.96, 0.96, 0.96');
        set (handles.text26,'BackgroundColor','0.96, 0.96, 0.96');
        set (handles.text27,'BackgroundColor','0.96, 0.96, 0.96');
        handles.csvlist =[];
        handles.EgoData_received =0;
        handles.EPMAfterRx_received =0;
        handles.EPMListAfterRotation_received =0;
        set (handles.Plot,'Enable','off');
        set (handles.Add_to_report,'Enable','off');
        set (handles.Report,'Enable','off');
        set (handles.text3, 'String', 'IMPORT EgoData.csv file');
        
        %calling EgoData scan fucntion
        EgoData_scan(hObject, eventdata, handles)
        %getting updated handles... as EgoData Scan has updated some
        %handles....
        handles = guidata(gcbo);
end


%if all CSV are present then proceed to next GUI state
if (handles.EgoData_received==1) && (handles.EPMAfterRx_received==1) && (handles.EPMListAfterRotation_received==1)
    
    %defining default handles values for x-axis & y-axix parameters.
    handles.xaxis = handles.s1{1};
    handles.yaxis = handles.s1{1};
    
    %filling up the list boxes with elements of first row of CSV file
    set(handles.listbox2, 'string' , handles.s1);
    set(handles.listbox3, 'string' , handles.s1);
    
    %defining default handles values
    handles.csv = handles.csvlist{1};
    %filling Macros list
    handles.ss = {'Ego-Vehicle Velocity', 'Ego-Vehicle Acceleration', 'EPM Reception Points', 'EPM Message Size'};
    
    %filling up the list boxes
    set(handles.Macros_listbox, 'string' , handles.ss);
    
    %defining default handles values for x-axis & y-axix parameters.
    handles.sval = handles.ss{1};
    
    %Setting message plane for instructions
    set (handles.text25,'BackgroundColor','0.73, 0.83, 0.96');
    set (handles.text26,'BackgroundColor','0.73, 0.83, 0.96');
    set (handles.text27,'BackgroundColor','0.73, 0.83, 0.96');
    
    %Displaying messages as per radio button state
    if get(handles.radiobutton3, 'Value') == 1
        set (handles.text3,'string','Make your selection from "CUSTOMIZE PLOT" to plot');
        set (handles.text3,'BackgroundColor','0.73, 0.83, 0.96');
    end
    if get(handles.radiobutton4, 'Value') == 1
        set (handles.text3,'string','Make your selection from "MACROS PLOT" to plot');
        set (handles.text3,'BackgroundColor','0.73, 0.83, 0.96');
    end
    %setting GUI to next conditions
    set (handles.Plot,'Enable','on');
    set (handles.Report,'Enable','on');
    set (handles.Add_to_report, 'Enable', 'on');
    %setting falg
    handles.scan_ok = true;
end

% save the changes to the structure of handles
guidata(hObject, handles);

function EgoData_scan(hObject, eventdata, handles)
% Asking user to import EgoData.csv
[filename ,pathname] = uigetfile({'*.CSV'},'Select EgoData.CSV File');
%If user scans correct file or no... checking
if strcmp(filename , 'EgoData.csv') == 1
    %storing the full path of selected CSV
    fullpathname = strcat(pathname, filename);
    %stroing first CSV in string
    handles.csvlist{1} = filename;
    %displying in listbox
    set(handles.text25, 'string' , filename);
    %clearing the 2nd and 3rd file name
    set (handles.text26,'string','');
    set (handles.text27,'string','');
    %setting a flag
    handles.EgoData_received=1;
    %extracting table from selected CSV file
    T1 = readtable('EgoData.csv');
    %extracting first row of CSV file in Cell format. That have names of all parameters
    z1 = T1.Properties.VariableNames;
    %Converting cell into string
    s1 = cellstr(z1);
    %taking count accorrding to length of string
    count1 = length(s1);
    
    % extracting timestamp values & taking count
    handles.sliderrtextego = 'timeStamp';
    handles.sliderrego = T1.(handles.sliderrtextego);
    handles.countego = length(handles.sliderrego);
    
    %storing into handles
    handles.s1 = s1;
    handles.count1 = count1;
    handles.T1 = T1;
    handles.z1 = z1;
    set(handles.Importcsv, 'String', 'Import EPMAfterRx.csv');
    set (handles.text3, 'String', 'Import EPMAfterRx.csv now');
else
    set (handles.text3, 'String', 'Imported CSV file is not "EgoData.csv". Please Import again');
end
% save the changes to the structure of handles
guidata(hObject, handles);

%push button of Plot
% --- Executes on button press in Plot.
function Plot_Callback(hObject, eventdata, handles)
% hObject    handle to Plot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% enabling the text fields & displying text
set (handles.text8,'Enable','on');
set (handles.text8,'String','Plotting');
set (handles.text15,'Enable','on');
set (handles.text15,'String','Versus');
set (handles.text22,'string', '' );
set (handles.text22,'Enable','off');
zoom out;
%enabling and making slider visible
set(handles.slider1, 'Enable', 'on');
set(handles.slider1, 'Visible', 'on');
set(handles.axes, 'Visible', 'on');
handles.sliderstepval = 1;
set (handles.sliderstep, 'String', handles.sliderstepval);

%If "Plot from Macros" is slected
if get(handles.radiobutton4, 'value') == 1
    
    %taking the value from the Macros list callback
    switch char(handles.sval)
        
        case char('Ego-Vehicle Velocity')
            
            %setting slider values
            set(handles.slider1, 'Min', 1);
            set(handles.slider1, 'Max', handles.countego);
            set(handles.slider1, 'Value', handles.countego);
            set(handles.slider1, 'SliderStep', [ handles.sliderstepval/handles.countego, (handles.sliderstepval*10)/handles.countego ]);
            
            %Calling the Macros_plot_velocity function
            Macros_plot_velocity(hObject, eventdata, handles);
            
            %updating handles to get vales of vectors
            handles = guidata(gcbo);
            
            %preparing values for plot
            x = str2double(handles.vector1);
            y = cell2mat(handles.vector2);
            %plotting
            cla;
            plot(x,y, 'b','LineWidth',1);
            grid on;
            grid minor;
            title('Ego-Vehicle Velocity');
            legend('Mean Velocity','Location','northeast');
            ylabel('Mean Velocity');
            xlabel('Time Stamp');
            zoom on;
            h = zoom(handles.axes);
            set(h, 'RightClickAction', 'PostContextMenu');
            xli = xlim;
            yli = ylim;
            
            %finding timestamp min value
            tstampval_min = str2double(handles.sliderrego(1));
            tstampval_min = num2str(tstampval_min);
            
            set (handles.text28,'Enable','on');
            set (handles.text28,'BackgroundColor','0.94, 0.94, 0.94');
            set (handles.text28,'string', (['Min - ' tstampval_min ]) );
            
            %finding timestamp max value
            tstampval_max = str2double(handles.sliderrego(handles.countego));
            tstampval_max = num2str(tstampval_max);
            
            set (handles.text29,'Enable','on');
            set (handles.text29,'BackgroundColor','0.94, 0.94, 0.94');
            set (handles.text29,'string', (['Max - ' tstampval_max ]) );
            
            %printing Timestamp present value on GUI (its max value by default)
            set (handles.text22,'Enable','on');
            set (handles.text22,'BackgroundColor','0.94, 0.94, 0.94');
            set (handles.text22,'string', (['Time stamp value - ' tstampval_max ]) );
            
        case char('Ego-Vehicle Acceleration')
            
            %setting slider values
            set(handles.slider1, 'Min', 1);
            set(handles.slider1, 'Max', handles.countego);
            set(handles.slider1, 'Value', handles.countego);
            set(handles.slider1, 'SliderStep', [ handles.sliderstepval/handles.countego, (handles.sliderstepval*10)/handles.countego ]);
            
            %calling the Macros_plot_acceleration function
            Macros_plot_accelaration(hObject, eventdata, handles)
            
            %updating handles to get vales of vectors
            handles = guidata(gcbo);
            
            %preparing values for plot
            x = str2double(handles.vector1);
            y = cell2mat(handles.vector2);
            %plotting
            cla;
            plot(x,y, 'b','LineWidth',1);
            grid on;
            grid minor;
            title('Ego-Vehicle Acceleration');
            legend('Mean Acceleration','Location','northeast');
            ylabel('Mean Acceleration');
            xlabel('Time Stamp');
            zoom on;
            h = zoom(handles.axes);
            set(h, 'RightClickAction', 'PostContextMenu');
            xli = xlim;
            yli = ylim;
            
            %finding timestamp min value
            tstampval_min = str2double(handles.sliderrego(1));
            tstampval_min = num2str(tstampval_min);
            
            set (handles.text28,'Enable','on');
            set (handles.text28,'BackgroundColor','0.94, 0.94, 0.94');
            set (handles.text28,'string', (['Min - ' tstampval_min ]) );
            
            %finding timestamp max value
            tstampval_max = str2double(handles.sliderrego(handles.countego));
            tstampval_max = num2str(tstampval_max);
            
            set (handles.text29,'Enable','on');
            set (handles.text29,'BackgroundColor','0.94, 0.94, 0.94');
            set (handles.text29,'string', (['Max - ' tstampval_max ]) );
            
            %printing Timestamp present value on GUI (its max value by default)
            set (handles.text22,'Enable','on');
            set (handles.text22,'BackgroundColor','0.94, 0.94, 0.94');
            set (handles.text22,'string', (['Time stamp value - ' tstampval_max ]) );
            
        case char('EPM Reception Points')
            
            %setting slider values
            set(handles.slider1, 'Min', 1);
            set(handles.slider1, 'Max', handles.countego);
            set(handles.slider1, 'Value', handles.countego);
            set(handles.slider1, 'SliderStep', [ handles.sliderstepval/handles.countego, (handles.sliderstepval*10)/handles.countego ]);
            
            %Calling the Macros_plot_epmreception function
            Macros_plot_epmreception(hObject, eventdata, handles);
            %updating handles to get vales of vectors
            handles = guidata(gcbo);
            
            %preparing values for 1st plot
            x = str2double(handles.vector1);
            y = str2double(handles.vector2);
            
            cla;
            x1 = cell2mat(handles.vector3);
            y1 = cell2mat(handles.vector4);
            %plotting
            plot(x,y,'r','LineWidth', 1);
            hold on;
            plot(x1,y1,'x', 'color', 'g');
            title('EPM Reception Points');
            legend('coordinates of vehicle','Relative distance to Ego-vehicle','Location','southeast');
            grid on;
            grid minor;
            ylabel('Longitude in degrees');
            xlabel('Latitude in degrees');
            zoom on;
            h = zoom(handles.axes);
            set(h, 'RightClickAction', 'PostContextMenu');
            xli = xlim;
            yli = ylim;
            
            %finding timestamp min value
            tstampval_min = str2double(handles.sliderrego(1));
            tstampval_min = num2str(tstampval_min);
            
            set (handles.text28,'Enable','on');
            set (handles.text28,'BackgroundColor','0.94, 0.94, 0.94');
            set (handles.text28,'string', (['Min - ' tstampval_min ]) );
            
            %finding timestamp max value
            tstampval_max = str2double(handles.sliderrego(handles.countego));
            tstampval_max = num2str(tstampval_max);
            
            set (handles.text29,'Enable','on');
            set (handles.text29,'BackgroundColor','0.94, 0.94, 0.94');
            set (handles.text29,'string', (['Max - ' tstampval_max ]) );
            
            %printing Timestamp present value on GUI (its max value by default)
            set (handles.text22,'Enable','on');
            set (handles.text22,'BackgroundColor','0.94, 0.94, 0.94');
            set (handles.text22,'string', (['Time stamp value - ' tstampval_max ]) );
            
        case char('EPM Message Size')
            
            %setting slider values
            set(handles.slider1, 'Min', 1);
            set(handles.slider1, 'Max', handles.countaftrx);
            set(handles.slider1, 'Value', handles.countaftrx);
            set(handles.slider1, 'SliderStep', [ handles.sliderstepval/handles.countaftrx, (handles.sliderstepval*10)/handles.countaftrx ]);
            
            %Calling the Macros_plot_epmreception function
            Macros_plot_messagesize(hObject, eventdata, handles);
            %updating handles to get vales of vectors
            handles = guidata(gcbo);
            
            %preparing values for plot
            x = str2double(handles.vector1);
            y = str2double(handles.vector2);
            %plotting
            cla;
            plot(x,y, 'b','LineWidth',1);
            title('EPM Message Size');
            legend('Message Size','Location','north');
            grid on;
            grid minor;
            ylabel('Message Size');
            xlabel('Time Stamp');
            zoom on;
            h = zoom(handles.axes);
            set(h, 'RightClickAction', 'PostContextMenu');
            xli = xlim;
            yli = ylim;
            
            %finding timestamp min value
            tstampval_min = str2double(handles.sliderraftrx(1));
            tstampval_min = num2str(tstampval_min);
            
            set (handles.text28,'Enable','on');
            set (handles.text28,'BackgroundColor','0.94, 0.94, 0.94');
            set (handles.text28,'string', (['Min - ' tstampval_min ]) );
            
            %finding timestamp max value
            tstampval_max = str2double(handles.sliderraftrx(handles.countaftrx));
            tstampval_max = num2str(tstampval_max);
            
            set (handles.text29,'Enable','on');
            set (handles.text29,'BackgroundColor','0.94, 0.94, 0.94');
            set (handles.text29,'string', (['Max - ' tstampval_max ]) );
            
            %printing Timestamp present value on GUI (its max value by default)
            set (handles.text22,'Enable','on');
            set (handles.text22,'BackgroundColor','0.94, 0.94, 0.94');
            set (handles.text22,'string', (['Time stamp value - ' tstampval_max ]) );
            
    end
    
    % if "Plot from List" is selected
elseif get(handles.radiobutton3, 'value') == 1
    
    %calling List_plot function
    Custom_plot(hObject, eventdata, handles);
    %updating handles to get values of vectors
    handles = guidata(gcbo);
    
    %preparing values for plot
    x = str2double(handles.vector1);
    y = str2double(handles.vector2);
    %plotting
    cla;
    plot(x,y, 'g','LineWidth',1);
    grid on;
    grid minor;
    title(' CUSTOMIZE PLOT ');
    legend(handles.yaxis, 'Location','northeast');
    zoom on;
    h = zoom(handles.axes);
    set(h, 'RightClickAction', 'PostContextMenu');
    xli = xlim;
    yli = ylim;
    
    %finding timestamp min value
    tstampval_min = str2double(handles.sliderrego(1));
    tstampval_min = num2str(tstampval_min);
    
    set (handles.text28,'Enable','on');
    set (handles.text28,'BackgroundColor','0.94, 0.94, 0.94');
    set (handles.text28,'string', (['Min - ' tstampval_min ]) );
    
    %finding timestamp max value
    tstampval_max = str2double(handles.sliderrego(handles.countego));
    tstampval_max = num2str(tstampval_max);
    
    set (handles.text29,'Enable','on');
    set (handles.text29,'BackgroundColor','0.94, 0.94, 0.94');
    set (handles.text29,'string', (['Max - ' tstampval_max ]) );
    
    %printing Timestamp present value on GUI (its max value by default)
    set (handles.text22,'Enable','on');
    set (handles.text22,'BackgroundColor','0.94, 0.94, 0.94');
    set (handles.text22,'string', (['Time stamp value - ' tstampval_max ]) );
    
end

% setting up the axes limits to default
handles.xli_min = xli(1);
handles.xli_max = xli(2);
handles.yli_min = yli(1);
handles.yli_max = yli(2);

%Setting message plane for instructions
set (handles.text3,'string','Move Slider to analyze the plot with respect to time stamps');
set (handles.text3,'BackgroundColor','0.73, 0.83, 0.96');
%initializing Lastslider value to 1
handles.lastSliderVal=1;
% save the changes to the structure of handles
guidata(hObject, handles);


% --- function executes on respective plot selection.
function Custom_plot(hObject, eventdata, handles)
% hObject    handle to Confirmselection (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get the structure using guidata in the local function
handles = guidata(gcbo);

handles.vector1 ={''};
handles.vector2 ={''};
handles.vector3 ={''};
handles.vector4 ={''};

% enabling the text fields & displying text
set (handles.text8,'Enable','on');
set (handles.text8,'String','PLOT Selected');
set (handles.text15,'Enable','on');
set (handles.text15,'String','Versus');

%displaying the X_AXIX (Plot-1) selection on GUI
set (handles.text9,'enable','on');
set (handles.text9,'string',[handles.xaxis, ' on x-axis']);
set (handles.text9,'BackgroundColor','0.68, 0.92, 1');

%displaying the Y_AXIX (Plot-1) selection on GUI & changing colour field
set (handles.text10,'enable','on');
set (handles.text10,'string',[handles.yaxis, ' on y-axis']);
set (handles.text10,'BackgroundColor','0.68, 0.92, 1');

%extracting vectors from tables.
handles.vector1= handles.T1.(handles.xaxis);
handles.vector2= handles.T1.(handles.yaxis);


% save the changes to the structure of handles
guidata(hObject,handles);

function Macros_plot_velocity(hObject, eventdata, handles)

%clearing the vectors
handles.vector1 ={''};
handles.vector2 ={''};
%extracting vectors
handles.vector1 = handles.sliderrego;
vector2_interm= handles.T1.('f64Vx');
vector2_interm2= handles.T1.('f64Vy');

%converting into number
vector2_interm  = str2double(vector2_interm);
vector2_interm2 = str2double(vector2_interm2);

% calculating mean value
vector2 = (sqrt(((vector2_interm).^(2))+((vector2_interm2).^(2))));

% Converting double to cell
handles.vector2 = num2cell(vector2);

%displaying the X_AXIX (Plot-1) selection on GUI
set (handles.text9,'enable','on');
set (handles.text9,'string','Velocity in km/h on y-axis');
set (handles.text9,'BackgroundColor','0.68, 0.92, 1');

%displaying the Y_AXIX (Plot-1) selection on GUI & changing colour field
set (handles.text10,'enable','on');
set (handles.text10,'string','Samples on x-axis');
set (handles.text10,'BackgroundColor','0.68, 0.92, 1');
%Updating handles
guidata(hObject, handles);

function Macros_plot_accelaration(hObject, eventdata, handles)

%clearing the vectors
handles.vector1 ={''};
handles.vector2 ={''};

%extracting vectors
handles.vector1 = handles.sliderrego;
vector2_interm= handles.T1.('f64Ax');
vector2_interm2 = handles.T1.('f64Ay');

%converting into number
vector2_interm  = str2double(vector2_interm);
vector2_interm2 = str2double(vector2_interm2);

%calculating mean value
vector2 = (sqrt(((vector2_interm).^(2))+((vector2_interm2).^(2))));

%Converting double to cell
handles.vector2 = num2cell(vector2);

%displaying the X_AXIX (Plot-1) selection on GUI
set (handles.text9,'enable','on');
set (handles.text9,'string','Acceleration in km/h on y-axis');
set (handles.text9,'BackgroundColor','0.68, 0.92, 1');

%displaying the Y_AXIX (Plot-1) selection on GUI & changing colour field
set (handles.text10,'enable','on');
set (handles.text10,'string','Samples on x-axis');
set (handles.text10,'BackgroundColor','0.68, 0.92, 1');
%Updating handles
guidata(hObject, handles);

function Macros_plot_epmreception(hObject, eventdata, handles)

%clearing the vectors
handles.vector1 ={''};
handles.vector2 ={''};
handles.vector3 ={''};
handles.vector4 ={''};

%extracting vectors
handles.vector1= handles.T1.('f64Lon');
handles.vector2= handles.T1.('f64Lat');

vector3= handles.T3.('measDx_Obj_0');
vector4= handles.T3.('measDy_Obj_0');

%declaring memory for interim calculation
vector3_interm = zeros(1, handles.countaftro);
vector4_interm = zeros(1, handles.countaftro);

%converting meters to degree
for i=1:handles.countaftro
    
    temp = str2double(vector3(i));
    temp = temp*0.001;
    deg= temp/(pi*6371000/180.0);
    vector3_interm(i) = deg;
    
end
%converting meters to degree
for i=1:handles.countaftro
    
    temp2 = str2double(vector4(i));
    temp2 = temp2*0.001;
    deg2= temp2/(pi*6371/180.0);
    vector4_interm(i) = deg2;
    
end

%searching time stamps of afterRotation in Egodata and getting
%their index
tempsliderrego= str2double(handles.sliderrego);
tempsliderraftro = str2double(handles.sliderraftro);

%declaring memory for interim calculation
AA = zeros(1, handles.countaftro);

%searching the time time stamps of AfterRo in EgoData and storing all indices in AA
for j=1:handles.countaftro
    
    [p1,p2] = min(abs(tempsliderrego - tempsliderraftro(j)));
    AA(j)=p2;
end

%finding values of time stamp in EgoData which are common in
%EPMatrRoration. using the index matrix AA (generated in above "for loop")
for i=1:handles.countaftro
    el1=str2double(cell2mat(handles.vector1((AA(i)))));
    el2=str2double(cell2mat(handles.vector2((AA(i)))));
    %extracting time stamps of EPM after rotation to plot on
    %route(from EgoData)
    vector3_interm(i) =  el1;
    vector4_interm(i) =  el2;
    %if relative distance is required to be ploted on route then.
    %this portion of code will be used instead of above 2 lines
    %vector3_interm(i) =  vector3_interm(i)+el1 ;
    %vector4_interm(i) =  vector4_interm(i)+el2;
end

%transposing
tmp = vector3_interm.';
tmp2 = vector4_interm.';
%converting matric to Cell
n= length(tmp);
n2 = length(tmp2);
handles.vector3 = mat2cell(tmp, ones(n,1), 1);
handles.vector4 = mat2cell(tmp2, ones(n2,1), 1);

%displaying the X_AXIX (Plot-1) selection on GUI

set (handles.text9,'enable','on');
set (handles.text9,'string',('f64Lon && measDx_Obj_0 on y-axis'));
set (handles.text9,'BackgroundColor','0.68, 0.92, 1');

%displaying the Y_AXIX (Plot-1) selection on GUI & changing colour field

set (handles.text10,'enable','on');
set (handles.text10,'string',('f64Lat && measDy_Obj_0 on x-axis'));
set (handles.text10,'BackgroundColor','0.68, 0.92, 1');

%Updating handles
guidata(hObject, handles);

function Macros_plot_messagesize(hObject, eventdata, handles)
%clearing the vectors
handles.vector1 ={''};
handles.vector2 ={''};

%extracting vectors
handles.vector1 = handles.sliderraftrx;
handles.vector2 = handles.T2. ('MessageSize');

%displaying the X_AXIX (Plot-1) selection on GUI
set (handles.text9,'enable','on');
set (handles.text9,'string','Message Size on y-axis');
set (handles.text9,'BackgroundColor','0.68, 0.92, 1');

%displaying the Y_AXIX (Plot-1) selection on GUI & changing colour field
set (handles.text10,'enable','on');
set (handles.text10,'string','Samples on x-axis');
set (handles.text10,'BackgroundColor','0.68, 0.92, 1');
%Updating handles
guidata(hObject, handles);


% --- Executes on button press in Report.
function Report_Callback(hObject, eventdata, handles)
% hObject    handle to Report (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Checking if axes is empty or No...
if isempty(get(handles.axes, 'Children')) == 0
    
    if handles.snap_count ~= 0
        % checking if there is already any RPT name previously selected or NO...
        if isempty(handles.rptname)
            % If no RPT name is already selected, then asking user to select RPT file
            [filename ,pathname] = uigetfile({'*.rpt'},'Select RPT file');
            % checking if user has selected any RPT file or NO...
            if filename~=0
                % if user has selected some RPT file....
                
                % removing last 4 characters from file name
                filename = filename(1:end-4);
                % Generate the report from slected RPT file in folder that have RPT file
                report (filename, '-fpdf');
                % saving the rpt name in handles
                handles.rptname = filename;
            else
                % if user did not selected any RPT file. disply error
                set (handles.text3,'String','NO RPT file slected');
                msgbox('No report can be genrated', 'Error');
            end
            % if there is already PRT name present... that user has selected
            % previously
        else
            % Generate the report from slected RPT file in folder that have RPT file
            report (handles.rptname, '-fpdf');
        end
    else
        set (handles.text3,'String','No Plot is added to Report yet');
        msgbox('No Plot is added to Report yet', 'Error');
    end
    
    % is the axes is empty... no plot available...disply error
else
    set (handles.text3,'String','No Plot available to add in Report');
    msgbox('No Plot available to add in Report', 'Error');
end
%setting snap count to zerro.
handles.snap_count = 0;
% deleting the png files
delete('*.bmp');
%Updating handles
guidata(hObject, handles);

% --- Executes on button press in Add_to_report.
function Add_to_report_Callback(hObject, eventdata, handles)
% hObject    handle to Add_to_report (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if isempty(get(handles.axes, 'Children')) == 0
    
    % incrementing the snap counter
    handles.snap_count = handles.snap_count + 1;
    % converting the counter output to string.. to give as file name
    snap_name = num2str(handles.snap_count);
    % making a new string for file extention
    format = '.bmp';
    %combining strings of ---file name & file extension
    snap_name_full = [snap_name format];
    
    % getting frame from axes
    Frame = getframe(handles.axes);
    %new figure
    %f1 = figure();
    
    %show selected axes in new figure
    %image(F.cdata);
    % getting image from frame.
    Image = frame2im(Frame);
    %save
    %saveas(f1, snap_name, 'bmp');
    % writing image object to a file
    imwrite(Image, snap_name_full);
    % close fig
    %close(f1);
    
    % is the axes is empty... no plot available...disply error
else
    set (handles.text3,'String','No Plot available to add in Report');
    msgbox('No Plot available to add in Report', 'Error');
end
%Updating handles
guidata(hObject, handles);


% --- Executes on selection change in listbox2.---(Plot 1, X-Axix)
function listbox2_Callback(hObject, eventdata, handles)
% hObject    handle to listbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox2

%Getting the value of selected index in listbox
index_selected = get(handles.listbox2,'Value');
file_list = get(handles.listbox2,'String');

% Item selected in list box
handles.xaxis = file_list{index_selected};

%if user clicks on any element of list... radio button selected
%automatically
if get (handles.radiobutton3, 'Value') == 0
    set (handles.radiobutton3, 'Value', 1);
    set (handles.radiobutton4, 'Value', 0);
end

%Updating handles
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function listbox2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in listbox3.---(Plot 1, Y-Axix)
function listbox3_Callback(hObject, eventdata, handles)
% hObject    handle to listbox3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox3 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox3

%Getting the value of selected index in listbox
index_selected = get(handles.listbox3,'Value');
file_list = get(handles.listbox3,'String');

% Item selected in list box
handles.yaxis = file_list{index_selected};

%if user clicks on any element of list... radio button selected
%automatically
if get (handles.radiobutton3, 'Value') == 0
    set (handles.radiobutton3, 'Value', 1);
    set (handles.radiobutton4, 'Value', 0);
end

%Updating handles
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function listbox3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection in Macros_listbox.
function Macros_listbox_Callback(hObject, eventdata, handles)
% hObject    handle to Macros_listbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns Macros_listbox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Macros_listbox

%Getting the value of selected index in listbox
index_selected = get(handles.Macros_listbox,'Value');
file_list = get(handles.Macros_listbox,'String');

% Item selected in list box
handles.sval = file_list{index_selected};

%if user clicks on any element of list... radio button selected
%automatically
if get (handles.radiobutton4, 'Value') == 0
    set (handles.radiobutton4, 'Value', 1);
    set (handles.radiobutton3, 'Value', 0);
end

%Updating handles
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function Macros_listbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Macros_listbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

%getting new slider value
newVal = get(hObject,'Value');
% save the last slider value
lastVal = round(handles.lastSliderVal,0);
%comparing if last slider value is different from new value..
if newVal ~= lastVal
    zoom out;
    %save new value to last value
    handles.lastSliderVal= newVal;
    % update handles
    guidata(hObject,handles);
    %rounding off the value to interger
    newVal = round(newVal,0);
    
    %if No Macros selected but ploting from custom list
    if get(handles.radiobutton3, 'Value') == 1
        
        %extracting the new values of X & Y as per selected time value from slider
        %declaring memory for new vector creation
        timedepndtx = zeros(1, newVal);
        timedepndty = zeros(1, newVal);
        %converting memory to cell from number
        timedepndtx = num2cell(timedepndtx);
        timedepndty = num2cell(timedepndty);
        %filling up new memory with values of x & y upto value of slider
        for i=1:newVal
            timedepndtx{i} = handles.vector1{i};
            timedepndty{i} = handles.vector2{i};
        end
        %converting string to double
        timedepndtx = str2double(timedepndtx);
        timedepndty = str2double(timedepndty);
        
        %saving extracted Vectors of values in Handles
        handles.timedepndtx = timedepndtx;
        handles.timedepndty = timedepndty;
        cla;
        %Plotting new values of x & y
        plot(timedepndtx, timedepndty, 'g','LineWidth',1);
        %setting the axes limits
        axis([handles.xli_min handles.xli_max handles.yli_min handles.yli_max]);
        grid on;
        grid minor;
        title(' CUSTOMIZE PLOT ');
        legend(handles.yaxis, 'Location','northeast');
        zoom on;
        h = zoom(handles.axes);
        set(h, 'RightClickAction', 'PostContextMenu');
        
        
        %finding timestamp value at the slider present value
        tstampval = str2double(handles.sliderrego{newVal});
        tstampval = num2str(tstampval);
        
        %printing Timestamp value on GUI
        set (handles.text22,'Enable','on');
        set (handles.text22,'BackgroundColor','0.94, 0.94, 0.94');
        set (handles.text22,'string', (['Time stamp value - ' tstampval ]) );
    end
    
    %If Macros Selected
    if get(handles.radiobutton4, 'Value') == 1
        
        switch char(handles.sval)
            %extracting new values of x & y upto the value of slider
            case char('Ego-Vehicle Velocity')
                %extracting the new values of X & Y as per selected time value from slider
                %declaring memory for new vector creation
                timedepndtx1 = zeros(1, newVal);
                timedepndty1 = zeros(1, newVal);
                %converting memory to cell from number
                timedepndtx1 = num2cell(timedepndtx1);
                timedepndty1 = num2cell(timedepndty1);
                %filling up new memory with values of x & y upto value of slider
                for i=1:newVal
                    timedepndtx1{i} = handles.vector1{i};
                    timedepndty1{i} = handles.vector2{i};
                end
                %converting string to double
                timedepndtx1 = str2double(timedepndtx1);
                timedepndty1 = cell2mat(timedepndty1);
                
                %saving extracted Vectors of values in Handles
                handles.timedepndtx1 = timedepndtx1;
                handles.timedepndty1 = timedepndty1;
                cla;
                %Plotting new values of x & y
                plot(timedepndtx1, timedepndty1, 'b','LineWidth',1);
                %setting the axes limits
                axis([handles.xli_min handles.xli_max handles.yli_min handles.yli_max]);
                grid on;
                grid minor;
                title('Ego-Vehicle Velocity');
                legend('Mean Velocity','Location','northeast');
                ylabel('Mean Velocity');
                xlabel('Time Stamp');
                zoom on;
                h = zoom(handles.axes);
                set(h, 'RightClickAction', 'PostContextMenu');
                
                %extracting timestamp value from slider
                tstampval = str2double(handles.sliderrego{newVal});
                
            case char('Ego-Vehicle Acceleration')
                
                %extracting the new values of X & Y as per selected time value from slider
                %declaring memory for new vector creation
                timedepndtx1 = zeros(1, newVal);
                timedepndty1 = zeros(1, newVal);
                %converting memory to cell from number
                timedepndtx1 = num2cell(timedepndtx1);
                timedepndty1 = num2cell(timedepndty1);
                %filling up new memory with values of x & y upto value of slider
                for i=1:newVal
                    timedepndtx1{i} = handles.vector1{i};
                    timedepndty1{i} = handles.vector2{i};
                end
                %converting string to double
                timedepndtx1 = str2double(timedepndtx1);
                timedepndty1 = cell2mat(timedepndty1);
                
                %saving extracted Vectors of values in Handles
                handles.timedepndtx1 = timedepndtx1;
                handles.timedepndty1 = timedepndty1;
                cla;
                %Plotting new values of x & y
                plot(timedepndtx1, timedepndty1, 'b','LineWidth',1);
                %setting the axes limits
                axis([handles.xli_min handles.xli_max handles.yli_min handles.yli_max]);
                grid on;
                grid minor;
                title('Ego-Vehicle Acceleration');
                legend('Mean Acceleration','Location','northeast');
                ylabel('Mean Acceleration');
                xlabel('Time Stamp');
                zoom on;
                h = zoom(handles.axes);
                set(h, 'RightClickAction', 'PostContextMenu');
                
                %extracting timestamp value from slider
                tstampval = str2double(handles.sliderrego{newVal});
                
            case char('EPM Reception Points')
                
                %extracting the new values of X & Y as per selected time value from slider
                %declaring memory for new vector creation
                timedepndtx1 = zeros(newVal, 1);
                timedepndty1 = zeros(newVal, 1);
                %converting memory to cell from number
                timedepndtx1 = num2cell(timedepndtx1);
                timedepndty1 = num2cell(timedepndty1);
                %filling up new memory with values of x & y upto value of slider
                for i=1:newVal
                    timedepndtx1{i} = handles.vector1{i};
                    timedepndty1{i} = handles.vector2{i};
                end
                %%converting string to double  for plot1
                timedepndtx1 = str2double(timedepndtx1);
                timedepndty1 = str2double(timedepndty1);
                %saving extracted Vectors of values in Handles
                handles.timedepndtx1 = timedepndtx1;
                handles.timedepndty1 = timedepndty1;
                
                %extracting timestamp value from slider
                tstampval = str2double(handles.sliderrego{newVal});
                
                %seaarching the above found time stamp--- in EPMafterRotation
                %file. and finding timestamp index value
                tstampindex = -1;
                for j=1:handles.countaftro
                    a=(str2double(handles.sliderraftro(j)));
                    if tstampval >= (a)
                        tstampindex = j;
                    end
                end
                
                cla;
                %plotting
                plot(timedepndtx1,timedepndty1,'r', 'LineWidth',1);
                %setting the axes limits
                axis([handles.xli_min handles.xli_max handles.yli_min handles.yli_max]);
                hold on;
                title('EPM Reception Points');
                legend('coordinates of vehicle','Relative distance to Ego-vehicle','Location','southeast');
                grid on;
                grid minor;
                ylabel('Longitude in degrees');
                xlabel('Latitude in degrees');
                zoom on;
                h = zoom(handles.axes);
                set(h, 'RightClickAction', 'PostContextMenu');
                
                % if slider has some time stamp value that is in the
                % range of timestamps of AfterRO...
                if tstampindex ~= -1
                    %extracting values of x & y upto timestamp value from
                    %EMPafterRotation. allocating memory to save new values
                    timedepndtx2 = zeros(tstampindex, 1);
                    timedepndty2 = zeros(tstampindex, 1);
                    %converting memory to cell from number
                    timedepndtx2 = num2cell(timedepndtx2);
                    timedepndty2 = num2cell(timedepndty2);
                    %filling up new memory with values of x & y upto value of slider
                    for k=1:tstampindex
                        timedepndtx2{k} = handles.vector3{k};
                        timedepndty2{k} = handles.vector4{k};
                    end
                    
                    %%converting string to double  for plot2
                    timedepndtx2 = cell2mat(timedepndtx2);
                    timedepndty2 = cell2mat(timedepndty2);
                    
                    %saving extracted Vectors of values in Handles
                    handles.timedepndtx2 = timedepndtx2;
                    handles.timedepndty2 = timedepndty2;
                    
                    plot(timedepndtx2,timedepndty2,'x', 'color', 'g');
                    %setting the axes limits
                    axis([handles.xli_min handles.xli_max handles.yli_min handles.yli_max]);
                    title('EPM Reception Points');
                    legend('coordinates of vehicle','Relative distance to Ego-vehicle','Location','southeast');
                    grid on;
                    grid minor;
                    ylabel('Longitude in degrees');
                    xlabel('Latitude in degrees');
                    zoom on;
                    h = zoom(handles.axes);
                    set(h, 'RightClickAction', 'PostContextMenu');
                    
                end
                
            case char('EPM Message Size')
                
                %extracting timestamp value from slider
                tstampval = str2double(handles.sliderraftrx{newVal});
                
                %extracting the new values of X & Y as per selected time value from slider
                %declaring memory for new vector creation
                timedepndtx1 = zeros(1, newVal);
                timedepndty1 = zeros(1, newVal);
                %converting memory to cell from number
                timedepndtx1 = num2cell(timedepndtx1);
                timedepndty1 = num2cell(timedepndty1);
                %filling up new memory with values of x & y upto value of slider
                for i=1:newVal
                    timedepndtx1{i} = handles.vector1{i};
                    timedepndty1{i} = handles.vector2{i};
                end
                %converting string to double
                timedepndtx1 = str2double(timedepndtx1);
                timedepndty1 = str2double(timedepndty1);
                
                %saving extracted Vectors of values in Handles
                handles.timedepndtx1 = timedepndtx1;
                handles.timedepndty1 = timedepndty1;
                cla;
                %Plotting new values of x & y
                plot(timedepndtx1, timedepndty1, 'b','LineWidth',1);
                %setting the axes limits
                axis([handles.xli_min handles.xli_max handles.yli_min handles.yli_max]);
                title('EPM Message Size');
                legend('Message Size','Location','north');
                grid on;
                grid minor;
                ylabel('Message Size');
                xlabel('Time Stamp');
                zoom on;
                h = zoom(handles.axes);
                set(h, 'RightClickAction', 'PostContextMenu');
                
        end
        %converting timestamp value into string to display
        tstampval = num2str(tstampval);
        %printing Timestamp value on GUI
        set (handles.text22,'Enable','on');
        set (handles.text22,'BackgroundColor','0.94, 0.94, 0.94');
        set (handles.text22,'string', (['Time stamp value - ' tstampval ]) );
        
    end
end
%Updating handles
guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



% --- Executes on button press in radiobutton3.
function radiobutton3_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton3
%taking current value of radio button

if get(hObject,'Value') ==1
    set (handles.radiobutton4, 'Value', 0);
    set (handles.text3,'string','Make your selection from "CUSTOMIZE PLOT" to plot');
end
%Updating handles
guidata(hObject, handles);

% --- Executes on button press in radiobutton4.
function radiobutton4_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton4

%getting present value of the radio button

if get(hObject,'Value') ==1
    set (handles.radiobutton3, 'Value', 0);
    set (handles.text3,'string','Make your selection from "MACROS PLOT" to plot');
end
%Updating handles
guidata(hObject, handles);



function sliderstep_Callback(hObject, eventdata, handles)
% hObject    handle to sliderstep (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of sliderstep as text
%        str2double(get(hObject,'String')) returns contents of sliderstep as a double

% geting the string and converting into double
sliderstepval = str2double(get(hObject,'String'));
if handles.scan_ok ==true
    %checking if value are valid real number
    if isnan(sliderstepval) || ~isreal(sliderstepval)
        
        % if not correct value...
        set (handles.text3,'string','Error: Selection is not a Number');
        msgbox('Error: Selection is not a Number');
        set (handles.sliderstep, 'string', '');
        
        %if correct value...
    else
        % checking if value is greater then 0
        if sliderstepval > 0
            % Round up to the next integer
            sliderstepval = ceil(sliderstepval);
            % updating handles
            handles.sliderstepval = sliderstepval;
            %checking if the present plot is EPM Message Size or No...
            if  strcmp(handles.sval , 'EPM Message Size')  == 1
                
                %if yes setting slider values to AfterRx time stamps
                set(handles.slider1, 'Min', 1);
                set(handles.slider1, 'Max', handles.countaftrx);
                set(handles.slider1, 'Value', handles.countaftrx);
                set(handles.slider1, 'SliderStep', [ handles.sliderstepval/handles.countaftrx, (handles.sliderstepval*10)/handles.countaftrx ]);
            else
                
                %if no setting slider values to EgoData time stamps
                set(handles.slider1, 'Min', 1);
                set(handles.slider1, 'Max', handles.countego);
                set(handles.slider1, 'Value', handles.countego);
                set(handles.slider1, 'SliderStep', [ handles.sliderstepval/handles.countego, (handles.sliderstepval*10)/handles.countego ]);
            end
        else
            % if not correct...
            set (handles.text3,'string','Error: Selection is not a Positive integer');
            msgbox('Error: Selection is not a Positive integer');
            set (handles.sliderstep, 'string', '');
        end
        
    end
else
    % clearing the value if not correct
    set (handles.sliderstep, 'string', '');
end

%Updating handles
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function sliderstep_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sliderstep (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
