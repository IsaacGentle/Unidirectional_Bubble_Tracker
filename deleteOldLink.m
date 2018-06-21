function deleteOldLink(hObject, eventdata, handles)

currentIndex = getappdata(handles.figure1,'currentIndex');
centers = getappdata(handles.figure1,'centers');
radii = getappdata(handles.figure1,'radii');

% Get first bubble
[x,y] = ginput(1);
k = dsearchn(centers{currentIndex},[x,y]);

currentIndex = currentIndex+1;
setappdata(handles.figure1,'currentIndex',currentIndex);

updateImage(hObject, eventdata, handles)
viscircles(handles.axes1,centers{currentIndex-1}(k,:), radii{currentIndex}(k,:),'color','b');

% Get second bubble
[x2,y2] = ginput(1);
k2 = dsearchn(centers{currentIndex},[x2,y2]);

viscircles(handles.axes1,centers{currentIndex}(k2,:), radii{currentIndex}(k2,:),'color','g');

%% Find link and delete
Links = getappdata(handles.figure1,'Links');
beforeFrame = currentIndex-1;
afterFrame = currentIndex;
beforeIndex = k;
afterIndex = k2;

% Search current links

LinksLogical = ...
    Links(:,1)==beforeFrame & ...
    Links(:,2)==afterFrame & ...
    Links(:,3)==beforeIndex & ...
    Links(:,4)==afterIndex;

IndexForRemoval = find(LinksLogical);
Links(IndexForRemoval,:) = [];

Links = sortrows(Links);
setappdata(handles.figure1,'Links',Links);

Links2Tracks(hObject, eventdata, handles);

updateImage(hObject, eventdata, handles)

end