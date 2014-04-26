%implement RANSAC algorithm
%=========================================================================
%input:
%  list: finalList form output of feature_match.m(a n*4 2D Matrix with each row = (x1,y1,x2,y2))
%
%output:
%   O:
%=========================================================================
function tempm = RANSAC(list,I1,I2,k)%I1 I2 are saved for showing ,not necessary

Num = size(list,1);


%%
%calculate homography

thes = 20;  
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
%show
disp(tempr);
    If = zeros(1400,1800,3);
    If(300:300+size(I1,1)-1,300:300+size(I1,2)-1,:) = I1;
    %minv = tempm.';
    %figure,imshow(uint8(If));
    %I = zeros(size(I2));
    for in1 = 1:size(I2,2)%col
        for in2 = 1:size(I2,1)%row
            v = tempm*[in1;in2;1];%???
            if(I2(in2,in1,:)~= 0 )
            If(round(v(2,1))+300,round(v(1,1))+300,:) = I2(in2,in1,:);
            end
        end
        
    end

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
    
 
    
