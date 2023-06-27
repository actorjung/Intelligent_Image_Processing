clear;
clc;

% 이미지 로드
img = imread("rice1.png");

% 그레이 이미지 변환
if size(img,3)==1
    gray = img;
else
    gray = rgb2gray(img);
end

figure(1);
imshow(gray);

% 배경제거
se = strel('disk',15);
background = imopen(gray,se);
I2 = gray - background;
I3 = imadjust(I2);

figure(2)
imshow(I3)

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

% 이진화
bw = imbinarize(I2);
bw = bwareaopen(bw,5);

figure(4)
imshow(bw)

% 면적값, 중앙픽셀값 확인
stats = regionprops(bw,{'Area','Centroid'});

% 스트럭처를 테이블로 바꾹기
tab = struct2table(stats);

% sorting 면적을 기준으로
ordered = sortrows(tab, 1, "descend");

figure(5);
imshow(img);

% 쌀알 객체 검출
hold on;
num = 97;
title(['Detected Rices : ', num2str(num)]);

for n=1:num
    r = ordered.Centroid(n,1);
    c = ordered.Centroid(n,2);
   
    % 쌀알 겹쳐 있는것 빨간색 + 표시
    if n <= 4
        text(r,c,'+',"color","red");
    % 일반 쌀알 검정색 + 표시
    elseif n > 4 && n < 81
        text(r,c,'+',"color","black");
    % 잘려진 쌀알 파란색 + 표시
    else  
       text(r,c,'+',"color","blue");
    end
end

hold off;








