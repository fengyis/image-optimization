clc;clear;close all;
InputImage=imread('test_4.png');


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


for m=2:254
  
    A(m,m-1)=-1;
    A(m,m)=-1;
    A(m,m+1)=-1;
%     A(m,254-m+4)=1;
%     A(m,254-m+3)=1;
%     A(m,254-m+2)=1;

end
%A((255:507),(1:256))=A((2:254),(1:256));
A(1,:)=ones(1,256);
B=-1*ones(254,1);
B(1,:)=255;
%B=[B;ones(253,1)];
lb=0.5*ones(256,1);
ub=3*ones(256,1);

A1=ones(1,256);


s=linprog(f,A1,255,[],[],lb,ub);
OutputImage=zeros(row,col);

[r,c]=size(s);
gradient=0;
figure(3)
for i=1:r
    plot([i-1,i],[gradient,gradient+s(i)])
    hold on;
    gradient=gradient+s(i);
    
    for j=1:row
        for k=1:col
            if(InputImage(j,k)==(i-1))
                
                OutputImage(j,k)=gradient;
                %fprintf('Input is %g, output is %g\n',InputImage(j,k),OutputImage(j,k));
            end
        
        end
    end
    
end


X=linspace(0,255,256);
figure(4)
u_out=reshape(OutputImage,row*col,1);
N_out=HIST(u_out,X);
p_out=N_out/(row*col);
plot(p_out)



whos OutputImage
figure(5)
imshow(uint8(OutputImage));title('Output Image'); 

TimeElapsed = cputime-t;
