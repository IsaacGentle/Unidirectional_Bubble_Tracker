function addCircle(hObject, eventdata, handles, x, y )

currentIndex = getappdata(handles.figure1,'currentIndex');
finIndex = getappdata(handles.figure1,'finIndex');

if isappdata(handles.figure1,'centers')
    centers = getappdata(handles.figure1,'centers');
    radii = getappdata(handles.figure1,'radii');
    doesNotExistSoCreate = 0;
else
    doesNotExistSoCreate = 1;
    centers = cell(1,finIndex); radii = cell(1,finIndex);
end
    
sucessfulPlacement = false;
while ~sucessfulPlacement
    
% [x,y] = ginput(1); % centre
[xR,yR] = ginput(1); % point on radius
hold(handles.axes1,'on')
plot(handles.axes1,xR,yR,'bx');

[x2,y2] = ginput(1); % point on radius
plot(handles.axes1,x2,y2,'bx');

% this calculation is for the bubble centre when two radius points are
% given
x = xR - (xR-x2)/2;
y = yR - (yR-y2)/2;

r = sqrt((x2-x)^2 + abs(y2-y)^2);

th = 0:pi/50:2*pi;
xunit = r * cos(th) + x;
yunit = r * sin(th) + y;

h = plot(handles.axes1,xunit, yunit,'b');

[x3,y3] = ginput(1);
distanceFromCentre = sqrt((x3-x)^2 + abs(y3-y)^2);

if distanceFromCentre > r
    sucessfulPlacement = true;
end

set(h,'Color','y')

end

hold(handles.axes1,'off')

if doesNotExistSoCreate
    centers{currentIndex}(1,:) = [x,y];
    radii{currentIndex}(1) = [r];
else
    centers{currentIndex}(end+1,:) = [x,y];
    radii{currentIndex}(end+1) = [r];
end
setappdata(handles.figure1,'centers',centers);
setappdata(handles.figure1,'radii',radii);

updateImage(hObject, eventdata, handles)

end