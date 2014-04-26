%mMkefile
%===================parameter setting======================
num = 6;%image number
ch1 = 'stair (';
ch2 = ').jpg';
fc = [630,630,630,630,630,630,630,630];%focal length
k = 150;
%==========================================================
I = cell(num,1);
for in = 1:num
    c = [ch1,num2str(in),ch2];
    temp = imread(c);
    I{in} = cylindrical_project(temp,fc(in));
end
disp('cylindrical prjecting finish.');

Is = I{1};
for i = 1:num-1
    [list I1f I2f] = test(Is,I{i+1});
    Is = RANSAC(list,I1f,I2f,k);
    cha = ['finish I',num2str(i),' RANSAC.'];
    disp(cha);
end
imshow(uint8(Is));
str = 'stairCon.jpg';
imwrite(Is,str);

