%mMkefile
%===================parameter setting======================
num = 16;%image number

ch1 = 'shoes (';
ch2 = ').jpg';
fc = [759.302,759.679,757.935,746.803,741.131,742.476,746.377,749.779,750.112,752.262,749.098,754.083,760.929,766.051,771.784,773.526,771.039,769.384,770.13,771.128,770.873,771.342,772.624,756.144,755.546,755.984,755.537,752.815,758.925,749.202,749.25,746.588,765.375,766.299];%focal length
k = 150;
%==========================================================
I = cell(num,1);
for in = 1:num
    c = [ch1,num2str(in),ch2];
    temp = imread(c);
    I{in} = cylindrical_project(temp,fc(in));
end
disp('cylindrical projecting finish.');

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
str = 'outtesttree.jpg';
imwrite(Is,str);
%imshow(uint8(Is));

