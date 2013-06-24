function ImageClickCallback ( objectHandle , eventData )
%This is the funciton that used to get the coordinates of the image
   axesHandle  = get(objectHandle,'Parent');
   global coordinates;
   coordinates = get(axesHandle,'CurrentPoint'); 
   coordinates = coordinates(1,1:2);
   message     = sprintf('Pixel Coordinates:   (%.1d , %.1d)',round(coordinates (2)) ,round(coordinates (1)));
   helpdlg(message);