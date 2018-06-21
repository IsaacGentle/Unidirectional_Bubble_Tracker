function bubbleFinder(hObject, eventdata, handles)

RawImage = getappdata(handles.figure1,'RawImage');
currentIndex = getappdata(handles.figure1,'currentIndex');
finIndex = getappdata(handles.figure1,'finIndex');

adapthisteqSwitch = get(handles.checkbox2,'Value');
NumTiles = str2num(get(handles.edit2,'String'));
clipLimit = str2num(get(handles.edit3,'String'));

imsharpenSwitch = get(handles.checkbox3,'Value');
Radius = str2num(get(handles.edit4,'String'));
Amount = str2num(get(handles.edit5,'String'));

minRadius = str2num(get(handles.edit6,'String'));
maxRadius = str2num(get(handles.edit7,'String'));
EdgeThreshold = str2num(get(handles.edit8,'String'));
Sensitivity = str2num(get(handles.edit9,'String'));

minusRadius = str2num(get(handles.edit10,'String'));

h = waitbar(0,'Processing');

for i = 1:finIndex
    % Adaptive contrast
    if adapthisteqSwitch
        ProcessedImage(:,:,i) = adapthisteq(RawImage(:,:,i),'NumTiles',[NumTiles,NumTiles],'clipLimit',clipLimit,'Distribution','uniform');
    end
    
    % Sharpen
    if imsharpenSwitch
    	ProcessedImage(:,:,i) = imsharpen(ProcessedImage(:,:,i),'Radius',Radius,'Amount',Amount);
    end
    
    % Find circles
    if or(adapthisteqSwitch,imsharpenSwitch)
        [centers{i} radii{i} metric{i}]= imfindcircles(ProcessedImage(:,:,i),[minRadius,maxRadius],'ObjectPolarity','dark','EdgeThreshold',EdgeThreshold,'Sensitivity',Sensitivity);
    else
        [centers{i} radii{i} metric{i}]= imfindcircles(RawImage(:,:,i),[minRadius,maxRadius],'ObjectPolarity','dark','EdgeThreshold',EdgeThreshold,'Sensitivity',Sensitivity);
    end
        
    % Bulk radius adjustment
    radii{i} = radii{i} - minusRadius;
    
    waitbar(i/finIndex,h)
end

setappdata(handles.figure1,'centers',centers);
setappdata(handles.figure1,'radii',radii);
setappdata(handles.figure1,'metric',metric);

set(handles.checkbox1,'Value',1)

updateImage(hObject, eventdata, handles)

close(h)
end