function deleteCircle(hObject, eventdata, handles)

[x,y] = ginput(1);

currentIndex = getappdata(handles.figure1,'currentIndex');
centers = getappdata(handles.figure1,'centers');
radii = getappdata(handles.figure1,'radii');

k = dsearchn(centers{currentIndex},[x,y]);

centers{currentIndex}(k,:) = [];
radii{currentIndex}(k,:) = [];

setappdata(handles.figure1,'centers',centers);
setappdata(handles.figure1,'radii',radii);

updateImage(hObject, eventdata, handles)

end