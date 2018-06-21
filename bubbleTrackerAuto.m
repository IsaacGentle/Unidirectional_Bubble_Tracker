function bubbleTrackerAuto(hObject, eventdata, handles)

currentIndex = getappdata(handles.figure1,'currentIndex');
noFrames = getappdata(handles.figure1,'finIndex');
centers = getappdata(handles.figure1,'centers');
radii = getappdata(handles.figure1,'radii');

%%

% Set up wait bar
h = waitbar(0,'Processing');

% This matrix holds all the links information
Links = [];

% Set up UnlinkedPool, LinkedPool, GivenUpPool logicals
% These are keeping track of whether it is linked to a bubble in the next
% frame

for i = 1:noFrames-1
    UnlinkedPool{i} = ones(1,length(centers{i}));
    AllUnlinked{i} = centers{i}(find(UnlinkedPool{i}),:);
    LinkedPool{i} = zeros(1,length(centers{i}));
    GivenUpPool{i} = zeros(1,length(centers{i}));
end

% Search parameters
R1 = str2num(get(handles.edit11,'String')); % search radius
R2 = str2num(get(handles.edit12,'String'));
D = str2num(get(handles.edit14,'String')); % distance travel in a frame
theta = str2num(get(handles.edit13,'String'))*(2*pi/360); % Angle at which bubble travels
plotOn = get(handles.checkbox4,'Value');

for frame = 1:noFrames-1
    unlinkedBubbles = 1;
    
    if plotOn
        figure(2); cla;
    end
    while unlinkedBubbles
        % Choose first unlinked bubble 
        beforeIndex = find(UnlinkedPool{frame},1); % index of bubble that will be searched for in next frame
        bubble = AllUnlinked{frame}(1,:);

        L = linspace(0,2.*pi,20);
        xv = bubble(1) - D*cos(theta) + R1*cos(L).*cos(theta) - R2*sin(L).*sin(theta);
        yv = bubble(2) - D*sin(theta) + R1*cos(L).*sin(theta) + R2*sin(L).*cos(theta);
        
        if plotOn
            figure(2);
            viscircles(centers{frame+1}, radii{frame+1},'color','b');
            hold on
            plot(xv,yv)
            plot([bubble(1),bubble(1)-D*cos(theta)],[bubble(2),bubble(2)-D*sin(theta)],'-x')
            drawnow
        end
        
        xq = centers{frame+1}(:,1);
        yq = centers{frame+1}(:,2);

        [in,on] = inpolygon(xq,yq,xv,yv);

        if numel(xq(in)) == 1 % Only one bubble in search radius
            inIndex = find(in);
            Links(end+1,:) = [frame, frame+1, beforeIndex,inIndex];

            % Move bubble from unlinked pool to linked
            UnlinkedPool{frame}(beforeIndex) = 0;
            LinkedPool{frame}(beforeIndex) = 1;

        else
            % Move bubble from unlinked pool to given up
            UnlinkedPool{frame}(beforeIndex) = 0;
            GivenUpPool{frame}(beforeIndex) = 1;
        end

        
        % update unlinked bubble
        AllUnlinked{frame} = centers{frame}(find(UnlinkedPool{frame}),:);
        
        % Calc number of bubbles left for frame
        numberLeft = length(AllUnlinked{frame});
        fprintf('Bubble left %i for frame %i\n',numberLeft,frame)
        
        if numberLeft == 0
            unlinkedBubbles = 0;
        end
        
    end
    
    waitbar(frame/(noFrames-1),h)

end

%% Make tracks from links

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


% Save data to app data
setappdata(handles.figure1,'Tracks',Tracks)
setappdata(handles.figure1,'Links',Links)
setappdata(handles.figure1,'TrackX',TrackX)
setappdata(handles.figure1,'TrackY',TrackY)

% Set plot tracks checkbox on
set(handles.checkbox5,'Value',1)

% Update image
updateImage(hObject, eventdata, handles)
close(h)

%% Display

disp('Success!')

% for i = 1:noFrames-1
%     disp(length(find(GivenUpPool{i})))
% end

% for i = 1:noFrames-1
%     disp(length(find(LinkedPool{i})))
% end

end