clear all;
clc;

addpath('D:\Software Projects\matlab-vigrade-interfacing\interface'); % check if it actually imports everything

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