clear all;

%% Initializing VI files
addpath_vicrt_20;
cfg = createCfg('vicrt_cdb.cfg');
systemFile = 'file://C:/Users/ashwi/Desktop/VIgrade/MMRtestVehicle.xml';
modelDirFiles='crtWork';
systemStruct = generateSystemStruct(systemFile,cfg,modelDirFiles);
baseFingerprint='fingerprintSLT.xml';

%% Inputs
aeroBalF = .2:0.01:.32;
aeroBalR = ones(size(aeroBalF)) - aeroBalF;
df = 495.4;
aeroFile = 'C:\Program Files\VI-grade\VI-CarRealTime 20\acarrt\MMR_2019.cdb\aero_forces.tbl\MMR_2019_aero.aer';

%% Output arrays
laptime = NaN(size(aeroBalF));
pitchAng = NaN(size(aeroBalF));
u = cell(size(aeroBalF));
Faf = cell(size(aeroBalF));
Far = cell(size(aeroBalF));
gear = cell(size(aeroBalF));

%% Batch Simulations
for i = 1:length(aeroBalF)
    fdf = df .* aeroBalF(i);
    rdf = df .* aeroBalR(i);
    Parse_aero(aeroFile,fdf, rdf);
    [successFlag, outputNameList]=runViCrt(baseFingerprint,systemStruct,'work',modelDirFiles);
    
    split = regexp(outputNameList{1, 1} , '\', 'split');
    ResFile = strcat(split{1,2},'.csv');
    
    OUT{i} = readtable(ResFile);
    laptime(i) = OUT{i}.xTime(end);
    pitchAng(i) = mean(OUT{i}.Chassis_Pospitch);
    u{i} = OUT{i}.Speed;
    Faf{i} = OUT{i}.Aero_DownForceF;
    Far{i} = OUT{i}.Aero_DownForceR;
    gear{i} = OUT{i}.Driver_Gear;
    X{i} = OUT{i}.X;
    Y{i} = OUT{i}.Y;
    s(i) = OUT{i}.S(end);
    
end

%% Plots

% Laptime
figure(1)
clf
b = bar(aeroBalF,laptime,'BarWidth',0.7 );
text(b.XEndPoints,b.YEndPoints,string(b.YEndPoints),'HorizontalAlignment','center',...
    'VerticalAlignment','bottom');
ylim([min(laptime)-1 max(laptime)+1]);
title('Laptime')
xlabel('Aero balance- Front [*100%]')
ylabel('Laptime [s]')
grid on;
    
% Speed map
figure(2)
clf

for i = 1:length(aeroBalF)
    ax(i) = subplot(round(length(aeroBalF)/2),2,i);
    h = surf([X{i} X{i}],[Y{i} Y{i}],zeros(size([Y{i} Y{i}])),[u{i} u{i}],'EdgeColor','interp');
    title(strjoin({'Velocity maps | Front aero distribution=', sprintf('%d',aeroBalF(i)*100),'%'}));
    hold on
    plot(X{i}(1),Y{i}(1),'+')
    hold on
    idx = find(abs(diff(OUT{i}.Driver_Gear))) + 1; % gear change index
    plot(X{i}(idx),Y{i}(idx),'d')
    
    gearNum = cellstr(num2str(OUT{i}.Driver_Gear(idx)));
    text(X{i}(idx)+0.1,Y{i}(idx)+3, gearNum,'FontSize',8);
    
    [maxu(i),idxu] = max(u{i}); 
    maxuc = cellstr(num2str(maxu(i)));
    %text(X{i}(idxu),Y{i}(idxu), maxuc,'FontSize',14,'Color','r');
    
    h.LineWidth = 2;
    %h.DisplayName = 'Front aero dist: %.3f %',aeroBalF(i)*100;
    colormap('turbo')
    colorbar;
    view(2)
end
linkaxes(ax,'xy')


% Brake maps
figure(3)
clf
for i = 1:length(aeroBalF)
    ax(i) = subplot(round(length(aeroBalF)/2),2,i);
    h = surf([X{i} X{i}],[Y{i} Y{i}],zeros(size([Y{i} Y{i}])),[OUT{i}.Driver_Brake OUT{i}.Driver_Brake],'EdgeColor','interp');
    title(strjoin({'Brake % | Front aero distribution=', sprintf('%d',aeroBalF(i)*100),'%'}));
    view(2)
    h.LineWidth = 2;
    colorbar;
    colormap('turbo')
end 
linkaxes(ax,'xy')

% Throtle maps
figure(4)
clf
for i = 1:length(aeroBalF)
    ax(i) = subplot(round(length(aeroBalF)/2),2,i);    
    h = surf([X{i} X{i}],[Y{i} Y{i}],zeros(size([Y{i} Y{i}])),[OUT{i}.Driver_Brake OUT{i}.Driver_Throttle],'EdgeColor','interp');
    title(strjoin({'Throttle % | Front aero distribution=', sprintf('%d',aeroBalF(i)*100),'%'}));
    view(2)
    h.LineWidth = 2;
    colorbar;
    colormap('turbo')
end 
linkaxes(ax,'xy')



%% Functions
function Parse_aero(aeroFile,fdf, rdf)
A = fileread(aeroFile);
C = regexp(A, '\n', 'split');
C{1, 39}    =  sprintf('0	%.3f	%.3f	%.3f %.3f %.3f %.3f', fdf, fdf ,fdf ,fdf ,fdf, fdf);
C{1, 40}    =  sprintf('25	%.3f	%.3f	%.3f %.3f %.3f %.3f', fdf, fdf ,fdf ,fdf ,fdf, fdf);
C{1, 41}    =  sprintf('50	%.3f	%.3f	%.3f %.3f %.3f %.3f', fdf, fdf ,fdf ,fdf ,fdf, fdf);
C{1, 42}    =  sprintf('75	%.3f	%.3f	%.3f %.3f %.3f %.3f', fdf, fdf ,fdf ,fdf ,fdf, fdf);
C{1, 43}    =  sprintf('100	%.3f	%.3f	%.3f %.3f %.3f %.3f', fdf, fdf ,fdf ,fdf ,fdf, fdf);

C{1, 55}    =  sprintf('0	%.3f	%.3f	%.3f %.3f %.3f %.3f', rdf, rdf ,rdf ,rdf ,rdf, rdf);
C{1, 56}    =  sprintf('25	%.3f	%.3f	%.3f %.3f %.3f %.3f', rdf, rdf ,rdf ,rdf ,rdf, rdf);
C{1, 57}    =  sprintf('50	%.3f	%.3f	%.3f %.3f %.3f %.3f', rdf, rdf ,rdf ,rdf ,rdf, rdf);
C{1, 58}    =  sprintf('75	%.3f	%.3f	%.3f %.3f %.3f %.3f', rdf, rdf ,rdf ,rdf ,rdf, rdf);
C{1, 59}    =  sprintf('100	%.3f	%.3f	%.3f %.3f %.3f %.3f', rdf, rdf ,rdf ,rdf ,rdf, rdf);

combinedStr = strjoin(C,'\n');

fprintf(1,'fdf = %.3f\trdf = %.3f\n',fdf,rdf)

% Save file
fid = fopen(aeroFile, 'w+');
fprintf(fid, combinedStr);
fclose(fid);
end