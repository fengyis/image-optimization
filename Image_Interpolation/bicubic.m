clc;clear;close all;
InputImage=imread('graylizard_downsample.bmp');
figure(1)
imshow(InputImage); 
title('Input Image');

t = cputime;

%InputImage=rgb2gray(InputImage); %not necessary for tif
row=size(InputImage,1);
col=size(InputImage,2);
channel=size(InputImage,3);


% OutputImage_2=uint8(zeros(row/2,col/2,channel)); % down sampling
% for i=1:row/2
%     for j=1:col/2
%         OutputImage_2(i,j)=InputImage(2*i-1,2*j-1);
%     end
% end
% [row_2, col_2, channel_2]=size(OutputImage_2);
% 
% row=row_2;
% col=col_2;
% channel=channel_2;
% Original=InputImage;
% InputImage=OutputImage_2;
% figure(2)
% imshow(OutputImage_2);   
% title('Down sampling image'); %show down sampling


whos InputImage
OutputImage=uint8(zeros(2*row,2*col,channel));% Expand the output image by a factor of 2

for k=1:row
    for j=1:col
        OutputImage(2*k-1,2*j-1)=InputImage(k,j);% copy the element from original image/ upsampling
        %OutputImage(2*k-1,2*j-1)=OutputImage_2(k,j);
    end
end
figure(3);
imshow(OutputImage);
title('Before Interpolation');
%return;

%OutputImage=double(OutputImage);

B=[-1.0 1.0 -1.0 1.0;0 0 0 1.0;1.0 1.0 1.0 1.0;8.0 4.0 2.0 1.0;];
a=[1.0/8.0 1.0/4.0 1.0/2.0 1.0]*inv(B);% the coefficient of f(0.5,0.5)
b=inv(B)'*[1.0;1.0;1.0;1.0];% the coefficient of f(0.5,1)
c=[0 0 0 1.0]*inv(B);% the coefficient of f(0,0.5)

for i=1:(row-3)
    for j=1:(col-3)
        F=double(InputImage(i:i+3,j:j+3));
        f_mid=a*F*a';       %Interpolate f(0.5,0.5)
        f_midu=a*F*b;%Interpolate f(0.5 1)
        f_midl=c*F*a'; %Interpolate f(0,0,5)
        OutputImage(2*i+2,2*j+2)=f_mid;
        OutputImage(2*i+2,2*j+1)=f_midu;
        OutputImage(2*i+1,2*j+2)=f_midl;
    end
end
[newrow, newcol]=size(OutputImage);

for k=1:newrow % This loop is dealing with the fram of the image
    for j=1:newcol
        if(OutputImage(k,j)==0&&j~=1)
            OutputImage(k,j)=OutputImage(k,j-1);
        end
        if(OutputImage(k,j)==0&&k~=1)
            OutputImage(k,j)=OutputImage(k-1,j);
        end
        
    end
end
[r,cl]=size(OutputImage);

% 
% Diff=OutputImage-Original(1:r,1:cl);%compare with the original
% s=sum(sum(Diff.^2));
% mse=s/(r*cl);                       %calculate mse



figure(4);

imshow(OutputImage);title('Output Image'); 
TimeElapsed = cputime-t;
