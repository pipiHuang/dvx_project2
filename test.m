%test only
function [O If1 If2]= test(I1,I2)
I1 = cutBound(I1);
I2 = cutBound(I2);
[list1 o1] = HCDetector(I1,2);
[list2 o2] = HCDetector(I2,2);

[O If1 If2] = feature_match(I1,list1,I2,list2);