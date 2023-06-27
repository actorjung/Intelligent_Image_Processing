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

% 바분 시그마는 높게 설정하여 가우시안 마스크 생성
[row1,col1,dep1] = size(block1_resized);
msksize1 = [row1,col1];
sigma1 = 50;
imMsk1 = GaussMsk1(msksize1, sigma1);
figure(1); 
imshow(imMsk1);

% 레나 시그마는 낮게 설정하여 가우시안 마스크 생성
[row2,col2,dep2] = size(block2);
msksize2 = [row2,col2];
sigma2 = 10;
imMsk2 = GaussMsk2(msksize2, sigma2);

% 이미지형 맞추기
imgA = double(imgA);
imgB = double(imgB);
imgR = imgB;
block1_resized = double(block1_resized);
block2 = double(block2);
imMsk1 = double(imMsk1);
imMsk2 = double(imMsk2);

% 마스킹
block1_masked = block1_resized.*imMsk1;
block2_masked = block2.*(1-imMsk2);

% 로우패스필터적용
filter = ones(3)/size(block2,1);
block1_filtered = zeros(size(block1_masked));
for i=1:3
    block1_filtered(:,:,i) = conv2(block1_masked(:,:,i), filter, 'same');
end

figure(5); 
imshow(block1_filtered/255);

% 합성
imgR(260:280, 320:350, :) = block1_filtered + block2_masked ; 

% PSNR값
pval = psnr(imgR,imgB,255);
txt = sprintf('PSNR = %4.2fdB',pval);
disp(txt);

% 시각화
figure(2);
imshow(block1_masked/255);
figure(3);
imshow(block2_masked/255);
figure(4);
imshow(imgR/255);

% 원숭이 이미지에 적용할 가우시안 마스크 함수
function imMsk1 = GaussMsk1(msksize1, sigma1)

% 중앙값,가로,세로 설정
rows1 = msksize1(2);
cols1 = msksize1(1);
center1 = msksize1/2;

% 벡터생성
[x1,y1] = meshgrid(1:rows1,1:cols1);

% 가우시안 계산
% exp(- (x^2 + y^2)/2*sigma)
dist1 = exp( -(( x1-center1(2) ).^2 + ( y1-center1(1) ).^2)/(2*sigma1) );

% 가우시안 마스크 생성
imMsk1 = dist1/max(dist1(:));

end

% 레나 이미지에 적용할 가우시안 마스크 함수
function imMsk2 = GaussMsk2(msksize2, sigma2)

% 중앙값,가로,세로 설정
rows2 = msksize2(2);
cols2 = msksize2(1);
center2 = msksize2/2;

% 벡터생성
[x2,y2] = meshgrid(1:rows2,1:cols2);

% 가우시안 계산
% exp(- (x^2 + y^2)/2*sigma)
dist2 = exp( -(( x2-center2(2) ).^2 + ( y2-center2(1) ).^2)/(2*sigma2) );

% 가우시안 마스크 생성
imMsk2 = dist2/max(dist2(:));

end