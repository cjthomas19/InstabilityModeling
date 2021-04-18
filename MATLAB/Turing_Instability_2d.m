clear;

size = 100;
x = 1:size;
y = 1:size;

[my,mx] = meshgrid(y,x);

M1 = (rand(size,size)-.5)*.05;
M2 = (rand(size,size)-.5)*.05;

fig = figure;

ax = gca;
ax.NextPlot = "replaceChildren";

v = VideoWriter('Videos\2d_no_diff.mp4','MPEG-4');
v.FrameRate = 40;
open(v);



tstep = .01;
numframes = 225;
trange = 0:tstep:numframes*tstep;

a = 1;
b = -8;
c = 1;
d = -4;

mu = .5;
nu = 25;


for t=trange
    M1_d = zeros(size, size);
    M2_d = zeros(size, size);
    
    L1 = del2(M1);
    L2 = del2(M2);
    
    for ix=1:size
        
        downx = ix-1;
        upx = ix +1;
        
        if ix == 1
            downx = size;
        elseif ix == size
            upx = 1;
        end
        
        for iy=1:size
            downy = iy-1;
            upy = iy +1;
            if iy == 1
                downy = size;
            elseif iy == size
                upy = 1;
            end
            M1_d(ix,iy) = a * M1(ix,iy) + b * M2(ix,iy) + mu * ((M1(downx,iy) - 2 * M1(ix,iy) + M1(upx,iy))+(M1(ix,downy) - 2 * M1(ix,iy) + M1(ix,upy)));
            
            %M1_d(ix,iy) = a * M1(ix,iy) + b * M2(ix,iy) + mu * L1(ix,iy);
            M2_d(ix,iy) = c * M1(ix,iy) + d * M2(ix,iy) + nu * ((M2(downx,iy) - 2 * M2(ix,iy) + M2(upx,iy))+(M2(ix,downy) - 2 * M2(ix,iy) + M2(ix,upy)));
            %M2_d(ix,iy) = c * M1(ix,iy) + d * M2(ix,iy) + nu * L2(ix,iy);
        end
    end
    
    M1 = M1 + M1_d * tstep;
    M2 = M2 + M2_d * tstep;
    
    %imagesc(M1,[-1,1]);
    surf(M1, min(max(M1, -1), 1)./max(max(M1)))
    axis([0,100,0,100,-1,1]);
    %col = colorbar;
    writeVideo(v,getframe(fig));
    
end

close(v);
