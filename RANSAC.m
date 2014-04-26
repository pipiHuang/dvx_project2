%implement RANSAC algorithm
%=========================================================================
%input:
%  list: finalList form output of feature_match.m(a n*4 2D Matrix with each row = (x1,y1,x2,y2))
%
%output:
%   O:
%=========================================================================
function If = RANSAC(list,I1,I2,k)%I1 I2 are saved for showing ,not necessary

Num = size(list,1);


%%
%calculate homography(affine addition)

thes = 5;  
tempr = 0;
tempm=[];
for in = 1:k
       A = [];
       B = [];
   for i = 1:4
       ran = randperm(Num);
tempa =[list(ran(i),3),list(ran(i),4),1,0,0,0;
       0,0,0,list(ran(i),3),list(ran(i),4),1];       
        A =[A;tempa];        
        B = [B;list(ran(i),1);list(ran(i),2)];
   end
   x = (A.'*A)\(A.'*B);
   
   m = [x(1),x(2),x(3);
        x(4),x(5),x(6);
        0   ,0   ,1  ];
    
     rank = 0;
    for j = 1:Num
        v = m*[list(j,3);list(j,4);1];
        dis = ((v(1,1)-list(j,1))^2+(v(2,1)-list(j,2))^2)^(1/2);
%         if(j == ran(1) || j ==ran(2) || j ==ran(3) || j ==ran(4))
%         disp(dis)
%         end
        if(dis<thes)
            rank = rank+1;
        end
    end
    if(rank>tempr)
        tempr = rank;
        tempm = m;  
    end
end
    
%%
%show(forward addition)
disp(tempr);
space = 50;
row = size(I1,1);%forced row of I1 = I2 at feature_match
co1 = size(I1,2);
co2 = size(I2,2);
    If = zeros(space*2+row,space*2+co1+co2,3);
    If(space: space+row-1, space:space+co1-1, :) = I1;
%%   
%{
    for in1 = 1:co2%col
        for in2 = 1:size(I2,1)%row
            v = tempm*[in1;in2;1];%???
            if(I2(in2,in1,:)~= 0 )
            If(round(v(2,1))+space, round(v(1,1))+space, :) = I2(in2,in1,:);
            end
        end
    end
%}
%%
    %backward
    i2check = I2(:,:,1)+I2(:,:,2)+I2(:,:,3);
    for in1 = 1:size(If,2)-space %col
        for in2 = 1:size(If,1)-space %row
            v = tempm\[in1;in2;1];%???
            if(v(1,1)<1 || v(1,1)>size(I2,2) || v(2,1)<1 || v(2,1)>size(I2,1))
                %If(in1,in2,:) = zeros(1,1,3);
                continue;
            else
                    if(i2check(round(v(2,1)), round(v(1,1)))~= 0)
                If(in2+space,in1+space,:) = I2(round(v(2,1)), round(v(1,1)), :);
                    end
            end
        end
    end
%%        
    
   %{
    %as blending
    for in1 = 2:size(If,1)-1%row: 1000
        for in2 = 2:size(If,2)-1%col: 1400
            if(If(in1,in2) ==0)
                for ch = 1:3
                p = [If(in1+1,in2,ch),If(in1,in2+1,ch),If(in1-1,in2,ch),If(in1,in2-1,ch)];
                If(in1,in2,ch) = median(p,2);
                end
            end
        end
    end
    %}
 figure,imshow(uint8(If));

 %%
 %shift addition
 %{
 thres = 10;  
%rank = zeros(k,1);
rank = 0;
finx = 0;
finy = 0;
for in = 1:k
 tempr = 0;
 ran = randperm(Num);
 xs = list(ran(1),3)-list(ran(1),1);
 ys = list(ran(1),4)-list(ran(1),2);  
 tempr = 0;
 for j = 1:Num
    dis = ((list(j,3)-list(j,1)-xs)^2+(list(j,4)-list(j,2)-ys)^2)^(1/2);
    if(dis<thres)
        tempr = tempr +1;
    end
 end
 if(rank<tempr)
     rank = tempr;
      finx = list(ran(1),3)-list(ran(1),1);
      finy = list(ran(1),4)-list(ran(1),2);   
 end
end

disp(rank);
 %%
 %show
 If = zeros(1400,1800,3);
 If(300:300+size(I1,1)-1,300:300+size(I1,2)-1,:) = I1;
 for in1 = 1:size(I2,2)%col
     for in2 = 1:size(I2,1)%row
        if(I2(in2,in1,:)~= 0 )
        If(300+in2-finy,300+in1-finx,:) = I2(in2,in1,:);
        end
     end
 end
 figure,imshow(uint8(If));
%}
    
 
    
