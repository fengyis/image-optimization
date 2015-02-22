clc;clear;close all;
InputImage=imread('test.png');


t = cputime;

InputImage=rgb2gray(InputImage); %not necessary for tif
figure(1)
imshow(InputImage); 
title('Input Image');
InputImage=double(InputImage);
row=size(InputImage,1);
col=size(InputImage,2);
channel=size(InputImage,3);
X=linspace(0,255,256);
figure(2)
u=reshape(InputImage,row*col,1);
N=HIST(u,X);
p=N/(row*col);
plot(p);
%hist(u,X);
f=-p';
A=zeros(254,256);
A(1,:)=ones(1,256);

for m=1:254
    for n=1:253
        A(m,m)=1;
        A(m,m+1)=1;
        A(m,m+2)=1;
    end
end

B=ones(254,1);
B(1,:)=255;
lb=zeros(256,1);
ub=255*ones(256,1);


s=linprog(f,A,B,[],[],lb,ub);
OutputImage=zeros(row,col);

[r,c]=size(s);
for i=1:r
    for j=1:row
        for k=1:col
            if(InputImage(j,k)==(i-1))
                gradient=gradient+s(i);
                OutputImage(j,k)=gradient;
                %fprintf('Input is %g, output is %g\n',InputImage(j,k),OutputImage(j,k));
            end
        
        end
    end
    
end


X=linspace(0,255,256);
figure(3)
u_out=reshape(OutputImage,row*col,1);
N_out=HIST(u_out,X);
p_out=N_out/(row*col);
plot(p_out)




whos InputImage
figure(4)
imshow(uint8(OutputImage));title('Output Image'); 

TimeElapsed = cputime-t;
