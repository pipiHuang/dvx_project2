%mMkefile
%===================parameter setting======================
num = 11;%image number

ch1 = 'house (';
ch2 = ').jpg';
fc = [630,630,630,630,630,630,630,630,630,630,630,630,630,630,630];%focal length
k = 150;
%==========================================================
I = cell(num,1);
for in = 1:num
    c = [ch1,num2str(in),ch2];
    temp = imread(c);
    I{in} = cylindrical_project(temp,fc(in));
end
disp('cylindrical projecting finish.');

k = 200;
Is = I{1};
for i = 1:num-1
    Is = cutBound(Is);
    I{i+1} = cutBound(I{i+1});

[list1 o1] = HCDetector(Is,2,size(I{i+1},2));
[list2 o2] = HCDetector(I{i+1},2,size(I{i+1},2));

[list I1f I2f] = feature_match(Is,list1,I{i+1},list2);
    
    Is = RANSAC(list,I1f,I2f,k);
    cha = ['finish I',num2str(i),' RANSAC.'];
    disp(cha);
end
Is = uint8(Is);
str = 'outhouse_3 (1).jpg';
imwrite(Is,str);
%imshow(uint8(Is));

