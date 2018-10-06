function zwd = GridZWD(B,L,doy,c,e)

% Obtain the longitudes and latitudes of the four grid points closet to the
% GNSS receiver
B1 = floor(B/2.5)*2.5;
B2 = ceil(B/2.5)*2.5;
L1 = floor(L/2.5)*2.5;
L2 = ceil(L/2.5)*2.5;

% The case where the GNSS receiver is at the grid point

if B1==B2&&L1==L2
    
    para = c(c(:,1)==B&c(:,2)==L,:);
    
elseif B1==B2
    
    para1 = c(c(:,1)==B1&c(:,2)==L1,:);
    para2 = c(c(:,1)==B1&c(:,2)==L2,:);
    para = ((L2-L)*para1+(L-L1)*para2)/(L2-L1);    
    
elseif L1==L2
    
    para1 = c(c(:,1)==B1&c(:,2)==L1,:);
    para2 = c(c(:,1)==B2&c(:,2)==L1,:);
    para = ((B2-B)*para1+(B-B1)*para2)/(B2-B1);   
    
else
    % Obtain the coeffcieints of the four grid points closet to the GNSS
    % receiver
    para1 = c(c(:,1)==B1&c(:,2)==L1,:);
    para2 = c(c(:,1)==B1&c(:,2)==L2,:);
    para3 = c(c(:,1)==B2&c(:,2)==L1,:);
    para4 = c(c(:,1)==B2&c(:,2)==L2,:);

    % Calculate the coefficients of the GNSS receiver employing bilinear
    % interpolation methodology
    para = ((B2-B)*(L2-L)*para1+(B-B1)*(L-L1)*para4+(B-B1)*(L2-L)*para3+(B2-B)*(L-L1)*para2)/((B2-B1)*(L2-L1));    
end

% Extract the coefficients (alpha0~alpha6)
a1 = para(:,3);
a2 = para(:,4);
a3 = para(:,5);
a4 = para(:,6);
a5 = para(:,7);
a6 = para(:,8);

% Use doy (day of year) to calculate model coefficients
C1 = cos(2*pi*doy/365.25);
S1 = sin(2*pi*doy/365.25);
C2 = cos(4*pi*doy/365.25);
S2 = sin(4*pi*doy/365.25);

% Use GridZWD model to calcualte zwd
zwd = a1*e + a2 + a3*C1 + a4*S1 + a5*C2 + a6*S2;


