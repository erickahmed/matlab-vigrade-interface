clear all;
clc;

%% File paths
% VI-Grade init file paths
fprintf('Initialization...\n')
addpath_vicrt_20;

database = 'VI_Racer.cdb';
proj_dir = 'D:\Software Projects\matlab-vigrade-interfacing';
cd(proj_dir);
cd(database);

systemFile = 'systems.tbl\vicrt_22_M22L_21_03_22.xml';
cfg = createCfg('D:\Software Projects\matlab-vigrade-interface\VI_Racer.cdb\config\vicrt_cdb.cfg');
modelDirFiles = 'D:\Software Projects\matlab-vigrade-interface\VI_Racer.cdb\database\VI_Racer.cdb';
systemStruct = generateSystemStruct(systemFile, cfg, modelDirFiles);

baseFingerprint = 'FILEPATH\FILENAME.xml';

% Database file paths
fprintf('Loading VI subsystems\n')
aeromap      = 'aero_forces.tbl\aeromap_standard_CV.aer, database';
f_bumpstops  = 'bumpstops.tbl\vicrt_22_FrontSusp_bumpstop.xml';
r_bumpstops  = 'bumpstops.tbl\vicrt_22_RearSusp_bumpstop.xml';
f_dampers    = 'dampers.tbl\vicrt_22_VF_FrontSuspension_damper.xml';
f_dampers    = 'dampers.tbl\vicrt_22_VF_RearSuspension_damper.xml';
vdf          = 'driver_controls.tbl\Acceleration.vdf';
output_maps  = 'output_maps.tbl\VI_Racer_output_map.xml';
powertrain   = 'powertrains.tbl\Four_cylinder_600cc.pwr';
f_springs    = 'springs.tbl\vicrt_22_FrontSusp_spring.xml';
r_springs    = 'springs.tbl\vicrt_22_RearSusp_spring.xml';
f_suspension = 'suspensions.tbl\vicrt_22_FrontSusp.sgs';
r_suspension = 'suspensions.tbl\vicrt_22_RearSusp.sgs';
tir          = 'tires.tbl\Hoosier_16x75x10_R25B_7_in_rim.tir';
%loadcases   = 'loadcases.tbl\';

% Simulation file paths
fprintf('Loading simulation files\n')
graphics      = 'graphic_models.tbl\VI_Racer_graphic.xgr';
racetrack_drd = 'driver_roads.tbl\RaceTrack.drd';
racetrack_rdf = 'roads.tbl\RaceTrack.rdf';
skidpad_drd   = 'driver_roads.tbl\Skidpad.drd';
skidpad_rdf   = 'roads.tbl\Skidpad.rdf';
accel_rdf     = 'roads.tbl\Acceleration.rdf';

% note: useful function:
% coder.cinclude() allows to include a C file
% I like C !  :D

%% Input arrays

%% Outputs

fprintf('Loading complete\n')

%% Choose subsys test

subsysIn = input('Subsystem: ',  prompt)
% go back prompt here
subsystemSelect(subsysIn)

%% Get file names and path

[file_list, file_path] = uigetfile('xml', 'Choose the subsystem file', 'MultiSelect', 'on');

if iscell(file_list) == 0
    file_list = {file_list};
end

%% Ask subsystem test function
function subsystemSelect(subsys)
if(subsys <1 | subsys >)
switch subsystem 
    case 
% stuff

%% Test xml parsing function
function parseXML(IO, subsystem, sub_subsystem)
    switch subsystem
        case aeromap
            fileRead = fileread(aeromap);
            splitFile = regexp(A, '\n', 'split');
        case bumpstops
            key(1,1) = {'CRTSprungMass'};
            key(2,1) = {'body'};
            attr(1) = {'CGHeight'};

%% test: read and write stuff function
if(IO == 'read')
    % Set data to different value
    newVal = 25
    newCG = bodyGetValue{systemStruct, key, newVal}
elseif(IO == 'write')
    % Retrieve data from system file: key{tag, name}; attr(n)=attribute
    CGHeight = bodyGetValue{systemStruct, key, attr}

fprintf('Modified value: %s', CGHeight) %check if using %s is correct
            
end