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
ImEnhanced = imadjust(ImMedian,[0.8 1],[0 1]);

% figure to show histograms for per and post enhancement
figure;
subplot(2,2,1);
imshow(ImMedian)
subplot(2,2,2);
imshow(ImEnhanced)
subplot(2,2,3);
imhist(ImMedian)
subplot(2,2,4);
imhist(ImEnhanced)

figure;
imshow(ImEnhanced)
title('Step-4: Enhance image');



% Step-5(1): invert enhanced image
figure;
ImInvert = imcomplement(ImEnhanced);
imshow(ImInvert)
title('Step-5(1): Invert Enhanced image');


% Step-5(2): Convert to binary image
figure;
ImBin = im2bw(ImInvert);
%ImBin = imbinarize(ImEnhanced);
%ImInvert = imcomplement(ImBin);
imshow(ImBin)
title('Step-5(2): Convert to binary image');


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

% bwlable numbers pixels based upon which object it is connected to. 
ImObjects = bwlabel(ImOpe);

% image will look the same as prior but values will have changed to
% identify objects individually 
imshow(ImObjects)
title('Objects seperated');

% get number of detected objects (53)
NumObjects = max(max(ImObjects));
ImOutput = zeros(size(ImObjects));
for id=1:NumObjects
	ImTempShape = ImObjects;
	
	% set ImTempShape to only include object with pixels valued equal to id 
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
	
	% Create image showing edge of shape
	ImEdge = edge(ImTempShape,'Canny');
	
	EdgeCount = 0;
	VolCount = 0;
	% for each pixel
	% count area and perimiter 
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
	
	% calculate roundness metric
	ShapeMetric = 4*pi*VolCount/EdgeCount^2;
	
	% if shape metric is within bounds
	% add image to output file
	if(ShapeMetric > 0.20 && ShapeMetric <0.231)
		ImOutput = ImOutput + ImTempShape;
	end
	
	% display each object with metric value
	subplot(7,8,id);
	imshow(ImTempShape)
	title(strcat('no. ', num2str(id), ' met:', num2str(ShapeMetric)));
end

figure;
imshow(ImOutput)
title('Step-7: Automatic Recognition');



