clc;clear;close all;
InputImage=imread('sample.png'); 
imshow(InputImage); 
title('Input Image');
[imgwid,imghi]=size(InputImage);
t = cputime;
width=1024;
height=1024;
OutputImage=uint8(zeros(width,height));





WidthScale=imgwid/width;
HeightScale=imghi/height;









for i=(3/WidthScale):(width-(3/WidthScale))
for j=(3/HeightScale):(height-(3/HeightScale))
      x=i*WidthScale;
      y=j*HeightScale;
      if(x==floor(x)) && (y==floor(y))
     i= floor(i);
     j= floor(j);
OutputImage(i,j)=InputImage(int16(x),int16(y));
      else
         if(floor(x)<=0) || (floor(y)<=0)
OutputImage(i,j)=InputImage(1,1);
else
I22=double(InputImage(floor(x),floor(y))); 
I12=double(InputImage(floor(x)-1,floor(y))); 
I11=double(InputImage(floor(x)-1,floor(y)-1));
I21=double(InputImage(floor(x),floor(y)-1)); 
I31=double(InputImage(ceil(x),floor(y)-1)); 
I41=double(InputImage(ceil(x)+1,floor(y)-1)); 
I42=double(InputImage(ceil(x)+1,floor(y))); 
I32=double(InputImage(ceil(x),floor(y))); 
I33=double(InputImage(ceil(x),ceil(y))); 
I23=double(InputImage(floor(x),ceil(y))); 
I13=double(InputImage(floor(x)-1,ceil(y))); 
I14=double(InputImage(floor(x)-1,ceil(y)+1)); 
I24=double(InputImage(floor(x),ceil(y)+1)); 
I34=double(InputImage(ceil(x),ceil(y)+1)); 
I44=double(InputImage(ceil(x)+1,ceil(y)+1)); 
I43=double(InputImage(ceil(x)+1,ceil(y)));
deltax=x-floor(x); 
Wx1=-deltax+2*power(deltax,2)-power(deltax,3); 
Wx2=1-2*power(deltax,2)+power(deltax,3); 
Wx3=deltax+power(deltax,2)-power(deltax,3);
Wx4=-deltax+power(deltax,3);
deltay=y-floor(y);
Wy1=-deltay+2*power(deltay,2)-power(deltay,3);


Wy2=1-2*power(deltay,2)+power(deltay,3);
Wy3=deltay+power(deltay,2)-power(deltay,3);
Wy4=-deltay+power(deltay,3);
           i= floor(i);
           j= floor(j);
OutputImage(i,j)=[Wx1 Wx2 Wx3 Wx4]*[I11 I12 I13 I14;I21 I22 I23 I24;I31 I32 I33 I34;I41 I42 I43 I44]*[Wy1;Wy2;Wy3;Wy4];
         end
      end
end
end
figure;
imshow(OutputImage);title('Output Image'); 
TimeElapsed = cputime-t;
