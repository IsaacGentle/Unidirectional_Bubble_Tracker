function updateImage(hObject, eventdata, handles)

currentIndex = getappdata(handles.figure1,'currentIndex');
RawImage = getappdata(handles.figure1,'RawImage');
finIndex = getappdata(handles.figure1,'finIndex');
% zoomIn = getappdata(handles.figure1,'zoomIn');
% zoomOut = getappdata(handles.figure1,'zoomOut');

% Get current zoom
v = axis;

% % zoom in or zoom out if this is called for
% if zoomIn
%     v = v*0.8;
%     setappdata(handles.figure1,'zoomIn',0);
% end
% if zoomOut
%     v = v/0.8;
%     setappdata(handles.figure1,'zoomOut',0);
% end

if handles.checkbox6.Value
    imshow(RawImage(:,:,currentIndex),'Parent',handles.axes1)
else
    cla(handles.axes1)
end

if handles.checkbox1.Value
    centers = getappdata(handles.figure1,'centers');
    radii = getappdata(handles.figure1,'radii');
    viscircles(handles.axes1,centers{currentIndex}, radii{currentIndex},'color','r');
    if handles.checkbox9.Value
%         for i = 1:finIndex
            i = currentIndex;
            for k = 1:length(radii{i})
                 metricB1_string = sprintf('%i',k);  
                 text(centers{i}(k,1),centers{i}(k,2),metricB1_string,'color','k','HorizontalAlignment', 'center','VerticalAlignment', 'middle','FontSize',8);
            end
%         end
    end
end

% Reset image to current zoom
if isappdata(handles.pushbutton10,'ResetButton')
    if getappdata(handles.pushbutton10,'ResetButton') == 0
        axis(v)
    else % the view is reset
        setappdata(handles.pushbutton10,'ResetButton',0)
    end
else
    axis(v)
end

if handles.checkbox5.Value
    hold(handles.axes1,'on')
    Tracks = getappdata(handles.figure1,'Tracks');
    TrackX = getappdata(handles.figure1,'TrackX');
    TrackY = getappdata(handles.figure1,'TrackY');

    if handles.checkbox7.Value % filter frames
        noFramesBefore = str2num(handles.edit15.String);
        noFramesAfter = str2num(handles.edit16.String);

        if currentIndex - noFramesBefore > 1
            beforeIndex = currentIndex - noFramesBefore;
        else
            beforeIndex = 1;
        end
        if currentIndex + noFramesBefore < finIndex
            afterIndex = currentIndex + noFramesAfter;
        else
            afterIndex = finIndex;
        end
        
        TrackXfiltered = TrackX(beforeIndex:afterIndex,:);
        TrackYfiltered = TrackY(beforeIndex:afterIndex,:);
    else
        TrackXfiltered = TrackX; TrackYfiltered = TrackY;
    end
        
    
    
    for TrackNum = 1:size(Tracks,1)
        nonZeroLogical = TrackXfiltered(:,TrackNum)>0;
        plot(handles.axes1, ...
            TrackXfiltered(nonZeroLogical,TrackNum), ...
            TrackYfiltered(nonZeroLogical,TrackNum));
    end
    hold(handles.axes1,'off')
end

% Update the slider and text
set(handles.text2, 'String', [num2str(currentIndex),'/',num2str(finIndex)]);
set(handles.slider1, 'Value', (currentIndex-1)/(finIndex-1));

end