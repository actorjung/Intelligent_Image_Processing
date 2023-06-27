clear;
clc;

% 이미지 로드
img = imread("rice2.png");

% 그레이 이미지 변환
if size(img,3)==1
    gray = img;
else
    gray = rgb2gray(img);
end

figure(1);
imshow(gray);

se = strel('disk',40);
background = imopen(gray,se);

% 배경제거 
I2 = gray - background;
I3 = imadjust(I2);

figure(2);
imshow(I3);

% 히스토그램 분포 확인
pixel_values = double(I3(:));
num_bins = 256;
histogram = histcounts(pixel_values, num_bins);

% PDF
pdf = histogram / numel(pixel_values);

figure(3);
bar(pdf);
title('Pixel Value PDF');
xlabel('Pixel Value');
ylabel('Probability');

% 소벨 필터 이용 엣지검출
[~,threshold] = edge(I3,'sobel');
fudgeFactor = 0.4;
BWs = edge(gray,'sobel',threshold * fudgeFactor);

figure(4);
imshow(BWs);
title('Binary Gradient Mask');

% 엣지 경계 확장
se90 = strel('line',3,90);
se0 = strel('line',3,0);
BWsdil = imdilate(BWs,[se90 se0]);

figure(5);
imshow(BWsdil);
title('Dilated Gradient Mask');

% 엣지 안쪽 채우기 
BWdfill = imfill(BWsdil,'holes');

figure(6);
imshow(BWdfill)
title('Binary Image with Filled Holes')

% 면적값, 중앙픽셀값 확인
stats = regionprops(BWdfill,{'Area','Centroid'});

% 스트럭처를 테이블로 바꾹기
tab = struct2table(stats);

% sorting 면적을 기준으로
ordered = sortrows(tab, 1, "descend");

figure(7);
imshow(img);

% 쌀알 객체 검출
hold on;
num = 14;
title(['Detected Rices : ', num2str(num)]);

for n=1:num
    r = ordered.Centroid(n,1);
    c = ordered.Centroid(n,2);
    % +로 출력
    text(r,c,'+',"color","red");
end

hold off;



