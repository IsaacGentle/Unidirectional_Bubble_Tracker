function bubbleMeasurement(hObject, eventdata, handles)


currentIndex = getappdata(handles.figure1,'currentIndex');
finIndex = getappdata(handles.figure1,'finIndex');

centers = getappdata(handles.figure1,'centers');
radii = getappdata(handles.figure1,'radii');


%% Things to measure
% Bubble size distribution
% Bubble volume fraction
% Number of bubbles per frame


%% Isolate bubbles that are not touching the sides

for i = 1:length(radii)
    
    % Bubble touching edges
    RightMost = centers{i}(:,1)+radii{i};
    LeftMost = centers{i}(:,1)-radii{i};
    TopMost = centers{i}(:,2)+radii{i};
    BottomMost = centers{i}(:,2)-radii{i};
    
    A = RightMost<1280;
    B = LeftMost>0;
    C = TopMost<720;
    D = BottomMost>0;
    
    Keep = A&B&C&D;
    
    centers2{i} = centers{i}(Keep);
    
    radii2{i} = radii{i}(Keep);
end



%% Bubble size distribution

% Measure radii distribution
pix2mm = 0.00329356846473029;

figure;
allRadii = [];
for i = 1:length(radii)
    allRadii = [allRadii;radii2{i}];
end
histogram(allRadii*pix2mm,50)

%% Bubble volume fraction

for i = 1:length(radii)
    clear V
    % Volume of bubbles
    V = pi*radii2{i}.^2;
    
    % Total volume of bubbles (summation)
    Vtot = sum(V);
    
    % Bubble volume fraction
    bvf(i) = Vtot/(1280*720);

end

bvf
mean(bvf)

%% Number of bubbles per frame

% Need it to be the number not touching sides??????

for i = 1:length(radii)
    numBubbles(i,1) = i;
    numBubbles(i,2) = length(radii2{i});
end

%% Save all radii data

[FileName,PathName] = uiputfile('allRadii.txt');
[fileID,errmsg] = fopen(fullfile(PathName,FileName),'w');
fprintf(fileID,'%5d\r\n',allRadii*pix2mm);
fclose(fileID);

%% Save number of bubbles per frame
[FileName,PathName] = uiputfile('No. of bubbles per frame.txt');
[fileID2,errmsg] = fopen(fullfile(PathName,FileName),'w');
fprintf(fileID2,'%i\r\n',numBubbles(:,2));
fclose(fileID2);


end