function [Tracks,TrackX,TrackY] = Links2Tracks(hObject, eventdata, handles)

centers = getappdata(handles.figure1,'centers');
noFrames = getappdata(handles.figure1,'finIndex');
Links = getappdata(handles.figure1,'Links');

% Make tracks from links
Tracks = zeros(1,noFrames);

for i = 1:size(Links,1)
    beforeFrame = Links(i,1);
    afterFrame = Links(i,2);
    beforeIndex = Links(i,3);
    afterIndex = Links(i,4);
    
    % search Tracks for tracks that contain bubble 1
    TracksFrame = Tracks(:,beforeFrame);
    TrackIndex = find(TracksFrame==beforeIndex);
    
    if isempty(TrackIndex)
        % make new track
        Tracks(end+1,:) = zeros(1,noFrames);
        Tracks(end,beforeFrame) = beforeIndex;
        Tracks(end,afterFrame) = afterIndex;
    else
        % Add to existing track
        Tracks(TrackIndex,beforeFrame) = beforeIndex;
        Tracks(TrackIndex,afterFrame) = afterIndex;
    end
    
end

TrackX =[];TrackY=[];
for TrackNum = 1:size(Tracks,1)
    for i = 1:noFrames
        if Tracks(TrackNum, i) ~= 0
            TrackX(i,TrackNum) = centers{i}(Tracks(TrackNum ,i),1);
            TrackY(i,TrackNum) = centers{i}(Tracks(TrackNum ,i),2);
        end
    end
end


setappdata(handles.figure1,'Tracks',Tracks);
setappdata(handles.figure1,'TrackX',TrackX);
setappdata(handles.figure1,'TrackY',TrackY);

end
