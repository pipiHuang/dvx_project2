%describe the feature as its nine neibor's intensity
%set a threshold to first match the two images
%=========================================================================
%input:
%   I1,I2: origin images
%   list1,list2: candidate feature list of I1,I2
%output:
%   O = matching list of list1 and list2
%========================================================================
function [O If1 If2] = feature_match(I1,list1,I2,list2)
%set feature using gray image

Num1 = size(list1,2);%Num1: number of feature points in I1
Num2 = size(list2,2);%NUm2: number of feature points in I2
dis = ones(Num1,2);%the smallest distance between each feature point in I1 to I2
%Img1 = 54/256*I1(:,:,1)+183/256*I1(:,:,2)+19/256*I1(:,:,3);
%Img2 = 54/256*I2(:,:,1)+183/256*I2(:,:,2)+19/256*I2(:,:,3);
%set feature using red space in RGB
Img1 = I1(:,:,2);
Img2 = I2(:,:,2);
%set feature using hue space
% I1hsv = rgb2hsv(I1);
% I2hsv = rgb2hsv(I2);
% Img1 = I1hsv(:,:,1);
% Img2 = I2hsv(:,:,1);
% 
% 
%%
%find the best corespoonding feature point for I1 and I2
w = 12;%widow size = 8*8+1 = 17

initM2 = Img2(list2(1,1)-w:list2(1,1)+w,list2(2,1)-w:list2(2,1)+w);
for i = 1:Num1
    diM1 = Img1(list1(1,i)-w:list1(1,i)+w,list1(2,i)-w:list1(2,i)+w);
    dis(i,1) = sum(sum((double(diM1) - double(initM2)).^2));%score
    for j = 2:Num2        
        diM2 = Img2(list2(1,j)-w:list2(1,j)+w,list2(2,j)-w:list2(2,j)+w);
        p = double((double(diM1)-double(diM2)).^2);
        temp = sum(sum(p));
          if(temp < dis(i,1))
            dis(i,1) = temp;
            dis(i,2) = j;
          end
    end
end
%%
% sort the coresponding score
%fdis = zeros(1,2);%a list of good feature point of I1 and I2 
nu = 35;%number of the best feature points to be taken 

[so turn] = sort(dis(:,1));

if(size(dis(:,1),1) < nu)
    nu = size(dis(:,1),1);
end

finalList = zeros(nu,4);%(number,list1/2,x/y)
for i = 1:nu
   % fdis(i,1) = turn(i,1);%order of image I1's feature points in list1
   %fdis(i,2) = dis(turn(i,1),2);%order of image I2's feature points in list2
    finalList(i,1) = list1(2,turn(i,1)); %x1
    finalList(i,2) = list1(1,turn(i,1)); %y1
    finalList(i,3) = list2(2,dis(turn(i,1),2)); %x2
    finalList(i,4) = list2(1,dis(turn(i,1),2)); %y2
end   
    
%%
%show

Ic1 = size(I1(:,:,1),2);
Ic2 = size(I2(:,:,1),2);
Ir1 = size(I1(:,:,1),1); 
Ir2 = size(I2(:,:,1),1);
If1 = I1;
If2 = I2;
t1 = 1;
t2 = 1;
if (Ir1>Ir2)
    Ib = Ir1;
    If2 = zeros(Ib,Ic2,3);
    t2 = round((Ir1-Ir2)/2);
    If2(t2:t2+Ir2-1,:,:) = I2(:,:,:);
end
if(Ir1<Ir2)
    Ib = Ir2;
    If1 = zeros(Ib,Ic1,3);
    t1 = round((Ir2-Ir1)/2);
    If1(t1:t1+Ir1-1,:,:) = I1(:,:,:);
end

Icon = [If1,If2];%combine I1 and I2
figure,imshow(uint8(Icon));

hold on;
%plot all the original feature point candidates of I1 and I2
plot(list1(2,:),list1(1,:)+t1*ones(1,size(list1(1,:))),'*','Color','b');
plot(list2(2,:)+Ic1,list2(1,:)+t2*ones(1,size(list2(1,:))),'*','Color','b');
for i = 1:nu
    finalList(i,2) = finalList(i,2)+t1-1;
    finalList(i,4) = finalList(i,4)+t2-1;
    plot([finalList(i,1),finalList(i,3)+Ic1], [finalList(i,2),finalList(i,4)],'LineWidth',1,'Color',[1,0,0]);
    %plot([list1(2,fdis(i,1)),list2(2,fdis(i,2))+Ic],[list1(1,fdis(i,1)),list2(1,fdis(i,2))],'LineWidth',1,'Color',[1,0,0]);
end
O = finalList;
