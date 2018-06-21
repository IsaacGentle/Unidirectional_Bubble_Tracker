function bubbleFinderTest(hObject, eventdata, handles)



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


i = currentIndex;
% Adaptive contrast
if adapthisteqSwitch
    ProcessedImage(:,:,i) = adapthisteq(RawImage(:,:,i),'NumTiles',[NumTiles,NumTiles],'clipLimit',clipLimit,'Distribution','uniform');
end

% Sharpen
if imsharpenSwitch
    ProcessedImage(:,:,i) = imsharpen(ProcessedImage(:,:,i),'Radius',Radius,'Amount',Amount);
end

% Find circles
[centers radii metric]= imfindcircles(RawImage(:,:,i),[minRadius,maxRadius],'ObjectPolarity','dark','EdgeThreshold',EdgeThreshold,'Sensitivity',Sensitivity);
[centers2 radii2 metric2]= imfindcircles(ProcessedImage(:,:,i),[minRadius,maxRadius],'ObjectPolarity','dark','EdgeThreshold',EdgeThreshold,'Sensitivity',Sensitivity);

% Bulk radius adjustment
radii = radii - minusRadius;

figure(2)
imshowpair(RawImage(:,:,currentIndex), ProcessedImage(:,:,currentIndex), 'montage')

viscircles(centers, radii);
centers2(:,1) = centers2(:,1)+1280;
viscircles(centers2, radii2,'color','b');

end