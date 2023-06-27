clear;

% 이미지 불러오기 
imgA = imread("baboon.png");
imgB = imread("lena.png");

% 원숭이의 오른쪽 눈 찾기
block1 = imgA(45:75, 310:360, :);

% 레나의 오른쪽 눈 찾기
block2 = imgB(260:280, 320:350, :);

% 원숭이의 오른쪽 눈 크기를 레나의 오른쪽 눈 크기와 맞추기
block1_resized = imresize(block1, [size(block2,1) size(block2,2)]);

%
[row1,col1,dep1] = size(block1_resized);
msksize1 = [row1,col1];
rad1 = min(msksize1)/2;
imMsk1 = CircleMsk1(msksize1, rad1);
figure(1); 
imshow(imMsk1);

%
[row2,col2,dep2] = size(block2);
msksize2 = [row2,col2];
rad2 = min(msksize2)/2;
imMsk2 = CircleMsk2(msksize2, rad2);
figure(2); 
imshow(imMsk2);

%이미지형 맞추기
imgA = double(imgA);
imgB = double(imgB);
imgR = imgB;
block1_resized = double(block1_resized);
block2 = double(block2);
imMsk1 = double(imMsk1);

%마스킹
block1_masked = block1_resized.*imMsk1;
block2_masked = block2.*(1-imMsk2);

%합성
imgR(260:280, 320:350, :) = block1_masked + block2_masked ; 

%PSNR값
pval = psnr(imgR,imgB,255);
txt = sprintf('PSNR = %4.2fdB',pval);
disp(txt);

%시각화
figure(3);
imshow(block1_masked/255);
figure(4);
imshow(block2_masked/255);
figure(5);
imshow(imgR/255);

function imMsk1 = CircleMsk1(msksize1, rad1)

% imMsk = CircleMsk(msksize, rad)
% msksize - [row,col] of size of mask
% rad : radius for circle

%중앙값,가로,세로 설정
rows1 = msksize1(2);
cols1 = msksize1(1);
center1 = msksize1/2;

%벡터생성
[x1,y1] = meshgrid(1:rows1,1:cols1);

%거리계산
dist1 = sqrt( ( x1-center1(2) ).^2 + ( y1-center1(1) ).^2 );

%이진 마스크 생성
imMsk1 = dist1 <= rad1;

end

function imMsk2 = CircleMsk2(msksize2, rad2)

% imMsk = CircleMsk(msksize, rad)
% msksize - [row,col] of size of mask
% rad : radius for circle

%중앙값,가로,세로 설정
rows2 = msksize2(2);
cols2 = msksize2(1);
center2 = msksize2/2;

%벡터생성
[x2,y2] = meshgrid(1:rows2,1:cols2);

%거리계산
dist2 = sqrt( ( x2-center2(2) ).^2 + ( y2-center2(1) ).^2 );

%이진 마스크 생성
imMsk2 = dist2 <= rad2;

end