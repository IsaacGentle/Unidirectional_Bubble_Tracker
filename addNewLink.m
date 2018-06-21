function addNewLink(hObject, eventdata, handles)

currentIndex = getappdata(handles.figure1,'currentIndex');
centers = getappdata(handles.figure1,'centers');
radii = getappdata(handles.figure1,'radii');

% Get first bubble
[x,y] = ginput(1);
k = dsearchn(centers{currentIndex},[x,y]);

currentIndex = currentIndex+1;
setappdata(handles.figure1,'currentIndex',currentIndex);

updateImage(hObject, eventdata, handles)
viscircles(handles.axes1,centers{currentIndex-1}(k,:), radii{currentIndex-1}(k,:),'color','b');

% Get second bubble
[x2,y2] = ginput(1);
k2 = dsearchn(centers{currentIndex},[x2,y2]);

viscircles(handles.axes1,centers{currentIndex}(k2,:), radii{currentIndex}(k2,:),'color','g');

%% Make link
Links = getappdata(handles.figure1,'Links');
beforeFrame = currentIndex-1;
afterFrame = currentIndex;
beforeIndex = k;
afterIndex = k2;

% Search current links to see if there is overlap

LinksInvolvingBeforeBubble = ...
    Links(:,1)==beforeFrame & ...
    Links(:,2)==afterFrame & ...
    Links(:,3)==beforeIndex;
LinksInvolvingAfterBubble = ...
    Links(:,1)==beforeFrame & ...
    Links(:,2)==afterFrame & ...
    Links(:,4)==afterIndex;

IndexForRemoval_1 = find(LinksInvolvingBeforeBubble);
IndexForRemoval_2 = find(LinksInvolvingAfterBubble);
IndexForRemoval = unique([IndexForRemoval_1;IndexForRemoval_2]);

Links(IndexForRemoval',:) = [];

if isempty(Links)
    Links(1,1) =  beforeFrame;
    Links(1,2) = afterFrame;
    Links(1,3) = beforeIndex;
    Links(1,4) = afterIndex;
else
    Links(end+1,1) =  beforeFrame;
    Links(end,2) = afterFrame;
    Links(end,3) = beforeIndex;
    Links(end,4) = afterIndex;
end

Links = sortrows(Links);
setappdata(handles.figure1,'Links',Links);

Links2Tracks(hObject, eventdata, handles);

updateImage(hObject, eventdata, handles)

% Tracks = getappdata(handles.figure1,'Tracks');
% f = figure(2);
% t = uitable(f,'Data',Tracks);

end