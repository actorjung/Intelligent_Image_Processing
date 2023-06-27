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

%이미지형 맞추기
imgA = double(imgA);
imgB = double(imgB);
imgR = imgB;
block1_resized = double(block1_resized);
block2 = double(block2);

%alpha
alp = 0:0.1:1;

%알파 블랜딩 알파값 설정
for i =1:length(alp)
 	ap = alp(i);
 	imgR(260:280, 320:350, :) = ap*block1_resized + (1-ap)*block2;
    %PSNR값
    pval = psnr(imgR,imgB,255);
    txt = sprintf('PSNR = %4.2fdB',pval);
    disp(txt);
end 

%시각화
figure(1);
imshow(block1);
figure(2);
imshow(block2/255);
figure(3);
imshow(imgR/255);