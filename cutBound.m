function img = cutBound(I)
imgb = 54/256*I(:,:,1)+183/256*I(:,:,2)+19/256*I(:,:,3);
R = size(imgb,1);
C = size(imgb,2);

for in = 1:R
    if(sum(imgb(in,:),2)~=0)
    yd = in;
    break;
    end
end
for in = R:-1:1
    if((sum(imgb(in,:),2)~=0))
    yu = in;
    break;
    end
end

for in = 1:C
    if(sum(imgb(:,in),1)~=0)
        xl = in;
        break;
    end
end
for in = C:-1:1
    if(sum(imgb(:,in),1)~=0)
        xr = in;
        break;
    end
end
img = I(yd:yu,xl:xr,:);
