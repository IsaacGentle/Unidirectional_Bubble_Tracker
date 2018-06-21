function deleteOverlap(hObject, eventdata, handles)

currentIndex = getappdata(handles.figure1,'currentIndex');

centersAll = getappdata(handles.figure1,'centers');
radiiAll = getappdata(handles.figure1,'radii');
metricAll = getappdata(handles.figure1,'metric');

centers = centersAll{currentIndex};
radii = radiiAll{currentIndex};
metric = metricAll{currentIndex};

tol = str2num(get(handles.edit1,'String'));
for i = 1:length(centers)-1
    for k = i+1:length(centers)
        
        distanceApart = sqrt((centers(i,1)-centers(k,1)).^2+(centers(i,2)-centers(k,2)).^2);
        R = radii(i)+radii(k)-tol;
        
        if distanceApart < R
           % Remove the one with the lowest metric
           
           if metric(i) > metric(k)
               % bubble j has the lowest metric...
                radii(k) = 0;
           else
               % bubble i has the lowest metric...
                radii(i) = 0;
           end
           
        end
        
    end
end

% Remove bubbles with zero radii
centers(radii==0,:) = [];
metric(radii==0) = [];
radii(radii==0) = [];


centersAll{currentIndex} = centers;
radiiAll{currentIndex} = radii;
metricAll{currentIndex} = metric;


setappdata(handles.figure1,'centers',centersAll);
setappdata(handles.figure1,'radii',radiiAll);
setappdata(handles.figure1,'metric',metricAll);

updateImage(hObject, eventdata, handles)

end