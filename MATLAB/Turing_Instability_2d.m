clear;

size = 100;
x = 1:size;
y = 1:size;

[my,mx] = meshgrid(y,x);

M1 = (rand(size,size)-.5)*.2;
M2 = (rand(size,size)-.5)*.2;

%M1 = wgn(size, size, -40);
%M2 = wgn(size, size, -40);

fig = figure;

ax = gca;
ax.NextPlot = "replaceChildren";

v = VideoWriter('Videos\2d_noise.mp4','MPEG-4');
v.FrameRate = 40;
open(v);



tstep = .1;
numframes = 1000;
trange = 0:tstep:numframes*tstep;

a = 1;
b = -1;
c = 1/.1;
d = -1/.1;

mu = .00028;
nu = .005/.1;


for t=trange
    M1_d = zeros(size, size);
    M2_d = zeros(size, size);
    
    L1 = del2(M1);
    L2 = del2(M2);
    
    L1(1,:) = 0;
    L1(end,:) = 0;
    L2(1,:) = 0;
    L2(end,:) = 0;
    
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
            M1_d(ix,iy) = a * (M1(ix,iy)-M1(ix,iy).^3) + b * M2(ix,iy) + mu * ((M1(downx,iy)+M1(upx,iy)+M1(ix,downy)+M1(ix,upy))/4 - M1(ix,iy));
            M2_d(ix,iy) = c * M1(ix,iy) + d * M2(ix,iy) + nu * ((M2(downx,iy)+M2(upx,iy)+M2(ix,downy)+M2(ix,upy))/4 - M2(ix,iy));
        end
    end
    
    M1 = M1 + M1_d * tstep;
    M2 = M2 + M2_d * tstep;
    
    %imagesc(M1,[-1,1]);
    s = surf(M1, min(max(M1, -1), 1)./max(max(M1)));
    s.EdgeColor = 'none';
    axis([0,size,0,size,-1,1]);
    title("t = " + t);
    colormap autumn
    %col = colorbar;
    writeVideo(v,getframe(fig));
    
end

close(v);
