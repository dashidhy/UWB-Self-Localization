function M = decode(Name)
fid = fopen(Name,'rb');

header = 0;
L = zeros(7,7);
M = zeros(7,7);

while ~feof(fid)
    % detect header
    while (~header) && (~feof(fid))
        h = fread(fid,1,'uint8');
        if h == 170
            h = fread(fid,1,'uint8');
            if h == 85
                h = fread(fid,1,'uint8');
                if h == 165
                    h = fread(fid,1,'uint8');
                    if h == 90
                        header = 1;
                    end
                end
            end 
        end
    end
	header = 0;
    if feof(fid)
        break;
    end
	
    fread(fid,1,'uint8'); % jump over the 4th byte
	ID_cur = fread(fid,1,'uint8'); % current ID
	
	fread(fid,3,'uint8');
	
	type = fread(fid,1,'uint8');
	if type == 5
        %L(ID_cur+1) = 1;
	    fread(fid,2,'uint8');
		tail = 0;
		while tail < 60
		    ID_nei = fread(fid,1,'uint8');
			if ID_nei ~= 255
			    Dis = fread(fid,1,'uint8');
				Dis = Dis+fread(fid,1,'uint8')*16^2;
				Dis = Dis+fread(fid,1,'uint8')*16^4;
				Dis = Dis+fread(fid,1,'uint8')*16^6;
                if Dis < 19000
                    M(ID_cur+1,ID_nei+1) = M(ID_cur+1,ID_nei+1)+Dis;
                    L(ID_cur+1,ID_nei+1) = L(ID_cur+1,ID_nei+1)+1;
                end
			else
			    fread(fid,4,'uint8');
			end
			tail = tail+5;
		end
	end
	
%     if sum(L) == 6
%         break;
%     end		
	
end

L = L+(L == 0);
M = M./L;

fclose(fid);
end

