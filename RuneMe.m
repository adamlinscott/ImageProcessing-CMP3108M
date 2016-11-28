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
ImEnhanced = imadjust(ImMedian,[0.8 1],[1 0]);
imshow(ImEnhanced)
title('Step-4: Enhance image');


% Step-5: Convert to binary image
figure;
ImBin = im2bw(ImEnhanced);
%ImBin = imbinarize(ImEnhanced);
%ImInvert = imcomplement(ImBin);
imshow(ImBin)
title('Step-5: Convert to binary image');


% Step-6: morphological processing
figure;
se = strel('disk', 3);

% Dilate Image
ImDil = imdilate(ImBin,se);
subplot(2,2,1);
imshow(ImDil)
title('dilate');

% Erode Image
ImEro = imerode(ImBin,se);
subplot(2,2,2);
imshow(ImEro)
title('erode');

% Open Image
ImOpe = imopen(ImBin,se);
subplot(2,2,3);
imshow(ImOpe)
title('open');

% Close Image
ImClo = imclose(ImBin,se);
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

ImOutput = zeros(size(ImObjects));
for id=1:NumObjects
	subplot(7,8,id);
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
	
	ImEdge = edge(ImTempShape,'Canny');
	% for each pixel
	EdgeCount = 0;
	VolCount = 0;
	for i=1:size(ImEdge,1)
		for j=1:size(ImEdge,2)
			% if pixel is part of edge
			if(ImEdge(i,j) == 1)
				% increment edge count
				EdgeCount = EdgeCount + 1;
			end
			% if pixel is part of shape
			if(ImTempShape(i,j) == 1)
				% increment volume count
				VolCount = VolCount + 1;
			end
		end
	end  
	
	ShapeMetric = 4*pi*VolCount/EdgeCount^2;
	
	% if shape metric is within bounds
	if(ShapeMetric > 0.20 && ShapeMetric <0.231)
		% add image to output file
		ImOutput = ImOutput + ImTempShape;
	end
	
	imshow(ImTempShape)
	title(strcat('no. ', num2str(id), ' met:', num2str(ShapeMetric)));
end

figure;
imshow(ImOutput)
title('Step-7: Automatic Recognition');



