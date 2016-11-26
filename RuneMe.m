% MATLAB script for Assessment Item-1
close all;

% Step-1: Load input image
ImOrig = imread('AssignmentInput.jpg');
figure;
imshow(ImOrig);
title('Step-1: Load input image');


% Step-2: Conversion of input image to greyscale
ImGray = rgb2gray(ImOrig);
figure;
imshow(ImGray);
title('Step-2: Conversion of input image to greyscale');


% Step-3: Noise removal
figure;
ImMedian = medfilt2(ImGray);
imshow(ImMedian)
title('Step-3: Removal of noise');


% Step-4: Enhance image
figure;
ImEnhanced = imadjust(ImMedian,[0.8 1],[0 1]);
imshow(ImEnhanced)
title('Step-4: Enhance image');


% Step-5: Convert to binary image
figure;
ImBin = im2bw(ImEnhanced);
%ImBin = imbinarize(ImEnhanced);
ImInvert = imcomplement(ImBin);
imshow(ImInvert)
title('Step-5: Convert to binary image');


% Step-6: morphological processing
figure;
se = strel('disk', 2);

% Dilate Image
ImDil = imdilate(ImInvert,se);
subplot(2,2,1);
imshow(ImDil)
title('dilate');

% Erode Image
ImEro = imerode(ImInvert,se);
subplot(2,2,2);
imshow(ImEro)
title('erode');

% Open Image
ImOpe = imopen(ImInvert,se);
subplot(2,2,3);
imshow(ImOpe)
title('open');

% Close Image
ImClo = imclose(ImInvert,se);
subplot(2,2,4);
imshow(ImClo)
title('close');

figure;
imshow(ImOpe)
title('Step-6: Morphological Processing');


% Step-7: Automatic Recognition
figure;
% bwlable numbers pixels based upon whichobject it is connected to. 
ImObjects = bwlabel(ImOpe);
imshow(ImObjects)
title('Objects seperated');

% get number of detected objects (72)
NumObjects = max(max(ImObjects));

for id=1:NumObjects
	subplot(8,9,id);
	ImTempShape = ImObjects;
	% for each pixel
	for i=1:size(ImObjects,1)
		for j=1:size(ImObjects,2)
			% if pixel matches current searching id
			if(ImObjects(i,j) == id)
				% set object pixel to white
				ImTempShape(i,j) = 1;
			else
				% set non-object pixel to black
				ImTempShape(i,j) = 0;
			end
		end
	end  
	
	imshow(ImTempShape)
	title(strcat('shape no. ', num2str(id)));
end

figure;
ImEdge = edge(ImOpe,'Canny');
imshow(ImEdge)
title('Canny edge detection');
%title('Step-7: Automatic Recognition');



