function TracksMeasure(hObject, eventdata, handles)

Tracks = getappdata(handles.figure1,'Tracks');
TrackX = getappdata(handles.figure1,'TrackX');
TrackY = getappdata(handles.figure1,'TrackY');
Links = getappdata(handles.figure1,'Links');
centers = getappdata(handles.figure1,'centers');
radii = getappdata(handles.figure1,'radii');
noFrames = getappdata(handles.figure1,'finIndex');

%% Data for links

for i = 1:size(Links,1)
    beforeFrame = Links(i,1);
    afterFrame = Links(i,2);
    beforeIndex = Links(i,3);
    afterIndex = Links(i,4);
    
    x1 = centers{beforeFrame}(beforeIndex,1);
    y1 = centers{beforeFrame}(beforeIndex,2);
    x2 = centers{afterFrame}(afterIndex,1);
    y2 = centers{afterFrame}(afterIndex,2);
    
    dataLinks(i,1) = beforeFrame; % Frame before link
    dataLinks(i,2) = sqrt((x1-x2).^2 + (y1-y2).^2); % Distance between links
end

figure;
plot(dataLinks(:,1),dataLinks(:,2),'x')

%% Save all Links speed

[FileName,PathName] = uiputfile('allLinks.txt');
[fileID,errmsg] = fopen(fullfile(PathName,FileName),'w');
fprintf(fileID,'%5d %5d\r\n',dataLinks');
fclose(fileID);


%% Data for Tracks

for i = 1:size(Tracks,1)
    Index = 1:noFrames;
    currentTrack = Tracks(i,Tracks(i,:)>0);
    currentTrackIndex = Index(Tracks(i,:)>0); % this is the frame
    frameTrack{i} = currentTrackIndex(1:end-1); % this the frame before the track link
    
    if ~isempty(currentTrack)
        for j = 1:length(currentTrack)-1
            beforeFrame = currentTrackIndex(j);
            afterFrame = currentTrackIndex(j+1);
            beforeIndex = currentTrack(j); % this is the bubble index
            afterIndex = currentTrack(j+1);
            
            x1 = centers{beforeFrame}(beforeIndex,1);
            y1 = centers{beforeFrame}(beforeIndex,2);
            x2 = centers{afterFrame}(afterIndex,1);
            y2 = centers{afterFrame}(afterIndex,2);
            
            
            distanceTracks{i}(j) = sqrt((x1-x2).^2 + (y1-y2).^2);
            radiusTracks{i}(j) = radii{beforeFrame}(beforeIndex);
        end
        
    end
    
end

figure; hold on
for i = 1:size(Tracks,1)
    plot(frameTrack{i},distanceTracks{i},'-x')
end

figure; hold on
for i = 1:size(Tracks,1)
    plot(frameTrack{i},radiusTracks{i},'-x')
end

figure; hold on
for i = 1:size(Tracks,1)
    plot(radiusTracks{i},distanceTracks{i},'x')
end

%% Save all Track info

[FileName,PathName] = uiputfile('allTracks.txt');
[fileID2,errmsg] = fopen(fullfile(PathName,FileName),'w');
for i = 2:size(Tracks,1)
    fprintf(fileID2,'%i %5d %5d %5d\r\n',[repmat(i,1,length(frameTrack{i}));frameTrack{i};distanceTracks{i};radiusTracks{i}]);
end
fclose(fileID2);

end